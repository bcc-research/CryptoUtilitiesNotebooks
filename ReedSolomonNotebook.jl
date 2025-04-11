### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 972386be-16f2-11f0-36c5-fbe5da0445d9
begin 
	using Pkg
	lib_path = "/Users/_andrija_/bain/CryptoUtilities.jl"
	Pkg.add(url=lib_path, subdir="BinaryFields")
	Pkg.add(url=lib_path, subdir="BinaryReedSolomon")
end

# ╔═╡ 33c89c91-0ef4-4986-95e8-d1f65482fd91
begin
	using BinaryFields 
	using BinaryReedSolomon
end

# ╔═╡ bbdb3e6a-50d1-46df-9c40-77cd0535d019
using BenchmarkTools

# ╔═╡ bbbb51f5-1798-4d73-b7f5-c0568c4a1dfa
md"Now let's initialize ReedSolomon code over $F_{2^{16}}$ as []"

# ╔═╡ 71b5f2d2-3c54-4815-8ea7-a2f9947d7ac4
begin 
	log_msg_len = 10
	log_block_len = 12

	msg_len = 2^log_msg_len
	block_len = 2^log_block_len

	rs = reed_solomon(BinaryElem16, msg_len, block_len)
end

# ╔═╡ afacf7b9-250e-4c42-a53a-191f6580310f
md"Now we can generate a random message and encode it!"

# ╔═╡ ebe614e4-47ac-44ad-9149-a639792d501d
begin
	msg = rand(BinaryElem16, msg_len)
	codeword = encode(rs, msg)
end

# ╔═╡ 8aaad925-92ac-41c6-b9a4-ba95930911b4
md"We use systematic encoding, which we can ensure of by comparing message with first message_length values of the codeword"

# ╔═╡ 6a8f44ae-980d-481f-ab21-3be15634cd63
msg == codeword[1:msg_len]

# ╔═╡ f635864c-d60a-4dc1-93b0-1aac01d39ad6
md"To prove the point from the previous notebook and demonstrate that Julia (and our library :) ) is insanely fast, we will bench fft for a very large vectors"

# ╔═╡ b848efad-6093-4245-bb56-43e876347ec0
md"Let's start by importing the benchmarking package"

# ╔═╡ 45495c3e-bb9a-4743-91c6-9300117cd315
begin
	msg_len_big = 2^20 
	block_len_big = 2^22 

	rs_big = reed_solomon(BinaryElem32, msg_len_big, block_len_big)
	msg_big = rand(BinaryElem32, msg_len_big)
end

# ╔═╡ 8f98d9af-fc49-4140-a319-fc331625b950
@benchmark encode(rs_big, msg_big)

# ╔═╡ a2e47a7b-94d6-4831-8574-ac600e718433
md"In the next notebook we proceed to build a Ligero proving system on top of CryptoUtilities.jl"

# ╔═╡ Cell order:
# ╠═972386be-16f2-11f0-36c5-fbe5da0445d9
# ╠═33c89c91-0ef4-4986-95e8-d1f65482fd91
# ╠═bbbb51f5-1798-4d73-b7f5-c0568c4a1dfa
# ╠═71b5f2d2-3c54-4815-8ea7-a2f9947d7ac4
# ╠═afacf7b9-250e-4c42-a53a-191f6580310f
# ╠═ebe614e4-47ac-44ad-9149-a639792d501d
# ╠═8aaad925-92ac-41c6-b9a4-ba95930911b4
# ╠═6a8f44ae-980d-481f-ab21-3be15634cd63
# ╠═f635864c-d60a-4dc1-93b0-1aac01d39ad6
# ╠═b848efad-6093-4245-bb56-43e876347ec0
# ╠═bbdb3e6a-50d1-46df-9c40-77cd0535d019
# ╠═45495c3e-bb9a-4743-91c6-9300117cd315
# ╠═8f98d9af-fc49-4140-a319-fc331625b950
# ╠═a2e47a7b-94d6-4831-8574-ac600e718433
