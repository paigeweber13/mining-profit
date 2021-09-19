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
   not to do this, you will need to restart julia after each change)
4. Activate the package: `Pkg.activate(".")`
5. Run whatever function you want to test. Consider starting with
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
gathering mining statistics and saving them to the SQLite database. First, the
code is run without a pre-compiled system image:

```
riley-desktop-opensuse code/mining-profit ‹main*› » date && julia cli.jl -s && date 
Sun Sep 19 16:19:46 CDT 2021
  Activating environment at `~/code/mining-profit/Project.toml`
Sun Sep 19 16:19:55 CDT 2021
# Total runtime: 9 seconds
```

Then, after creating a system image with `julia build.jl`:

```
riley-desktop-opensuse code/mining-profit ‹main*› » date && julia --sysimage build/sys_miningprofit.so cli.jl -s && date
Sun Sep 19 16:25:52 CDT 2021
  Activating environment at `~/code/mining-profit/Project.toml`
Sun Sep 19 16:25:54 CDT 2021
# Total runtime: 2 seconds
```

This is a greater than 4x speedup, and at this point most of the runtime is
surely just latency while waiting for web requests to be completed.

## How to

The method described above requires a julia repl and has significant overhead
at launch, during which time the JIT compiler does its work. To use this tool
in a production environment, consider pre-compiling the code as described
below.

1. Make sure `PackageCompiler` is installed.
2. In the root of this directory, run `julia build.jl` to create a precompiled
   package
3. From now on, whenever you want to use the program, run `julia --sysimage
   build/sys_miningprofit.so cli.jl <args>` to take advantage of improved
   speeds.
