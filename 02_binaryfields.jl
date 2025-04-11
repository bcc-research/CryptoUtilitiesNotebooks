### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 44aaaa20-1706-11f0-07da-a7a2143bc8de
begin
	import Pkg
	git_url = "https://github.com/bcc-research/CryptoUtilities.jl.git"
	Pkg.add(url=git_url, subdir="BinaryFields")
end

# ╔═╡ 2c9f6aed-b739-49db-99e7-94ef9a20ac25
using BinaryFields

# ╔═╡ 88e95733-d4ce-401c-a993-f2336531fac7
using BenchmarkTools

# ╔═╡ 46125d64-d8cb-45f1-9a52-6605bae3d61a
md"""
# BinaryFields.jl

Unfortunately as we don't yet have the package registered, we need to add it manually from the Github repo. (This should be fixed soon!)
"""

# ╔═╡ 52cce847-a1de-4785-96a3-72925d7f978a
md"""
First, we can define binary polynomials; _i.e._, polynomials whose coefficients are $\{0,1\} = \mathbf{F}_2$, in other words, binary elements. The degrees of these polynomials can be any of $\{16, 32, 64, 128, 256\}$. Here, we'll define two degree-64 polynomials, `f` and `g`: with $f(x) = 1$ and $g(x) = x$:
"""

# ╔═╡ 6d490563-d602-406d-ac72-f53231e01a2b
f, g = BinaryPoly64(0b1), BinaryPoly64(0b10)

# ╔═╡ 7d80d539-6d6d-4978-9a83-5995ec9a3815
md"""
Under the hood, a `BinaryPoly64` is just a wrapper struct around a `UInt64`. (The same is true for `BinaryPoly16` all the way to `BinaryPoly128`. A `BinaryPoly256` is, instead, represented as a tuple of `UInt128`s, since this is the largest `UInt` type supported by Julia.)

As expected, we can add these two polynomials, which results in the polynomial $(f+g)(x) = 1+x$.
"""

# ╔═╡ b85d5f43-2ce8-4556-a6b0-24bd0980be23
f+g

# ╔═╡ 5d1b8580-dd61-4ae0-af35-d515cc0cbf39
@code_native f+g

# ╔═╡ dc0a7bfd-e618-4947-b66f-7949b6f17dc3
md"""
Similarly, we can multiply two polynomials together (though in this particular case it is a bit silly since $f$ is just $1$):
"""

# ╔═╡ 0aaa1c16-ac4a-49ad-ac96-e210cc75aaf9
f*g

# ╔═╡ c4fa1511-3c90-4f89-b368-aaf72b37cf93
md"""
Note that the result is a `BinaryPoly128` (in other words, a polynomial of degree 128).

And we can see that the underlying operation simply calls the `aarch64` operation `pmull`, which is the hardware-accelerated multiplication of two polynomials of degree 64:
"""

# ╔═╡ ba717d00-f8c3-433e-954e-2c16e83282da
@code_native f*g

# ╔═╡ babcf2d7-d8ba-4efe-be87-1627b485892e
md"""
This will work on `x86_64` platforms as well, but the operations will be different (namely the underlying call will be to `pclmulqdq` instead of to `pmull`.)
"""

# ╔═╡ bb2db986-8f48-4e8d-b69c-f1c83894dd0a
md"""
## Julia niceness

Some things that are of interest here: because the types are appropriately defined, we can do all sorts of fun nonsense.

For example, let's make a $1024$-sized vector of `BinaryPoly16` elements:
"""

# ╔═╡ 85b2773a-5380-4adc-abe4-f1ffddd5c6e7
v = rand(BinaryPoly16, 2^10)

# ╔═╡ 169a4bb6-30dc-4482-850e-2e35ef46a6c7
md"""
We can take the transpose of this vector, which is a reasonable operation (again, note that we have _not_ defined any of this stuff even in the library!)
"""

# ╔═╡ 850ef7b8-a5da-4e6a-90c3-84dda633acda
v'

# ╔═╡ abd0200d-2d0c-4dbf-9f89-a8480ca479a8
md"""
And take, say, an inner product of these things, which results in a single polynomial corresponding to the elementwise product and cumulative sum of all of the resulting entries:
"""

# ╔═╡ 1fd49d5e-dd49-46c9-b0bb-2eaf6e4d5c53
v' * v

# ╔═╡ 09621926-b853-425f-9c04-f434a744b91c
md"""
(Again, note that we haven't defined any of these operations in the library, all we had to do was create some basic abstractions.)

We can do the same with matrices, too
"""

# ╔═╡ 5e823daf-accb-4226-8e5c-fe6221d4ed18
A = rand(BinaryPoly16, 2^12, 2^10)

