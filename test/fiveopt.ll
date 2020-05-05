; ModuleID = 'fiveopt.bc'
source_filename = "five.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.test = type { [2 x i8], void (...)* }

@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.1 = private unnamed_addr constant [24 x i8] c"Thou base belongs to us\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"@@@@@@@@@\07@\00", align 1
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 0, void ()* @__cpi__init.module, i8* null }]

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @breakme() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @hello() #0 {
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0))
  ret void
}

declare dso_local i32 @printf(i8*, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @pwn() #0 {
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.1, i64 0, i64 0))
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.test, align 8
  store i32 0, i32* %1, align 4
  %3 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  %4 = bitcast void (...)** %3 to i8*
  store void (...)* bitcast (void ()* @hello to void (...)*), void (...)** %3, align 8
  call void asm sideeffect "bndmk 1($0), %bnd0", "r"(i8* bitcast (void ()* @hello to i8*), i8 0)
  call void asm sideeffect "bndstx %bnd0, ($0, 0, 1)", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %4)
  %5 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  %6 = load void (...)*, void (...)** %5, align 8
  %7 = bitcast void (...)** %5 to i8*
  call void asm sideeffect "bndldx ($0, 0, 1), %bnd0", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %7)
  %8 = bitcast void (...)* %6 to i64*
  call void asm sideeffect "bndcl ($0), %bnd0", "r"(i64* %8)
  %9 = bitcast void (...)* %6 to i64*
  call void asm sideeffect "bndcu ($0), %bnd0", "r"(i64* %9)
  call void (...) %6()
  %10 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 0
  %11 = getelementptr inbounds [2 x i8], [2 x i8]* %10, i64 0, i64 0
  %12 = call i8* @strcpy(i8* %11, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i64 0, i64 0)) #3
  call void @breakme()
  %13 = getelementptr inbounds %struct.test, %struct.test* %2, i32 0, i32 1
  %14 = load void (...)*, void (...)** %13, align 8
  %15 = bitcast void (...)** %13 to i8*
  call void asm sideeffect "bndldx ($0, 0, 1), %bnd0", "r,~{dirflag}, ~{fpsr}, ~{flags}"(i8* %15)
  %16 = bitcast void (...)* %14 to i64*
  call void asm sideeffect "bndcl ($0), %bnd0", "r"(i64* %16)
  %17 = bitcast void (...)* %14 to i64*
  call void asm sideeffect "bndcu ($0), %bnd0", "r"(i64* %17)
  call void (...) %14()
  ret i32 0
}

; Function Attrs: nounwind
declare dso_local i8* @strcpy(i8*, i8*) #2

declare void @__cpi__init()

define internal void @__cpi__init.module() {
  call void @__cpi__init()
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 9.0.1 "}
