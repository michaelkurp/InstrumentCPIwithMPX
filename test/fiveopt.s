	.text
	.file	"five.c"
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
.Lfunc_end0:
	.size	hello, .Lfunc_end0-hello
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
	movl	$0, -4(%rbp)
	movq	%rax, -16(%rbp)
	movl	$hello, %eax
	#APP
	bndmk	1(%rax), %bnd0
	#NO_APP
	movq	-16(%rbp), %rcx
	movl	$hello, %eax
	#APP
	bndcl	1(%rax), %bnd0
	#NO_APP
	movb	$0, %al
	callq	*%rcx
	leaq	-32(%rbp), %rdi
	movb	$0, %al
	callq	gets
	movq	-16(%rbp), %rcx
	movl	$hello, %eax
	#APP
	bndcl	1(%rax), %bnd0
	#NO_APP
	movb	$0, %al
	callq	*%rcx
	xorl	%eax, %eax
	addq	$32, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
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
.Lfunc_end2:
	.size	__cpi__init.module, .Lfunc_end2-__cpi__init.module
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.section	.init_array.0,"aw",@init_array
	.p2align	3
	.quad	__cpi__init.module

	.ident	"clang version 9.0.1 "
	.section	".note.GNU-stack","",@progbits
