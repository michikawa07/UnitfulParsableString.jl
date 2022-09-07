module UnitfulParsableString

using Unitful
using Unitful: # unexported Struct 
	AbstractQuantity, Unitlike, MixedUnits, Gain, Level
using Unitful: # need for print
	showval, sortexp, prefix, abbr, power

has_unit_bracket(x::AbstractQuantity) = has_unit_bracket(x.val)
has_unit_bracket(x::Complex) = false
has_unit_bracket(x) = true

function Unitful.string(x::AbstractQuantity)
	v = sprint(showval, x.val, true)
	u = string(unit(x))
	has_unit_bracket(x) && return string(v, "(", u, ")")
	string(v,  u)
end

function Unitful.string(x::Union{Gain, Level})
	
end

function Unitful.string(u::Unitlike)
	first = true
	str = ""
	foreach(sortexp(typeof(u).parameters[1])) do y
		pow = power(y)
		sep = first ? "" : pow<0 ? "/" : "*"
		p = abs(pow)== 1	? ""  :
			 pow.den == 1	? string("^" , abs(pow.num)) : 
			 					  string("^(", abs(pow.num), "/", pow.den, ")")
		str *= string(sep, prefix(y), abbr(y), p)
		first = false
	end
	str
end

function Unitful.string(r::StepRange{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	u = unit(a)
	U = string(u)
	S = ustrip(u, s) == 1 ?	repr(ustrip(u, a):ustrip(u, b)) : 
								 	repr(ustrip(u, a):ustrip(u, s):ustrip(u, b))
	length(typeof(u).parameters[1]) > 1 && return string("(", S, ")", "*(", U, ")")
	string("(", S, ")", U)
end

function Unitful.string(r::StepRangeLen{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	u = unit(a)
	U = string(u)
	S = repr(ustrip(u, a):ustrip(u, s):ustrip(u, b))
	length(typeof(u).parameters[1]) > 1 && return string("(", S, ")", "*(", U, ")")
	string("(", S, ")", U)
end

function Unitful.string(x::typeof(NoDims))
	"NoDims"
end

end
