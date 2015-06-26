using Docile, Lexicon, JuliaFEM

const api_directory = "api"
const modules = [JuliaFEM, JuliaFEM.elasticity_solver]

# main_folder = dirname(dirname(@__FILE__))
# this_folder = dirname(@__FILE__)

# file_ = "README.md"
# run(`cp $main_folder/$file_ $this_folder`)

cd(dirname(@__FILE__)) do
    # Generate and save the contents of docstrings as markdown files.
    index  = Index()
    for mod in modules
        Lexicon.update!(index, save(joinpath(api_directory, "$(mod).md"), mod))
    end
    save(joinpath(api_directory, "index.md"), index; md_subheader = :category)

    # Add a reminder not to edit the generated files.
    open(joinpath(api_directory, "README.md"), "w") do f
        print(f, """
        Files in this directory are generated using the `build.jl` script. Make
        all changes to the originating docstrings/files rather than these ones.
        """)
    end

    info("Adding all documentation changes in $(api_directory) to this commit.")
    success(`git add $(api_directory)`) || exit(1)

end


cd(dirname(dirname(@__FILE__))) do
    yaml = """
    # This is automatically generated by docs/build.jl. Edit that file if you
    # wish to make any permenant changes.
    site_name: JuliaFEM.jl
    site_description: JuliaFEM.jl, open-source software for reliable, scalable, distributed Finite Element Method.
    repo_name: GitHub
    docs_dir: 'docs'
    site_dir: 'site'
    repo_url: https://github.com/JuliaFEM/JuliaFEM.jl
    pages:
    - Home: 'README.md'
    - Overview: 'api/index.md'
    - API Docs:
      - JuliaFEM: 'api/JuliaFEM.md'
      - JuliaFEM.elasticity_solver: 'api/JuliaFEM.elasticity_solver.md'
    """

    # TODO: add the solutions if I figure out how to get them to render properly

    open("mkdocs.yml", "w") do f
        write(f, yaml)
    end
end
