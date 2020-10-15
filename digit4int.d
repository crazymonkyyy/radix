struct digit4int{
  int i; alias i this;
  this(int a){
    assert(a>-1&& a<10000);
    i=a;
  }
  struct lyingint{
    int i; alias i this;
    enum max=10;
    this(int a){
      assert(a>-1&& a<10);
      i=a;
    }
  }
  auto opRadix(int N:0)(){
    return lyingint(i%10);
  }
  auto opRadix(int N:1)(){
    return lyingint((i/10)%10);
  }
  auto opRadix(int N:2)(){
    return lyingint((i/100)%10);
  }
  auto opRadix(int N:3)(){
    return lyingint((i/1000)%10);
  }
}
import std;
unittest{
  import radix;
  digit4int[10000] foo;
  foreach(ref e;foo){
    e=uniform(1,9999);
  }
  foo.radixsort;
  //foo.writeln;
  assert(foo[].isSorted);
}