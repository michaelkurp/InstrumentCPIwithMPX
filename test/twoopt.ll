; ModuleID = 'twoopt.bc'
source_filename = "two.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 0, void ()* @__cpi__init.module, i8* null }]

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @add(i32, i32) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load i32, i32* %4, align 4
  %7 = add nsw i32 %5, %6
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32 (i32, i32)*, align 8
  %3 = alloca i32 (i32, i32)*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %8 = bitcast i32 (i32, i32)** %2 to i8*
  store i32 (i32, i32)* @add, i32 (i32, i32)** %2, align 8
  call void asm sideeffect "bndmk 1($0), %bnd0", "r"(i8* bitcast (i32 (i32, i32)* @add to i8*), i8 0)
  call void asm sideeffect "movq $0, %rdx", "r"(i64 0)
  call void asm sideeffect "bndstx %bnd0, ($0, %rdx, 1)", "r"(i8* %8)
  %9 = bitcast i32 (i32, i32)** %3 to i8*
  store i32 (i32, i32)* @add, i32 (i32, i32)** %3, align 8
  call void asm sideeffect "bndmk 1($0), %bnd1", "r"(i8* bitcast (i32 (i32, i32)* @add to i8*), i8 1)
  call void asm sideeffect "movq $0, %rdx", "r"(i64 0)
  call void asm sideeffect "bndstx %bnd1, ($0, %rdx, 1)", "r"(i8* %9)
  store i32 1, i32* %4, align 4
  store i32 2, i32* %5, align 4
  %10 = load i32 (i32, i32)*, i32 (i32, i32)** %2, align 8
  %11 = load i32, i32* %4, align 4
  %12 = load i32, i32* %5, align 4
  %13 = bitcast i32 (i32, i32)** %2 to i8*
  call void asm sideeffect "movq $0, %rdx", "r"(i64 0)
  call void asm sideeffect "bndldx ($0, %rdx, 1), %bnd1", "r"(i8* %13)
  %14 = bitcast i32 (i32, i32)* %10 to i64*
  call void asm sideeffect "bndcl ($0), %bnd1", "r"(i64* %14)
  %15 = bitcast i32 (i32, i32)* %10 to i64*
  call void asm sideeffect "bndcu ($0), %bnd1", "r"(i64* %15)
  %16 = call i32 %10(i32 %11, i32 %12)
  store i32 %16, i32* %6, align 4
  %17 = load i32 (i32, i32)*, i32 (i32, i32)** %3, align 8
  %18 = load i32, i32* %4, align 4
  %19 = load i32, i32* %5, align 4
  %20 = bitcast i32 (i32, i32)** %3 to i8*
  call void asm sideeffect "movq $0, %rdx", "r"(i64 0)
  call void asm sideeffect "bndldx ($0, %rdx, 1), %bnd1", "r"(i8* %20)
  %21 = bitcast i32 (i32, i32)* %17 to i64*
  call void asm sideeffect "bndcl ($0), %bnd1", "r"(i64* %21)
  %22 = bitcast i32 (i32, i32)* %17 to i64*
  call void asm sideeffect "bndcu ($0), %bnd1", "r"(i64* %22)
  %23 = call i32 %17(i32 %18, i32 %19)
  store i32 %23, i32* %7, align 4
  ret i32 0
}

declare void @__cpi__init()

define internal void @__cpi__init.module() {
  call void @__cpi__init()
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 9.0.1 "}
