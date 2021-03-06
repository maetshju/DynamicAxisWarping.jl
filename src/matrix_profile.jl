
function MatrixProfile.matrix_profile(T, m::Int, dist::DTW; showprogress=true, normalizer=Val(Nothing))
    n   = lastlength(T)
    l   = n-m+1
    r   = dist.radius
    # n > 2m+1 || throw(ArgumentError("Window length too long, maximum length is $((n+1)÷2)"))
    P    = Vector{floattype(T)}(undef, l)
    I    = Vector{Int}(undef, l)
    prog = Progress((l - 1) ÷ 5, dt=1, desc="Matrix profile", barglyphs = BarGlyphs("[=> ]"), color=:blue)
    bsf = typemax(floattype(T))
    @inbounds for i = 1:l
        Ti = getwindow(T,m,i)
        res = dtwnn(Ti, T, dist.dist, r, transportcost=dist.transportcost, avoid=i-r:i+r, normalizer=normalizer)
        I[i] = res.loc
        P[i] = res.cost
        showprogress && i % 5 == 0 && next!(prog)
    end
    MatrixProfile.Profile(T, P, I, m, nothing)
end
