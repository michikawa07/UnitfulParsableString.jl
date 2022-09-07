module UnitfulParsableString

using Unitful
using Unitful: # unexported Struct 
	AbstractQuantity, Unitlike, MixedUnits, Gain, Level
using Unitful: # need for print
	showval, sortexp, showrep

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
	io = IOBuffer()
	first = ""
	sep = "*"
	foreach(sortexp(typeof(u).parameters[1])) do y
		 print(io,first)
		 showrep(IOContext(io, :fancy_exponent=>false), y) #これを自分で実装しなおす必要があるかもしれない．
		 first = sep
	end
	io |> take! |> String
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
