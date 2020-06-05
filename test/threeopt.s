	.text
	.file	"three.c"
	.globl	fct0                    # -- Begin function fct0
	.p2align	4, 0x90
	.type	fct0,@function
fct0:                                   # @fct0
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	xorl	%eax, %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	fct0, .Lfunc_end0-fct0
	.cfi_endproc
                                        # -- End function
	.globl	fct1                    # -- Begin function fct1
	.p2align	4, 0x90
	.type	fct1,@function
fct1:                                   # @fct1
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	$1, %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	fct1, .Lfunc_end1-fct1
	.cfi_endproc
                                        # -- End function
	.globl	fct2                    # -- Begin function fct2
	.p2align	4, 0x90
	.type	fct2,@function
fct2:                                   # @fct2
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	$2, %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	fct2, .Lfunc_end2-fct2
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
	movl	$0, -20(%rbp)
	movl	%edi, -4(%rbp)
	movq	%rsi, -32(%rbp)
	movslq	-4(%rbp), %rax
	movq	fcts(,%rax,8), %rax
	movq	%rax, -16(%rbp)
	callq	*-16(%rbp)
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
	.type	fcts2,@object           # @fcts2
	.data
	.globl	fcts2
	.p2align	4
fcts2:
	.quad	fct0
	.quad	fct1
	.quad	fct2
	.size	fcts2, 24

	.type	fcts,@object            # @fcts
	.section	.rodata,"a",@progbits
	.p2align	4
fcts:
	.quad	fct0
	.quad	fct1
	.quad	fct2
	.size	fcts, 24

	.section	.init_array.0,"aw",@init_array
	.p2align	3
	.quad	__cpi__init.module

	.ident	"clang version 9.0.1 "
	.section	".note.GNU-stack","",@progbits
