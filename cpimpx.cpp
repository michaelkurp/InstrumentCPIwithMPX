
#include "inc/cpimpx.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/TargetFolder.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InlineAsm.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/Value.h"
#include "llvm/Pass.h"
#include "llvm/PassSupport.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/IR/CFG.h"

#include <iostream>
#include <map>
#include <queue>
#include <set>
#include <string>
#include <utility>

using namespace std;
using namespace llvm;
using namespace CPIMPX;

bool canReach(BasicBlock* source, BasicBlock* dest)
{
  SmallVector<BasicBlock*, 32> Worklist;
  Worklist.push_back(const_cast<BasicBlock*>(source));
  unsigned Limit = 32;
  SmallPtrSet<const BasicBlock*, 32> Visisted;
  do {
    BasicBlock* BB = Worklist.pop_back_val();
    if(!Visisted.insert(BB).second)
      continue;
    if(BB == dest)
      return true;
    if(!--Limit)
      return true;
    else
      Worklist.append(succ_begin(BB), succ_end(BB));
  } while(!Worklist.empty());
  return false;
}
std::map<BasicBlock*, std::vector<BasicBlock*> > preprocessReach(Function& F){
  std::map<BasicBlock*, std::vector<BasicBlock*> > possible;
  for(auto &BB : F){
    BasicBlock* bb = &BB;
    std::vector<BasicBlock*> temp;
    for(auto &qq : F){
      BasicBlock* tempBB = &qq;
      if(canReach(bb, tempBB))
        temp.push_back(tempBB);
    }
    possible[bb] = temp;
  }
  return possible;
}


static void initCPIFunctions(const DataLayout *DL, Module &M,
                             CPIFunctions &CF) {
  LLVMContext &C = M.getContext();
  Type *voidTy = Type::getVoidTy(C);
  Type *Int8PtrTy = Type::getInt8PtrTy(C);
  Type *Int64Ty = Type::getInt64Ty(C);
  Type *Int64PtrTy = Type::getInt64PtrTy(C);
  Type *Int8PtrPtrTy = Int8PtrTy->getPointerTo();

  FunctionCallee temp1 = M.getOrInsertFunction("__cpi__init", voidTy, NULL);
  CF.CPIInit = temp1;
}
Function *CPI::getPhiNode(PHINode *PI) {
  for (Value *inc : PI->incoming_values()) {
    if (Function *func = dyn_cast<Function>(inc))
      return func;
    else if (PI = dyn_cast<PHINode>(inc))
      return getPhiNode(PI);
    else if (Argument *arg = dyn_cast<Argument>(inc))
      return getFuncPtrArg(arg);
  }
  return nullptr;
}

Function *CPI::getFuncPtrArg(Argument *arg) {
  unsigned index = arg->getArgNo();
  Function *caller = arg->getParent();
  for (auto U : caller->users()) {
    if (CallInst *CI = dyn_cast<CallInst>(U)) {
      Value *v = CI->getArgOperand(index);
      if (Function *func = dyn_cast<Function>(v)) {
        return func;
      } else if (PHINode *PN = dyn_cast<PHINode>(v)) {
        for (auto *U : PN->users()) {
          if (CallInst *CI = dyn_cast<CallInst>(U)) {
            Value *vall = CI->getArgOperand(index);
            if (Function *func = dyn_cast<Function>(vall)) {
              return func;
            }
          }
        }
        return getPhiNode(PN);
      } else if (LoadInst *LI = dyn_cast<LoadInst>(v))
        return getLoadInst(LI);
      else if (Argument *_arg = dyn_cast<Argument>(v))
        return getFuncPtrArg(_arg);
    }

    else if (PHINode *PN = dyn_cast<PHINode>(U)) {
      for (auto *U : PN->users()) {
        if (CallInst *CI = dyn_cast<CallInst>(U)) {
          Value *v = CI->getOperand(index);
          if (Function *func = dyn_cast<Function>(v))
            return func;
        }
      }
    }
  }
  return nullptr;
}
Function *CPI::createGlobalsReload(Module &M, StringRef N) {
  LLVMContext &C = M.getContext();
  Function *F = Function::Create(FunctionType::get(Type::getVoidTy(C), false),
                                 GlobalValue::InternalLinkage, N, &M);
  TargetFolder TF(*DL);
  IRBuilder<TargetFolder> IRB(C, TF);
  BasicBlock *Entry = BasicBlock::Create(C, "", F);
  IRB.SetInsertPoint(Entry);
  Instruction *CI = IRB.CreateCall(_CF.CPIInit);
  IRB.CreateRetVoid();
  IRB.SetInsertPoint(IRB.GetInsertBlock(),
                     IRB.GetInsertBlock()->getTerminator()->getIterator());
  return F;
}

