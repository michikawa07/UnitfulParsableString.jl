using UnitfulParsableString
using Test, Term
using Unitful

#Meta.parse(str) |> Term.expressiontree

@testset "FreeUnit" begin
    #* no unit
    u=u"NoUnits"       ; @test string(u) == ""      
    #* a unit
    u=u"nm"            ; @test string(u) == "nm"      
    u=u"NoUnits/s"     ; @test string(u) == "s^-1"   
    u=u"K^-2"          ; @test string(u) == "K^-2"   
    u=u"m^(1/2)"       ; @test string(u) == "m^(1/2)"     
    u=u"K^(1//2)"      ; @test string(u) == "K^(1/2)"
    u=u"m^(2//3)"      ; @test string(u) == "m^(2//3)"
    u=u"kg^(-1/2)"     ; @test string(u) == "kg^(-1/2)"     
    #* two unit
    u=u"mm*kg"         ; @test string(u) == "kg*mm"   
    u=u"mm/kg"         ; @test string(u) == "mm/kg"   
    u=u"(m*Hz)^-1"     ; @test string(u) == "Hz^-1*m^-1"   
    u=u"(m/Hz)^-1"     ; @test string(u) == "Hz/m"   
    u=u"m^2/K^3"       ; @test string(u) == "m^2/K^3"
    u=u"m^(1/2)/K^3"   ; @test string(u) == "m^(1/2)*K^-3"
    u=u"m^2/K^(1//3)"  ; @test string(u) == "m^2*K^(-1//3)"
    #* more unit
    u=u"mm/kg/s^2"     ; @test string(u) == "mm/kg/s^2"   
    u=u"m/K^(1/2)/kg"  ; @test string(u) == "m*kg^-1*K^(-1/2)"
    u=u"m/K^(1/2)/kg^2"; @test string(u) == "m*kg^-2*K^(-1/2)"
end

@testset "FreeUnit reversibility" begin
    #* no unit
    #u=u"NoUnits"       ; @test string(u)|>uparse == u #Cannot parse
    #* a unit
    u=u"nm"            ; @test string(u)|>uparse == u
    u=u"NoUnits/s"     ; @test string(u)|>uparse == u
    u=u"K^-2"          ; @test string(u)|>uparse == u
    u=u"m^(1/2)"       ; @test string(u)|>uparse == u
    u=u"K^(1//2)"      ; @test string(u)|>uparse == u
    u=u"m^(2//3)"      ; @test string(u)|>uparse == u
    u=u"kg^(-1/2)"     ; @test string(u)|>uparse == u
    #* two unit
    u=u"mm*kg"         ; @test string(u)|>uparse == u
    u=u"mm/kg"         ; @test string(u)|>uparse == u
    u=u"(m*Hz)^-1"     ; @test string(u)|>uparse == u
    u=u"(m/Hz)^-1"     ; @test string(u)|>uparse == u
    u=u"m^2/K^3"       ; @test string(u)|>uparse == u
    u=u"m^(1/2)/K^3"   ; @test string(u)|>uparse == u
    u=u"m^2/K^(1//3)"  ; @test string(u)|>uparse == u
    #* more unit
    u=u"mm/kg/s^2"     ; @test string(u)|>uparse == u
    u=u"m/K^(1/2)/kg"  ; @test string(u)|>uparse == u
    u=u"m/K^(1/2)/kg^2"; @test string(u)|>uparse == u
end

@testset "Quantity Float" begin
    @test string(u"1.0nm"               ) == "1.0nm"      
    @test string(u"1.0K^-1"             ) == "1.0K^-1"   
    @test string(u"1.0/minute"          ) == "1.0minute^-1"   
    @test string(u"1.0(m*Hz)^-1"        ) == "1.0(Hz^-1*m^-1)"     
    @test string(u"1.0m^2"              ) == "1.0m^2"     
    @test string(u"1.0mm*kg"            ) == "1.0(kg*mm)"   
    @test string(u"1.0mm/kg"            ) == "1.0(mm/kg)"   
    @test string(u"1.0m^2/K^2"          ) == "1.0(m^2/K^2)"
    @test string(u"1.0m^(2//3)/K^(1/2)" ) == "1.0(m^(2//3)*K^(-1/2))"

    @test string(1/2u"nm"               ) == "0.5nm^-1"      
    @test string(1/2u"K^-1"             ) == "0.5K"   
    @test string(1/2u"m^2"              ) == "0.5m^-2"     
    @test string(1/2u"mm*kg"            ) == "0.5(kg^-1*mm^-1)"   
    @test string(1/2u"mm/kg"            ) == "0.5(kg/mm)"   
    @test string(1/2u"m^2/K^2"          ) == "0.5(K^2/m^2)"
    @test string(1/2u"m^(2//3)/K^(1/2)" ) == "0.5(K^(1/2)*m^(-2//3))"