# ╔═╡ 116abcc3-9b2c-41c6-83dd-7acff73bccd5
md"""
and get the expected thing:
"""

# ╔═╡ 473ded59-38da-4224-9e30-b3ec4bbd0ffe
y = A*v

# ╔═╡ a1818409-e572-4af0-9d28-13459c56ddfc
md"""
And, since this is all compiled to (relatively fast) native code, the results are quite good, which we can verify via the `BenchmarkTools` package
"""

# ╔═╡ 5d4aa8c3-776e-473c-ab62-e03aac2025f6
@benchmark A*v

# ╔═╡ 347d0172-ad11-489b-8092-70d563ddf2ca
md"""
(Roughly speaking, here we are multiplying $2^{12} \cdot 2^{10} = 2^{22} \sim 4\cdot 10^6$ elements from $\mathbf{F}_{2^{16}}$, which means that we are sitting at ~.5 ns per operation.)
"""

# ╔═╡ 32c43fea-0a48-4621-b363-24dcc2f1ef8d
md"""
# Now on to Binary Elements!

Ok, now that we've had enough fun with polynomials, we can talk about binary elements: these are binary polynomials (like $f$) modulo some binary irreducible polynomial (which is some fixed, standard polynomial).

A binary field element is represented _exactly in this way_ by the `BinaryFields` package: for example, a `BinaryElem16` really is just a simple wrapper struct around a `BinaryPoly16`, which is itself a simple wrapper around `UInt16`:
"""

# ╔═╡ eb703b67-6d3f-47d8-9b50-416922ba4666
α, β = BinaryElem16(2), rand(BinaryElem16)

# ╔═╡ a96f0162-8003-49fd-9a1c-73e336da4584
md"""
Similar to `BinaryPoly` we can add and multiply binary elements
"""

# ╔═╡ f2d41618-20ed-4477-b7a9-1fe11ae1e6ea
α + β

# ╔═╡ 496f2dde-9f53-4bdf-8e32-9a652ebf8b40
α*β

# ╔═╡ 6e4c93c9-80ca-424b-a9e7-bf4ba4b5df38
md"""
Note that, unlike a binary polynomial, the result of multiplying two 16-bit binary elements is just another 16-bit binary element: we take the underlying polynomials, multiply them (receiving a degree-32 polynomial) and then reduce them modulo a degree 16 irreducible polynomial.

We can see that the resulting number of operation here is _very small_: indeed, if you look into `BinaryFields`, we generate relatively compact code at compile time!
"""

# ╔═╡ eeb32ee8-cf3f-4adf-a134-3b07a0beb014
@code_native α*β

# ╔═╡ 19cacb85-e868-4de1-b909-c74176249ef8
md"""
(In particular, note that we load the binary polynomials into the right registers, call the hardware-optimized multiplication instruction, and then do a reduction via multiple XORs.)
"""

# ╔═╡ 80157e5e-eeca-4e0c-b0c3-9b2eaba0fa09
md"""
## Inverses
Another thing that distinguishes binary elements from binary polynomials is the existence of inverses:
"""

# ╔═╡ 09d7cc88-914c-48df-b5f8-68eb97244f30
inv(α)

# ╔═╡ 4d698782-56ee-4558-9901-5c3181e59fcd
md"""
Which gives the obvious result
"""

# ╔═╡ d8aba143-ffe0-41b1-bd2e-89f1ab8064b0
inv(α)*α

# ╔═╡ 6dfc65a9-8381-4d1a-826d-10574d0fdd11
md"""
We can do the same matrix-vector stuff and so on that we did earlier, of course
"""

# ╔═╡ 5773f9e1-446e-4fb3-915a-8095bd4ccc1b
B, w = rand(BinaryElem16, 2^12, 2^10), rand(BinaryElem16, 2^10)

# ╔═╡ ea937968-dd56-4614-a647-438ebfde417e
@benchmark B*w

# ╔═╡ 4d6a0553-6b5f-4a3f-8a0e-843cb56fcee2
md"""
The operations here are a little slower than those over the polynomials `BinaryPoly16` since they require the reductions and so on.

Finally, it is generally very useful to draw randomness from a larger field, such as $\mathbf{F}_{2^{128}}$ and use this to take random combinations of elements of the smaller field (like $\mathbf{F}_{2^{16}}$). We can do this extremely transparently in Julia:
"""

# ╔═╡ 01076abf-9632-4b72-b5a5-94b40c6eaa72
w_128 = rand(BinaryElem128, 2^10)

# ╔═╡ 46373f08-0683-468b-a45b-e10c387a3053
B*w_128

