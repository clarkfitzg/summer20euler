include("euler.jl")


not_sum_two_abundant = function(upper = 28123)
    # filter is eager, so it calls abundant() n times.
    # Iterators.filter is lazy, so it calls abundant n^2 times in this implementation.
    # Since abundant() is expensive, this makes the eager version FAR more efficient.
    ab = filter(abundant, 2:upper)

    sum2abundant = (x+y for x in ab for y in ab)

    # setdiff accepts any iterable object.
    # If I collect sum2abundant into a set first, then it's much slower.
    setdiff(1:upper, sum2abundant)
end


# 0.67 seconds
@time sum(not_sum_two_abundant())
