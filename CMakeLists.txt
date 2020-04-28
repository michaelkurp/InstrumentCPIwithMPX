add_llvm_library( LLVMLab MODULE
  cpimpx.cpp

  DEPENDS
  intrinsics_gen
  PLUGIN_TOOL
  opt
)

set_target_properties(LLVMLab PROPERTIES
  COMPILE_FLAGS "-fno-rtti -Wno-unused-variable"
)
