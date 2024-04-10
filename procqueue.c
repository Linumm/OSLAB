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
			if (p->priority > 0)
				p->priority--;
		default:
			break;
	}
	return;
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
			p = qfindnext();
			
			if (p == 0){
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

