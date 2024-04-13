#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// lab-user-define
int
sys_getgpid(void)
{
  return myproc()->parent->parent->pid;
}
int
sys_yield(void)
{
  yield();
  return 0;
}
int
sys_getlev(void)
{
  if(myproc()->moqid != -1) return 99;
  else return myproc()->qlv;
}
int
sys_setpriority(void)
{
  int pid;
  int pr;
  struct proc *p;
  argint(0, &pid);
  argint(1, &pr);

  if (pid < -1) return -1;
  if (pr < 0 && pr > 10) return -2;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if(p->pid == pid){
	  p->priority = pr;
	  return 0;
	}
  }
  return -1;
}
int
sys_setmonopoly(void)
{
  struct proc *p;
  int pid;
  int password;
  argint(0, &pid);
  argint(1, &password);
  int studentID = 2020002542;

  if(password != studentID) return -2;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if(p->pid == pid){
	  p->moqid = ptable.nextmoqid;
	  ptable.nextmoqid++;
	  ptable.moqsize++;
	  return ptable.moqsize;
	}
  }

  // pid process not found
  return -1;
}
int
sys_monopolize(void)
{
  acquire(&ptable.lock);
  ptable.ismlfq = 0;
  release(&ptable.lock);
  yield();
}
int
sys_unmonopolize(void)
{
  acquire(&ptable.lock);
  ptable.ismlfq = 1;
  release(&ptable.lock);
  yield();
}
