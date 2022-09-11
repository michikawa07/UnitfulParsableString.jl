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
メモ  
これ単体でパース出来る様に作る
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
