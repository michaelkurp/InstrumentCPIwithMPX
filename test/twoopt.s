	.text
	.file	"two.c"
	.globl	add                     # -- Begin function add
	.p2align	4, 0x90
	.type	add,@function
add:                                    # @add
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	%edi, -8(%rbp)
	movl	%esi, -4(%rbp)
	movl	-8(%rbp), %eax
	addl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	add, .Lfunc_end0-add
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
	subq	$48, %rsp
	movl	$0, -36(%rbp)
	movabsq	$add, %rax
	movq	%rax, -24(%rbp)
	movl	$add, %eax
	#APP
	bndmk	1(%rax), %bnd0
	#NO_APP
	movabsq	$add, %rax
	movq	%rax, -16(%rbp)
	movl	$add, %eax
	#APP
	bndmk	1(%rax), %bnd1
	#NO_APP
	movl	$1, -8(%rbp)
	movl	$2, -4(%rbp)
	movq	-24(%rbp), %rax
	movl	-8(%rbp), %edi
	movl	-4(%rbp), %esi
	movl	$add, %ecx
	#APP
	bndcu	(%rcx), %bnd1
	#NO_APP
	callq	*%rax
	movl	%eax, -32(%rbp)
	movq	-16(%rbp), %rax
	movl	-8(%rbp), %edi
	movl	-4(%rbp), %esi
	movl	$add, %ecx
	#APP
	bndcu	(%rcx), %bnd1
	#NO_APP
	callq	*%rax
	movl	%eax, -28(%rbp)
	xorl	%eax, %eax
	addq	$48, %rsp
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
	.section	.init_array.0,"aw",@init_array
	.p2align	3
	.quad	__cpi__init.module

	.ident	"clang version 9.0.1 "
	.section	".note.GNU-stack","",@progbits
