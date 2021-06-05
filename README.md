# mining-profit
A tool for tracking historical mining pool profit, to be compared to profit predictions.

# Development Quickstart:
In this directory, use the following procedure to load the package and test it:

1. In a terminal, run `julia` to start the repl
2. Load `Pkg` with `using Pkg`
3. We recommend using Revise: `Pkg.add("Revise"); using Revise` (if you choose
   not to do this, you will need to restart julia after each change)
4. Activate the package: `Pkg.activate(".")`
5. Run whatever function you want to test. Consider starting with
   `MiningProfit.main()`

# Running in a Production Environment
The method described above requires a julia repl and has significant overhead
at launch, during which time the JIT compiler does its work. To use this tool
in a production environment, consider pre-compiling the code as described
below.

1. Make sure `PackageCompiler` is installed. 
2. In the root of this directory, run `julia build.jl` to create a precompiled package
3. From now on, whenever you want to use the program, run `julia --sysimage build/sys_miningprofit.so cli.jl <args>` to take advantage of improved speeds.
