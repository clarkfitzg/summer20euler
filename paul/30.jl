using Multisets

function d5power()
    digitlists=Int[]
    N=0:9

    function d5powersum(n)
        sum(i^5 for i in digits(n; pad=6))
    end

    # Sample, with replacement, 6 digits from
    # the set {0,1,2,...,9} of decimal digits.
    # There are 11 partitions of 6:
    #  6
    #  5 + 1
    #  4 + 2
    #  4 + 1 + 1
    #  ...
    #  1 + 1 + 1 + 1 + 1 + 1
    # Record each sample as an int between 0 and 999999.
    # (We pad with zeros elsewhere.)
    for i in N
        # Partition: 6 -- i.e., all 6 digits the same
        push!(digitlists, 111111*i)
        for j in setdiff(N,i)
            # Partition: 5+1
            push!(digitlists, 111110*i + j)
            # Partition: 4+2
            # ... etc.
            push!(digitlists, 111100*i + 11*j)
            # For the partition 3+3, quotient by symmetry; i.e.,
            # don't count, say, "333777" as distinct from "777333",
            # since the sums of the 5th powers of their digits are the same.
			# The conditionals further below serve the same purpose.
            if i<j
                push!(digitlists, 111000*i + 111*j)
            end
            for k in setdiff(N,i,j)
                push!(digitlists, 111000*i + 110*j + k)
                if j<k
                    push!(digitlists, 111100*i + 10*j + k)
                end
                if i<j<k
                    push!(digitlists, 110000*i + 1100*j + 11*k)
                end
                for m in setdiff(N,i,j,k)
                    if j<k<m
                        push!(digitlists, 111000*i + 100*j + 10*k + m)
                    end
                    if i<j && k<m
                        push!(digitlists, 110000*i + 1100*j + 10*k + m)
                    end
                    for p in setdiff(N,i,j,k,m)
                        if j<k<m<p
                            push!(digitlists, 110000*i + 1000*j + 100*k + 10*m + p)
                        end
                        for q in setdiff(N,i,j,k,m,p)
                            if i<j<k<m<p<q
                                push!(digitlists, 100000*i + 10000*j + 1000*k +
                                        100*m + 10*p + q)
                            end
                        end
                    end
                end
            end
        end
    end

    # Iterate over the samples. Accept a "d5p" sum if
    # the sum contains all the digits that yielded it.
    terms = Set([d5powersum(x) for x in digitlists if
                    Multiset(digits(x; pad=6)) ==
                    Multiset(digits(d5powersum(x); pad=6))])

    sum(terms) - 1 # No need to subtract 0 😄
end
