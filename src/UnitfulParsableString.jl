module UnitfulParsableString

using Unitful
using Unitful: # unexported Struct 
	AbstractQuantity, Unitlike, MixedUnits, Gain, Level
using Unitful: # need for print
	prefix, abbr, power

has_value_bracket(x::Quantity) = has_value_bracket(x.val)
has_value_bracket(::Union{Gain, Level}) = true
has_value_bracket(::Union{Complex, Rational}) = true
has_value_bracket(::Union{BigInt,Int128,Int16,Int32,Int64,Int8}) = false
has_value_bracket(::Union{BigFloat,Float16,Float32,Float64}) =  false
has_value_bracket(x::Number) = any(!isdigit, string(x)) # slow

has_unit_bracket(x::Quantity) = has_unit_bracket(unit(x)) #&& !has_value_bracket(x)
has_unit_bracket(u::Unitlike) = length(typeof(u).parameters[1]) > 1 

function sortedunits(u)
	us = collect(typeof(u).parameters[1])
	sort!(us, by = u->power(u)>0 ? 1 : -1, rev=true)
end

"""
	Unitful.string(unit::Unitlike)
This function provied by `UnitfulParsableString` converts `Unitful.Unitlike` subtypes to `string` that julia can parse.

Multi-units are expressed as basicaly separeted by "*".

When all exponential of the units is positive, all separates are "*".  
When all exponential of the units is negative, all separates are "*" and the negative exponential is expressed as "^-|x|".  
When both positive and negative exponentials coexist, if there are rational exponentials, all separates are "*" and the negative exponential is expressed as "^-|x|".  
When both positive and negative exponentials coexist, if not there are rational exponentials, the separates of the units with negative exponential are "/" and the negative exponential is expressed as "^|x|".  

When the exponentials are rational, if the velue n//m is strictly same as n/m, it is expressed as "^(n/m)".
If not the velue n//m is strictly same as n/m, it is expressed as "^(n//m)".

## Examples1:

```jldoctest
julia> u"m*s", string(u"m*s")
(m s, "m*s")

julia> u"m*m", string(u"m*m")
(m², "m^2")
```

## Examples2: Expression of negative exponential

```jldoctest
julia> u"m/s", string(u"m/s")
(m s⁻¹, "m/s") 

julia> u"(m*s)^-1", string(u"(m*s)^-1")
(m⁻¹ s⁻¹, "m^-1*s^-1")

julia> u"m/s^(1/2)", string(u"m/s^(1/2)")
(m s⁻¹ᐟ², "m*s^(-1/2)")
```

## Examples3: Expression of rational exponential

```jldoctest
julia> u"m^(1//2)", string(u"m^(1//2)")
(m¹ᐟ², "m^(1/2)") 

julia> u"m^(1//3)", string(u"m^(1//3)")
(m¹ᐟ³, "m^(1//3)")
```
"""
function Unitful.string(u::Unitlike)
	unit_list = sortedunits(u)
	#* Express as `^-1` -> `/` 
	#* if there exists a unit whose exponent part is positive 
	#* and all exponents are written as integers.
	is_div_note = any(u->power(u)>0, unit_list) && all(u->power(u).den==1, unit_list)
	str = ""
	for (i, y) in enumerate(unit_list)
		sep = "*"
		p = power(y) 
		if is_div_note && p.num<0
			sep = "/"
			p = abs(p)
		end
		pow = p == 1//1        ? ""  :
		      p.den == 1       ? string("^", p.num) : 
		      p == p.num/p.den ? string("^", "(", p.num, "/" , p.den, ")") :
		                         string("^", "(", p.num, "//", p.den, ")")
		str = string(str, (i==1 ? "" : sep), prefix(y), abbr(y), pow)
	end
	str
end

"""
	Unitful.string(x::AbstractQuantity)
	This function provied by `UnitfulParsableString` converts `Unitful.AbstractQuantity` subtypes to `string` that julia can parse.

has_value_bracket(x) == true 
 -> "(2//3)m^2"
has_unit_bracket(x) == true 
 -> "1.0(m*kg)"


## Examples:

```jldoctest
julia> u"1.0s", string(u"1.0s")
(1.0 s, "1.0s")

julia> u"1.0m^(2//3)", string(u"1.0m^(2//3)")
(1.0 m²ᐟ³, "1.0m^(2//3)")

julia> u"1.0m*kg", string(u"1.0m*kg")
(1.0 kg m, "1.0(kg*m)")
```
"""
function Unitful.string(x::AbstractQuantity)
	v = x.val |> string
	u = unit(x) |> string
	val = has_value_bracket(x) ? string("(", v, ")") : v
	uni = has_unit_bracket(x)  ? string("(", u, ")") : u
	sep = has_value_bracket(x) && has_unit_bracket(x) ? "*" : ""
	string(val, sep, uni)
end

function Unitful.string(x::Gain)
	v = x.val |> string
	val = has_value_bracket(x.val) ? string("(", v, ")") : v
	string(val, abbr(x))
end

function Unitful.string(x::Level)
	v = ustrip(x) |> string
	val = has_value_bracket(ustrip(x)) ? string("(", v, ")") : v
	string(val, abbr(x))
end

function Unitful.string(r::StepRange{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	U,u = unit(a), string(unit(a))
	rng = ustrip(U, s)==1 ? repr(ustrip(U, a):ustrip(U, b)) : 
	                        repr(ustrip(U, a):ustrip(U, s):ustrip(U, b))
	uni = has_unit_bracket(U) ? string("*", "(", u, ")") : u
	string("(", rng, ")", uni)
end

function Unitful.string(r::StepRangeLen{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	U,u = unit(a), string(unit(a))
	rng = repr(ustrip(U, a):ustrip(U, s):ustrip(U, b))
	uni = has_unit_bracket(U) ? string("*", "(", u, ")") : u
	string("(", rng, ")", uni)
end

function Unitful.string(x::typeof(NoUnits))
	"NoUnits"
end

end
