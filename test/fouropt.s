	.text
	.file	"four.c"
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
	.globl	sub                     # -- Begin function sub
	.p2align	4, 0x90
	.type	sub,@function
sub:                                    # @sub
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
	subl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	sub, .Lfunc_end1-sub
	.cfi_endproc
                                        # -- End function
	.globl	foo                     # -- Begin function foo
	.p2align	4, 0x90
	.type	foo,@function
foo:                                    # @foo
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$48, %rsp
	movl	%edi, -20(%rbp)
	movabsq	$add, %rax
	movq	%rax, -40(%rbp)
	movl	$add, %eax
	#APP
	bndmk	1(%rax), %bnd0
	#NO_APP
	movabsq	$sub, %rax
	movq	%rax, -32(%rbp)
	movl	$sub, %eax
	#APP
	bndmk	1(%rax), %bnd1
	#NO_APP
	movq	$0, -8(%rbp)
	movl	$1, -16(%rbp)
	movl	$2, -12(%rbp)
	cmpl	$3, -20(%rbp)
	jne	.LBB2_2
# %bb.1:
	movq	-40(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	.LBB2_3
.LBB2_2:
	movq	-32(%rbp), %rax
	movq	%rax, -8(%rbp)
.LBB2_3:
	cmpq	$0, -8(%rbp)
	je	.LBB2_5
# %bb.4:
	movq	-8(%rbp), %rax
	movl	-16(%rbp), %edi
	movl	-12(%rbp), %esi
	movl	$sub, %ecx
	#APP
	bndcu	(%rcx), %bnd1
	#NO_APP
	callq	*%rax
	movl	%eax, -44(%rbp)
.LBB2_5:
	xorl	%eax, %eax
	addq	$48, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo
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
	subq	$16, %rsp
	movl	$0, -8(%rbp)
	movl	$2, %edi
	callq	foo
	movl	%eax, -4(%rbp)
	xorl	%eax, %eax
	addq	$16, %rsp
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
	.section	.init_array.0,"aw",@init_array
	.p2align	3
	.quad	__cpi__init.module

	.ident	"clang version 9.0.1 "
	.section	".note.GNU-stack","",@progbits
