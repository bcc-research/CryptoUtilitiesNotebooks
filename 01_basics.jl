### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

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

# ╔═╡ 72d4bf34-aed4-4c8c-a4d8-29652bc02385
md"""
## Function calling and conventions
"""

# ╔═╡ e31aff2b-1c88-49b2-8b1b-117784704a64
md"""
It is very rare for code to do something like `a = "hello"` and then call a method by accessing a (_i.e._, it is very rare to have `a.length()` be a reasonable thing, normally a function is called on XXX)
"""

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

There are some very nice benchmark utilities in Julia (XXX)
"""

# ╔═╡ Cell order:
# ╠═68426662-44b5-4775-90f0-4ebbc9676bb5
# ╠═c2972d7f-823c-47f9-b6b8-0fb6ed33a5db
# ╟─0fa676f0-6c20-4f56-80f5-7f597011d812
# ╠═03f105d4-4ad3-427a-a2fc-7d289982195d
# ╠═739e5712-34ea-4bef-ad48-00750e344173
# ╟─0c81634c-2608-49af-b48c-f5340fac52c3
# ╠═8417a507-6b30-4bb3-a89e-06f421aa5850
# ╟─59e2f602-564e-48ee-9780-0bad80373d42
# ╠═f160bd24-45d1-4c16-a612-ecd0252326e2
# ╠═72d4bf34-aed4-4c8c-a4d8-29652bc02385
# ╠═e31aff2b-1c88-49b2-8b1b-117784704a64
# ╟─ce3c9c1d-6425-4fa2-91ec-a681dcf7bb49
# ╠═f0cbecfa-8392-44d3-ac69-3413146353ac
# ╟─e3223cc2-c4bd-4a77-8ffa-c9469701246c
# ╠═db05fa73-e3a0-4a7b-9e48-97aba133b1c8
# ╠═71df17b6-2a6f-412b-b5b0-9e26d9575fdc
