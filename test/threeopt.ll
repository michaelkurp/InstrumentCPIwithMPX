; ModuleID = 'threeopt.bc'
source_filename = "three.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@fcts2 = dso_local global [3 x i32 ()*] [i32 ()* @fct0, i32 ()* @fct1, i32 ()* @fct2], align 16
@fcts = internal constant [3 x i32 ()*] [i32 ()* @fct0, i32 ()* @fct1, i32 ()* @fct2], align 16
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 0, void ()* @__cpi__init.module, i8* null }]

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fct0() #0 {
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fct1() #0 {
  ret i32 1
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fct2() #0 {
  ret i32 2
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32 ()*, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  %7 = load i32, i32* %4, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [3 x i32 ()*], [3 x i32 ()*]* @fcts, i64 0, i64 %8
  %10 = load i32 ()*, i32 ()** %9, align 8
  store i32 ()* %10, i32 ()** %6, align 8
  %11 = load i32 ()*, i32 ()** %6, align 8
  %12 = call i32 %11()
  ret i32 %12
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
