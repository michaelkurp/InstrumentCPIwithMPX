	.text
	.file	"five.c"
	.globl	breakme                 # -- Begin function breakme
	.p2align	4, 0x90
	.type	breakme,@function
breakme:                                # @breakme
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	breakme, .Lfunc_end0-breakme
	.cfi_endproc
                                        # -- End function
	.globl	hello                   # -- Begin function hello
	.p2align	4, 0x90
	.type	hello,@function
hello:                                  # @hello
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movabsq	$.L.str, %rdi
	movb	$0, %al
	callq	printf
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	hello, .Lfunc_end1-hello
	.cfi_endproc
                                        # -- End function
	.globl	pwn                     # -- Begin function pwn
	.p2align	4, 0x90
	.type	pwn,@function
pwn:                                    # @pwn
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movabsq	$.L.str.1, %rdi
	movb	$0, %al
	callq	printf
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	pwn, .Lfunc_end2-pwn
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movabsq	$hello, %rax
	movl	$0, -20(%rbp)
	leaq	-16(%rbp), %rcx
	addq	$8, %rcx
	movq	%rax, -8(%rbp)
	movl	$hello, %eax
	#APP
	bndmk	1(%rax), %bnd0
	#NO_APP
	xorl	%eax, %eax
	#APP
	movq	%rax, %rdx
	#NO_APP
	#APP
	bndstx	%bnd0, (%rcx,%rdx)
	#NO_APP
	leaq	-16(%rbp), %rax
	addq	$8, %rax
	movq	-8(%rbp), %rcx
	xorl	%edx, %edx
	#APP
	movq	%rdx, %rdx
	#NO_APP
	#APP
	bndldx	(%rax,%rdx), %bnd0
	#NO_APP
	#APP
	bndcl	(%rcx), %bnd0
	#NO_APP
	#APP
	bndcu	(%rcx), %bnd0
	#NO_APP
	movb	$0, %al
	callq	*%rcx
	leaq	-16(%rbp), %rdi
	movl	$.L.str.2, %esi
	callq	strcpy
	callq	breakme
	leaq	-16(%rbp), %rax
	addq	$8, %rax
	movq	-8(%rbp), %rcx
	xorl	%edx, %edx
	#APP
	movq	%rdx, %rdx
	#NO_APP
	#APP
	bndldx	(%rax,%rdx), %bnd0
	#NO_APP
	#APP
	bndcl	(%rcx), %bnd0
	#NO_APP
	#APP
	bndcu	(%rcx), %bnd0
	#NO_APP
	movb	$0, %al
	callq	*%rcx
	xorl	%eax, %eax
	addq	$32, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90         # -- Begin function __cpi__init.module
	.type	__cpi__init.module,@function
__cpi__init.module:                     # @__cpi__init.module
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	__cpi__init
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end4:
	.size	__cpi__init.module, .Lfunc_end4-__cpi__init.module
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"Thou base belongs to us"
	.size	.L.str.1, 24

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"@@@@@@@@@\007@"
	.size	.L.str.2, 12

	.section	.init_array.0,"aw",@init_array
	.p2align	3
	.quad	__cpi__init.module

	.ident	"clang version 9.0.1 "
	.section	".note.GNU-stack","",@progbits
