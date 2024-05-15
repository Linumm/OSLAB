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
} ptable;

static struct proc *initproc;
typedef int thread_t;

int nextpid = 1;
int nexttid = 1;
extern void forkret(void);
extern void trapret(void);

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
  struct thread *t;
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
  p->curtidx = 0;

  // Thread pool init
  for(int i = 0; i < NTHREAD; i++)
	p->threads[i].state = UNUSED;

  // Default-thread init
  t = &p->threads[0];
  t->state = EMBRYO;
  t->tid = nexttid++;
  t->ret = 0;

  release(&ptable.lock);

  // Allocate kernel stack to Default-thread
  if((t->kstack = kalloc()) == 0){
    p->state = UNUSED;
	t->state = UNUSED;
    return 0;
  }
  sp = t->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *t->tf;
  t->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *t->context;
  t->context = (struct context*)sp;
  memset(t->context, 0, sizeof *t->context);
  t->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  struct thread *t;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  t = &p->threads[0]; // p's Default-thread

  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(t->tf, 0, sizeof(*t->tf));
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  t->tf->es = t->tf->ds;
  t->tf->ss = t->tf->ds;
  t->tf->eflags = FL_IF;
  t->tf->esp = PGSIZE;
  t->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  t->state = RUNNABLE;
  p->state = RUNNABLE;

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
  struct thread *ndt; // np's Default-thread
  struct proc *curproc = myproc();
  struct thread *curt = &curproc->threads[curproc->curtidx];

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  ndt = &np->threads[0];

  // Copy process state from proc. (from current thread)
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(ndt->kstack);
    ndt->kstack = 0;
    np->state = UNUSED;
	ndt->state = UNUSED;
    return -1;
  }
  // Only need the current thread's user stack in adress space
  // to-do T.T
  //
  np->sz = curproc->sz;
  np->parent = curproc;
  *ndt->tf = *curt->tf;

  // Clear %eax so that fork returns 0 in the child.
  ndt->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  ndt->state = RUNNABLE;

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
  struct thread *t;
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
	t->state = ZOMBIE;
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  struct thread *t;
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
        // Found one.
        pid = p->pid;
		// clear Thread pool
		for(int i = 0; i < NTHREAD; i++){
			t = &p->threads[i];
			kfree(t->kstack);
			t->kstack = 0;
			t->tid = 0;
			t->ret = 0;
			t->state = UNUSED;
		}
        freevm(p->pgdir); // t->ustack are also freed
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
  struct proc *p;
  struct thread *t;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;

	  // Need to choose thread.
	  int next = tscheduler(p);
	  if(next == -1)
		continue;

	  t = &p->threads[next];
	  p->curtidx = next;
      switchuvm(p);
      p->state = RUNNING;
	  t->state = RUNNING;

      swtch(&(c->scheduler), t->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
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
  struct thread *t = &p->threads[p->curtidx];

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(t->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&t->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct thread *t = &myproc()->threads[myproc()->curtidx];
  t->state = RUNNABLE;
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
    panic("sleep (p)");

  struct thread *t = &p->threads[p->curtidx];
  if(t == 0)
	panic("sleep (t)");

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
  t->chan = chan;
  t->state = SLEEPING;

  // if every thread: SLEEPING -> p:SLEEPING
  setpstate(p, SLEEPING);

  sched();

  // Tidy up.
  t->chan = 0;

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
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
      if(t->state == SLEEPING && t->chan == chan){
      	t->state = RUNNABLE;
	  }
	// check and change p->state
	setpstate(p, RUNNABLE);
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
  struct thread *t;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
	  // kill every thread in p, too
	  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
		if(t->state == SLEEPING)
		  t->state = RUNNABLE;
	  }
	  
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
  struct thread *t;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
	
	t = &p->threads[p->curtidx];
    if(t->state >= 0 && t->state < NELEM(states) && states[t->state])
      state = states[t->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(t->state == SLEEPING){
      getcallerpcs((uint*)t->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// Project 3 - private

// thread_create(): create new thread and start from start routine with arg
int
thread_create(thread_t* thread, void *(*start_routine)(void *), void *arg)
{
  struct thread *nt;
  struct proc *p = myproc();
  char *sp;
  acquire(&ptable.lock);
  // find UNUSED slot
  for(nt = p->threads; nt < &p->threads[NTHREAD]; nt++){
	if(nt->state == UNUSED)
	  goto found;
  }
  release(&ptable.lock);
  return -1;

found:
  nt->state = EMBRYO;
  nt->tid = nexttid++;

  release(&ptable.lock);

  // allocate kernel stack
  if((nt->kstack = kalloc()) == 0){
	nt->state = UNUSED;
	return -1;
  }
  sp = nt->kstack + KSTACKSIZE;

  // leave room for trap frame
  sp -= sizeof *nt->tf;
  nt->tf = (struct trapframe*)sp;

  // set up new context
  sp -= 4;
  *(uint*)sp = (uint)trapret;
  
  sp -= sizeof *nt->context;
  nt->context = (struct context*)sp;
  memset(nt->context, 0, sizeof *nt->context);
  nt->context->eip = (uint)forkret;

  // allocate user stack with a guard-page
  uint argc, usp;
  uint ustack[3+MAXARG+1];
  uint sz = PGROUNDUP(p->sz);
  if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0){
	cprintf("thread_create() fail\n");
	return -1;
  }
  clearpteu(p->pgdir, (char*)(sz - 2*PGSIZE));
  usp = sz;

  // push argument strings, prepare rest of stack in user stack
  argc = 1;
  usp = (usp - (strlen(arg) + 1)) & ~3;
  if(copyout(p->pgdir, usp, arg, strlen(arg) + 1) < 0){
	cprintf("thread_create() fail: arg copy fail\n");
	return -1;
  }
  ustack[3] = usp;
  ustack[3+argc] = 0;
  ustack[0] = 0xFFFFFFFF;	// fake return PC
  ustack[1] = 1;
  ustack[2] = usp - (argc+1)*4; // arg pointer

  usp -= (3+argc+1) * 4;
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
	cprintf("thread_create() fail: ustack->vm copy fail\n");
	return -1;
  }

  // setting routine
  p->sz = sz;
  nt->ustackp = sz;
  nt->tf->eip = (uint)start_routine;	// start_routine
  nt->tf->esp = usp;

  // save tid to thread_t*
  *thread = nt->tid;

  return 0;
}

// thread_exit(): terminate thread then return "return value" from routine
// every thread should only exit with this function
void
thread_exit(void *retval)
{
  struct proc *p = myproc();
  acquire(&ptable.lock);
  struct thread *t = &p->threads[p->curtidx];

  // do not clear resources, only change state: ZOMBIE
  t->state = ZOMBIE;
  t->ret = retval;
  // if any other proc or thread sleep, wakeup
  wakeup1((void*)t->tid);
  // then sched()
  sched();
}

// thread_join(): wait for thread with tid, get return value from thread
// by thread_exit()
int
thread_join(thread_t tid, void **retval)
{
  // first find proc & thread
  struct proc *p;
  struct thread *t;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
	  if(t->tid == tid)
		goto found;

  release(&ptable.lock);
  cprintf("thread_join() failed: tid not found\n");
  return -1;

found:
  // wait until target thread exit
  while(t->state != ZOMBIE)
	sleep((void*)t->tid, &ptable.lock);
  // now target thread exit
  *retval = t->ret;
  // Do not change any info, since reaping is only done in wait()
  release(&ptable.lock);
  return 0;
}


// tscheduler(): return next RUNNABLE thread idx from thread pool
// Basic policy is RR (the same with proc scheduler())
// ensured that ptable-lock already acquired (only-use in scheduler)
int
tscheduler(struct proc* p)
{
  int next = -1;
  int i;
  for(i = next + 1; i < NTHREAD; i++){
	if(p->threads[i].state == RUNNABLE){
	  next = i;
	  break;
	}
  }

  // still not found
  for(i = 0; i < next + 1; i++){
	if(p->threads[i].state == RUNNABLE){
	  next = i;
	  break;
	}
  }
  
  return next;
}


// setpstate() : check the every thread state and set p->state
// only check about ZOMBIE, SLEEPING
void
setpstate(struct proc *p, enum procstate check)
{
  struct thread *t;
  int flag = 1;
  switch(check){
	case SLEEPING:
	  goto ISSLEEPING;
	  break;
	case ZOMBIE:
	  goto ISZOMBIE;
	  break;
	case RUNNABLE:
	  goto ISRUNNABLE;
	  break;
	default:
	  panic("setpstate");
	  break;
  }

ISSLEEPING: // if every created threads sleep, change p states: SLEEPING
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
	if(t->state != UNUSED && t->state != SLEEPING){
	  flag = 0;
	  break;
	}
  if(flag)
	p->state = SLEEPING;
  return;

ISZOMBIE: // if every created threads are zombie, change p states: ZOMBIE
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
	if(t->state != UNUSED && t->state != ZOMBIE){
	  flag = 0;
	  break;
	}
  if(flag)
	p->state = ZOMBIE;
  return;
 
ISRUNNABLE: // if any threads are runnable, change p states: RUNNABLE
  flag = 0;
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
	if(t->state == RUNNABLE){
	  flag = 1;
	  break;
	}
  if(flag)
	p->state = RUNNABLE;
  return;
}
