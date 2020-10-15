void partialradix(size_t n,T,size_t m)(ref T[m] a_array,ref T[m] b_array){
  import pointerarray_;
  pointerarray!(T,typeof(T.opRadix!n())) bar;
  foreach(e;a_array){
    ++bar[e.opRadix!n];
  }
  bar.prefixsum(b_array);
  foreach_reverse(e;a_array){
    bar[e.opRadix!n]=e;
    --bar[e.opRadix!n];
  }
}
void partialradix_(size_t n,T,size_t m)(ref T[m] a_array,ref T[m] b_array){
  static if(n%2==0){//trail and error parity
    partialradix!n(a_array,b_array);
  } else {
    partialradix!n(b_array,a_array);
  }
}
void radixsort(T,size_t n)(ref T[n] a_array){
  static assert(is(typeof(T().opRadix!0())), "I assume you want somethin to run, define opRadix!n");
  T[n] b_array;
  void copybtoa(){
    foreach(i;0..n){
      a_array[i]=b_array[i];
    }
  }
  void radixsort_(size_t m)(){
    static if(is(typeof(T().opRadix!m()))){
      partialradix_!m(a_array,b_array);
      radixsort_!(m+1);
    } else {
      static if(m%2!=0){//trail and error parity
        copybtoa;
      }
    }
  }
  radixsort_!0;
}