end

@testset "Quantity Float reversibility" begin
    u=u"1.0nm"               ; @test uparse(string(u)) == u
    u=u"1.0K^-1"             ; @test uparse(string(u)) == u
    u=u"1.0/s"               ; @test uparse(string(u)) == u
    u=u"1.0NoUnits/minute"   ; @test uparse(string(u)) == u
    u=u"1.0mm*kg"            ; @test uparse(string(u)) == u
    u=u"1.0mm/kg"            ; @test uparse(string(u)) == u
    u=u"1.0m^2"              ; @test uparse(string(u)) == u
    u=u"1.0m^2/K^2"          ; @test uparse(string(u)) == u
    u=u"1.0m^(2//3)/K^(1/2)" ; @test uparse(string(u)) == u

    u=1/2u"nm"               ; @test uparse(string(u)) == u
    u=1/2u"K^-1"             ; @test uparse(string(u)) == u
    u=1/2u"m^2"              ; @test uparse(string(u)) == u
    u=1/2u"mm*kg"            ; @test uparse(string(u)) == u
    u=1/2u"mm/kg"            ; @test uparse(string(u)) == u
    u=1/2u"m^2/K^2"          ; @test uparse(string(u)) == u
    u=1/2u"m^(2//3)/K^(1/2)" ; @test uparse(string(u)) == u
end

@testset "Quantity Complex" begin   
    #* Complex
    @test string((1.0+2im)u"nm"      ) == "(1.0 + 2.0im)nm"      
    @test string((1.0+2im)u"K^-1"    ) == "(1.0 + 2.0im)K^-1"   
    @test string((1.0+2im)u"m^2"     ) == "(1.0 + 2.0im)m^2"     
    @test string((1.0+2im)u"mm*kg"   ) == "(1.0 + 2.0im)*(kg*mm)"   
    @test string((1.0+2im)u"mm/kg"   ) == "(1.0 + 2.0im)*(mm/kg)"   
    @test string((1.0+2im)u"m^2/K^2" ) == "(1.0 + 2.0im)*(m^2/K^2)"
    @test string((1.0+2im)u"m^(2//3)/K^(1/2)" ) == "(1.0 + 2.0im)*(m^(2//3)*K^(-1/2))"
end

@testset "Quantity Rational" begin
    #* Rational
    @test string((-2//3)u"nm"      ) == "(-2//3)nm"      
    @test string((-2//3)u"K^-1"    ) == "(-2//3)K^-1"   
    @test string((-2//3)u"m^2"     ) == "(-2//3)m^2"     
    @test string((-2//3)u"mm*kg"   ) == "(-2//3)*(kg*mm)"   
    @test string((-2//3)u"mm/kg"   ) == "(-2//3)*(mm/kg)"   
    @test string((-2//3)u"m^2/K^2" ) == "(-2//3)*(m^2/K^2)"
    @test string((-2//3)u"m^(2//3)/K^(1/2)" ) == "(-2//3)*(m^(2//3)*K^(-1/2))"
end

@testset "Quantity StepRange" begin
    @test string((1:10)u"nm"      ) == "(1:10)nm"      
    @test string((1:10)u"K^-1"    ) == "(1:10)K^-1"   
    @test string((1:10)u"m^2"     ) == "(1:10)m^2"     
    @test string((1:10)u"mm*kg"   ) == "(1:10)*(kg*mm)"   
    @test string((1:10)u"mm/kg"   ) == "(1:10)*(mm/kg)"   
    @test string((1:10)u"m^2/K^2" ) == "(1:10)*(m^2/K^2)" 
    @test string((1:10)u"m^2/K^3/s" ) == "(1:10)*(m^2/K^3/s)" 
    @test string((1:10)u"m^(2//3)/K^(1/2)" ) ==  "(1:10)*(m^(2//3)*K^(-1/2))"
end

@testset "Quantity StepRangeLen" begin
    # StepRangeLen(1u"mm", 0.01u"m", 12)
    # @test string((1:10)u"nm"      ) == "(1:10)nm"      
    # @test string((1:10)u"m^2"     ) == "(1:10)m^2"     
    # @test string((1:10)u"mm*kg"   ) == "(1:10)*(kg*mm)"   
    # @test string((1:10)u"mm/kg"   ) == "(1:10)*(mm/kg)"   
    # @test string((1:10)u"m^2/K^2" ) == "(1:10)*(m^2/K^2)" 
    # @test string((1:10)u"m^(2//3)/K^(1/2)" ) ==  "(1:10)*(m^(2//3)/K^(1/2))"
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