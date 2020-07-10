import Primes


"""
Find all divisors of n

```julia-repl
julia> sort(collect(divisors(12)))
6-element Array{Int64,1}:
  1
  2
  3
  4
  6
 12
```
"""
divisors = function(n)
    f = Primes.factor(n)
    primefactors = keys(f)
    multiplicity = values(f)
    eachpower = (0:k for k in multiplicity)
    powers = Iterators.product(eachpower...)
    div = (prod(primefactors .^ p) for p in powers)
    Iterators.flatten(div)
end


"""
Sum of the proper divisors of n

```julia-repl
julia> sum_divisors(220)
284
```
"""
sum_divisors = function(n)
    sum(divisors(n)) - n
end


"""
Determine if n is an abundant number, meaning the sum of divisors is greater than n.

```julia-repl
julia> abundant(11)
false

julia> abundant(12)
true
```
"""
abundant = function(n)
    n < sum_divisors(n)
end
