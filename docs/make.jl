using WMesa
using Documenter

DocMeta.setdocmeta!(WMesa, :DocTestSetup, :(using WMesa); recursive=true)

makedocs(;
    modules=[WMesa],
    authors="Paulo Jabardo <pjabardo@ipt.br>",
    repo="https://github.com/pjsjipt/WMesa.jl/blob/{commit}{path}#{line}",
    sitename="WMesa.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
