module timeprop
1
2
function perform_timeprop(F::Function, tmax::Float64, x0::Float64, a0::Float64, h::Float64)::Tuple{Float64, Float64}
    if tmax <= 0.0
        error("tmax must be positive")
    end
    if h <= 0.0
        error("h must be positive")
    end

    x::Float64 = x0
    a::Float64 = a0
    t::Float64 = 0.0
    while t < tmax
        a = a + h * F(x, t)
        x = x + h * a
        t = t + h
    end
    return (x, a)
end

end
