LLVM_ROOT=~/llvm
LLVM_PASS_LOC=$(LLVM_ROOT)/build/lib/LLVMLab.so
LLVM_PASS=-cpi

all: one two three

one: one.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm one.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < one.bc > oneopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis oneopt.bc
	$(LLVM_ROOT)/build/bin/llc oneopt.bc
	$(LLVM_ROOT)/build/bin/clang -c hook.c
	$(LLVM_ROOT)/build/bin/clang -o one oneopt.s hook.o

two: two.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm two.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < two.bc > twoopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis twoopt.bc
	$(LLVM_ROOT)/build/bin/llc twoopt.bc
	$(LLVM_ROOT)/build/bin/clang -c hook.c
	$(LLVM_ROOT)/build/bin/clang -o two twoopt.s hook.o

three: three.c $(LLVM_PASS_LOC)
	$(LLVM_ROOT)/build/bin/clang -c -emit-llvm three.c
	$(LLVM_ROOT)/build/bin/opt -p -load $(LLVM_PASS_LOC) $(LLVM_PASS) < three.bc > threeopt.bc
	$(LLVM_ROOT)/build/bin/llvm-dis threeopt.bc
	$(LLVM_ROOT)/build/bin/llc threeopt.bc
	$(LLVM_ROOT)/build/bin/clang -c hook.c
	$(LLVM_ROOT)/build/bin/clang -o two threeopt.s hook.o

clean:
	rm -f *.bc *.ll *.s one two three
