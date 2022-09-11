# UnitfulParsableString [![Build Status](https://github.com/michikawa07/UnitfulParsableString.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/michikawa07/UnitfulParsableString.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://michikawa07.github.io/UnitfulParsableString.jl/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://michikawa07.github.io/UnitfulParsableString.jl/dev/) [![Build Status](https://travis-ci.com/michikawa07/UnitfulParsableString.jl.svg?branch=main)](https://travis-ci.com/michikawa07/UnitfulParsableString.jl)

`UnitfulParsableString.jl` expand [Unitful.jl](https://github.com/PainterQubits/Unitful.jl) to add the method `Unitful.string` which convert `Quantity` (or some type) to parsable `String`.

```julia
julia> using Unitful

julia> string(1.0u"m*s") 
"1.0 m s" # <- julia cannot parse

julia> string(1.0u"m*s") |> Unitful.uparse
ERROR: Base.Meta.ParseError("extra token \"m\" after end of expression")

julia> using UnitfulParsableString

julia> string(1.0u"m*s")
"1.0(m*s)" # <- julia can parse

julia> string(1.0u"m*s") |> Unitful.uparse
1.0 m s
```

## Expression of Unit
 	Unitful.string(unit::Unitlike)

Values of `Unitful.Unitlike` subtypes are converted to `string` that julia can parse as following rules.

Multi-units are expressed as basicaly separeted by `"*"`, but sometimes `"/"` is used exceptionally for simplicity, see below for details.
Exponents are expressed as `"^|x|"` or `"^-|x|"` (x > 0) in principle, except for units with a rational exponent y, which are expressed by wrapping them in parentheses as `"^(y)"`.

### Detail of separatoers
When all exponential of the units is positive, all separates are `"*"`.
```julia
julia> string(u"m*s^2")
"m*s^2"
```
When all exponential of the units is negative, all separates are `"*"` and the negative exponential is expressed as `"^-|x|"`.
```julia
julia> string(u"(m*s)^-1") # all exponents are negative
"m^-1*s^-1"                # -> separater is "*"
```
When both positive and negative exponentials coexist, if there are rational exponentials, all separates are `"*"` and the negative exponential is expressed as `"^-|x|"`.
```julia
julia> string(u"m^(1/2)*s^-2") # positive and negative exponent coexist
"m^(1/2)*s^-2"                 # if rational exponent exist -> separater is "*"
```
When both positive and negative exponentials coexist, if not there are rational exponentials, the separates of the units with negative exponential are `"/"` and the negative exponential is expressed as `"^|x|"`.
```julia
julia> string(u"m*s^-2") # positive and negative exponent coexist
"m/s^2"                  # if rational exponent never exist -> "/" can be use for separater
```
### Detail of rational exponents

When the exponentials are rational, if the velue n//m is strictly same as n/m, it is expressed as "^(n/m)".
```julia
julia> string(u"m^(1//2)" # 1//2 == 1/2
"m^(1/2)")
```
If not the velue n//m is strictly same as n/m, it is expressed as "^(n//m)".
```julia
julia> string(u"m^(1//3)" # 1//3 != 1/3
"m^(1//3)"
```

## Expression of Quantity
	Unitful.string(x::AbstractQuantity)

Values of `Unitful.AbstractQuantity` subtypes to `string` that julia can parse as following rules.

The `Unitful.Quantity` `x` have value and units (they can be get `x.val` and `unit(x)`).
Thus, the work of this function is simply shown as follows:
```julia
string( ["("], string(value), [")"], ["*"], ["("], string(units), [")"] )
```
The presence or absence of each bracket is determined by the return values of the `has_value_bracket(x)` and `has_unit_bracket(x)` functions.
And the sepaprator `"*"` is inserted, if `has_value_bracket(x) && has_unit_bracket(x) == true`.

Note: see `Unitful.string(x::Unitlike)` about the string expression of unit 

```julia
julia> string(u"1.0s^2")	# u"1.0s^2" -> 1.0 s²
"1.0s^2"
```

```julia
julia> string(u"1.0m*kg")	# u"1.0m*kg" -> 1.0 kg m
"1.0(kg*m)"
```

```julia
julia> string((1//2)u"m")	# (1//2)u"m" -> 1//2 m
"(1//2)m"
```

```julia
julia> string((1+2im)u"m/s")	# (1+2im)u"m/s" -> (1 + 2im) m s⁻¹
"(1 + 2im)*(m/s)"
```

## Parsability

#### expamle
```julia
julia> using UnitfulParsableString 

julia> x = u"1.0m^2/K^(1//3)"
1.0 m² K⁻¹ᐟ³

julia>  x |> string |> uparse == x
true

julia> x = 2u"m"//3u"s"
2//3 m s⁻¹

julia> x |> string |> uparse == x
true
```

See more test/runtest.jl.

## Note
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
