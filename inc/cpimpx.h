#ifndef LLVM_CPI_MPX_H
#define LLVM_CPI_MPX_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"

#include <map>
#include <set>

namespace CPIMPX {
using namespace llvm;

struct CPIFunctions {
  FunctionCallee CPIInit;
  FunctionCallee CPISet;
  FunctionCallee CPIGet;
};
struct boundsInfo {
  std::set<StoreInst *> needsBounds;
  std::set<CallInst *> needsChecks;
};
struct debugInfo {
  int numBndMk = 0;
  int numBndCl = 0;
  int numBndCu = 0;
  int numBndLdx = 0;
  int numBndStx = 0;
};

class CPI : public ModulePass {
  const DataLayout *DL;
  TargetLibraryInfo *TLI;
  AliasAnalysis *AA;

  CPIFunctions _CF;
  boundsInfo _BI;
  debugInfo _DI;

  std::set<Value *> _call_list;
  std::map<StoreInst *, Function *> SItoFunc;
  std::map<Function *, StoreInst *> FuncToSI;
  std::map<CallInst* , Function * > callToFunc;
  std::map<Function *, int> callNum;
  std::map<StoreInst *, AllocaInst*> SItoAll;
  std::map<CallInst* , LoadInst*> CalltoLoad;
  LoadInst* currLoadInst = NULL;

  Function* getPhiNode(PHINode *);
  Function* getFuncPtrArg(Argument *);
  Function* getGetElementPtrInst(GetElementPtrInst *);
  Function* getCalledInst(CallInst *);
  Function* getLoadInst(LoadInst *);
  Function* getCallInst(CallInst *);
  Function* getFunc(CallInst *);

  void insertBndMk(StoreInst *, int);
  void insertBndcl(StoreInst *, CallInst *, int);
  //void insertBndcu(CallInst *, Function *, int);
  void insertBndldx(StoreInst *, int);
  void insertBndStx(StoreInst *, int);

  void instrumentDaStuff();

  Function *createGlobalsReload(Module &M, StringRef N);

public:
  static char ID;
  CPI() : ModulePass(ID) {}

  void getAnalysisUsage(AnalysisUsage &AU) const {
    AU.setPreservesCFG();
    AU.addRequired<AAResultsWrapperPass>();
    AU.addRequired<TargetLibraryInfoWrapperPass>();
  }
  bool runOnFunction(Function &F);
  bool runOnModule(Module &M);
};
} // namespace CPIMPX
#endif
