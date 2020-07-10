using Primes

function nonabsums()
    N=28123

    # Find σ(n), the sum of all divisors, for all n ≤ N.
    σvec=ones(Int,N)
    for p in primes(N)
        pfactor = p + 1
        pvec = pfactor*ones(Int, N÷p)
        α=2
        # By repeated addition, construct the factor of σ(n) associated
        # with this prime p, adding pᵅ for each increment in α.
        while (b=p^α) <= N
            pstep=b÷p
            pvec[pstep:pstep:end].+=b
            α+=1
        end
        # Multiply by these factors (pvec) for multiples of p. The precise
        # factor depends on the highest power of p that divides n.
        σvec[p:p:N] .*= pvec
    end

    # n is abundant if s(n)>n, and s(n) = σ(n) - n
    abvec = σvec.>2*(1:N)

    sumof2 = falses(N)
    # gaps between abundant numbers:
    skips = diff(findall(abvec))
    pushfirst!(skips, 12)

    for skip in skips
        # shift right to the next abundant number
        abvec >>= skip
        # mark numbers of the form (sum of skips thus far) + abundant number
        sumof2 .|= abvec
    end

    sum(findall(.!sumof2))        # "Sum the non-sums"
end
