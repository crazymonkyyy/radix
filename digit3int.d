struct digit3int{
  int i; alias i this;
  this(int a){
    assert(a>-1&& a<1000);
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
    static assert(false);
  }
}
import std;
unittest{
  assert(digit3int(123).opRadix!0==3);
  assert(digit3int(123).opRadix!1==2);
  assert(digit3int(123).opRadix!2==1);
  static assert( ! is(typeof(digit3int(123).opRadix!3())));
  digit3int(0)   .writeln;
  //digit3int(-1)  .writeln;
  digit3int(999) .writeln;
  //digit3int(1000).writeln;
}

digit3int[n] manualradix(size_t n)(digit3int[n] a_array){
  import pointerarray_;
  digit3int[n] b_array;
  {
    pointerarray!(digit3int,typeof(digit3int.opRadix!0())) bar;
    foreach(e;a_array){
      ++bar[e.opRadix!0];
    }
    bar.prefixsum(b_array);
    foreach_reverse(e;a_array){
      bar[e.opRadix!0]=e;
      --bar[e.opRadix!0];
    }
  }
  {
    pointerarray!(digit3int,typeof(digit3int.opRadix!1())) bar;
    foreach(e;b_array){
      ++bar[e.opRadix!1];
    }
    bar.prefixsum(a_array);
    foreach_reverse(e;b_array){
      bar[e.opRadix!1]=e;
      --bar[e.opRadix!1];
    }
  }
  {
    pointerarray!(digit3int,typeof(digit3int.opRadix!2())) bar;
    foreach(e;a_array){
      ++bar[e.opRadix!2];
    }
    bar.prefixsum(b_array);
    foreach_reverse(e;a_array){
      bar[e.opRadix!2]=e;
      --bar[e.opRadix!2];
    }
  }
  return b_array;
}
digit3int[n] manualradix2(size_t n)(ref digit3int[n] a_array){
  import radix;
  digit3int[n] b_array;
  
  partialradix!0(a_array,b_array);
  partialradix!1(b_array,a_array);
  partialradix!2(a_array,b_array);
  return b_array;
}
digit3int[n] manualradix3(size_t n)(ref digit3int[n] a_array){
  import radix;
  digit3int[n] b_array;
  
  partialradix_!0(a_array,b_array);
  partialradix_!1(a_array,b_array);
  partialradix_!2(a_array,b_array);
  return b_array;
}
unittest{
  digit3int[10000] foo;
  foreach(ref e;foo){
    e=uniform(1,999);
  }
  assert(foo.manualradix[].isSorted);
}
unittest{
  digit3int[10000] foo;
  foreach(ref e;foo){
    e=uniform(1,999);
  }
  //foo.manualradix2[].writeln;
  assert(foo.manualradix2[].isSorted);
}
unittest{
  digit3int[10000] foo;
  foreach(ref e;foo){
    e=uniform(1,999);
  }
  //foo.manualradix3[].writeln;
  assert(foo.manualradix3[].isSorted);
}
unittest{
  import radix;
  digit3int[10000] foo;
  foreach(ref e;foo){
    e=uniform(1,999);
  }
  foo.radixsort;
  //foo.writeln;
  assert(foo[].isSorted);
}