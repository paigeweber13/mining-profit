using Pkg

# following the tutorial on creating and using my own package:
# https://pkgdocs.julialang.org/v1/creating-packages/

Pkg.activate(".")
import MiningProfit
MiningProfit.main()

