; ModuleID = 'fiveopt.bc'
source_filename = "five.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.test = type { [10 x i8], void (...)* }

@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 0, void ()* @__cpi__init.module, i8* null }]

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @hello() #0 {
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0))
  ret void
}

declare dso_local i32 @printf(i8*, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.test, align 8
  store i32 0, i32* %1, align 4
  %3 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  store void (...)* bitcast (void ()* @hello to void (...)*), void (...)** %3, align 8
  call void asm sideeffect "bndmk 1($0), %bnd0", "r"(i8* bitcast (void ()* @hello to i8*), i8 0)
  %4 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  %5 = load void (...)*, void (...)** %4, align 8
  call void asm sideeffect "bndcl 1($0), %bnd0", "r"(i8* bitcast (void ()* @hello to i8*))
  call void (...) %5()
  %6 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 0
  %7 = getelementptr inbounds [10 x i8], [10 x i8]* %6, i64 0, i64 0
  %8 = call i32 (i8*, ...) bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %7)
  %9 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  %10 = load void (...)*, void (...)** %9, align 8
  call void asm sideeffect "bndcl 1($0), %bnd0", "r"(i8* bitcast (void ()* @hello to i8*))
  call void (...) %10()
  ret i32 0
}

declare dso_local i32 @gets(...) #1

declare void @__cpi__init()

define internal void @__cpi__init.module() {
  call void @__cpi__init()
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 9.0.1 "}
