void main(){
	import radixksmallest; import std; import actaulint;
	radixint[] foo = new radixint[](100000000);
	foreach(i;0..100000000){
		foo[i]=radixint(uniform(int.min,int.max));
	}
	enum k=1000007;
	auto o=take(foo[],k);
	assert(o.length==k,o.length.to!string);
}