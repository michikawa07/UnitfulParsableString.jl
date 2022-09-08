module UnitfulParsableString

using Unitful
using Unitful: # unexported Struct 
	AbstractQuantity, Unitlike, MixedUnits, Gain, Level
using Unitful: # need for print
	showval, sortexp, prefix, abbr, power

#Meta.parse(str) |> Term.expressiontree

has_value_bracket(x::Quantity) = has_value_bracket(x.val)
has_value_bracket(::Union{Complex, Rational}) = true
has_value_bracket(::Any) = false

has_unit_bracket(x::Quantity) = has_unit_bracket(unit(x)) #&& !has_value_bracket(x)
has_unit_bracket(u::Unitlike) = length(typeof(u).parameters[1]) > 1 
has_unit_bracket(::Any) = false

function Unitful.string(u::Unitlike)
	isFirst = true
	str = ""
	foreach(sortexp(typeof(u).parameters[1])) do y
		sep = isFirst ? "" : power(y)<0 ? "/" : "*"
		p = abs(power(y))
		pow =     p == 1           ? ""  :
		      p.den == 1           ? string("^", p.num) : 
		          p == p.num/p.den ? string("^", "(", p.num, "/" , p.den, ")") :
		                             string("^", "(", p.num, "//", p.den, ")")
		str *= string(sep, prefix(y), abbr(y), pow)
		isFirst = false
	end
	str
end

function Unitful.string(x::AbstractQuantity)
	v = x.val |> string
	u = unit(x) |> string
	V = has_value_bracket(x) ? string("(", v, ")") : v
	U = has_unit_bracket(x) ? string("(", u, ")") : u
	sep = has_value_bracket(x) && has_unit_bracket(x) ? "*" : ""
	string(V, sep, U)
end

function Unitful.string(x::Union{Gain, Level})
	
end

function Unitful.string(r::StepRange{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	u = unit(a) 
	S = ustrip(u, s) == 1 ?	repr(ustrip(u, a):ustrip(u, b)) : 
								 	repr(ustrip(u, a):ustrip(u, s):ustrip(u, b))
	U = has_unit_bracket(u) ? "*("*string(u)*")" : string(u)
	string("(", S, ")", U)
end

function Unitful.string(r::StepRangeLen{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	u = unit(a)
	S = repr(ustrip(u, a):ustrip(u, s):ustrip(u, b))
	U = has_unit_bracket(u) ? "*("*string(u)*")" : string(u)
	string("(", S, ")", U)
end

function Unitful.string(x::typeof(NoDims))
	"NoDims"
end

end
