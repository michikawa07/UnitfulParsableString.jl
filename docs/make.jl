using UnitfulParsableString
using Documenter

DocMeta.setdocmeta!(UnitfulParsableString, :DocTestSetup, :(using UnitfulParsableString); recursive=true)

makedocs(;
    modules=[UnitfulParsableString],
    authors="michikawa07 <michikawa.ryohei@gmail.com> and contributors",
    repo="https://github.com/michikawa07/UnitfulParsableString.jl/blob/{commit}{path}#{line}",
    sitename="UnitfulParsableString.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://michikawa07.github.io/UnitfulParsableString.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/michikawa07/UnitfulParsableString.jl",
    devbranch="main",
)
