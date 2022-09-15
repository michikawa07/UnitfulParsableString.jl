using UnitfulParsableString
using Unitful
using Test

macro mytest(unit, str) 
    quote
        u,s = $unit, $str
      #  @show u,s
        @test string(u)==s
        @test uparse(s)==u        
    end
end

macro mytest_Meta(Mod, unit, str) 
    quote
        u,s = $unit, $str
     #   @show u,s
        @test string(u)==s
        @test $Mod.eval(Meta.parse(s))==u
    end
end

macro mytest_Meta(unit, str)
    quote
        @mytest_Meta Unitful $unit $str
    end
end

include("test_otherPackages.jl")
include("test_default.jl")
include("test_u_str.jl")
