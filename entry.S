#define LOW_MEMORY (1 << 22)

.section ".text.boot"

.global _start

_start:
	mrs x0, mpidr_el1
	and x0, x0, #3
	cbz x0, core0_main
	b proc_inf_loop

proc_inf_loop:
	b proc_inf_loop

bzero:
	str xzr, [x0], #8
	subs x1, x1, #8
	b.gt bzero
	ret

core0_main:
	adr x0, bss_begin
	adr x1, bss_end
	sub x1, x1, x0
	bl bzero

	mov sp, #LOW_MEMORY
	bl kernel_main
	
