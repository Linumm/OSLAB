#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  //--P2--
  struct proc* mlfq[4][NPROC];	// mlfq multi-level array (0 is the highest)
  int toplv;					// mlfq current top level prior queue in flow
  int ismlfq;					// queue mode indicator, mlfq: 1, moq: 0
  int recentidx[4];				// recent choosen process's index in each lv queue
  
  int nextmoqid;				// next moq id to assign
  int targetmoqid;				// target moq process id to choose
  int moqsize;					// to check if moq is empty
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);
extern int sys_uptime(void);	// to get process's cpu-on time(tick)
extern int sys_unmonopolize(void);
static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	if(p->state == UNUSED)
	  goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  //--P2--
  p->rst = -1; // rst 0 means it's initialized (or re-initialized)
  p->priority = 0;
  p->qlv = -1;
  p->qidx = -1;
  p->moqid = -1;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  //--P2--
  // ptable initialization
  acquire(&ptable.lock);
  for(int i = 0; i < 4; i++)
	ptable.recentidx[i] = 0;
  ptable.toplv = 0;
  ptable.ismlfq = 1;
  ptable.nextmoqid = 1;
  ptable.targetmoqid = 1;
  ptable.moqsize = 0;
  release(&ptable.lock);

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
  qinsert(0, p);

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  //--P2--
  qinsert(0, np);

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  qdelete(curproc);
  cprintf("proc %d exit\n", curproc->pid);
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
		//--P2--
		/*
		if(p->moqid == -1)
		  qdelete(p->qlv, p);
		else
		  ptable.moqsize--;
		*/
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p = 0;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    acquire(&ptable.lock);
	// from this moment, not interruptable on this cpu.
	if(ptable.ismlfq){ 	// MLFQ mode
	  p = qfindnext();
	  if(p == 0){
		release(&ptable.lock);
		continue;
	  }
	}
	else{ 				// MOQ mode
	  if(checkmoq()){
	    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
		  if(p->state == RUNNABLE && p->moqid == ptable.targetmoqid){
			cprintf("MOQ Run, moqid: %d pid: %d\n", p->moqid, p->pid);
		    break;
		  }
	  }
	  else{
		release(&ptable.lock);
		sys_unmonopolize();
		continue;
	  }
	}
	c->proc = p;
	switchuvm(p);
	// Change the process state and record the running start time
	p->state = RUNNING;
	p->rst = sys_uptime();
	// after switch, process will release the lock.
	// and it will acquire lock again at the yield moment.
	swtch(&(c->scheduler), p->context);
	switchkvm();
	// Process is done running for now.
	// It should have changed its p->state before coming back.
	c->proc = 0;

	release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  qdemote();
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  if(p->qlv != 99){
	qdelete(p);
	sched();
  }

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
	  if(p->qlv != 99) qinsert(0, p);
	}
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


//--P2--
// mlfq control functions

// Delete the process from target queue level(including MoQ)
void
qdelete(struct proc* p)
{
  // ptable.lock is already acquired in qdemote()
  if(p->qlv == 99){
	// In MoQ, if the process deleted,
	// target should be next moqid by FCFS
	cprintf("MOQ Del, moqid: %d\n", p->moqid);
	p->moqid = -1;
	p->qlv = -1;
	ptable.moqsize--;
	ptable.targetmoqid++;
  }
  else{
    ptable.mlfq[p->qlv][p->qidx] = 0;
	p->qidx = -1;
	p->qlv = -1;
  }
  //cprintf("proc dequeued, name: %s, lv: %d\n", p->name, p->qlv); 
}

// Insert the process to the target queue level (only mlfq)
// then modify the mlfq top level
void
qinsert(int qlv, struct proc* p)
{
  // ptable.lock is already acquired in qdemote()
  for(int i = 0; i<NPROC; i++){
	// find empty slot
	if(ptable.mlfq[qlv][i] == 0){
	  ptable.mlfq[qlv][i] = p;
	  p->qlv = qlv;
	  p->qidx = i;
	  
	  // if qlv is higher queue, update ptable.toplv
	  if(qlv < ptable.toplv)
		ptable.toplv = qlv;
	  return;
	}
  }
  panic("qinsert error: FULL QUEUE");
}

// Demote the yielded process queue level
// this is only called in yield()
// so dont acquire/release ptable.lock
void
qdemote(void)
{
  struct proc *p = myproc();
  //cprintf("demoted name: %s, current lv: %d\n", p->name, p->qlv);
  p->rst = 0;

  switch(p->qlv){
	case 0:
	  qdelete(p);
	  if(p->pid % 2 == 1)	// odd->L1
		qinsert(1, p);
	  else					// even->L2
	    qinsert(2, p);
	  break;
	case 1: case 2:
	  qdelete(p);
	  qinsert(3, p);
	  break;
	case 3:
	  if(p->priority > 0)
		p->priority--;
	  break;
	default:
	  break;
  }
}

