using UnitfulParsableString
using Unitful
using Test

# checkexpr(str) = Meta.parse(str) |> Term.expressiontree
# typeof(1u"m") |> Term.typestree |> display
# typeof(u"m") |> Term.typestree |> display
# typeof(u"dB") |> Term.typestree |> display

macro mytest(unit, str) 
    quote
        u,s = $unit, $str
        @show u,s
        @test string(u)==s
        @test uparse(s)==u        
    end
end

macro mytest_Meta(Mod, unit, str) 
    quote
        u,s = $unit, $str
        @show u,s
        @test string(u)==s
        @test $Mod.eval(Meta.parse(s))==u
    end
end

macro mytest_Meta(unit, str)
    quote
        @mytest_Meta Unitful $unit $str
    end
end

#include("test_default_no_u_str.jl")
include("test_default_u_str.jl")
include("test_otherPackages.jl")
