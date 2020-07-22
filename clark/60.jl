using Primes
using Combinatorics: combinations

"""
```julia-repl
julia> pair_concat_prime(7, 109)
true

julia> pair_concat_prime(7, 2)
false
```
"""
pair_concat_prime = function(p1, p2)
    p1s = string(p1)
    p2s = string(p2)
    p1p2 = parse(Int, p1s * p2s)
    p2p1 = parse(Int, p2s * p1s)
    isprime(p1p2) & isprime(p2p1)
end


# 
pairs_for_p = function(p, candidates)
    (c for c in candidates if pair_concat_prime(p, c))
end


# Arbitrary upper bound, let's hope it works 😬
build_pairs = function(upper = 10_000)

    # 2 cannot be in this set, since any number ending in 2 is not prime (besides 2).
    candidates = primes(3, upper)

    # Why is this Dict{Any,Any}? 
    # The keys are integers and the values are sets of integers
    d = Dict()
    for (i, p) in Iterators.enumerate(candidates)
        larger_candidates = candidates[(i+1):end]
        d[p] = Set(c for c in larger_candidates if pair_concat_prime(p, c))
    end
    d
end


# All of these numbers are pairs
@time pairs = build_pairs()

# This is an undirected graph, where the nodes are the primes and the edges represent the prime concatenation property.
# The next step is to find all the fully connected subgraphs with 5 nodes.
# I wish there was an easy off the shelf implementation for this.
# Probably won't be too difficult to do the nongeneral case though.

# Is it possible to reuse this data structure?
# I think so.
# Let p0 be the candidate prime, connected to p1, ..., pn
# To see if pk can possibly be in a fully connected 5 group with p0, no, I see a better way.

# There aren't very many numbers to check.
# sum(map(length, values(pairs)))
# 18176

# maximum(length(x) for x in values(pairs))
# 142
# binomial(142, 5)
# 448072338
# Checking 448 million, hmmm.


# All those that have fewer than 4 elements cannot be in this set.
# We could keep filtering them down, but we'll still need some brute force in the end.
# May as well write the brute force now

# Suppose we represent the graph with a (sparse) matrix.
# To find the fully connected subcomponents, we just need to get the graph into a form with diagonal blocks:
# AD, where A is a permutation matrix.


# Tue Jul 21 16:46:11 PDT 2020
#
# Starting again.
# We're not looking for just any 5 clique, we're looking for the 5 clique with the lowest sum.
# We can use this property to improve how we search.
# Start with the smallest numbers in the list, and gradually add larger numbers.
# The idea is to iterate through the 


"""
Are nodes a and b connected, as represented by d?
"""
connected = function(a, b, d)
    if b < a
        a, b = b, a
    end
    b in d[a]
end


"""
Are nodes in a clique?

```julia-repl
julia> D = Dict(1 => Set([2, 3]),
         2 => Set([3]),
         3 => Set([4]))

julia> is_clique([1, 2, 3], D)
true

julia> is_clique([1, 2, 4], D)
false
```
"""
is_clique = function(nodes, d)
    pairs = combinations(nodes, 2)
    all(connected(p..., d) for p in pairs)
end


"""
Find a k clique by looking exhaustively through all possible subsets
"""
clique = function(d, nodes, k, value = false)
    for combo in combinations(nodes, k)
        if is_clique(combo, d)
            return value ? combo : true
        end
    end
    false
end


"""
Find a k clique.
It might not be the smallest one.
Mutate d by removing keys for all nodes that cannot be in a k clique.
We'll still need to remove those keys from the value set too, but that can be another step.

Implementation Details:

We could initially filter out nodes to only keep those that are connected to at least k other nodes in this set.
That could substantially reduce the size of the problem.
"""
find_k_clique = function(d, k = 5)
    # We can still start with the smallest
    allnodes = sort(collect(keys(d)))
    for n in allnodes
        @info n
        nodes = d[n]
        if clique(d, nodes, k-1)
            found = clique(d, nodes, k-1, value = true)
            push!(found, n)
            return found
        end
    end
    throw("Couldn't find a clique!")
end


@time find_k_clique(pairs)
