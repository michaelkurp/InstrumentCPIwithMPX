User::op_iterator OI, OE;
for( OI = insn->op_begin(), OE = insn->op_end(); OI != OE; ++OI)
{
  Value *val = *OI;
  if(isa<Instruction>(val) || isa<Argument>(val))
  {

  }
}
