type FastDiGraph<:AbstractFastGraph
    vertices::UnitRange{Int}
    edges::Set{Edge}
    finclist::Vector{Vector{Edge}} # [src]: ((src,dst), (src,dst), (src,dst))
    binclist::Vector{Vector{Edge}} # [dst]: ((src,dst), (src,dst), (src,dst))
end


function show(io::IO, g::FastDiGraph)
    if length(vertices(g)) == 0
        print(io, "empty directed graph")
    else
        print(io, "{$(nv(g)), $(ne(g))} directed graph")
    end
end

function FastDiGraph(n::Int)
    finclist = Vector{Edge}[]
    binclist = Vector{Edge}[]
    for i = 1:n
        push!(binclist, Edge[])
        push!(finclist, Edge[])
    end
    return FastDiGraph(1:n, Set{Edge}(), binclist, finclist)
end

FastDiGraph() = FastDiGraph(0)

function add_edge!(g::FastDiGraph, e::Edge)
    if !(has_vertex(g,e.src) && has_vertex(g,e.dst))
        throw(BoundsError)
    elseif e in edges(g)
        error("Edge $e is already in graph")
    else
        reve = rev(e)
        push!(g.finclist[e.src], e)
        push!(g.binclist[e.dst], e)
        push!(g.edges, e)
    end
    return e
end

has_edge(g::FastDiGraph, e::Edge) = e in edges(g)

degree(g::FastDiGraph, v::Int) = indegree(g,v) + outdegree(g,v)
all_neighbors(g::FastDiGraph, v::Int) = neighbors(g, v)
density(g::FastDiGraph) = ne(g) / (nv(g) * (nv(g)-1))
