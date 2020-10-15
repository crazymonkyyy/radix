struct radixfloat{
  float f; alias f this;
  struct lyingint{
    int i; alias i this;
    enum max=255;
    this(int a){
      //assert(a>-1&& a<256);
      i=a;
    }
  }
  auto opRadix(int N:0)(){
    return lyingint(cast(int)f&255);
  }
  auto opRadix(int N:1)(){
    return lyingint((cast(int)f>>8)&255);
  }
  auto opRadix(int N:2)(){
    return lyingint((cast(int)f>>16)&255);
  }
  auto opRadix(int N:3)(){
    return lyingint((((cast(int)f>>24)&255)+128)&255);
  }
}
import std;
unittest{
  import radix;
  radixfloat[1000000] foo;
  foreach(ref e;foo){
    e=cast(float)uniform(int.min,int.max);
  }
  foo.radixsort;
  //foreach(e;foo){
  //  e.write;" ,".write;
  //  e.opRadix!3.writeln;
  //}
  assert(foo[].isSorted);
}