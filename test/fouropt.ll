; ModuleID = 'fouropt.bc'
source_filename = "four.c"
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
define dso_local i32 @foo(i32) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32 (i32, i32)*, align 8
  %4 = alloca i32 (i32, i32)*, align 8
  %5 = alloca i32 (i32, i32)*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  store i32 (i32, i32)* @add, i32 (i32, i32)** %3, align 8
  call void asm sideeffect "bndmk 1($0), %bnd0", "r"(i8* bitcast (i32 (i32, i32)* @add to i8*), i8 0)
  store i32 (i32, i32)* @sub, i32 (i32, i32)** %4, align 8
  call void asm sideeffect "bndmk 1($0), %bnd1", "r"(i8* bitcast (i32 (i32, i32)* @sub to i8*), i8 1)
  store i32 (i32, i32)* null, i32 (i32, i32)** %5, align 8
  store i32 1, i32* %6, align 4
  store i32 2, i32* %7, align 4
  %9 = load i32, i32* %2, align 4
  %10 = icmp eq i32 %9, 3
  br i1 %10, label %11, label %13

11:                                               ; preds = %1
  %12 = load i32 (i32, i32)*, i32 (i32, i32)** %3, align 8
  store i32 (i32, i32)* %12, i32 (i32, i32)** %5, align 8
  br label %15

13:                                               ; preds = %1
  %14 = load i32 (i32, i32)*, i32 (i32, i32)** %4, align 8
  store i32 (i32, i32)* %14, i32 (i32, i32)** %5, align 8
  br label %15

15:                                               ; preds = %13, %11
  %16 = load i32 (i32, i32)*, i32 (i32, i32)** %5, align 8
  %17 = icmp ne i32 (i32, i32)* %16, null
  br i1 %17, label %18, label %23

18:                                               ; preds = %15
  %19 = load i32 (i32, i32)*, i32 (i32, i32)** %5, align 8
  %20 = load i32, i32* %6, align 4
  %21 = load i32, i32* %7, align 4
  call void asm sideeffect "bndcu ($0), %bnd1", "r"(i16* bitcast (i32 (i32, i32)* @sub to i16*))
  %22 = call i32 %19(i32 %20, i32 %21)
  store i32 %22, i32* %8, align 4
  br label %23

23:                                               ; preds = %18, %15
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %3 = call i32 @foo(i32 2)
  store i32 %3, i32* %2, align 4
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
