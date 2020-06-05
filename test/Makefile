LLVM_ROOT=~/llvm
LLVM_PASS_LOC=$(LLVM_ROOT)/build/lib/LLVMLab.so
LLVM_PASS=-cpi

all: one two three four five seven

one: one.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm one.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < one.bc > oneopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis oneopt.bc
	$(LLVM_ROOT)/build/bin/llc oneopt.bc
	$(LLVM_ROOT)/build/bin/clang -c ../inc/hook.c
	$(LLVM_ROOT)/build/bin/clang -o one oneopt.s hook.o

two: two.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang++ -c -emit-llvm two.cc
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < two.bc > twoopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis twoopt.bc
	$(LLVM_ROOT)/build/bin/llc twoopt.bc
	$(LLVM_ROOT)/build/bin/clang -c ../inc/hook.c
	$(LLVM_ROOT)/build/bin/clang -o two twoopt.s hook.o

three: three.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm three.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < three.bc > threeopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis threeopt.bc
	$(LLVM_ROOT)/build/bin/llc threeopt.bc
	$(LLVM_ROOT)/build/bin/clang -c ../inc/hook.c
	$(LLVM_ROOT)/build/bin/clang -o three threeopt.s hook.o

four: four.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm four.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < four.bc > fouropt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis fouropt.bc
	$(LLVM_ROOT)/build/bin/llc fouropt.bc
	$(LLVM_ROOT)/build/bin/clang -c ../inc/hook.c
	$(LLVM_ROOT)/build/bin/clang -o four fouropt.s hook.o

five: five.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm five.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < five.bc > fiveopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis fiveopt.bc
	$(LLVM_ROOT)/build/bin/llc --debug-entry-values fiveopt.bc
	$(LLVM_ROOT)/build/bin/clang -c ../inc/hook.c
	$(LLVM_ROOT)/build/bin/clang -o five fiveopt.s hook.o


seven: seven.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm seven.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < seven.bc > sevenopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis sevenopt.bc
	$(LLVM_ROOT)/build/bin/llc --debug-entry-values sevenopt.bc
	$(LLVM_ROOT)/build/bin/clang -c ../inc/hook.c
	$(LLVM_ROOT)/build/bin/clang -o seven sevenopt.s hook.o
clean:
	rm -f *.bc *.ll *.s one two three four five seven
