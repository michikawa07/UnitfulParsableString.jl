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
	io = IOContext(IOBuffer(), :fancy_exponent=>false)
	first = true
	foreach(sortexp(typeof(u).parameters[1])) do y
		p = 	power(y) == 1//1 ? "" :
				power(y)  ≥  0   ? denominator(power(y)) == 1 ? "^" * string(power(y).num) : "^(" * replace(string(power(y)), "//" => "/") * ")" : 
				power(y)  <  0	  ? denominator(power(y)) == 1 ? "^" * string(-power(y).num) : "^(" * replace(string(-power(y)), "//" => "/") * ")" : ""
		sep = first ? "" : power(y)<0 ? "/" : "*"
		print(io, sep)
		print(io, prefix(y))
		print(io, abbr(y))
		print(io, p)
		first = false
	end
	io.io |> take! |> String
end

function Unitful.string(r::StepRange{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	u = unit(a)
	U = sprint(show, u; context=(:showoperators=>true, :fancy_exponent=>false))
	S = ustrip(u, s) == 1 ?	repr(ustrip(u, a):ustrip(u, b)) : 
								 	repr(ustrip(u, a):ustrip(u, s):ustrip(u, b))
	string("(", S, ")", U)
end

function Unitful.string(r::StepRangeLen{T}) where T<:Quantity
	a,s,b = first(r), step(r), last(r)
	u = unit(a)
	U = sprint(show, u; context=(:showoperators=>true, :fancy_exponent=>false))
	S = repr(ustrip(u, a):ustrip(u, s):ustrip(u, b))
	string("(", S, ")", U)
end

function Unitful.string(x::typeof(NoDims))
	"NoDims"
end

end
