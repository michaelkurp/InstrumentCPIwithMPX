	.text
	.file	"three.c"
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
	.globl	goo                     # -- Begin function goo
	.p2align	4, 0x90
	.type	goo,@function
goo:                                    # @goo
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	%edi, -16(%rbp)
	movl	%esi, -12(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -8(%rbp)
	movq	-8(%rbp), %rax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	goo, .Lfunc_end2-goo
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
	subq	$32, %rsp
	movl	%edi, -8(%rbp)
	movl	%esi, -4(%rbp)
	movq	%rdx, -32(%rbp)
	movq	%rcx, -24(%rbp)
	movl	-8(%rbp), %edi
	movl	-4(%rbp), %esi
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	callq	goo
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	-8(%rbp), %edi
	movl	-4(%rbp), %esi
	callq	*%rax
	addq	$32, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end3:
	.size	foo, .Lfunc_end3-foo
	.cfi_endproc
                                        # -- End function
	.globl	moo                     # -- Begin function moo
	.p2align	4, 0x90
	.type	moo,@function
moo:                                    # @moo
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$48, %rsp
	movb	%dil, -1(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -20(%rbp)
	movabsq	$add, %rax
	movq	%rax, -32(%rbp)
	movl	$add, %eax
	#APP
	bndmk	1(%rax), %bnd0
	#NO_APP
	movabsq	$sub, %rax
	movq	%rax, -40(%rbp)
	movl	$sub, %eax
	#APP
	bndmk	1(%rax), %bnd1
	#NO_APP
	movq	$0, -16(%rbp)
	movsbl	-1(%rbp), %eax
	cmpl	$43, %eax
	jne	.LBB4_2
# %bb.1:
	movq	-32(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	.LBB4_5
.LBB4_2:
	movsbl	-1(%rbp), %eax
	cmpl	$45, %eax
	jne	.LBB4_4
# %bb.3:
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
.LBB4_4:
	jmp	.LBB4_5
.LBB4_5:
	movl	-24(%rbp), %edi
	movl	-20(%rbp), %esi
	movq	-32(%rbp), %rdx
	movq	-16(%rbp), %rcx
	callq	foo
	movl	%eax, -44(%rbp)
	xorl	%eax, %eax
	addq	$48, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end4:
	.size	moo, .Lfunc_end4-moo
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
	movl	$0, -4(%rbp)
	xorl	%eax, %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
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
.Lfunc_end6:
	.size	__cpi__init.module, .Lfunc_end6-__cpi__init.module
	.cfi_endproc
                                        # -- End function
	.section	.init_array.0,"aw",@init_array
	.p2align	3
	.quad	__cpi__init.module

	.ident	"clang version 9.0.1 "
	.section	".note.GNU-stack","",@progbits