# ╔═╡ 6b4dca4d-a5fb-4973-83ee-9788f5ce10cf
md"""
This looks super innocent, but it is not! Note that `B` has elements of type `BinaryElem16` while `w_128` has elements of type `BinaryElem128`. As before, we have _not_ specified how this matrix-vector multiplication should work in the library, either, so... there's some magic going on.

Specifically, under the hood, Julia knows how to 'upcast' elements correctly. Indeed, we have specified a way of mapping elements from the small field $\mathbf{F}_{2^{16}}$ to the 'big' field $\mathbf{F}_{2^{128}}$ in a way that preserves addition, multiplication, and inverses. So, if Julia ever sees some operation of the form `BinaryElem128 + BinaryElem16`, or multiplication, etc, it will automatically do this casting. This, in turn, will automatically be converted and compiled down to fast code!

That's pretty much it for the `BinaryFields` stuff. For more advanced topics, like Reed–Solomon encodings, or how to use this library to run a basic succinct proof system like Ligero, check out the other notebooks.
"""

# ╔═╡ 856b9d47-c231-4e6d-99fc-ae6657eed072


# ╔═╡ Cell order:
# ╟─46125d64-d8cb-45f1-9a52-6605bae3d61a
# ╠═44aaaa20-1706-11f0-07da-a7a2143bc8de
# ╠═2c9f6aed-b739-49db-99e7-94ef9a20ac25
# ╟─52cce847-a1de-4785-96a3-72925d7f978a
# ╠═6d490563-d602-406d-ac72-f53231e01a2b
# ╟─7d80d539-6d6d-4978-9a83-5995ec9a3815
# ╠═b85d5f43-2ce8-4556-a6b0-24bd0980be23
# ╠═5d1b8580-dd61-4ae0-af35-d515cc0cbf39
# ╠═dc0a7bfd-e618-4947-b66f-7949b6f17dc3
# ╠═0aaa1c16-ac4a-49ad-ac96-e210cc75aaf9
# ╠═c4fa1511-3c90-4f89-b368-aaf72b37cf93
# ╠═ba717d00-f8c3-433e-954e-2c16e83282da
# ╠═babcf2d7-d8ba-4efe-be87-1627b485892e
# ╟─bb2db986-8f48-4e8d-b69c-f1c83894dd0a
# ╠═85b2773a-5380-4adc-abe4-f1ffddd5c6e7
# ╟─169a4bb6-30dc-4482-850e-2e35ef46a6c7
# ╠═850ef7b8-a5da-4e6a-90c3-84dda633acda
# ╟─abd0200d-2d0c-4dbf-9f89-a8480ca479a8
# ╠═1fd49d5e-dd49-46c9-b0bb-2eaf6e4d5c53
# ╠═09621926-b853-425f-9c04-f434a744b91c
# ╠═5e823daf-accb-4226-8e5c-fe6221d4ed18
# ╠═116abcc3-9b2c-41c6-83dd-7acff73bccd5
# ╠═473ded59-38da-4224-9e30-b3ec4bbd0ffe
# ╟─a1818409-e572-4af0-9d28-13459c56ddfc
# ╠═88e95733-d4ce-401c-a993-f2336531fac7
# ╠═5d4aa8c3-776e-473c-ab62-e03aac2025f6
# ╠═347d0172-ad11-489b-8092-70d563ddf2ca
# ╠═32c43fea-0a48-4621-b363-24dcc2f1ef8d
# ╠═eb703b67-6d3f-47d8-9b50-416922ba4666
# ╠═a96f0162-8003-49fd-9a1c-73e336da4584
# ╠═f2d41618-20ed-4477-b7a9-1fe11ae1e6ea
# ╠═496f2dde-9f53-4bdf-8e32-9a652ebf8b40
# ╠═6e4c93c9-80ca-424b-a9e7-bf4ba4b5df38
# ╠═eeb32ee8-cf3f-4adf-a134-3b07a0beb014
# ╠═19cacb85-e868-4de1-b909-c74176249ef8
# ╠═80157e5e-eeca-4e0c-b0c3-9b2eaba0fa09
# ╠═09d7cc88-914c-48df-b5f8-68eb97244f30
# ╠═4d698782-56ee-4558-9901-5c3181e59fcd
# ╠═d8aba143-ffe0-41b1-bd2e-89f1ab8064b0
# ╠═6dfc65a9-8381-4d1a-826d-10574d0fdd11
# ╠═5773f9e1-446e-4fb3-915a-8095bd4ccc1b
# ╠═ea937968-dd56-4614-a647-438ebfde417e
# ╠═4d6a0553-6b5f-4a3f-8a0e-843cb56fcee2
# ╠═01076abf-9632-4b72-b5a5-94b40c6eaa72
# ╠═46373f08-0683-468b-a45b-e10c387a3053
# ╠═6b4dca4d-a5fb-4973-83ee-9788f5ce10cf
# ╠═856b9d47-c231-4e6d-99fc-ae6657eed072
