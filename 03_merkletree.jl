### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ da35730f-0a52-45f0-941a-aad90e80af2f
begin 
	using Pkg
	utils_path = "https://github.com/bcc-research/CryptoUtilities.jl.git"
	Pkg.add(url=utils_path, subdir="MerkleTree")
end

# ╔═╡ 4cd5a088-e02b-4de8-b867-02c2095c73ff
using MerkleTree

# ╔═╡ 52e74295-fe96-4b2a-b0e5-c10701da0581
begin 
	using Random

	function sample_queries(a::Int, b::Int, n::Int=100)
	    return randperm(b - a + 1)[1:n] .+ (a - 1)
	end
end

# ╔═╡ f0d90a48-1702-11f0-1ca9-91faf837fffd
md"""Another primitive provided by CryptoUtilities is a Merkle tree with built-in batched proof generation and verification."""

# ╔═╡ b4ec4921-da03-4af5-ab98-7d53aaf97e55
md"We can start by a simple function that should generate random leaves. To make it look like Ligero over binary fields, let's assume that that each function is an array of random UInt32 elements"

# ╔═╡ 54077072-7906-4a27-8442-837c93d9036a
function generate_random_leaves(N, K)
    return [rand(UInt32, K) for _ in 1:N]
end

# ╔═╡ 7070251a-8c33-4129-a7c9-ae7ee322ec01
begin 
	n = 20
	K = 4
	Q = 1000
	N = 2^n
	
	leaves = generate_random_leaves(N, K)
	tree = build_merkle_tree(leaves)
	queries = sort(sample_queries(1, N, Q))

	proof = prove(tree, queries)

    queried_leaves = [leaves[q] for q in queries]
    depth = get_depth(tree)
    root = get_root(tree)

    res = verify(root, proof; depth, leaves=queried_leaves, leaf_indices=queries)
	res
end

# ╔═╡ Cell order:
# ╠═f0d90a48-1702-11f0-1ca9-91faf837fffd
# ╠═da35730f-0a52-45f0-941a-aad90e80af2f
# ╠═4cd5a088-e02b-4de8-b867-02c2095c73ff
# ╠═b4ec4921-da03-4af5-ab98-7d53aaf97e55
# ╠═54077072-7906-4a27-8442-837c93d9036a
# ╠═52e74295-fe96-4b2a-b0e5-c10701da0581
# ╠═7070251a-8c33-4129-a7c9-ae7ee322ec01
