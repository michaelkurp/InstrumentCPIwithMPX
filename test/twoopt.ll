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
  call void asm sideeffect "bndmk ($0, $1), %bnd0", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %8, i8 0)
  %9 = bitcast i32 (i32, i32)** %3 to i8*
  store i32 (i32, i32)* @add, i32 (i32, i32)** %3, align 8
  call void asm sideeffect "bndmk ($0, $1), %bnd1", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %9, i8 1)
  store i32 1, i32* %4, align 4
  store i32 2, i32* %5, align 4
  %10 = load i32 (i32, i32)*, i32 (i32, i32)** %2, align 8
  %11 = load i32, i32* %4, align 4
  %12 = load i32, i32* %5, align 4
  %13 = bitcast i32 (i32, i32)** %3 to i8*
  call void asm sideeffect "bndcl ($0), %bnd1", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %13)
  %14 = call i32 %10(i32 %11, i32 %12)
  store i32 %14, i32* %6, align 4
  %15 = load i32 (i32, i32)*, i32 (i32, i32)** %3, align 8
  %16 = load i32, i32* %4, align 4
  %17 = load i32, i32* %5, align 4
  %18 = bitcast i32 (i32, i32)** %3 to i8*
  call void asm sideeffect "bndcl ($0), %bnd1", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %18)
  %19 = call i32 %15(i32 %16, i32 %17)
  store i32 %19, i32* %7, align 4
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