void CPI::insertBndMk(StoreInst *SI, int priority) {
  _DI.numBndMk++;
  std::string bndReg;
  switch (priority) {
    assert(priority > -1 && priority < 4);
  case 0:
    bndReg = "%bnd0";
    break;
  case 1:
    bndReg = "%bnd1";
    break;
  case 2:
    bndReg = "%bnd2";
    break;
  case 3:
    bndReg = "%bnd3";
    break;
  }
  LLVMContext &C = SI->getContext();
  IRBuilder<> IRB(SI);
  auto ptrOP = SI->getValueOperand()->stripPointerCasts();
  auto *size = ConstantInt::get(Type::getInt8Ty(C), priority);
  auto ptrOpAsVoidPtr = IRB.CreateBitCast(ptrOP, Type::getInt8PtrTy(C), "");
  auto checkTy = FunctionType::get(
      Type::getVoidTy(C), {Type::getInt8PtrTy(C), Type::getInt8Ty(C)}, false);

  auto mkBound = InlineAsm::get(checkTy, "bndmk 1($0), " + bndReg, "r", true);
  IRB.SetInsertPoint(SI->getNextNode());
  IRB.CreateCall(mkBound, {ptrOpAsVoidPtr, size});
}

void CPI::insertBndcl(StoreInst *LI, CallInst *CI, int priority) {
  _DI.numBndCl++;
  std::string bndReg;
  switch (priority) {
    assert(priority > -1 && priority < 4);
  case 0:
    bndReg = "%bnd0";
    break;
  case 1:
    bndReg = "%bnd1";
    break;
  case 2:
    bndReg = "%bnd2";
    break;
  case 3:
    bndReg = "%bnd3";
    break;
  }
  LLVMContext &C = CI->getContext();

  IRBuilder<> IRB(CI);
  LoadInst *test = dyn_cast<LoadInst>(CI->getCalledValue());
  if (!test)
    return;

  auto realFunction = CI->getCalledOperand();
  auto ptrOpAsVoidPtr =
      IRB.CreateBitCast(realFunction, Type::getInt64PtrTy(C), "");
  auto checkTy =
      FunctionType::get(Type::getVoidTy(C), {Type::getInt64PtrTy(C)}, false);

  auto ckBound = InlineAsm::get(checkTy, "bndcl ($0), " + bndReg, "r", true);
  IRB.SetInsertPoint(CI);
  IRB.CreateCall(ckBound, {ptrOpAsVoidPtr});
}

void CPI::insertBndcu(StoreInst *LI, CallInst *CI, int priority) {
  _DI.numBndCu++;
  std::string bndReg;
  switch (priority) {
    assert(priority > -1 && priority < 4);
  case 0:
    bndReg = "%bnd0";
    break;
  case 1:
    bndReg = "%bnd1";
    break;
  case 2:
    bndReg = "%bnd2";
    break;
  case 3:
    bndReg = "%bnd3";
    break;
  }
  LLVMContext &C = CI->getContext();
  IRBuilder<> IRB(CI);
  LoadInst *test = dyn_cast<LoadInst>(CI->getCalledValue());
  if (!test)
    return;

  auto realFunction = CI->getCalledOperand();
  auto ptrOpAsVoidPtr =
      IRB.CreateBitCast(realFunction, Type::getInt64PtrTy(C), "");
  auto checkTy =
      FunctionType::get(Type::getVoidTy(C), {Type::getInt64PtrTy(C)}, false);

  auto ckBound = InlineAsm::get(checkTy, "bndcu ($0), " + bndReg, "r", true);
  IRB.SetInsertPoint(CI);
  IRB.CreateCall(ckBound, {ptrOpAsVoidPtr});
}

