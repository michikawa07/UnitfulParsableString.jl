using UnitfulParsableString
using Test, Term
using Unitful

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

macro mytest_Meta(unit, str) 
    quote
        u,s = $unit, $str
        @show u,s
        @test string(u)==s
        @test Unitful.eval(Meta.parse(s))==u
    end
end

using CSV, DataFrames
@testset "CSV, DataFrames" begin
    A = [u"1mm", 2.0u"N", 3u"N*m/s", (1//3)u"N*m/s^(1/2)/kg^(1//5)"]
    B = [u"(1//1)mm", (2//1)u"N", (3//1)u"N*m/s", (1//3)u"N*m/s^(1/2)/kg^(1//5)"]
    DataFrame(;A, B) |> CSV.write("sample.csv")
    df = CSV.read("sample.csv", DataFrame)
    
    @test uparse.(df.A) == A
    @test uparse.(df.B) == B
end

using Measurements
Unitful.eval(:(± = $measurement))
@testset "Measurements" begin
    @mytest_Meta (10±0.1)u"m/s^2" "(10.0 ± 0.1)*(m/s^2)"
end

@testset "Units" begin
    #* no unit
    @mytest u"NoUnits" "NoUnits"
    #* a unit
    @mytest u"nm"        "nm"        
    @mytest u"NoUnits/s" "s^-1"      
    @mytest u"K^-2"      "K^-2"      
    @mytest u"m^(1/2)"   "m^(1/2)"   
    @mytest u"K^(1//2)"  "K^(1/2)"   
    @mytest u"m^(2//3)"  "m^(2//3)"  
    @mytest u"kg^(-1/2)" "kg^(-1/2)" 
    #* two unit
    @mytest u"mm*kg"        "kg*mm"        
    @mytest u"mm/kg"        "mm/kg"        
    @mytest u"(m*Hz)^-1"    "Hz^-1*m^-1"   
    @mytest u"(m/Hz)^-1"    "Hz/m"         
    @mytest u"m^2/K^3"      "m^2/K^3"      
    @mytest u"m^(1/2)/K^3"  "m^(1/2)*K^-3" 
    @mytest u"m^2/K^(1//3)" "m^2*K^(-1//3)"
    #* more unit
    @mytest u"mm*kg^3*s^(1/2)" "kg^3*mm*s^(1/2)" 
    @mytest u"mm/kg/s^2"       "mm/kg/s^2"       
    @mytest u"m/K^(1/2)/kg"    "m*kg^-1*K^(-1/2)"
    @mytest u"m/K^(1/2)/kg^-2" "kg^2*m*K^(-1/2)" 
end

@testset "Quantity Float" begin
    #* no unit
    @mytest u"1.0"         "1.0"
    @mytest u"2.0NoUnits"  "2.0"
    @mytest u"3.0/NoUnits" "3.0"
    #* a unit
    @mytest u"1.0nm"        "1.0nm"        
    @mytest u"1.0NoUnits/s" "1.0s^-1"      
    @mytest u"1.0K^-2"      "1.0K^-2"      
    @mytest u"1.0m^(1/2)"   "1.0m^(1/2)"   
    @mytest u"1.0K^(1//2)"  "1.0K^(1/2)"   
    @mytest u"1.0m^(2//3)"  "1.0m^(2//3)"  
    @mytest u"1.0kg^(-1/2)" "1.0kg^(-1/2)" 
    @mytest 1/2u"nm"        "0.5nm^-1"        
    @mytest 1/2u"NoUnits/s" "0.5s"         
    @mytest 1/2u"K^-2"      "0.5K^2"       
    @mytest 1/2u"m^(1/2)"   "0.5m^(-1/2)"  
    @mytest 1/2u"K^(1//2)"  "0.5K^(-1/2)"  
    @mytest 1/2u"m^(2//3)"  "0.5m^(-2//3)" 
    @mytest 1/2u"kg^(-1/2)" "0.5kg^(1/2)"  
    #* two unit
    @mytest u"1.0mm*kg"        "1.0(kg*mm)"        
    @mytest u"1.0mm/kg"        "1.0(mm/kg)"        
    @mytest u"1.0(m*Hz)^-1"    "1.0(Hz^-1*m^-1)"   
    @mytest u"1.0(m/Hz)^-1"    "1.0(Hz/m)"         
    @mytest u"1.0m^2/K^3"      "1.0(m^2/K^3)"      
    @mytest u"1.0m^(1/2)/K^3"  "1.0(m^(1/2)*K^-3)" 
    @mytest u"1.0m^2/K^(1//3)" "1.0(m^2*K^(-1//3))"
    @mytest 1/2u"mm*kg"        "0.5(kg^-1*mm^-1)"  
    @mytest 1/2u"mm/kg"        "0.5(kg/mm)"        
    @mytest 1/2u"(m*Hz)^-1"    "0.5(Hz*m)"         
    @mytest 1/2u"(m/Hz)^-1"    "0.5(m/Hz)"         
    @mytest 1/2u"m^2/K^3"      "0.5(K^3/m^2)"      
    @mytest 1/2u"m^(1/2)/K^3"  "0.5(K^3*m^(-1/2))" 
    @mytest 1/2u"m^2/K^(1//3)" "0.5(K^(1//3)*m^-2)"
    #* more unit
    @mytest u"1.0mm*kg^3*s^(1/2)" "1.0(kg^3*mm*s^(1/2))"      
    @mytest u"1.0mm/kg/s^2"       "1.0(mm/kg/s^2)"            
    @mytest u"1.0m/K^(1/2)/kg"    "1.0(m*kg^-1*K^(-1/2))"     
    @mytest u"1.0m/K^(1/2)/kg^-2" "1.0(kg^2*m*K^(-1/2))"      
    @mytest 1/2u"mm*kg^3*s^(1/2)" "0.5(kg^-3*mm^-1*s^(-1/2))" 
    @mytest 1/2u"mm/kg/s^2"       "0.5(kg*s^2/mm)"            
    @mytest 1/2u"m/K^(1/2)/kg"    "0.5(kg*K^(1/2)*m^-1)"      
    @mytest 1/2u"m/K^(1/2)/kg^-2" "0.5(K^(1/2)*kg^-2*m^-1)"   
end

@testset "Quantity Complex" begin   
    #* no unit
    @mytest (1.0+0im)u"NoUnits"    "1.0 + 0.0im"
    @mytest (1.0+0im)u"NoUnits^-1" "1.0 + 0.0im"
    #* a unit
    @mytest (1.0+0im)u"nm"        "(1.0 + 0.0im)nm"        
    @mytest (1.0+0im)u"NoUnits/s" "(1.0 + 0.0im)s^-1"      
    @mytest (1.0+0im)u"K^-2"      "(1.0 + 0.0im)K^-2"      
    @mytest (1.0+0im)u"m^(1/2)"   "(1.0 + 0.0im)m^(1/2)"   
    @mytest (1.0+0im)u"K^(1//2)"  "(1.0 + 0.0im)K^(1/2)"   
    @mytest (1.0+0im)u"m^(2//3)"  "(1.0 + 0.0im)m^(2//3)"  
    @mytest (1.0+0im)u"kg^(-1/2)" "(1.0 + 0.0im)kg^(-1/2)" 
    #* two unit
    @mytest (1.0+0im)u"mm*kg"        "(1.0 + 0.0im)*(kg*mm)"        
    @mytest (1.0+0im)u"mm/kg"        "(1.0 + 0.0im)*(mm/kg)"        
    @mytest (1.0+0im)u"(m*Hz)^-1"    "(1.0 + 0.0im)*(Hz^-1*m^-1)"   
    @mytest (1.0+0im)u"(m/Hz)^-1"    "(1.0 + 0.0im)*(Hz/m)"         
    @mytest (1.0+0im)u"m^2/K^3"      "(1.0 + 0.0im)*(m^2/K^3)"      
    @mytest (1.0+0im)u"m^(1/2)/K^3"  "(1.0 + 0.0im)*(m^(1/2)*K^-3)" 
    @mytest (1.0+0im)u"m^2/K^(1//3)" "(1.0 + 0.0im)*(m^2*K^(-1//3))"
    #* more unit
    @mytest (1.0+0im)u"mm*kg^3*s^(1/2)" "(1.0 + 0.0im)*(kg^3*mm*s^(1/2))"      
    @mytest (1.0+0im)u"mm/kg/s^2"       "(1.0 + 0.0im)*(mm/kg/s^2)"            
    @mytest (1.0+0im)u"m/K^(1/2)/kg"    "(1.0 + 0.0im)*(m*kg^-1*K^(-1/2))"     
    @mytest (1.0+0im)u"m/K^(1/2)/kg^-2" "(1.0 + 0.0im)*(kg^2*m*K^(-1/2))"     
    #* Complex
    @mytest 1.0u"mm" + 0.2im*u"km" "(0.001 + 200.0im)m" 
    @mytest 1u"mm" + 2im*u"km"     "(1//1000 + 2000//1*im)m"
end

@testset "Quantity Rational" begin
    #* no unit
    @mytest (2//3)u"NoUnits"    "2//3"
    @mytest (2//3)u"NoUnits^-1" "2//3"
    #* a unit
    @mytest (2//3)u"nm"        "(2//3)nm"        
    @mytest (2//3)u"NoUnits/s" "(2//3)s^-1"      
    @mytest (2//3)u"K^-2"      "(2//3)K^-2"      
    @mytest (2//3)u"m^(1/2)"   "(2//3)m^(1/2)"   
    @mytest (2//3)u"K^(1//2)"  "(2//3)K^(1/2)"   
    @mytest (2//3)u"m^(2//3)"  "(2//3)m^(2//3)"  
    @mytest (2//3)u"kg^(-1/2)" "(2//3)kg^(-1/2)" 
    #* two unit
    @mytest (2//3)u"mm*kg"        "(2//3)*(kg*mm)"        
    @mytest (2//3)u"mm/kg"        "(2//3)*(mm/kg)"        
    @mytest (2//3)u"(m*Hz)^-1"    "(2//3)*(Hz^-1*m^-1)"   
    @mytest (2//3)u"(m/Hz)^-1"    "(2//3)*(Hz/m)"         
    @mytest (2//3)u"m^2/K^3"      "(2//3)*(m^2/K^3)"      
    @mytest (2//3)u"m^(1/2)/K^3"  "(2//3)*(m^(1/2)*K^-3)" 
    @mytest (2//3)u"m^2/K^(1//3)" "(2//3)*(m^2*K^(-1//3))"
    #* more unit
    @mytest (2//3)u"mm*kg^3*s^(1/2)" "(2//3)*(kg^3*mm*s^(1/2))"      
    @mytest (2//3)u"mm/kg/s^2"       "(2//3)*(mm/kg/s^2)"            
    @mytest (2//3)u"m/K^(1/2)/kg"    "(2//3)*(m*kg^-1*K^(-1/2))"     
    @mytest (2//3)u"m/K^(1/2)/kg^-2" "(2//3)*(kg^2*m*K^(-1/2))"      
    #* Rational
    @mytest 2u"m"//3u"s" "(2//3)*(m/s)"    
end

@testset "Quantity StepRange" begin
    #* no unit
    @mytest_Meta (1:5)u"NoUnits"    "1:1:5" #not Unit
    @mytest_Meta (1:5)u"NoUnits^-1" "1:1:5" #not Unit
    #* a unit
    @mytest_Meta (1:5)u"nm"        "(1:5)nm"        
    @mytest_Meta (1:5)u"NoUnits/s" "(1:5)s^-1"      
    @mytest_Meta (1:5)u"K^-2"      "(1:5)K^-2"      
    @mytest_Meta (1:5)u"m^(1/2)"   "(1:5)m^(1/2)"   
    @mytest_Meta (1:5)u"K^(1//2)"  "(1:5)K^(1/2)"   
    @mytest_Meta (1:5)u"m^(2//3)"  "(1:5)m^(2//3)"  
    @mytest_Meta (1:5)u"kg^(-1/2)" "(1:5)kg^(-1/2)" 
    #* two unit
    @mytest_Meta (1:5)u"mm*kg"        "(1:5)*(kg*mm)"        
    @mytest_Meta (1:5)u"mm/kg"        "(1:5)*(mm/kg)"        
    @mytest_Meta (1:5)u"(m*Hz)^-1"    "(1:5)*(Hz^-1*m^-1)"   
    @mytest_Meta (1:5)u"(m/Hz)^-1"    "(1:5)*(Hz/m)"         
    @mytest_Meta (1:5)u"m^2/K^3"      "(1:5)*(m^2/K^3)"      
    @mytest_Meta (1:5)u"m^(1/2)/K^3"  "(1:5)*(m^(1/2)*K^-3)" 
    @mytest_Meta (1:5)u"m^2/K^(1//3)" "(1:5)*(m^2*K^(-1//3))"
    #* more unit
    @mytest_Meta (1:5)u"mm*kg^3*s^(1/2)" "(1:5)*(kg^3*mm*s^(1/2))"      
    @mytest_Meta (1:5)u"mm/kg/s^2"       "(1:5)*(mm/kg/s^2)"            
    @mytest_Meta (1:5)u"m/K^(1/2)/kg"    "(1:5)*(m*kg^-1*K^(-1/2))"     
    @mytest_Meta (1:5)u"m/K^(1/2)/kg^-2" "(1:5)*(kg^2*m*K^(-1/2))"    
    #* StepRange
    @mytest_Meta 1.0u"cm":1u"mm":1u"km" "(0.01:0.001:1000.0)m"
    @mytest_Meta 1u"cm":1u"mm":1u"km"   "(1//100:1//1000:1000//1)m"
end

@testset "Quantity StepRangeLen" begin
     @mytest_Meta StepRangeLen(0u"m", 2u"m", 11) "(0:2:20)m"    
end

@testset "Gain" begin
    @mytest u"1.0dB" "1.0dB"    
end

@testset "Level" begin
    @mytest 0.0u"dBV" "0.0dBV"  
    #@mytest 1.0u"dBV" "1.0dBV"  #Unitful internal float handling is wrong.
    @mytest (1/2)u"dBV" "0.5dBV"  
end

#=
typeof(u"nm")
typeof(u"μm")
typeof(u"mm")
typeof(u"cm")
typeof(u"m")
typeof(u"km")
typeof(u"inch")
typeof(u"ft")
typeof(u"mi")
typeof(u"ac")
typeof(u"mg")
typeof(u"g")
typeof(u"kg")
typeof(u"Ra")
typeof(u"°F")
typeof(u"°C")
typeof(u"K")
typeof(u"rad")
typeof(u"°")
typeof(u"ms")
typeof(u"s")
typeof(u"minute")
typeof(u"hr")
typeof(u"d")
typeof(u"yr")
typeof(u"Hz")
typeof(u"J")
typeof(u"A")
typeof(u"N")
typeof(u"mol")
typeof(u"V")
typeof(u"mW")
typeof(u"W")
typeof(u"dB")
typeof(u"dB_rp")
typeof(u"dB_p")
typeof(u"dBm")
typeof(u"dBV")
typeof(u"dBSPL")
typeof(u"Decibel")
typeof(u"Np")
typeof(u"Np_rp")
typeof(u"Np_p")
typeof(u"Neper")
typeof(u"C")

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