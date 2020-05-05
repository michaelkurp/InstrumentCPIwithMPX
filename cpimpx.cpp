
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

#include <iostream>
#include <map>
#include <queue>
#include <set>
#include <string>
#include <utility>

using namespace std;
using namespace llvm;
using namespace CPIMPX;

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

  IRBuilder<> IRB(SI);
  auto ptrOP = SI->getValueOperand()->stripPointerCasts();
  auto *size = ConstantInt::get(Type::getInt8Ty(SI->getContext()), priority);
  auto ptrOpAsVoidPtr =
      IRB.CreateBitCast(ptrOP, Type::getInt8PtrTy(SI->getContext()), "");
  auto checkTy = FunctionType::get(
      Type::getVoidTy(SI->getContext()),
      {Type::getInt8PtrTy(SI->getContext()), Type::getInt8Ty(SI->getContext())},
      false);

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

  IRBuilder<> IRB(CI);
  auto function = CI->getOperand(0);
  LoadInst *load = dyn_cast<LoadInst>(CI->getCalledValue());
  if (!load)
    return;

  auto ptrOP = load->getPointerOperand();
  GetElementPtrInst *actual = dyn_cast<GetElementPtrInst>(ptrOP);
  if (!actual)
    return;
  auto ptrOp = actual->getPointerOperand();
  auto *size = ConstantInt::get(Type::getInt8Ty(LI->getContext()), priority);
  auto ptrOpAsVoidPtr =
      IRB.CreateBitCast(function, Type::getInt64PtrTy(LI->getContext()), "");
  auto checkTy =
      FunctionType::get(Type::getVoidTy(LI->getContext()),
                        {Type::getInt64PtrTy(LI->getContext())}, false);

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

  IRBuilder<> IRB(CI);
  LoadInst *test = dyn_cast<LoadInst>(CI->getCalledValue());
  if (!test)
    return;
  auto function = test->getPointerOperand();
  auto *size = ConstantInt::get(Type::getInt8Ty(CI->getContext()), priority);

  auto realFunction = CI->getOperand(0);
  auto ptrOpAsVoidPtr = IRB.CreateBitCast(
      realFunction, Type::getInt64PtrTy(CI->getContext()), "");
  auto checkTy =
      FunctionType::get(Type::getVoidTy(CI->getContext()),
                        {Type::getInt64PtrTy(CI->getContext())}, false);

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

  IRBuilder<> IRB(CI);
  LoadInst *test = dyn_cast<LoadInst>(CI->getCalledValue());
  if (!test)
    return;
  auto functionPtr = test->getPointerOperand();
  // auto ptrOP = functionPtr->getPointerOperand();
  auto ptrOpAsVoidPtr =
      IRB.CreateBitCast(functionPtr, Type::getInt8PtrTy(CI->getContext()), "");
  auto checkTy =
      FunctionType::get(Type::getVoidTy(CI->getContext()),

                        {Type::getInt8PtrTy(CI->getContext())}, false);
  
  auto ckBound = InlineAsm::get(checkTy, "bndldx ($0, %rdx, 1), " + bndReg,
                                "r,{bnd0}", true);
auto zeroType = FunctionType::get(Type::getVoidTy(CI->getContext()), {}, false);
auto zero = InlineAsm::get(zeroType, "mov $0x0, %rdx", "={rdx},{rdx}", true);  
IRB.SetInsertPoint(CI);
IRB.CreateCall(zero, {});
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

  IRBuilder<> IRB(SI);
  auto ptrOP = SI->getPointerOperand();
  auto *size = ConstantInt::get(Type::getInt8Ty(SI->getContext()), priority);
  auto ptrOpAsVoidPtr =
      IRB.CreateBitCast(ptrOP, Type::getInt8PtrTy(SI->getContext()), "");
  auto checkTy =
      FunctionType::get(Type::getVoidTy(SI->getContext()),
                        {Type::getInt8PtrTy(SI->getContext())}, false);
  auto zeroType = FunctionType::get(Type::getVoidTy(SI->getContext()),
			{Type::getInt64Ty(SI->getContext())}, false);
  ConstantInt* zeroConstant = ConstantInt::get(Type::getInt64Ty(SI->getContext()), 0, false);

  auto zero = InlineAsm::get(zeroType, "movq $0, %rdx", "r", true);
  auto ckBound = InlineAsm::get(checkTy, "bndstx " + bndReg + ", ($0, %rdx, 1)",
                                "r", true);
  IRB.SetInsertPoint(SI->getNextNode()->getNextNode());
  IRB.CreateCall(zero, {zeroConstant});
  IRB.SetInsertPoint(SI->getNextNode()->getNextNode()->getNextNode());
  IRB.CreateCall(ckBound, {ptrOpAsVoidPtr});
}

Function *CPI::getGetElementPtrInst(GetElementPtrInst *getElementPtrInst) {
  Value *v = getElementPtrInst->getOperand(0);
  for (auto *U : v->users()) {
    if (GetElementPtrInst *GPI = dyn_cast<GetElementPtrInst>(U)) {

      for (auto *UL : GPI->users()) {
        if (StoreInst *SI = dyn_cast<StoreInst>(UL)) {

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

struct CompareReg {
  bool operator()(std::pair<Function *, int> const &p1,
                  std::pair<Function *, int> const &p2) {
    return p1.second < p2.second;
  }
};
void CPI::instrumentDaStuff() {
  std::map<Function *, int> funcToReg;
  for (auto sup : _BI.needsBounds) {
    Function *temp = SItoFunc[sup];

    int regNum = _RI.returnFirstFreeReg();
    if (regNum == 42) {
      // ToDO
    } else {
      insertBndMk(sup, regNum);
      insertBndStx(sup, regNum);
    }
    funcToReg[temp] = regNum;
  }
  for (auto sup : _BI.needsChecks) {
    Function *temp = callToFunc[sup];
    int Reg = funcToReg[callToFunc[sup]];
    StoreInst *check = FuncToSI[temp];
  //  insertBndldx(sup, Reg);
  //  insertBndcl(check, sup, Reg);
  //  insertBndcu(check, sup, Reg);
  }
}
bool CPI::runOnModule(Module &M) {
  LLVMContext &C = M.getContext();
  DL = &M.getDataLayout();
  TLI = &getAnalysis<TargetLibraryInfoWrapperPass>().getTLI();

  initCPIFunctions(DL, M, _CF);

  Function *cpiInitfunc = createGlobalsReload(M, "__cpi__init.module");
  appendToGlobalCtors(M, cpiInitfunc, 0);

  for (Module::iterator it = M.begin(); it != M.end(); ++it) {
    Function &F = *it;
    runOnFunction(F);
  }
  instrumentDaStuff();
  /*
  for (auto *instrumentMe : _call_list) {
    if (Function *func = dyn_cast<Function>(instrumentMe)) {
      ConstantInt *temp1 = ConstantInt::get(Type::getInt32Ty(C), 2);
      Instruction *temp = BinaryOperator::Create(
          Instruction::Add, temp1, temp1, "", &(func->getEntryBlock()));
    }
  }
  */
  return true;
}
char CPI::ID = 0;
static RegisterPass<CPI> Y("cpi", "cpi", false, false);
