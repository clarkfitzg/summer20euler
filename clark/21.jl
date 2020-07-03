using Primes: factor

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
    f = factor(n)
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
Check if a number is amicable, using precomputed sum of proper divisors
"""
is_amicable = function(n, spd)
    m = spd[n]
    # I've used this ternary operator a few times, it's clever, but too busy here for my tastes
    #m ≤ N ? spd[m] == n && m != n : false
    if m ≤ length(spd)
        spd[m] == n && m != n
    else
        false
    end
end


"""
All the amicable numbers less than N
"""
amicable = function(N = 10000)
    possible = 2:(N-1)
    spd = sum_divisors.(possible)
    # Putting 0 in front will line things up.
    pushfirst!(spd, 0)
    (n for n in possible if is_amicable(n, spd))
end

#a = collect(amicable())
sum(amicable())
