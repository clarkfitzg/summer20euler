using LinearAlgebra: ⋅

coins = [1, 2, 5, 10, 20, 50, 100, 200]
amount = 200

# The maximum number of coins of each kind we can have:
maxcoins = amount .÷ coins

# There are around 6 billion ways to choose 0 to maxcoins from each of these coins.
# It probably wouldn't take that long to check them all.
prod(maxcoins .+ 1) / 1e9


function exhaustive_count(coinvalue = coins, amount = amount)
    maxcoins = amount .÷ coinvalue
    coins_per = [0:mx for mx in maxcoins]
    count = 0
    for count_each_coin in Iterators.product(coins_per...)
        total = sum(count_each_coin .* coinvalue)
        if total == amount
            count += 1
        end
    end
    count
end


# I Let it run for close to an hour, and then I got tired of listening to my fan. 😖
# @time exhaustive_count()


"""
Two observations:
1. If the value is less than 200, then we can add 1's until we get to 200.
2. We don't need to consider the cases where each coin is the same type- we can add those in later.

This reduces the problem down from 6 billion cases to 6 million cases- no problem at all.
"""
function exhaustive_count2(coinvalue = [2, 5, 10, 20, 50, 100, 200], amount = 200)
    maxcoins = amount .÷ coinvalue
    coins_per = [0:(mx-1) for mx in maxcoins]
    count = 0
    for count_each_coin in Iterators.product(coins_per...)
        #total = sum(count_each_coin .* coinvalue)
        # Wow, using the builtin dot product gives me a 3-4x speedup.
        total = count_each_coin ⋅ coinvalue
        if total <= amount
            count += 1
        end
    end
    # Add the cases where all coins are the same type
    count + length(coinvalue)
end

@time exhaustive_count2()
