ENV["UNITFUL_PARSABLE_STRING_U_STR"] = true

@testset "@u_str version" begin

    @testset "Units" begin
        #* no unit
        @mytest_Meta u"NoUnits" "NoUnits"
        #* a unit
        @mytest_Meta u"nm"        "u\"nm\""        
        @mytest_Meta u"NoUnits/s" "u\"s^-1\""      
        @mytest_Meta u"K^-2"      "u\"K^-2\""      
        @mytest_Meta u"m^(1/2)"   "u\"m^(1/2)\""   
        @mytest_Meta u"K^(1//2)"  "u\"K^(1/2)\""   
        @mytest_Meta u"m^(2//3)"  "u\"m^(2//3)\""  
        @mytest_Meta u"kg^(-1/2)" "u\"kg^(-1/2)\"" 
        #* two unit
        @mytest_Meta u"mm*kg"        "u\"kg*mm\""        
        @mytest_Meta u"mm/kg"        "u\"mm/kg\""        
        @mytest_Meta u"(m*Hz)^-1"    "u\"Hz^-1*m^-1\""   
        @mytest_Meta u"(m/Hz)^-1"    "u\"Hz/m\""         
        @mytest_Meta u"m^2/K^3"      "u\"m^2/K^3\""      
        @mytest_Meta u"m^(1/2)/K^3"  "u\"m^(1/2)*K^-3\"" 
        @mytest_Meta u"m^2/K^(1//3)" "u\"m^2*K^(-1//3)\""
        #* more unit
        @mytest_Meta u"mm*kg^3*s^(1/2)" "u\"kg^3*mm*s^(1/2)\"" 
        @mytest_Meta u"mm/kg/s^2"       "u\"mm/kg/s^2\""       
        @mytest_Meta u"m/K^(1/2)/kg"    "u\"m*kg^-1*K^(-1/2)\""
        @mytest_Meta u"m/K^(1/2)/kg^-2" "u\"kg^2*m*K^(-1/2)\"" 
    end

    @testset "Quantity Float" begin
        #* no unit
        @mytest_Meta u"1.0"         "1.0"
        @mytest_Meta u"2.0NoUnits"  "2.0"
        @mytest_Meta u"3.0/NoUnits" "3.0"
        #* a unit
        @mytest_Meta u"1.0nm"        "1.0u\"nm\""        
        @mytest_Meta u"1.0NoUnits/s" "1.0u\"s^-1\""      
        @mytest_Meta u"1.0K^-2"      "1.0u\"K^-2\""      
        @mytest_Meta u"1.0m^(1/2)"   "1.0u\"m^(1/2)\""   
        @mytest_Meta u"1.0K^(1//2)"  "1.0u\"K^(1/2)\""   
        @mytest_Meta u"1.0m^(2//3)"  "1.0u\"m^(2//3)\""  
        @mytest_Meta u"1.0kg^(-1/2)" "1.0u\"kg^(-1/2)\"" 
        @mytest_Meta 1/2u"nm"        "0.5u\"nm^-1\""     
        @mytest_Meta 1/2u"NoUnits/s" "0.5u\"s\""         
        @mytest_Meta 1/2u"K^-2"      "0.5u\"K^2\""       
        @mytest_Meta 1/2u"m^(1/2)"   "0.5u\"m^(-1/2)\""  
        @mytest_Meta 1/2u"K^(1//2)"  "0.5u\"K^(-1/2)\""  
        @mytest_Meta 1/2u"m^(2//3)"  "0.5u\"m^(-2//3)\"" 
        @mytest_Meta 1/2u"kg^(-1/2)" "0.5u\"kg^(1/2)\""  
        #* two unit
        @mytest_Meta u"1.0m*kg"         "1.0u\"kg*m\""        
        @mytest_Meta u"1.0m/kg"         "1.0u\"m/kg\""        
        @mytest_Meta u"1.0(m*Hz)^-1"    "1.0u\"Hz^-1*m^-1\""   
        @mytest_Meta u"1.0(m/Hz)^-1"    "1.0u\"Hz/m\""         
        @mytest_Meta u"1.0m^2/K^3"      "1.0u\"m^2/K^3\""      
        @mytest_Meta u"1.0m^(1/2)/K^3"  "1.0u\"m^(1/2)*K^-3\"" 
        @mytest_Meta u"1.0m^2/K^(1//3)" "1.0u\"m^2*K^(-1//3)\""
        @mytest_Meta 1/2u"m*kg"         "0.5u\"kg^-1*m^-1\""  
        @mytest_Meta 1/2u"m/kg"         "0.5u\"kg/m\""        
        @mytest_Meta 1/2u"(m*Hz)^-1"    "0.5u\"Hz*m\""         
        @mytest_Meta 1/2u"(m/Hz)^-1"    "0.5u\"m/Hz\""         
        @mytest_Meta 1/2u"m^2/K^3"      "0.5u\"K^3/m^2\""      
        @mytest_Meta 1/2u"m^(1/2)/K^3"  "0.5u\"K^3*m^(-1/2)\"" 
        @mytest_Meta 1/2u"m^2/K^(1//3)" "0.5u\"K^(1//3)*m^-2\""
        #* more unit
        @mytest_Meta u"1.0m*kg^3*s^(1/2)"  "1.0u\"kg^3*m*s^(1/2)\""      
        @mytest_Meta u"1.0m/kg/s^2"        "1.0u\"m/kg/s^2\""            
        @mytest_Meta u"1.0m/K^(1/2)/kg"    "1.0u\"m*kg^-1*K^(-1/2)\""     
        @mytest_Meta u"1.0m/K^(1/2)/kg^-2" "1.0u\"kg^2*m*K^(-1/2)\""      
        @mytest_Meta 1/2u"m*kg^3*s^(1/2)"  "0.5u\"kg^-3*m^-1*s^(-1/2)\"" 
        @mytest_Meta 1/2u"m/kg/s^2"        "0.5u\"kg*s^2/m\""            
        @mytest_Meta 1/2u"m/K^(1/2)/kg"    "0.5u\"kg*K^(1/2)*m^-1\""      
        @mytest_Meta 1/2u"m/K^(1/2)/kg^-2" "0.5u\"K^(1/2)*kg^-2*m^-1\""   
    end

    @testset "Quantity Complex" begin   
        #* no unit
        @mytest_Meta (1.0+0im)u"NoUnits"    "1.0 + 0.0im"
        @mytest_Meta (1.0+0im)u"NoUnits^-1" "1.0 + 0.0im"
        #* a unit
        @mytest_Meta (1.0+0im)u"nm"        "(1.0 + 0.0im)u\"nm\""        
        @mytest_Meta (1.0+0im)u"NoUnits/s" "(1.0 + 0.0im)u\"s^-1\""      
        @mytest_Meta (1.0+0im)u"K^-2"      "(1.0 + 0.0im)u\"K^-2\""      
        @mytest_Meta (1.0+0im)u"m^(1/2)"   "(1.0 + 0.0im)u\"m^(1/2)\""   
        @mytest_Meta (1.0+0im)u"K^(1//2)"  "(1.0 + 0.0im)u\"K^(1/2)\""   
        @mytest_Meta (1.0+0im)u"m^(2//3)"  "(1.0 + 0.0im)u\"m^(2//3)\""  
        @mytest_Meta (1.0+0im)u"kg^(-1/2)" "(1.0 + 0.0im)u\"kg^(-1/2)\"" 
        #* two unit
        @mytest_Meta (1.0+0im)u"mm*kg"        "(1.0 + 0.0im)u\"kg*mm\""        
        @mytest_Meta (1.0+0im)u"mm/kg"        "(1.0 + 0.0im)u\"mm/kg\""        
        @mytest_Meta (1.0+0im)u"(m*Hz)^-1"    "(1.0 + 0.0im)u\"Hz^-1*m^-1\""   
        @mytest_Meta (1.0+0im)u"(m/Hz)^-1"    "(1.0 + 0.0im)u\"Hz/m\""         
        @mytest_Meta (1.0+0im)u"m^2/K^3"      "(1.0 + 0.0im)u\"m^2/K^3\""      
        @mytest_Meta (1.0+0im)u"m^(1/2)/K^3"  "(1.0 + 0.0im)u\"m^(1/2)*K^-3\"" 
        @mytest_Meta (1.0+0im)u"m^2/K^(1//3)" "(1.0 + 0.0im)u\"m^2*K^(-1//3)\""
        #* more unit
        @mytest_Meta (1.0+0im)u"mm*kg^3*s^(1/2)" "(1.0 + 0.0im)u\"kg^3*mm*s^(1/2)\""      
        @mytest_Meta (1.0+0im)u"mm/kg/s^2"       "(1.0 + 0.0im)u\"mm/kg/s^2\""            
        @mytest_Meta (1.0+0im)u"m/K^(1/2)/kg"    "(1.0 + 0.0im)u\"m*kg^-1*K^(-1/2)\""     
        @mytest_Meta (1.0+0im)u"m/K^(1/2)/kg^-2" "(1.0 + 0.0im)u\"kg^2*m*K^(-1/2)\""     
        #* Complex
        @mytest_Meta 1.0u"mm" + 0.2im*u"km" "(0.001 + 200.0im)u\"m\"" 
        @mytest_Meta 1u"mm" + 2im*u"km"     "(1//1000 + 2000//1*im)u\"m\""
    end

    @testset "Quantity Rational" begin
        #* no unit
        @mytest_Meta (2//3)u"NoUnits"    "2//3"
        @mytest_Meta (2//3)u"NoUnits^-1" "2//3"
        #* a unit
        @mytest_Meta (2//3)u"nm"        "(2//3)u\"nm\""        
        @mytest_Meta (2//3)u"NoUnits/s" "(2//3)u\"s^-1\""      
        @mytest_Meta (2//3)u"K^-2"      "(2//3)u\"K^-2\""      
        @mytest_Meta (2//3)u"m^(1/2)"   "(2//3)u\"m^(1/2)\""   
        @mytest_Meta (2//3)u"K^(1//2)"  "(2//3)u\"K^(1/2)\""   
        @mytest_Meta (2//3)u"m^(2//3)"  "(2//3)u\"m^(2//3)\""  
        @mytest_Meta (2//3)u"kg^(-1/2)" "(2//3)u\"kg^(-1/2)\"" 
        #* two unit
        @mytest_Meta (2//3)u"mm*kg"        "(2//3)u\"kg*mm\""        
        @mytest_Meta (2//3)u"mm/kg"        "(2//3)u\"mm/kg\""        
        @mytest_Meta (2//3)u"(m*Hz)^-1"    "(2//3)u\"Hz^-1*m^-1\""   
        @mytest_Meta (2//3)u"(m/Hz)^-1"    "(2//3)u\"Hz/m\""         
        @mytest_Meta (2//3)u"m^2/K^3"      "(2//3)u\"m^2/K^3\""      
        @mytest_Meta (2//3)u"m^(1/2)/K^3"  "(2//3)u\"m^(1/2)*K^-3\"" 
        @mytest_Meta (2//3)u"m^2/K^(1//3)" "(2//3)u\"m^2*K^(-1//3)\""
        #* more unit
        @mytest_Meta (2//3)u"mm*kg^3*s^(1/2)" "(2//3)u\"kg^3*mm*s^(1/2)\""      
        @mytest_Meta (2//3)u"mm/kg/s^2"       "(2//3)u\"mm/kg/s^2\""            
        @mytest_Meta (2//3)u"m/K^(1/2)/kg"    "(2//3)u\"m*kg^-1*K^(-1/2)\""     
        @mytest_Meta (2//3)u"m/K^(1/2)/kg^-2" "(2//3)u\"kg^2*m*K^(-1/2)\""      
        #* Rational
        @mytest_Meta 2u"m"//3u"s" "(2//3)u\"m/s\""    
    end

    @testset "StepRange{Quantity}" begin
        #* no unit
        @mytest_Meta (1:5)u"NoUnits"    "1:1:5" #not Unit
        @mytest_Meta (1:5)u"NoUnits^-1" "1:1:5" #not Unit
        #* a unit
        @mytest_Meta (1:5)u"nm"        "(1:5)u\"nm\""        
        @mytest_Meta (1:5)u"NoUnits/s" "(1:5)u\"s^-1\""      
        @mytest_Meta (1:5)u"K^-2"      "(1:5)u\"K^-2\""      
        @mytest_Meta (1:5)u"m^(1/2)"   "(1:5)u\"m^(1/2)\""   
        @mytest_Meta (1:5)u"K^(1//2)"  "(1:5)u\"K^(1/2)\""   
        @mytest_Meta (1:5)u"m^(2//3)"  "(1:5)u\"m^(2//3)\""  
        @mytest_Meta (1:5)u"kg^(-1/2)" "(1:5)u\"kg^(-1/2)\"" 
        #* two unit
        @mytest_Meta (1:5)u"mm*kg"        "(1:5)u\"kg*mm\""        
        @mytest_Meta (1:5)u"mm/kg"        "(1:5)u\"mm/kg\""        
        @mytest_Meta (1:5)u"(m*Hz)^-1"    "(1:5)u\"Hz^-1*m^-1\""   
        @mytest_Meta (1:5)u"(m/Hz)^-1"    "(1:5)u\"Hz/m\""         
        @mytest_Meta (1:5)u"m^2/K^3"      "(1:5)u\"m^2/K^3\""      
        @mytest_Meta (1:5)u"m^(1/2)/K^3"  "(1:5)u\"m^(1/2)*K^-3\"" 
        @mytest_Meta (1:5)u"m^2/K^(1//3)" "(1:5)u\"m^2*K^(-1//3)\""
        #* more unit
        @mytest_Meta (1:5)u"mm*kg^3*s^(1/2)" "(1:5)u\"kg^3*mm*s^(1/2)\""      
        @mytest_Meta (1:5)u"mm/kg/s^2"       "(1:5)u\"mm/kg/s^2\""            
        @mytest_Meta (1:5)u"m/K^(1/2)/kg"    "(1:5)u\"m*kg^-1*K^(-1/2)\""     
        @mytest_Meta (1:5)u"m/K^(1/2)/kg^-2" "(1:5)u\"kg^2*m*K^(-1/2)\""    
        #* StepRange
        @mytest_Meta 1.0u"cm":1u"mm":1u"km" "(0.01:0.001:1000.0)u\"m\""
        @mytest_Meta 1u"cm":1u"mm":1u"km"   "(1//100:1//1000:1000//1)u\"m\""
    end

    @testset "StepRangeLen{Quantity}" begin
        @mytest_Meta StepRangeLen(0u"m", 2u"m", 11) "(0:2:20)u\"m\""    
    end

    # @testset "Gain" begin
    #   @mytest_Meta u"1.0dB" "1.0u\"dB\""    
    # end

    # @testset "Level" begin
    #   @mytest_Meta 0.0u"dBV" "0.0u\"dBV\""  
    #   #@mytest_Meta 1.0u"dBV" "1.0u\"dBV\""  #Unitful internal float handling is wrong.
    #   @mytest_Meta (1/2)u"dBV" "0.5u\"dBV\""  
    # end

end