using AppleHealthParser
using Documenter

DocMeta.setdocmeta!(AppleHealthParser, :DocTestSetup, :(using AppleHealthParser); recursive=true)

makedocs(;
    modules=[AppleHealthParser],
    authors="Sumanth Athreya Seshasayee <sumant28@hotmail.com> and contributors",
    sitename="AppleHealthParser.jl",
    format=Documenter.HTML(;
        canonical="https://sumant-28.github.io/AppleHealthParser.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Reference" => "reference.md"
    ],
)

deploydocs(;
    repo="github.com/sumant-28/AppleHealthParser.jl",
    devbranch="main",
)
