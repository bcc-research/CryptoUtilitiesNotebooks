### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 9057e709-27b8-414a-81ba-93a5d26b93a2
begin 
	using Pkg
	Pkg.activate(".")
	utils_path = "https://github.com/bcc-research/CryptoUtilities.jl.git"
	Pkg.add(url=utils_path, subdir="BinaryFields")
	Pkg.add(url=utils_path, subdir="BinaryReedSolomon")
	Pkg.add(url=utils_path, subdir="BatchedMerkleTree")
	
	examples_path = "https://github.com/bcc-research/CryptoUtilitiesExamples.git"
	Pkg.add(url=examples_path, subdir="Ligero")
end

# ╔═╡ 0d6bbe3b-a98b-417b-b760-73f00ede109f
using BinaryFields, Ligero

# ╔═╡ 8f19110e-16fb-11f0-08fa-71c11f3b861d
md"""
# Ligero

In this notebook we will make a simple Ligero proof and verify it. Most of the code is from the [Ligero](https://github.com/bcc-research/CryptoUtilitiesExamples/tree/main/Ligero) example in the [CryptoUtilitiesExamples](https://github.com/bcc-research/CryptoUtilitiesExamples/) repository. We will simply be calling most of the utilities from [Ligero.jl](https://github.com/bcc-research/CryptoUtilitiesExamples/blob/main/Ligero/src/Ligero.jl) since `Ligero` is a single-file package.
"""

# ╔═╡ 31b81f6a-f009-4992-a363-25bae8b7cb34
md"In this version of Ligero we allow user to simply put the vector it wants to encode, and we reshape it into the matrix of optimal dimensions. This comes very handy when using Ligero as a form of PCS."

# ╔═╡ b68a3176-2e94-43ee-95f9-65bae1eb4834
message = rand(BinaryElem32, 2^20)

# ╔═╡ 7231ac77-b4f3-49b9-81d9-07c80c700cb1
md"The prover starts by, as noted above, reshaping a vector into the matrix and encoding its columns. Then it commits to the rows of the matrix (in our case via the MerkleTree) and sends that commitment to the verifier"

# ╔═╡ 9fc6f10a-9200-4532-8556-8541db9fc5f7
begin
	comm = commit(message; verbose=true)
	verifier_comm = verifier_commitment(comm)
end

# ╔═╡ 8f72c03c-36ce-411a-b32e-dcecc2039afe
md"After receiving a Merkle root commitment, verifier samples a random challenge vector!"

# ╔═╡ 93920392-24ed-48fc-b0ed-ae9af686b15c
begin
	n_rows, n_cols = size(matrix(comm))
	gr = rand(BinaryElem128, n_cols)
end

# ╔═╡ fc451d62-57fd-493c-9d52-e0f3b7a3b182
begin 
	using Random

	function sample_queries(a::Int, b::Int, n::Int=100)
	    return randperm(b - a + 1)[1:n] .+ (a - 1)
	end

	S_sorted = sort(sample_queries(1, n_rows, 148))
end

# ╔═╡ 349366dc-b263-4081-8e7f-e436875244ae
md"Be very careful here! Remember that soundness of Ligero depents on the size of the field. Thus sampling randomness from $\mathbf{F}_{2^{32}}$ field will not be enough! That's why verifier samples randomness from much larger field, in our case $\mathbf{F}_{2^{128}}$"

# ╔═╡ 35897be6-6275-44a9-9af5-baab18343759
md"With a simple combinatorics argument it can be shown that 148 queries for a ReedSolomon code and rate 1/4 is enough to achieve 100-bit security"

# ╔═╡ a3360497-6e4d-4c19-9540-bb5205febe63
md"After receiving queries and randomness prover can proceed to construct a proof. The premise of Ligero is essentially saying that, if a random linear combination of columns of a matrix is close to some codeword, then (with high probability) each of the original columns must also be close to codewords. The prover simply provides the resulting random linear combination of the columns (which is a vector) to the verifier, who then spot checks a few entries to ensure consistency."

# ╔═╡ 8b70c48c-3ea6-4d4a-ad47-bb027a1dc87b
proof = prove(comm, gr, S_sorted)

# ╔═╡ c4ab8a50-d3f9-4614-8755-0a91dae95c7b
Base.format_bytes(sizeof(proof))

# ╔═╡ 3e136bdc-a92f-4d82-b818-247f0718408c
md"And finally let's verify the proof given the commitment, queries and sampled randomness"

# ╔═╡ f24461f7-ee01-48d0-9ab4-56f7d2d7f3a2
verify(proof, verifier_comm, S_sorted, gr)

# ╔═╡ Cell order:
# ╟─8f19110e-16fb-11f0-08fa-71c11f3b861d
# ╠═9057e709-27b8-414a-81ba-93a5d26b93a2
# ╠═0d6bbe3b-a98b-417b-b760-73f00ede109f
# ╟─31b81f6a-f009-4992-a363-25bae8b7cb34
# ╠═b68a3176-2e94-43ee-95f9-65bae1eb4834
# ╟─7231ac77-b4f3-49b9-81d9-07c80c700cb1
# ╠═9fc6f10a-9200-4532-8556-8541db9fc5f7
# ╟─8f72c03c-36ce-411a-b32e-dcecc2039afe
# ╠═93920392-24ed-48fc-b0ed-ae9af686b15c
# ╟─349366dc-b263-4081-8e7f-e436875244ae
# ╠═fc451d62-57fd-493c-9d52-e0f3b7a3b182
# ╟─35897be6-6275-44a9-9af5-baab18343759
# ╟─a3360497-6e4d-4c19-9540-bb5205febe63
# ╠═8b70c48c-3ea6-4d4a-ad47-bb027a1dc87b
# ╠═c4ab8a50-d3f9-4614-8755-0a91dae95c7b
# ╟─3e136bdc-a92f-4d82-b818-247f0718408c
# ╠═f24461f7-ee01-48d0-9ab4-56f7d2d7f3a2
