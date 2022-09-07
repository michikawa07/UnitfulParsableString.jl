using UnitfulParsableString
using Test
using Unitful

@testset "Unit only" begin
    #* Unit only
    @test string(u"nm"      ) == "nm"      
    @test string(u"mm*kg"   ) == "kg*mm"   
    @test string(u"mm/kg"   ) == "mm/kg"   
    @test string(u"m^2"     ) == "m^2"     
    @test string(u"m^2/K^2" ) == "m^2/K^2"
    @test string(u"m^(2//3)/K^(1/2)" ) == "m^(2/3)/K^(1/2)"
    # @test string(u"m^0.1" ) == "m^0.1" #not work
end

@testset "Quantity" begin
    #* Int
    @test string(2u"nm"      ) == "2(nm)"      
    @test string(2u"mm*kg"   ) == "2(kg*mm)"   
    @test string(2u"mm/kg"   ) == "2(mm/kg)"   
    @test string(2u"m^2"     ) == "2(m^2)"     
    @test string(2u"m^2/K^2" ) == "2(m^2/K^2)"
    @test string(2u"m^(2//3)/K^(1/2)" ) == "2(m^(2/3)/K^(1/2))"

    #* Float1
    @test string(1.0u"nm"      ) == "1.0(nm)"      
    @test string(1.0u"mm*kg"   ) == "1.0(kg*mm)"   
    @test string(1.0u"mm/kg"   ) == "1.0(mm/kg)"   
    @test string(1.0u"m^2"     ) == "1.0(m^2)"     
    @test string(1.0u"m^2/K^2" ) == "1.0(m^2/K^2)"
    @test string(1.0u"m^(2//3)/K^(1/2)" ) == "1.0(m^(2/3)/K^(1/2))"

    #* Float2
    @test string((1/2)u"nm"      ) == "0.5(nm)"      
    @test string((1/2)u"mm*kg"   ) == "0.5(kg*mm)"   
    @test string((1/2)u"mm/kg"   ) == "0.5(mm/kg)"   
    @test string((1/2)u"m^2"     ) == "0.5(m^2)"     
    @test string((1/2)u"m^2/K^2" ) == "0.5(m^2/K^2)"
    @test string((1/2)u"m^(2//3)/K^(1/2)" ) == "0.5(m^(2/3)/K^(1/2))"
    
    #* Complex
    @test string((1.0+2im)u"nm"      ) == "(1.0 + 2.0im)nm"      
    @test string((1.0+2im)u"mm*kg"   ) == "(1.0 + 2.0im)kg*mm"   
    @test string((1.0+2im)u"mm/kg"   ) == "(1.0 + 2.0im)mm/kg"   
    @test string((1.0+2im)u"m^2"     ) == "(1.0 + 2.0im)m^2"     
    @test string((1.0+2im)u"m^2/K^2" ) == "(1.0 + 2.0im)m^2/K^2"
    @test string((1.0+2im)u"m^(2//3)/K^(1/2)" ) == "(1.0 + 2.0im)m^(2/3)/K^(1/2)"

end

@testset "StepRange, StepRangeLen" begin
    
end

#=
using CSV, DataFrames
@testset "Reversibility of string() and uparse()" begin
    @test uparse(string(m)) == m
    @test uparse(string((m,s))) == (m,s)
    @test uparse(string(1.0)) == 1.0
    @test uparse(string(m/s)) == m/s
    @test uparse(string(N*m)) == N*m
    @test uparse(string(1.0m/s)) == 1.0m/s
    @test uparse(string(m^-1)) == m^-1
    # @test uparse(string(dB/Hz)) == dB/Hz
    # @test uparse(string(3.0dB/Hz)) == 3.0dB/Hz
       
    # df = DataFrame(A = [1mm, 2.0u"N", 3u"mN*m/s"])
    # df |> CSV.write("test.csv")
    # df = CSV.read("test.csv", DataFrame)
    # @test uparse.(df.A) == [1mm, 2.0u"N", 3u"mN*m/s"]
end

typeof(nm)
typeof(μm)
typeof(mm)
typeof(cm)
typeof(m)
typeof(km)
typeof(inch)
typeof(ft)
typeof(mi)
typeof(ac)
typeof(mg)
typeof(g)
typeof(kg)
typeof(Ra)
typeof(°F)
typeof(°C)
typeof(K)
typeof(rad)
typeof(°)
typeof(ms)
typeof(s)
typeof(minute)
typeof(hr)
typeof(d)
typeof(yr)
typeof(Hz)
typeof(J)
typeof(A)
typeof(N)
typeof(mol)
typeof(V)
typeof(mW)
typeof(W)
typeof(dB)
typeof(dB_rp)
typeof(dB_p)
typeof(dBm)
typeof(dBV)
typeof(dBSPL)
typeof(Decibel)
typeof(Np)
typeof(Np_rp)
typeof(Np_p)
typeof(Neper)
typeof(C)

typeof(1nm)
typeof(1μm)
typeof(1mm)
typeof(1cm)
typeof(1m)
typeof(1km)
typeof(1inch)
typeof(1ft)
typeof(1mi)
typeof(1ac)
typeof(1mg)
typeof(1g)
typeof(1kg)
typeof(1Ra)
typeof(1°F)
typeof(1°C)
typeof(1K)
typeof(1rad)
typeof(1°)
typeof(1ms)
typeof(1s)
typeof(1minute)
typeof(1hr)
typeof(1d)
typeof(1yr)
typeof(1Hz)
typeof(1J)
typeof(1A)
typeof(1N)
typeof(1mol)
typeof(1V)
typeof(1mW)
typeof(1W)
typeof(1dB)
typeof(1dB_rp)
typeof(1dB_p)
typeof(1dBm)
typeof(1dBV)
typeof(1dBSPL)
typeof(Decibel)
typeof(1Np)
typeof(1Np_rp)
typeof(1Np_p)
typeof(Neper)
typeof(1C)
=#