// Find the next process target in the mlfq.
// if none, go down. if upper has, go up.
// one loop searching for RUNNABLE process. 
// return: target process in toplv queue. (not found 0)
struct proc*
qfindnext(void)
{
  struct proc* p;
  int i;
  for(;;){
	// if now in L3 queue, priority should be checked while in search.
	if(ptable.toplv == 3)
		break;
	// search starts from recentidx
	for(i = ptable.recentidx[ptable.toplv]+1; i < NPROC; i++){
	  //cprintf("mlfq idx i: %d\n", i);
	  p = ptable.mlfq[ptable.toplv][i];
	  if(p != 0 && p->state == RUNNABLE){
		ptable.recentidx[ptable.toplv] = i;
		return p;
	  }
	}
	// search the remain part of current lv queue
	for(i = 0; i <= ptable.recentidx[ptable.toplv]; i++){ // should I also check recentidx procs
	  p = ptable.mlfq[ptable.toplv][i];
	  if(p != 0 && p->state == RUNNABLE){
		ptable.recentidx[ptable.toplv] = i;
		return p;
	  }
	}
	// now none procs RUNNABLE in current lv queue, go down
	ptable.toplv++;
	//cprintf("current toplv: %d\n", ptable.toplv);
  }
  
  // Now in L3 queue
  // cprintf("current toplv: 3\n");
  int maxp = -1;
  int maxi = -1;
  for(i = ptable.recentidx[3]+1; i < NPROC; i++){
	p = ptable.mlfq[3][i];
	if(p != 0 && p->state == RUNNABLE && 
	   p->priority > maxp){
	  maxp = p->priority;
	  maxi = i;
	}
  }
  // search the remain part
  for(i = 0; i <= ptable.recentidx[3]; i++){
	p = ptable.mlfq[3][i];
	if(p != 0 && p->state == RUNNABLE && 
	   p->moqid == -1 && p->priority > maxp){
	  maxp= p->priority;
	  maxi = i;
	}
  }
  // No RUNNABLE process to return
  if(maxi == -1){
	// Reset all recentidx so that accessing get faster after enqueue from 0
	for(int j=0; j<4; j++)
	  ptable.recentidx[j] = -1;
	return 0;
  }
  
  return ptable.mlfq[3][maxi];
}

// Priority-boost
// called when gticks == 100 in trap.c(timer interrupt)
// reset all process in mlfq rst -> 0 and enqueue them all in L0 queue
void
priorityboost(void)
{
  struct proc *p;
  int idx;
  acquire(&ptable.lock);

  // reset process rst in L0
  for(idx = 0; idx < NPROC; idx++){
	p = ptable.mlfq[0][idx];
	if(p != 0) p->rst = 0;
  }
  // reset rst and  move every process in L1,2,3 into L0
  for(int i = 1; i < 4; i++){
	for(idx = 0; idx < NPROC; idx++){
	  p = ptable.mlfq[i][idx];
	  if(p != 0){ // except process currently in moq
		p->rst = 0;
		qdelete(p);
		qinsert(0, p);
	  }
	}
  }
  release(&ptable.lock);
}

// check any moq process remain in ptable.proc
int
checkmoq()
{
  struct proc * p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if(p->qlv == 99)
	  return 1;
  }
  return 0;
}

// For sysproc.c
int
psetpriority(int pid, int pr)
{
  struct proc *p;
  if(pid < -1) return -1;
  if(pr < 0 && pr > 10) return -2;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if(p != 0 && p->pid == pid){
	  p->priority = pr;
	  release(&ptable.lock);
	  return 0;
	}
  }
  release(&ptable.lock);
  return -1;
}

int
psetmonopoly(int pid, int pw)
{
  struct proc *p;
  int studentID = 2020002542;

  if(pw != studentID) return -2;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if(p != 0 && p->pid == pid && p->qlv != 99){
	  // if found, delete proc from mlfq then put into moq
	  if(p->qidx != -1)
		qdelete(p);
	  p->qlv = 99;
	  p->moqid = ptable.nextmoqid;
	  ptable.nextmoqid++;
	  ptable.moqsize++;

	  int moqsize = ptable.moqsize;
	  release(&ptable.lock);
	  return moqsize;
	}
  }
  // pid process not found or already in moq
  release(&ptable.lock);
  return -1;
}

void
pmonopolize(void)
{
  acquire(&ptable.lock);
  ptable.ismlfq = 0;
  release(&ptable.lock);
  yield();
}

void
punmonopolize(void)
{
  acquire(&ptable.lock);
  ptable.ismlfq = 1;
  release(&ptable.lock);
}
