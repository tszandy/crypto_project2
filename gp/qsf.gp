\rfactor_gpinput.gp

{
	L(N)=
		return (exp(sqrt(log(N)*log(log(N)))));
}
{
	B_smooth(N)=
		return ((L(N))^(1/sqrt(2)));
}
{
	getRoots(N,p)=
		local(sols=[]);
		for(i=1,p,
			if(Mod(i^2,p) == Mod(N,p),sols=concat(sols,i))
		);
		return(sols);
}
{
	validate(factors,N)=
		if(factors[1]*factors[2]==N, return(True));
		return(False);
}
{
	QSfactor(N,b,B)=
		local(
            roots, \\ solutions to t^2 = N (mod p)
            sieveStart, \\ starting index for each division in the list
            reducedNums=[], \\ list of numbers that sieve to 1
            a=ceil(sqrt(N)), \\ starting T value of the list
            P=primes([2,B]), \\ list of primes <= B
            pow=1, \\ starting exponent for prime powers
            numberList=vector(b+1,i,((i+a-1)^2-N)), \\ list of T^2-N
            fac, \\ prod of small primes in congruence
            M, \\ matrix to find kernel of,
            kernel, \\ kernel of M
            product1=1, \\ first product for the gcd subtraction
            product2=1, \\ second product for gcd subtraction
            product2Fac, \\ factorization of product2
            product2Base=1, \\ what is fed into gcd computation
            g \\ gcd(N, product1-product2Base)
        );
		for(i=1,#P,
            \\ Only need to consider square roots mod p
			if(issquare(Mod(N,P[i])),
                pow = 1;

                \\ continue dividing by powers of p
				while(issquare(Mod(N,P[i]^pow)),
					if(P[i]^pow > B, break);
					roots=getRoots(N,P[i]^pow);
					for(j=1,#roots,

                        \\ Determine where to start dividing from
						for(n=1,P[i]^pow,
							if(Mod(n+a-1,P[i]^pow) == Mod(roots[j],P[i]^pow),
								sieveStart=n;
								break
							)
						);

                        \\ Divide all multiples of p^pow in the list
						forstep(k=sieveStart,#numberList,P[i]^pow,
							numberList[k]=numberList[k]/P[i];

                            \\ Make note of fully sieved numbers
                            if(numberList[k]==1, reducedNums = concat(reducedNums, k+a-1))
						);
					);
					pow += 1;
				)
			)
		);

        \\ init M with B rows and col for each sieved to 1 num
        M=matrix(#P,#reducedNums);

        \\ fill M with exponents for each prime
        for(i=1, #reducedNums,
            fac=factor(lift(Mod(reducedNums[i],N)^2));
            for(j=1, #fac[,1],
                M[select((x) -> x == fac[j,1], P, 1)[1],i]=fac[j,2];
            )
        );

        \\ find the kernel of M mod 2
        kernel=matker(Mod(M,2));

        \\ try each product combination in the kernel
        for(i=1, #kernel[1,],
            product1=1;
            product2=1;
            product2Base=1;
            for(j=1, #kernel[,i],
                if(kernel[j,i] == Mod(1,2),
                    product1 *= reducedNums[j];
                    product2 *= lift(Mod(reducedNums[j],N)^2);
                )
            );
            product2Fac=factor(product2);
            for(j=1, #product2Fac[,1],
                product2Base *= product2Fac[j,1]^(product2Fac[j,2]/2)
            );
            g = gcd(N, product1-product2Base);

            \\ stop if we find a non-trivial divisor
            if(g != 1 && g != N, break);
        );

        \\ returns a list of the prime divisors plus a boolean for if the factors are valid
        return([g, N/g, validate([g,N/g], N)]);
}
{
	\\for(i=1,#N,QSfactor(N[i]))
}
