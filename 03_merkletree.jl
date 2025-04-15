### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ da35730f-0a52-45f0-941a-aad90e80af2f
begin 
	using Pkg
	Pkg.activate(".")
	utils_path = "https://github.com/bcc-research/CryptoUtilities.jl.git"
	Pkg.add(url=utils_path, subdir="MerkleTree")
end

# ╔═╡ 4cd5a088-e02b-4de8-b867-02c2095c73ff
using MerkleTree

# ╔═╡ 286ce6cb-e003-4bf4-b393-0892b0c6367a
using Random

# ╔═╡ f0d90a48-1702-11f0-1ca9-91faf837fffd
md"""
# MerkleTree.jl

Another primitive provided by CryptoUtilities is a Merkle tree with built-in batched proof generation and verification.

As before, unfortunately, we have to manually add the package until we finish adding it to the Julia package registry!
"""

# ╔═╡ b4ec4921-da03-4af5-ab98-7d53aaf97e55
md"""
In our case, we will generate an $m \times n$ matrix of `UInt`s and (as in Ligero) commit to each row as a leaf in our Merkle tree.
"""

# ╔═╡ 2fcbe14e-92a5-4659-ac93-f2cbfc7ac948
m, n = 2^14, 2^10

# ╔═╡ 54077072-7906-4a27-8442-837c93d9036a
X = rand(UInt, m, n)

# ╔═╡ d2158468-7c49-483c-9a66-1ff3875823ab
md"""
The function `eachrow` returns an iterator over each row of $X$ and the `collect` function concretizes the iterator into a vector.
"""

# ╔═╡ 1042f9b5-4b96-4e56-a676-aa868aa4e8ae
X_leaves = collect(eachrow(X))

# ╔═╡ 14ea86c3-b7d0-4c6e-8cea-31246e8fe60d
md"""
Here's the code we will use for sampling rows without replacement (though it is a bit expensive...)
"""

# ╔═╡ 7bec0f6d-6c30-41a4-939e-aae1b6c8a93f
Random.seed!(1234)

# ╔═╡ 52e74295-fe96-4b2a-b0e5-c10701da0581
function sample_queries(a::Int, b::Int, n::Int=100)
	return randperm(b - a + 1)[1:n] .+ (a - 1)
end

# ╔═╡ 7070251a-8c33-4129-a7c9-ae7ee322ec01
md"""
First, we build the complete merkle tree, this will return a `CompleteMerkleTree` object that we can use to construct opening proofs
"""

# ╔═╡ c9c330ea-fae0-42dc-8bce-eca3d657c0b8
tree = build_merkle_tree(X_leaves)

# ╔═╡ eb506af5-3e8f-4076-a9e5-9680b7a5f918
md"""
Now, we will query $Q$ leaves of this tree (equiv., rows of $X$) (note that the queries _must_ be sorted to construct the batched proof!)
"""

# ╔═╡ 2daae282-9660-4110-956a-d88a75bed740
Q = 148

# ╔═╡ 26ac03dd-c3d9-4a4f-ac7f-ac8cf64ba032
queries = sort(sample_queries(1, m, Q))

# ╔═╡ d606a6fe-5daf-4f8d-a52b-e5f4a4e3dcc5
md"""
We can then construct the multi-opening proof
"""

# ╔═╡ 5459a183-da8d-46ec-a748-859caf6a8f7b
proof = prove(tree, queries)

# ╔═╡ f3a0fb92-2305-4099-8453-92323d1c3994
md"""
The proof size of this batched proof is (cheating slightly as the proof objects are strings that correspond to 256-bit hex values)
"""

# ╔═╡ e56d5767-43ed-48cd-81fa-7e5a877bdf91
Base.format_bytes(sizeof(proof))

# ╔═╡ 94eb9399-aa9c-4929-a5b0-f769bed08a87
md"""
Compared with the naive proof size, which is just one opening, each of size $\log_2(m)$ times the hash size (256 bits)
"""

# ╔═╡ e1d50603-9e44-451e-b357-aa0e3be4f782
Base.format_bytes(256*log2(m)*148/8)

# ╔═╡ 82b2d9b4-8282-4bcd-91ef-9649d10bce81
md"""
We can now simply verify the resulting proof:
"""

# ╔═╡ c4a354fe-4e3e-404d-bb79-e42d3aa2caa4
begin
	leaves = X_leaves[queries]
	depth, root = get_depth(tree), get_root(tree)

	verify(root, proof; depth, leaves, leaf_indices=queries)
end

# ╔═╡ Cell order:
# ╟─f0d90a48-1702-11f0-1ca9-91faf837fffd
# ╠═da35730f-0a52-45f0-941a-aad90e80af2f
# ╠═4cd5a088-e02b-4de8-b867-02c2095c73ff
# ╟─b4ec4921-da03-4af5-ab98-7d53aaf97e55
# ╠═2fcbe14e-92a5-4659-ac93-f2cbfc7ac948
# ╠═54077072-7906-4a27-8442-837c93d9036a
# ╟─d2158468-7c49-483c-9a66-1ff3875823ab
# ╠═1042f9b5-4b96-4e56-a676-aa868aa4e8ae
# ╟─14ea86c3-b7d0-4c6e-8cea-31246e8fe60d
# ╠═286ce6cb-e003-4bf4-b393-0892b0c6367a
# ╠═7bec0f6d-6c30-41a4-939e-aae1b6c8a93f
# ╠═52e74295-fe96-4b2a-b0e5-c10701da0581
# ╟─7070251a-8c33-4129-a7c9-ae7ee322ec01
# ╠═c9c330ea-fae0-42dc-8bce-eca3d657c0b8
# ╟─eb506af5-3e8f-4076-a9e5-9680b7a5f918
# ╠═2daae282-9660-4110-956a-d88a75bed740
# ╠═26ac03dd-c3d9-4a4f-ac7f-ac8cf64ba032
# ╟─d606a6fe-5daf-4f8d-a52b-e5f4a4e3dcc5
# ╠═5459a183-da8d-46ec-a748-859caf6a8f7b
# ╟─f3a0fb92-2305-4099-8453-92323d1c3994
# ╠═e56d5767-43ed-48cd-81fa-7e5a877bdf91
# ╟─94eb9399-aa9c-4929-a5b0-f769bed08a87
# ╠═e1d50603-9e44-451e-b357-aa0e3be4f782
# ╟─82b2d9b4-8282-4bcd-91ef-9649d10bce81
# ╠═c4a354fe-4e3e-404d-bb79-e42d3aa2caa4
