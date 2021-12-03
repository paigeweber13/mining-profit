# mining-profit

A tool for tracking historical mining pool profit, to be compared to profit
predictions.

# CLI Usage

To update with the most recent data, run `julia cli.jl -s`. For full usage, run
`julia cli.jl -h`

# Development Quickstart:

In this directory, use the following procedure to load the package and test it:

1. In a terminal, run `julia` to start the repl
2. Load `Pkg` with `using Pkg`
3. We recommend using Revise: `Pkg.add("Revise"); using Revise` (if you choose
   not to do this, you will need to re-import the MiningProfit package after 
   each change)
4. Activate the package: `Pkg.activate(".")`
5. Import MiningProfit: `using MiningProfit`
6. Run whatever function you want to test. Consider starting with
   `MiningProfit.updateallstats()`

# Running in a Production Environment

## Motivation for Compilation

There is a lot of speedup to be had from using a precompiled system image.
Julia compiles code JIT for the specific parameters you give it, resulting in
long wait times for the first run of a given function for a given set of
parameter types. While developing Julia code, the Julia community recommends
running everything iside a REPL loop to reduce the need to re-compile code.
However, this is not a well-suited option when automating processes using julia
script. Typically automation is done by calling a script from the command line
with cron or similar. Therefore we must either recompile the code on each run
(slow) or create a precompiled system image. 

To demonstrate the speedup possible, consider the following example for
analyzing mining statistics using previously-gathered data. First, the code
is run without a pre-compiled system image:

```
riley-server code/mining-profit ‹main*› » time julia cli.jl -p
  Activating environment at `~/code/mining-profit/Project.toml`
Average Pool profitability:
Dict{Any, Any}("ezil" => 4.311079369316805e-6, "miningpoolhub" => Inf, "flexpool" => 3.2907976861502096e-6)
julia cli.jl -p  27.63s user 1.25s system 100% cpu 28.638 total
```

Then, after creating a system image with `julia build.jl`:

```
riley-server code/mining-profit ‹main*› » time julia --sysimage build/sys_miningprofit.so cli.jl -p
  Activating environment at `~/code/mining-profit/Project.toml`
Average Pool profitability:
Dict{Any, Any}("ezil" => 4.311079369316805e-6, "miningpoolhub" => Inf, "flexpool" => 3.2907976861502096e-6)
julia --sysimage build/sys_miningprofit.so cli.jl -p  7.53s user 0.98s system 103% cpu 8.235 total
```

This experiment shows nearly 4x speedup! For this reason, using a sysimage is
recommended in a production environment.

## How to

The `./build.jl` script provides an easy way to build a sysimage. Follow these
instructions:

1. Make sure `PackageCompiler` is installed
2. In the root of this directory, run `julia build.jl` to create a precompiled
   package
3. From now on, whenever you want to use the program, run `julia --sysimage
   build/sys_miningprofit.so cli.jl <args>` to take advantage of improved
   speeds
4. If the code is changed (by pulling updates from git or through your own
   edits) then you will need to re-build the sysimage

