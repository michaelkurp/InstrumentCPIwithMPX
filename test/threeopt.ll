; ModuleID = 'threeopt.bc'
source_filename = "three.c"
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
define dso_local i32 @sub(i32, i32) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %5 = load i32, i32* %3, align 4
  %6 = load i32, i32* %4, align 4
  %7 = sub nsw i32 %5, %6
  ret i32 %7
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 (i32, i32)* @goo(i32, i32, i32 (i32, i32)*, i32 (i32, i32)*) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32 (i32, i32)*, align 8
  %8 = alloca i32 (i32, i32)*, align 8
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store i32 (i32, i32)* %2, i32 (i32, i32)** %7, align 8
  store i32 (i32, i32)* %3, i32 (i32, i32)** %8, align 8
  %9 = load i32 (i32, i32)*, i32 (i32, i32)** %8, align 8
  ret i32 (i32, i32)* %9
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32, i32, i32 (i32, i32)*, i32 (i32, i32)*) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32 (i32, i32)*, align 8
  %8 = alloca i32 (i32, i32)*, align 8
  %9 = alloca i32 (i32, i32)*, align 8
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store i32 (i32, i32)* %2, i32 (i32, i32)** %7, align 8
  store i32 (i32, i32)* %3, i32 (i32, i32)** %8, align 8
  %10 = load i32, i32* %5, align 4
  %11 = load i32, i32* %6, align 4
  %12 = load i32 (i32, i32)*, i32 (i32, i32)** %7, align 8
  %13 = load i32 (i32, i32)*, i32 (i32, i32)** %8, align 8
  %14 = call i32 (i32, i32)* @goo(i32 %10, i32 %11, i32 (i32, i32)* %12, i32 (i32, i32)* %13)
  store i32 (i32, i32)* %14, i32 (i32, i32)** %9, align 8
  %15 = load i32 (i32, i32)*, i32 (i32, i32)** %9, align 8
  %16 = load i32, i32* %5, align 4
  %17 = load i32, i32* %6, align 4
  %18 = call i32 %15(i32 %16, i32 %17)
  ret i32 %18
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @moo(i8 signext, i32, i32) #0 {
  %4 = alloca i8, align 1
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32 (i32, i32)*, align 8
  %8 = alloca i32 (i32, i32)*, align 8
  %9 = alloca i32 (i32, i32)*, align 8
  %10 = alloca i32, align 4
  store i8 %0, i8* %4, align 1
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  store i32 (i32, i32)* @add, i32 (i32, i32)** %7, align 8
  call void asm sideeffect "bndmk 1($0), %bnd0", "r"(i8* bitcast (i32 (i32, i32)* @add to i8*), i8 0)
  store i32 (i32, i32)* @sub, i32 (i32, i32)** %8, align 8
  call void asm sideeffect "bndmk 1($0), %bnd1", "r"(i8* bitcast (i32 (i32, i32)* @sub to i8*), i8 1)
  store i32 (i32, i32)* null, i32 (i32, i32)** %9, align 8
  %11 = load i8, i8* %4, align 1
  %12 = sext i8 %11 to i32
  %13 = icmp eq i32 %12, 43
  br i1 %13, label %14, label %16

14:                                               ; preds = %3
  %15 = load i32 (i32, i32)*, i32 (i32, i32)** %7, align 8
  store i32 (i32, i32)* %15, i32 (i32, i32)** %9, align 8
  br label %23

16:                                               ; preds = %3
  %17 = load i8, i8* %4, align 1
  %18 = sext i8 %17 to i32
  %19 = icmp eq i32 %18, 45
  br i1 %19, label %20, label %22

20:                                               ; preds = %16
  %21 = load i32 (i32, i32)*, i32 (i32, i32)** %8, align 8
  store i32 (i32, i32)* %21, i32 (i32, i32)** %9, align 8
  br label %22

22:                                               ; preds = %20, %16
  br label %23

23:                                               ; preds = %22, %14
  %24 = load i32, i32* %5, align 4
  %25 = load i32, i32* %6, align 4
  %26 = load i32 (i32, i32)*, i32 (i32, i32)** %7, align 8
  %27 = load i32 (i32, i32)*, i32 (i32, i32)** %9, align 8
  %28 = call i32 @foo(i32 %24, i32 %25, i32 (i32, i32)* %26, i32 (i32, i32)* %27)
  store i32 %28, i32* %10, align 4
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
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
