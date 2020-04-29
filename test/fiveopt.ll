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
  %4 = bitcast void (...)** %3 to i8*
  store void (...)* bitcast (void ()* @hello to void (...)*), void (...)** %3, align 8
  call void asm sideeffect "bndmk ($0, $1), %bnd0", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %4, i8 0)
  %5 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  %6 = load void (...)*, void (...)** %5, align 8
  %7 = bitcast void (...)** %3 to i8*
  call void asm sideeffect "bndcl ($0), %bnd0", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %7)
  call void (...) %6()
  %8 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 0
  %9 = getelementptr inbounds [10 x i8], [10 x i8]* %8, i64 0, i64 0
  %10 = call i32 (i8*, ...) bitcast (i32 (...)* @gets to i32 (i8*, ...)*)(i8* %9)
  %11 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  %12 = load void (...)*, void (...)** %11, align 8
  %13 = bitcast void (...)** %3 to i8*
  call void asm sideeffect "bndcl ($0), %bnd0", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %13)
  call void (...) %12()
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
