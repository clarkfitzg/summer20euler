using Primes: isprime

"""
Find the length of a sequence of primes n^2 + an + b for integer n starting at n = 0.

```julia-repl
julia> quad_prime_seq_length(1, 41)
40
```
"""
function quad_prime_seq_length(a, b)
    p(n) = n^2 + a*n + b
    n = 0
    while isprime(p(n))
        n += 1
    end
    (n, a, b)
end


seqs = (quad_prime_seq_length(a, b) for a in -999:999 for b in -1000:1000)

@time mx = maximum(seqs)
prod(mx[2:3])
