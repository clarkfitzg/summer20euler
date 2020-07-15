"""
Check if a number is the sum of digits raised to a power

```julia-repl
julia> sum_of_power_digits(1634, 4)
true

julia> sum_of_power_digits(1635, 4)
false
```
"""
function sum_of_power_digits(n, p = 5)
    digits = parse.(Int, split(string(n), ""))
    pdigits = digits.^p
    sum(pdigits) == n
end


# What's an upper bound to check?
p = 5
largest_digit = 9
lower_bound = 10
# 6 is the first integer k for which k9^5 < 10^k
upper_bound = 6*largest_digit^p

sum(n for n in lower_bound:upper_bound if sum_of_power_digits(n))
