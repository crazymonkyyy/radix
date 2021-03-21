void main(){
	import std; import actaulint;
	enum n=1000000000;
	radixint[] foo = new radixint[](n);
	foreach(i;0..n){
		foo[i]=radixint(uniform(int.min,int.max));
	}
	enum k=n/(256*16);
	auto o=topN(foo[],k);
	assert(o.length==k,o.length.to!string);
}