void CPI::insertBndldx(CallInst *CI, int priority) {
  _DI.numBndLdx++;

  std::string bndReg;
  switch (priority) {
    assert(priority > -1 && priority < 4);
  case 0:
    bndReg = "%bnd0";
    break;
  case 1:
    bndReg = "%bnd1";
    break;
  case 2:
    bndReg = "%bnd2";
    break;
  case 3:
    bndReg = "%bnd3";
    break;
  }
  LLVMContext &C = CI->getContext();
  IRBuilder<> IRB(CI);
  LoadInst *test = dyn_cast<LoadInst>(CI->getCalledValue());
  if (!test)
    return;
  auto functionPtr = test->getPointerOperand();

  auto ptrOpAsVoidPtr =
      IRB.CreateBitCast(functionPtr, Type::getInt8PtrTy(C), "");
  auto checkTy = FunctionType::get(Type::getVoidTy(C),

                                   {Type::getInt8PtrTy(C)}, false);

  auto ckBound =
      InlineAsm::get(checkTy, "bndldx ($0, %rdx, 1), " + bndReg, "r", true);
  auto zeroType =
      FunctionType::get(Type::getVoidTy(C), {Type::getInt64Ty(C)}, false);
  ConstantInt *zeroConstant = ConstantInt::get(Type::getInt64Ty(C), 0, false);

  auto zero = InlineAsm::get(zeroType, "movq $0, %rdx", "r", true);
  IRB.SetInsertPoint(CI);
  IRB.CreateCall(zero, {zeroConstant});
  IRB.CreateCall(ckBound, {ptrOpAsVoidPtr});
}

void CPI::insertBndStx(StoreInst *SI, int priority) {
  _DI.numBndStx++;
  std::string bndReg;
  switch (priority) {
    assert(priority > -1 && priority < 4);
  case 0:
    bndReg = "%bnd0";
    break;
  case 1:
    bndReg = "%bnd1";
    break;
  case 2:
    bndReg = "%bnd2";
    break;
  case 3:
    bndReg = "%bnd3";
    break;
  }

  LLVMContext &C = SI->getContext();
  IRBuilder<> IRB(SI);
  auto ptrOP = SI->getPointerOperand();
  auto *size = ConstantInt::get(Type::getInt8Ty(C), priority);
  auto ptrOpAsVoidPtr = IRB.CreateBitCast(ptrOP, Type::getInt8PtrTy(C), "");
  auto checkTy =
      FunctionType::get(Type::getVoidTy(C), {Type::getInt8PtrTy(C)}, false);
  auto zeroType =
      FunctionType::get(Type::getVoidTy(C), {Type::getInt64Ty(C)}, false);
  ConstantInt *zeroConstant = ConstantInt::get(Type::getInt64Ty(C), 0, false);

  auto zero = InlineAsm::get(zeroType, "movq $0, %rdx", "r", true);
  auto ckBound = InlineAsm::get(checkTy, "bndstx " + bndReg + ", ($0, %rdx, 1)",
                                "r", true);
  IRB.SetInsertPoint(SI->getNextNode()->getNextNode());
  IRB.CreateCall(zero, {zeroConstant});
  IRB.SetInsertPoint(SI->getNextNode()->getNextNode()->getNextNode());
  IRB.CreateCall(ckBound, {ptrOpAsVoidPtr});
}

