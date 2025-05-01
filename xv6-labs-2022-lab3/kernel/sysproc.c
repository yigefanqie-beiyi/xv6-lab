#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


//int pgaccess(void *base, int len, void *mask);
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  uint64 base, mask_user;
  uint64 mask_kernel = 0;
  int len;
  argaddr(0, &base);
  argint(1, &len);
  argaddr(2, &mask_user);
  if(len > 64) return -1;
  struct proc *p = myproc();
  pte_t *pte;
  if((pte = walk(p->pagetable, base, 0)) == 0) return -1;
  //循环检查
  for(int i = 0; i < len; i++){
    if(*pte & PTE_A){
      mask_kernel |= (1 << i);
    }
    *pte &= ~PTE_A;
    pte++;
  }
  //利用copyout复制回用户空间
  if(copyout(p->pagetable, mask_user, (char*)&mask_kernel, sizeof(uint64)) < 0) return -1;
  return 0;
}


uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
