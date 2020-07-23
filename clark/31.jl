
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


@time exhaustive_count()
