using PackageCompiler
using Pkg

mkpath("build", mode=0o755)
Pkg.activate(".")
import MiningProfit
create_sysimage(:MiningProfit, sysimage_path="build/sys_miningprofit.so", 
  precompile_execution_file="examples.jl") 

