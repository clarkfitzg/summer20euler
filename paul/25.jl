# For large n, fib(n) ≈ ϕⁿ/√(5).
# With this approximation, we solve log₁₀(fib(n)) = 1000-1.
# If n₀ is the (real number) solution, then no term with index smaller than n₀
# has at least 1000 digits -- so take the ceiling.

function fibterm(digitlength=1000)
    ϕ = (1 + sqrt(5))/2
    n = Int(ceil((digitlength - 1 + 0.5log10(5))/log10(ϕ)))
end
