module UnitfulParsableString

using Unitful
using Unitful: # unexported Struct 
	AbstractQuantity, Unitlike, MixedUnits, Gain, Level
using Unitful: # need for print
	sortexp, prefix, abbr, power

has_value_bracket(x::Quantity) = has_value_bracket(x.val)
has_value_bracket(::Union{Gain, Level}) = true
has_value_bracket(::Union{Complex, Rational}) = true
has_value_bracket(::Any) = false

has_unit_bracket(x::Quantity) = has_unit_bracket(unit(x)) #&& !has_value_bracket(x)
has_unit_bracket(u::Unitlike) = length(typeof(u).parameters[1]) > 1 
has_unit_bracket(::Any) = false

"""
メモ  
これ単体でパース出来る様に作る
"""
function Unitful.string(u::Unitlike)
	isFirst = true
	str = ""
	foreach(sortexp(typeof(u).parameters[1])) do y
		p = power(y) 
		sep = "*"
		isDivNote = !isFirst && p.den==1
		if isDivNote
			sep = p ≥ 0 ? "*" : "/"
			p = abs(p)
		end
		pow = p == 1           ? ""  :
		      p.den == 1       ? string("^", p.num) : 
		      p == p.num/p.den ? string("^", "(", p.num, "/" , p.den, ")") :
		                         string("^", "(", p.num, "//", p.den, ")")
		str *= string(isFirst ? "" : sep, prefix(y), abbr(y), pow)
		isFirst = false
	end
	str
end

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

function Unitful.string(x::typeof(NoDims))
	"NoDims"
end

end
