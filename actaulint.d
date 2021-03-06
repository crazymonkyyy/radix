struct radixint{
  int i; alias i this;
  struct lyingint{
    int i; alias i this;
    enum max=255;
    this(int a){
      assert(a>-1&& a<256);
      i=a;
    }
  }
  enum signhack=1<<31;
  auto opRadix(int N:0)(){
    return lyingint(i&255);
  }
  auto opRadix(int N:1)(){
    return lyingint((i>>8)&255);
  }
  auto opRadix(int N:2)(){
    return lyingint((i>>16)&255);
  }
  auto opRadix(int N:3)(){
    return lyingint((((i>>24)&255)+128)&255);
  }
}/*
import std;
unittest{
  import radix;
  radixint[1000] foo;
  foreach(ref e;foo){
    e=uniform(int.min,int.max);
  }
  foo.radixsort;
  foreach(e;foo){
    e.write;" ,".write;
    e.opRadix!3.writeln;
  }
  assert(foo[].isSorted);
}*/
unittest{
	import radixksmallest; import std;
	radixint[] foo = new radixint[](100000000);
	foreach(i;0..100000000){
		foo[i]=radixint(uniform(int.min,int.max));
	}
	enum k=1000007;
	//auto o=ksmallest(foo[],k);
	auto o=topN(foo[],k);
	assert(o.length==k,o.length.to!string);
}