	.text
	.file	"two.cc"
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
	leaq	-16(%rbp), %rdi
	callq	_ZN1BC2Ev
	leaq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rdi
	movq	(%rdi), %rax
	callq	*(%rax)
	addq	$32, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.section	.text._ZN1BC2Ev,"axG",@progbits,_ZN1BC2Ev,comdat
	.weak	_ZN1BC2Ev               # -- Begin function _ZN1BC2Ev
	.p2align	4, 0x90
	.type	_ZN1BC2Ev,@function
_ZN1BC2Ev:                              # @_ZN1BC2Ev
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -24
	movq	%rdi, -16(%rbp)
	movq	-16(%rbp), %rbx
	movq	%rbx, %rdi
	callq	_ZN1AC2Ev
	movabsq	$_ZTV1B, %rax
	addq	$16, %rax
	movq	%rax, (%rbx)
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	_ZN1BC2Ev, .Lfunc_end1-_ZN1BC2Ev
	.cfi_endproc
                                        # -- End function
	.section	.text._ZN1AC2Ev,"axG",@progbits,_ZN1AC2Ev,comdat
	.weak	_ZN1AC2Ev               # -- Begin function _ZN1AC2Ev
	.p2align	4, 0x90
	.type	_ZN1AC2Ev,@function
_ZN1AC2Ev:                              # @_ZN1AC2Ev
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movabsq	$_ZTV1A, %rax
	addq	$16, %rax
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rcx
	movq	%rax, (%rcx)
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	_ZN1AC2Ev, .Lfunc_end2-_ZN1AC2Ev
	.cfi_endproc
                                        # -- End function
	.section	.text._ZN1B3fctEv,"axG",@progbits,_ZN1B3fctEv,comdat
	.weak	_ZN1B3fctEv             # -- Begin function _ZN1B3fctEv
	.p2align	4, 0x90
	.type	_ZN1B3fctEv,@function
_ZN1B3fctEv:                            # @_ZN1B3fctEv
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movl	$42, %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end3:
	.size	_ZN1B3fctEv, .Lfunc_end3-_ZN1B3fctEv
	.cfi_endproc
                                        # -- End function
	.section	.text._ZN1A3fctEv,"axG",@progbits,_ZN1A3fctEv,comdat
	.weak	_ZN1A3fctEv             # -- Begin function _ZN1A3fctEv
	.p2align	4, 0x90
	.type	_ZN1A3fctEv,@function
_ZN1A3fctEv:                            # @_ZN1A3fctEv
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	xorl	%eax, %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end4:
	.size	_ZN1A3fctEv, .Lfunc_end4-_ZN1A3fctEv
	.cfi_endproc
                                        # -- End function
	.text
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
.Lfunc_end5:
	.size	__cpi__init.module, .Lfunc_end5-__cpi__init.module
	.cfi_endproc
                                        # -- End function
	.type	_ZTV1B,@object          # @_ZTV1B
	.section	.rodata._ZTV1B,"aG",@progbits,_ZTV1B,comdat
	.weak	_ZTV1B
	.p2align	3
_ZTV1B:
	.quad	0
	.quad	_ZTI1B
	.quad	_ZN1B3fctEv
	.size	_ZTV1B, 24

	.type	_ZTS1B,@object          # @_ZTS1B
	.section	.rodata._ZTS1B,"aG",@progbits,_ZTS1B,comdat
	.weak	_ZTS1B
_ZTS1B:
	.asciz	"1B"
	.size	_ZTS1B, 3

	.type	_ZTS1A,@object          # @_ZTS1A
	.section	.rodata._ZTS1A,"aG",@progbits,_ZTS1A,comdat
	.weak	_ZTS1A
_ZTS1A:
	.asciz	"1A"
	.size	_ZTS1A, 3

	.type	_ZTI1A,@object          # @_ZTI1A
	.section	.rodata._ZTI1A,"aG",@progbits,_ZTI1A,comdat
	.weak	_ZTI1A
	.p2align	3
_ZTI1A:
	.quad	_ZTVN10__cxxabiv117__class_type_infoE+16
	.quad	_ZTS1A
	.size	_ZTI1A, 16

	.type	_ZTI1B,@object          # @_ZTI1B
	.section	.rodata._ZTI1B,"aG",@progbits,_ZTI1B,comdat
	.weak	_ZTI1B
	.p2align	3
_ZTI1B:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	_ZTS1B
	.quad	_ZTI1A
	.size	_ZTI1B, 24

	.type	_ZTV1A,@object          # @_ZTV1A
	.section	.rodata._ZTV1A,"aG",@progbits,_ZTV1A,comdat
	.weak	_ZTV1A
	.p2align	3
_ZTV1A:
	.quad	0
	.quad	_ZTI1A
	.quad	_ZN1A3fctEv
	.size	_ZTV1A, 24

	.section	.init_array.0,"aw",@init_array
	.p2align	3
	.quad	__cpi__init.module

	.ident	"clang version 9.0.1 "
	.section	".note.GNU-stack","",@progbits
