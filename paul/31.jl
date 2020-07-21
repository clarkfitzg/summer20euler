"""
    coinsum(n=200)

Compute the total number of ways to make `n` pence using the eight coins
    1p, 2p, 5p, 10p, 20p, 50p, 100p, and 200p.

# Examples
```julia-repl
julia> coinsum(5)
4

julia> coinsum(10)
11
```
"""
function coinsum(n=200)
    denominations = [1,2,5,10,20,50,100,200]

    # pathlengths[shift(total),coin] will be the number of ways to make the
    # sum _total_ using coins no larger than _coin_, assuming at least one coin
    # of this size.
    pathlengths = zeros(Int, n, 8)
    # For any sum, only one way to obtain it using coins of value at most 1p.
    pathlengths[:, 1] .= 1
	# For an even sum, need an even number of 1p coins; for an odd sum>1, need 
	# an odd number of them. No paths ending with 2p coin if total = 1p.
    pathlengths[:, 2] = collect(1:200) .÷ 2

    f(n) = max(0, n÷5 + sum([(n-5k)÷2 for k in 1:n÷5]))
    pathlengths[:, 3] = f.(1:200)
    # There should be more formulas like the above, but perhaps they become
    # more complicated for higher denominations.

    for coinindex in 4:8
        coin = denominations[coinindex]
        for totalvalue in coin:n
            # Example: The number of ways to reach 5p using a nondecreasing
            # sequence of coins of value ≤ 2p where the last coin is 2p is
            # just the number of ways to reach a total of 3p using such coins.
			#
			# The "max" call below is an ad-hoc way to avoid a 0-index
			# error.
            pathlengths[totalvalue, coinindex] =
                sum(pathlengths[max(totalvalue - coin, 1), 1:coinindex])
        end
    end
    sum(pathlengths[n, :])
end
