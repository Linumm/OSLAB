#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "procqueue.h"

extern int sys_uptime(void);

// Delete the process from target queue
void
qdelete(int qlv, struct proc* p)
{
}

// Insert the process to the target queue
void
qinsert(int qlv, struct proc* p)
{
}

// Demoting the yielded process queue level
void
qdemote()
{
	struct proc *p = myproc();
	p->rst = 0;
	p->state = RUNNABLE;

	switch(p->qlv){
		case 0:
			qdelete(0, p);
			p->qlv = p->pid % 2;
			qinsert(p->qlv, p);
		case 1, 2:
			qdelete(p->qlv, p);
			p->qlv = 3;
			qinsert(3, p);
		case 3:
			if(p->priority > 0)
				p->priority--;
		default:
			break;
	}
	return;
}

// Find the next process target in the queue.
// if none in current level, go down.
// if upper level has any process, go up.
// Standard policy is to find RUNNABLE procs in one loop search
// return: index of target process in toplv queue
int
qfindnext()
{
	struct proc* p;
	int foundflag = 0;
	int i;
	for(;;){
	  // from recent choosen process's idx, search
	  for(i = recentidx+1; i < NPROC; i++){
		p = mlfq.queue[mlfq.toplv][i];
		if(p->state == RUNNABLE){
		  mlfq.recentidx = i;
		  foundflag = 1;
		  return i;
		}
	  }	
	// search the remain part of current queue (front part of recentidx)
	  for(i = 0; i <= recentidx; i++){
	    p = mlfq.queue[mlfq.toplv][i];
	    if(p->state == RUNNABLE){
		  mlfq.recentidx = i;
		  foundflag = 1;
		  return i;
	    }
	  }
	  if(toplv == 3) {} // WHAT IF NO PROCESS RUNNABLE? > THINK
	  toplv++;
	}
	return 0;
}
void
qscheduler(void)
{
	struct proc *p;
	struct cpu *c = mycpu();
	c->proc = 0;

	for(;;){
		// Enable interrupts on this processor.
		sti();

		acquire(&mlfq.lock);
		while(1){
			int idx = qfindnext();
			p = mlfq.queue[mlfq.toplv][idx];
			if(p == 0){
				//
			}

			c->proc = p;
			switchuvm(p);
			p->state = RUNNING;

			swtch(&(c->scheduler), p->context);
			switchkvm();

			c->proc = 0;
		}
		release(&mlfq.lock);
	}
}

