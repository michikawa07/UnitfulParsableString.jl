ENV["UNITFUL_PARSABLE_STRING_U_STR"] = false
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
@eval Unitful begin
    const ± = $measurement
end
@testset "Measurements" begin
    @mytest_Meta (10±0.1)u"m/s^2" "(10.0 ± 0.1)*(m/s^2)"
end

using UnitfulAtomic
@testset "UnitfulAtomic" begin
    #todo 
end

####################################################################################

ENV["UNITFUL_PARSABLE_STRING_U_STR"] = true

using Measurements
@testset "Measurements" begin
    @mytest_Meta Main (10±0.1)u"m/s^2" "(10.0 ± 0.1)u\"m/s^2\""
end