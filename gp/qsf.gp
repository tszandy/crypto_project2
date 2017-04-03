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
	QSfactor(N)=
		local(a,b,B,P,roots,sieveStart);
		a=ceil(sqrt(N));
		\\ b=ceil(L(N)^(sqrt(2)));
		b=100;
		B=ceil(B_smooth(N));	
		P=primes([2,B]);
		num=vector(b+1,i,((i+a-1)^2-N));
		original=num;
		for(i=1,#P,
			if(issquare(Mod(N,P[i])),
				local(pow=1);
				while(issquare(Mod(N,P[i]^pow)),
					if(P[i]^pow > B, break);
					roots=getRoots(N,P[i]^pow);
					for(j=1,#roots,
						for(n=1,P[i]^pow,
							if(Mod(n+a-1,P[i]^pow) == Mod(roots[j],P[i]^pow),
								sieveStart=n;
								break
							)
						);
						forstep(k=sieveStart,#num,P[i]^pow,
							num[k]=num[k]/P[i]
						);
					);
					pow += 1;
				)
			)
		);
		return(num);
}
{
	kernel(N)=
		return matker(Mod(N,2));
}
{
	\\for(i=1,#N,QSfactor(N[i]))
}
