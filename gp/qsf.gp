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
		local(a,b,c);
		a=L(N)^(sqrt(2));
		b=B_smooth(N);
		c=ceil(sqrt(N));
		print([a,b,c])
}
{
	for(i=1,#N,QSfactor(N[i]))
}