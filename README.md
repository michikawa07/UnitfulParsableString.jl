# UnitfulParsableString [![Build Status](https://github.com/michikawa07/UnitfulParsableString.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/michikawa07/UnitfulParsableString.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://michikawa07.github.io/UnitfulParsableString.jl/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://michikawa07.github.io/UnitfulParsableString.jl/dev/) [![Build Status](https://travis-ci.com/michikawa07/UnitfulParsableString.jl.svg?branch=main)](https://travis-ci.com/michikawa07/UnitfulParsableString.jl)

`UnitfulParsableString.jl` expand [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) to add the method `Unitful.string` which convert `Quantity` (or some type) to parsable `String`.

```julia
julia> using Unitful

julia> string(1.0u"m")
"1.0 m" # <- cannot parse

julia> string(1.0u"m*s") 
"1.0 m s" # <- cannot parse

julia> using UnitfulParsableString

julia> string(1.0u"m")
"1.0m" # <- julia can parse

julia> string(1.0u"m*s")
"1.0(m*s)" # <- julia can parse
```

## note
`UnitfulParsableString.jl` not change the `display`, `show` and `print` functions about `Unitful.jl`.

```julia
julia> using Unitful

julia> 1.0u"m"
1.0 m

julia> 1.0u"m*s"
1.0 m s

julia> using UnitfulParsableString

julia> 1.0u"m"
1.0 m

julia> 1.0u"m*s"
1.0 m s
```


## Related Packages

* [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) - Implements dimensional numerical quantities for Julia
