"""
Find the index of the first term in the Fibonacci sequence to contain over d digits

julia> firstfib(3)
12
"""
function firstfib(d=1000)
    mx = big"10"^(d-1)
    f1 = 1
    f2 = 1
    idx = 2
    while f2 < mx
        idx += 1
        f1, f2 = f2, f1 + f2
    end
    idx
end


firstfib()
