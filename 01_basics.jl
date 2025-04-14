### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 342ad0c2-42eb-4f74-bc6b-85aab1c90346
using BenchmarkTools

# ╔═╡ 68426662-44b5-4775-90f0-4ebbc9676bb5
md"""
# Some Julia basics
As usual, Julia has a REPL, which allows you to evaluate expressions (like Python). Here, if the expression in the cell returns a value, this is written _above_ the cell; anything printed in the cell is _below_ the cell:
"""

# ╔═╡ c2972d7f-823c-47f9-b6b8-0fb6ed33a5db
1+1

# ╔═╡ 0fa676f0-6c20-4f56-80f5-7f597011d812
md"""
Assignment works the same way you would expect:
"""

# ╔═╡ 03f105d4-4ad3-427a-a2fc-7d289982195d
a = 2

# ╔═╡ 739e5712-34ea-4bef-ad48-00750e344173
a+a

# ╔═╡ 0c81634c-2608-49af-b48c-f5340fac52c3
md"""
We can also get the types of things in Julia; integers default to Int64:
"""

# ╔═╡ 8417a507-6b30-4bb3-a89e-06f421aa5850
typeof(a)

# ╔═╡ 59e2f602-564e-48ee-9780-0bad80373d42
md"""
Loops and such are very similar to those of Python, with the one caveat that everything is one-indexed, instead of zero-indexed(!). You can also do string interpolation via the `$` operator, which is neat:
"""

# ╔═╡ f160bd24-45d1-4c16-a612-ecd0252326e2
for i in 1:5
	println("Number of times this print statment has been run: $i")
end

# ╔═╡ e31aff2b-1c88-49b2-8b1b-117784704a64
md"""
### Function calling and conventions

It is very rare for code to do something like `s = [1,3,2,4]` and then call a method by accessing a field (_i.e._, it is almost never the case that you want to write something like `a.length()`, which, in this case, doesn't even parse!)

Calling convention is usually as follows:
1. Functions are simply called (_e.g._, `println(s)`)
2. Functions can return things, of course (_e.g._, `l = length(s)`)
3. Functions that modify their arguments end with an exclamation mark, by convention, and the modified arguments is generally the first argument (_e.g._, `sort!(s)`)
4. Keyword arguments must be explicitly included (_e.g._, `sort(s, rev=true)`) _except_ in the case that (a) there is a variable with the same name as the keyword passed in and (b) this happens after a separating semicolon

There is nothing enforcing the particular syntax in point 3, so this is a (strongly recommended) convention. It is also uncommon (but not unheard of) for a function to modify more than one argument at a time, but, if it does, then the first arguments are the ones that are modified.

An example of point 4 here: define the vector `s` and boolean `rev`:
"""

# ╔═╡ 634eff21-ad97-42eb-a99e-5e60c52d38d7
begin 
	s = [1,3,2,4]
	rev = false
end;

# ╔═╡ 69938952-e9c7-465b-b1b9-5de7f2e4959c
sort(s; rev)

# ╔═╡ ce3c9c1d-6425-4fa2-91ec-a681dcf7bb49
md"""
## Some (basic) Julia performance stuff
An important part of Julia is the fact that everything compiles down to machine instructions, indeed, Julia makes this very easy to see via `@code_native`:
"""

# ╔═╡ f0cbecfa-8392-44d3-ac69-3413146353ac
@code_native a+a

# ╔═╡ e3223cc2-c4bd-4a77-8ffa-c9469701246c
md"""
It does this by compiling Julia code down to LLVM code, which is also easy to see:
"""

# ╔═╡ db05fa73-e3a0-4a7b-9e48-97aba133b1c8
@code_llvm a+a

# ╔═╡ 71df17b6-2a6f-412b-b5b0-9e26d9575fdc
md"""
which then gets compiled down to native code (as above).

### BenchmarkTools
There are some very nice benchmark utilities in Julia. The most basic but powerful package of these is `BenchmarkTools`:
"""

# ╔═╡ 9932fa4c-0d87-4713-9ff3-89507d30de01
md"""
This package lets us do all sorts of interesting things. For example, we can make a random vector of $2^{10}$ entries 
"""

# ╔═╡ 36fd73ae-cf29-4149-94ea-9fbab817e8f8
v = rand(2^10)

# ╔═╡ f0fc84c7-f1b2-41e6-9e0e-3e76b1cb53a0
md"""
And benchmark, say, taking some inner products, testing allocations/garbage collection pressure, along with distributions of running time by just doing a simple call:
"""

# ╔═╡ ac440ed2-1f86-40cf-aad9-8cacca636759
@benchmark v' * v

# ╔═╡ 92539cfd-4938-4ea8-9a8d-53f08a676aee
md"""
We can see that Julia here barely allocates anything since it is relatively smart about how to compute these inner products.

We can try a more complicated operation that will certainly allocate, which will create a $2^{10} \times 2^{10}$ matrix on the fly and then take the matrix-vector product of this matrix with `v`:
"""

# ╔═╡ 4cf07835-9054-43a2-9979-2607c3e40d88
@benchmark rand(2^10, 2^10)*v

# ╔═╡ 48cf2dba-69c3-4ce8-b1a7-787dc8b591eb
md"""
We will use all of these things (and only a few more) in the next set of notebooks.

Good luck !
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"

[compat]
BenchmarkTools = "~1.6.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "2a7392fbc86bcb1608a6d4c3fafc922aa7051ef7"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.BenchmarkTools]]
deps = ["Compat", "JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "e38fbc49a620f5d0b660d7f543db1009fe0f8336"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.6.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Profile]]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"
"""

# ╔═╡ Cell order:
# ╟─68426662-44b5-4775-90f0-4ebbc9676bb5
# ╠═c2972d7f-823c-47f9-b6b8-0fb6ed33a5db
# ╟─0fa676f0-6c20-4f56-80f5-7f597011d812
# ╠═03f105d4-4ad3-427a-a2fc-7d289982195d
# ╠═739e5712-34ea-4bef-ad48-00750e344173
# ╟─0c81634c-2608-49af-b48c-f5340fac52c3
# ╠═8417a507-6b30-4bb3-a89e-06f421aa5850
# ╟─59e2f602-564e-48ee-9780-0bad80373d42
# ╠═f160bd24-45d1-4c16-a612-ecd0252326e2
# ╟─e31aff2b-1c88-49b2-8b1b-117784704a64
# ╠═634eff21-ad97-42eb-a99e-5e60c52d38d7
# ╠═69938952-e9c7-465b-b1b9-5de7f2e4959c
# ╟─ce3c9c1d-6425-4fa2-91ec-a681dcf7bb49
# ╠═f0cbecfa-8392-44d3-ac69-3413146353ac
# ╟─e3223cc2-c4bd-4a77-8ffa-c9469701246c
# ╠═db05fa73-e3a0-4a7b-9e48-97aba133b1c8
# ╟─71df17b6-2a6f-412b-b5b0-9e26d9575fdc
# ╠═342ad0c2-42eb-4f74-bc6b-85aab1c90346
# ╠═9932fa4c-0d87-4713-9ff3-89507d30de01
# ╠═36fd73ae-cf29-4149-94ea-9fbab817e8f8
# ╟─f0fc84c7-f1b2-41e6-9e0e-3e76b1cb53a0
# ╠═ac440ed2-1f86-40cf-aad9-8cacca636759
# ╟─92539cfd-4938-4ea8-9a8d-53f08a676aee
# ╠═4cf07835-9054-43a2-9979-2607c3e40d88
# ╟─48cf2dba-69c3-4ce8-b1a7-787dc8b591eb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
