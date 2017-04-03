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
	QSfactor(N)=
		local(a,b,B,P);
		a=ceil(sqrt(N));
		b=ceil(L(N)^(sqrt(2)));
		B=ceil(B_smooth(N));	
		P=primes([2,B]);

		print(vector(b,i,i+a))
}
{
	for(i=1,#N,QSfactor(N[i]))
}
