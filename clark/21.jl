using Primes: factor

include("euler.jl")


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
