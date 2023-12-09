#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
}

int sys_exit(void)
{
  exit();
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
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
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_find_digital_root(void)
{
  int number = myproc()->tf->ebx; // register after eax
  return find_digital_root(number);
}

int sys_get_uncle_count(void)
{
  int pid;

  if (argint(0, &pid) < 0)
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
  return count_child(grandFather) - 1;
}
int sys_get_process_lifetime(void)
{
  int pid;
  if (argint(0, &pid) < 0)
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
}
void sys_set_date(void)
{
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
}
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
  return myproc()->parent->pid;
}
int sys_change_queue(void)
{
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
    return -1;
  cprintf("%d\n", pid);
  struct proc *p = find_proc(pid);
  p->que_id = que_id;
  return 0;
}
int sys_bjf_validation_process(void)
{
  
  int pid;
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argf(1, &priority_ratio) < 0 || argf(2, &creation_time_ratio) < 0 || argf(3, &exec_cycle_ratio) < 0 || argf(4, &size_ratio) < 0)
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
  p->priority_ratio = priority_ratio;
  p->creation_time_ratio = creation_time_ratio;
  p->executed_cycle_ratio = exec_cycle_ratio;
  p->process_size_ratio = size_ratio;

  return 0;
}
int sys_bjf_validation_system(void)
{
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argf(0, &priority_ratio) < 0 || argf(1, &creation_time_ratio) < 0 || argf(2, &exec_cycle_ratio) < 0 || argf(3, &size_ratio) < 0)
  {
    return -1;
  }
  reset_bjf_attributes(priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio);
  return 0;
}
int sys_print_info(void)
{
  print_bitches();
  return 0;
}