
using Documenter

makedocs(
    # modules = [Romgs],
    sitename="Rings.jl",
    authors="Jeffrey Sarnoff",
    source="src",
    clean=false,
    strict=!("strict=false" in ARGS),
    doctest=("doctest=only" in ARGS) ? :only : true,
    format=Documenter.HTML(
        # Use clean URLs, unless built as a "local" build
        prettyurls=!("local" in ARGS),
        highlights=["yaml"],
        ansicolor=true,
    ),
    pages=[
        "Home" => "index.md",
        "Methods" => "methods.md",
    ]
)

#=
Deploy docs to Github pages.
=#
Documenter.deploydocs(
    branch="gh-pages",
    target="build",
    deps=nothing,
    make=nothing,
    repo="https://github.com/DiademSpecialProjects/Rings.jl.git",
)
