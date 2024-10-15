using AppleHealthParser
using XML
using DataFrames
using OrderedCollections
using StatsBase
using CSV
using Revise
using Test

Dict1 = Dict(
    "type" => "QuantityTypeIdentifierHeight",
    "sourceName" => "Health",
    "sourceVersion" => "9.2",
    "unit" => "cm",
    "creationDate" => "2016-01-02 09:45:10 +0100",
    "startDate" => "2016-01-02 09:44:00 +0100",
    "endDate" => "2016-01-02 09:44:00 +0100",
    "value" => "194",
)

Vect1 =
[
    Dict("MetadataEntry" => OrderedDict(
        "key" => "HKMetadataKeySyncVersion",
        "value" => "1612170589"
    ))
    Dict("MetadataEntry" => OrderedDict(
        "key" => "HKMetadaKeySyncIdentifier",
        "value" => "4715484070"
    ))
]

Dict1keys = collect(keys(Dict1))
Dict1keys = push!(Dict1keys,"")
Dict1values = vcat(collect(values(Dict1)),[Vect1])

Dict2 = OrderedDict(zip(Dict1keys,Dict1values))

@testset "AppleHealthParser.jl" begin
    @test length(collect(keys(Dict1))) == 8
    @test length(collect(keys(Dict2))) == 9
    @test length(collect(keys(flatten_dictionaries(Dict2)))) == 12
end
