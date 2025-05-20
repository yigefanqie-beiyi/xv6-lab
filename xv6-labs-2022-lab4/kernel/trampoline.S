#include "riscv.h"
#include "memlayout.h"

.section trampsec
.globl trampoline
trampoline:
.align 4
.globl uservec
uservec:    
        # 将a0寄存器的值存到sscratch寄存器中保存起来
        # a0存的是要切换的pagetable的地址
        # 先把a0的值暂存起来，因为后面要用a0来当做指针的角色将各种寄存器加载到trapframe中
        csrw sscratch, a0

        # li指令是加载立即数的伪指令，用于将一个立即数加载到寄存器中
        # 这里将TRAPFRAME的值加载到a0寄存器中
        li a0, TRAPFRAME
        
        # 保存各种寄存器到 TRAPFRAME 中，trapframe 是一个结构体，在proc.h中定义
        sd ra, 40(a0)
        sd sp, 48(a0)
        sd gp, 56(a0)
        sd tp, 64(a0)
        sd t0, 72(a0)
        sd t1, 80(a0)
        sd t2, 88(a0)
        sd s0, 96(a0)
        sd s1, 104(a0)
        sd a1, 120(a0)
        sd a2, 128(a0)
        sd a3, 136(a0)
        sd a4, 144(a0)
        sd a5, 152(a0)
        sd a6, 160(a0)
        sd a7, 168(a0)
        sd s2, 176(a0)
        sd s3, 184(a0)
        sd s4, 192(a0)
        sd s5, 200(a0)
        sd s6, 208(a0)
        sd s7, 216(a0)
        sd s8, 224(a0)
        sd s9, 232(a0)
        sd s10, 240(a0)
        sd s11, 248(a0)
        sd t3, 256(a0)
        sd t4, 264(a0)
        sd t5, 272(a0)
        sd t6, 280(a0)

	# 将sscratch的值读到t0寄存器中，再将t0寄存器的值存到TRAPFRAME的地址中
        # 这里的sscratch寄存器是一个特殊寄存器，存储上文一开始保存的a0寄存器的值
        csrr t0, sscratch
        sd t0, 112(a0)

        # initialize kernel stack pointer, from p->trapframe->kernel_sp
        ld sp, 8(a0)

        # make tp hold the current hartid, from p->trapframe->kernel_hartid
        ld tp, 32(a0)

        # load the address of usertrap(), from p->trapframe->kernel_trap
        ld t0, 16(a0)


        # fetch the kernel page table address, from p->trapframe->kernel_satp.
        ld t1, 0(a0)

        # 确保切换页表前所有的内存操作已完成
        sfence.vma zero, zero

        # 切换页表空间
        csrw satp, t1

        # 刷新TLB，防止旧的映射影响新的空间寻址
        sfence.vma zero, zero

        # 跳到usertrap函数执行
        jr t0

.globl userret
userret:
        # userret(pagetable)
        # called by usertrapret() in trap.c to
        # switch from kernel to user.
        # a0: user page table, for satp.

        # 同样，标准的页表切换步骤
        sfence.vma zero, zero
        csrw satp, a0
        sfence.vma zero, zero

        li a0, TRAPFRAME

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
        ld sp, 48(a0)
        ld gp, 56(a0)
        ld tp, 64(a0)
        ld t0, 72(a0)
        ld t1, 80(a0)
        ld t2, 88(a0)
        ld s0, 96(a0)
        ld s1, 104(a0)
        ld a1, 120(a0)
        ld a2, 128(a0)
        ld a3, 136(a0)
        ld a4, 144(a0)
        ld a5, 152(a0)
        ld a6, 160(a0)
        ld a7, 168(a0)
        ld s2, 176(a0)
        ld s3, 184(a0)
        ld s4, 192(a0)
        ld s5, 200(a0)
        ld s6, 208(a0)
        ld s7, 216(a0)
        ld s8, 224(a0)
        ld s9, 232(a0)
        ld s10, 240(a0)
        ld s11, 248(a0)
        ld t3, 256(a0)
        ld t4, 264(a0)
        ld t5, 272(a0)
        ld t6, 280(a0)

	# restore user a0
        ld a0, 112(a0)
        
        # 从sepc中取出用户态的程序计数器，加载到pc中
        # 从sstatus寄存器中恢复用户态的处理器状态，例如启用中断，切换回用户模式等
        sret
