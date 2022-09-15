ENV["UNITFUL_PARSABLE_STRING_U_STR"] = false

@testset "Units with same abbreviation and symbol" begin
    
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
        @mytest u"1.0m*kg"        "1.0(kg*m)"        
        @mytest u"1.0m/kg"        "1.0(m/kg)"        
        @mytest u"1.0(m*Hz)^-1"    "1.0(Hz^-1*m^-1)"   
        @mytest u"1.0(m/Hz)^-1"    "1.0(Hz/m)"         
        @mytest u"1.0m^2/K^3"      "1.0(m^2/K^3)"      
        @mytest u"1.0m^(1/2)/K^3"  "1.0(m^(1/2)*K^-3)" 
        @mytest u"1.0m^2/K^(1//3)" "1.0(m^2*K^(-1//3))"
        @mytest 1/2u"m*kg"        "0.5(kg^-1*m^-1)"  
        @mytest 1/2u"m/kg"        "0.5(kg/m)"        
        @mytest 1/2u"(m*Hz)^-1"    "0.5(Hz*m)"         
        @mytest 1/2u"(m/Hz)^-1"    "0.5(m/Hz)"         
        @mytest 1/2u"m^2/K^3"      "0.5(K^3/m^2)"      
        @mytest 1/2u"m^(1/2)/K^3"  "0.5(K^3*m^(-1/2))" 
        @mytest 1/2u"m^2/K^(1//3)" "0.5(K^(1//3)*m^-2)"
        #* more unit
        @mytest u"1.0m*kg^3*s^(1/2)" "1.0(kg^3*m*s^(1/2))"      
        @mytest u"1.0m/kg/s^2"       "1.0(m/kg/s^2)"            
        @mytest u"1.0m/K^(1/2)/kg"    "1.0(m*kg^-1*K^(-1/2))"     
        @mytest u"1.0m/K^(1/2)/kg^-2" "1.0(kg^2*m*K^(-1/2))"      
        @mytest 1/2u"m*kg^3*s^(1/2)" "0.5(kg^-3*m^-1*s^(-1/2))" 
        @mytest 1/2u"m/kg/s^2"       "0.5(kg*s^2/m)"            
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

    @testset "StepRange{Quantity}" begin
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

    @testset "StepRangeLen{Quantity}" begin
        @mytest_Meta StepRangeLen(0u"m", 2u"m", 11) "(0:2:20)m"    
    end

    # @testset "Gain" begin
    #   @mytest u"1.0dB" "1.0dB"    
    # end

    # @testset "Level" begin
    #   @mytest 0.0u"dBV" "0.0dBV"  
    #   #@mytest 1.0u"dBV" "1.0dBV"  #Unitful internal float handling is wrong.
    #   @mytest (1/2)u"dBV" "0.5dBV"  
    # end
end

@testset "Units with different abbreviations and symbols" begin
    @mytest u"percent"   "percent"        
    @mytest u"percent^2" "percent^2"      
end