Function *CPI::getGetElementPtrInst(GetElementPtrInst *GEP) {
  Value *v = GEP->getOperand(0);

  for (auto *U : v->users()) {
    if (GetElementPtrInst *GPI = dyn_cast<GetElementPtrInst>(U)) {

      for (auto *UL : GPI->users()) {
        if (StoreInst *SI = dyn_cast<StoreInst>(UL)) {
          ConstantInt *temp1 = ConstantInt::get(Type::getInt32Ty(SI->getContext()), 2);
          Instruction *temp = BinaryOperator::Create(
          Instruction::Add, temp1, temp1, "", SI);
          Value *v = SI->getOperand(0)->stripPointerCasts();
          if (Function *func = dyn_cast<Function>(v)) {

            return func;
          }
        }
      }
    }
  }
  return nullptr;
}
Function *CPI::getCallInst(CallInst *CI) {
  Function *func = CI->getCalledFunction();
  if (func != NULL) {
    for (inst_iterator inst_it = inst_begin(func), inst_ie = inst_end(func);
         inst_it != inst_ie; ++inst_it) {
      if (ReturnInst *ret = dyn_cast<ReturnInst>(&*inst_it)) {
        Value *v = ret->getReturnValue();
        if (Argument *arg = dyn_cast<Argument>(v))
          return getFuncPtrArg(arg);
      }
    }
  } else {
    Value *funcPTR = CI->getCalledValue();
    if (PHINode *PHI = dyn_cast<PHINode>(funcPTR)) {
      for (Value *inc : PHI->incoming_values()) {
        if (Function *func = dyn_cast<Function>(inc)) {
          for (inst_iterator inst_it = inst_begin(func),
                             inst_ie = inst_end(func);
               inst_it != inst_ie; ++inst_it) {
            if (ReturnInst *ret = dyn_cast<ReturnInst>(&*inst_it)) {
              Value *v = ret->getReturnValue();
              if (Argument *argument = dyn_cast<Argument>(v))
                return getFuncPtrArg(argument);
            }
          }
        }
      }
    }
  }
  return nullptr;
}

Function *CPI::getLoadInst(LoadInst *LI) {

  Value *v = LI->getPointerOperand();
  if (AllocaInst *all = dyn_cast<AllocaInst>(v))
    currLoadInst = LI;
  if (GetElementPtrInst *GEP = dyn_cast<GetElementPtrInst>(v)) {

    return getGetElementPtrInst(GEP);
  }
  for (auto *U : v->users()) {
    if (StoreInst *SI = dyn_cast<StoreInst>(U)) {
      Value *val = SI->getOperand(0);
      if (Function *fun = dyn_cast<Function>(val)) {

        return fun;
      } else if (Argument *arg = dyn_cast<Argument>(val)) {

        return getFuncPtrArg(arg);
      } else if (LI = dyn_cast<LoadInst>(val)) {
        return getLoadInst(LI);
      }
    }
  }

  return nullptr;
}
Function *CPI::getFunc(CallInst *callInst) {

  Value *funcptr = callInst->getCalledValue();

  if (LoadInst *LI = dyn_cast<LoadInst>(funcptr)) {

    return getLoadInst(LI);
  } else if (Argument *argument = dyn_cast<Argument>(funcptr)) {

    return getFuncPtrArg(argument);
  } else if (PHINode *PN = dyn_cast<PHINode>(funcptr)) {
    return getPhiNode(PN);
  } else if (CallInst *callinst = dyn_cast<CallInst>(funcptr)) {

    return getCallInst(callinst);
  } else
    return nullptr;
}
bool CPI::runOnFunction(Function &F) {
  LLVMContext &C = F.getContext();

  Function::iterator bb_it = F.begin(), bb_ie = F.end();
  for (; bb_it != bb_ie; ++bb_it) {
    BasicBlock::iterator ii = bb_it->begin(), ie = bb_it->end();

    for (; ii != ie; ++ii) {
      Instruction *inst = dyn_cast<Instruction>(ii);
      if (StoreInst *SI = dyn_cast<StoreInst>(inst)) {
        Value *candidateFunc = SI->getValueOperand()->stripPointerCasts();
        Value *v = SI->getPointerOperand();
        Type *ptrType = v->getType()->getPointerElementType();
        if (PointerType *pt = dyn_cast<PointerType>(ptrType)) {
          do {
            Type *pointedType = pt->getElementType();
            if (pointedType->isFunctionTy()) {

              if (Function *abc = dyn_cast<Function>(candidateFunc)) {
                SItoFunc[SI] = abc;
                FuncToSI[abc] = SI;
                _BI.needsBounds.insert(SI);
              }
            }
            ptrType = pointedType;
          } while (pt = dyn_cast<PointerType>(ptrType));
        }
      }

      if (isa<CallInst>(inst)) {
        CallInst *call = dyn_cast<CallInst>(inst);
        Function *func = call->getCalledFunction();
        FunctionType *type = call->getFunctionType();

        if (func == NULL) {


          if (Function *temp = getFunc(call)) {
            _BI.needsChecks.insert(call);
            callToFunc[call] = temp;
            if (currLoadInst) {
              callToFunc[call] = temp;
              CalltoLoad[call] = currLoadInst;
              currLoadInst = nullptr;
            }
          }
        } else if (func->isIntrinsic()) {

          continue;
        } else {
          // Direct Function Call
        }
      }
    }
  }
  return true;
}


