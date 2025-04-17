# CryptoUtilitiesNotebooks
Notebooks showing how to use the [CryptoUtilities.jl library](https://github.com/bcc-research/CryptoUtilities.jl), along with some
other goodies.

For cryptographers and developers with some familiarity with Python but no
familiarity with Julia, we recommend starting with `01_basics.jl` and moving on
from there. The presentation has very few things, but we use these constantly
in the rest of the notebooks, so it's worth at least a quick peek through. For
those more familiar with benchmarking, and low level code stuff in Julia
(`@code_native` and so on), this is mostly a short review and it's not
necessary to read.

Notebooks 2 and 3 are independent of each other, while notebook 4 depends on 2,
and each of these depends on the few things introduced in notebook 1. Finally,
notebook 5 brings pretty much all of it together to construct a (relatively
fast) succinct proof using the example code from the
[bcc-research/CryptoUtilitiesExamples](https://github.com/bcc-research/CryptoUtilitiesExamples)
repository.

## Viewing notebooks
To simply view the notebooks, statically compiled HTML files are available
in this repository.

1. [Julia basics](https://bcc-research.github.io/CryptoUtilitiesNotebooks/01_basics.html)
2. [BinaryFields](https://bcc-research.github.io/CryptoUtilitiesNotebooks/02_binaryfields.html)
3. [MerkleTree](https://bcc-research.github.io/CryptoUtilitiesNotebooks/03_merkletree.html)
4. [BinaryReedSolomon](https://bcc-research.github.io/CryptoUtilitiesNotebooks/04_reedsolomon.html)
5. [Ligero](https://bcc-research.github.io/CryptoUtilitiesNotebooks/05_ligero.html)

We highly recommend running these locally, though, and instructions for that are below!

## Pluto.jl
For the notebooks in this repository, we use
[Pluto.jl](https://github.com/fonsp/Pluto.jl).

For a brief intro to Pluto.jl, take a peek at [this 20 min
video](https://www.youtube.com/watch?v=Rg3r3gG4nQo). (We promise it's very
cool!)

## How to run
To run the files:

1. [Download and install Julia](https://julialang.org/downloads/)
2. Clone the repository
3. Follow [the instructions to install and run
   Pluto](https://github.com/fonsp/Pluto.jl?tab=readme-ov-file#lets-do-it) and
   simply open any of the notebook files from the cloned repo from Pluto.