void CPI::instrumentDaStuff() {
  std::map<StoreInst*, int> reg;
  int count = 0;
  for (auto sup : _BI.needsBounds) {
    //std::vector<Value*> emptyVec;
    //makeToCheck[sup] = emptyVec;
    insertBndMk(sup, count % 4);
    insertBndStx(sup, count % 4);
    reg[sup] = count;
    count++;
  }
  for (auto sup : _BI.needsChecks) {
    Function* temp = callToFunc[sup];
    StoreInst *check = FuncToSI[temp];
    int regNum = reg[check];
    insertBndldx(sup, regNum % 4);
    insertBndcl(check, sup, regNum % 4);
    insertBndcu(check, sup, regNum % 4);

    //makeToCheck[check].push_back(sup);
  }
  /*
  auto it = makeToCheck.begin();
  int quickCount = 0;
  while(it != makeToCheck.end())
  {
    StoreInst* makeBounds = it->first;
    std::vector<Value*> checkBounds = it->second;

    BasicBlock* start = makeBounds->getParent();
    std::vector<BasicBlock*> ptrUses;
    for(auto* a : checkBounds){
      if(Instruction* inst = dyn_cast<Instruction>(a))
        ptrUses.push_back(inst->getParent());
    }


    insertBndMk(makeBounds, quickCount);
    insertBndStx(makeBounds, quickCount);

    for(auto* a : checkBounds)
    {
      if(CallInst* CI = dyn_cast<CallInst>(a))
      {
        insertBndldx(CI, quickCount);
        insertBndcl(makeBounds, CI, quickCount);
        insertBndcu(makeBounds, CI, quickCount);
      }
    }
    quickCount = (quickCount + 1) % 4;
    it++;
  }
  */
}
bool CPI::runOnModule(Module &M) {
  LLVMContext &C = M.getContext();
  DL = &M.getDataLayout();

  initCPIFunctions(DL, M, _CF);

  Function *cpiInitfunc = createGlobalsReload(M, "__cpi__init.module");
  appendToGlobalCtors(M, cpiInitfunc, 0);
  for (auto it = M.global_begin(); it != M.global_end(); ++it){
    GlobalVariable* gv = &*it;
    if(Value* v = dyn_cast<Value>(gv)){
      if(v->getType()->isPointerTy()){
        auto thing = ConstantInt::get(Type::getInt64Ty(v->getContext()), 10);
        new GlobalVariable(M,
                            Type::getInt64Ty(v->getContext()),
                         true,
                         GlobalValue::ExternalLinkage,
                         NULL,
                         "halpme");
      }
      else if(v->getType()->isArrayTy()){

      }
      else if(v->getType()->isStructTy()){

      }
    }


  }
  for (Module::iterator it = M.begin(); it != M.end(); ++it) {
    Function &F = *it;
    // DominatorTree DT = DominatorTree(F);
    runOnFunction(F);
  }
  instrumentDaStuff();

  return true;
}
char CPI::ID = 0;
static RegisterPass<CPI> Y("cpi", "cpi", false, false);
