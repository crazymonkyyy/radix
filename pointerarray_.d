struct pointerarray(T,KEY,keycast=size_t){
  static assert(KEY.max < 1000,"you probaly missed a memo somewhere, your 'key' value needs to be small for radix to be fast, set KEY.max to something reasonable");
  T*[KEY().max+1] pointerstore;
  void opIndexUnary(string op:"++")(KEY k){
    pointerstore[cast(keycast)k]++;
  }
  void opIndexUnary(string op:"--")(KEY k){
    pointerstore[cast(keycast)k]--;
  }
  void prefixsum(T[] a){
    auto total=&a[0]-1;
    foreach(ref e;pointerstore){
      total+=cast(int)e/T.sizeof;
      e=total;
    }
  }
  ref T opIndex(KEY k){
    return *pointerstore[cast(keycast)k];
  }
}
unittest{
  struct lyingint{
    int i; alias i this;
    enum max=10;
    this(int a){
      assert(a>-1&& a<10);
      i=a;
    }
  }
  pointerarray!(int,lyingint) foo;
  ++foo[lyingint(5)];
}
unittest{
  import std;
  enum foo{a,b,c}
  pointerarray!(int,foo) bar;
  ++bar[foo.a];
  ++bar[foo.b];
  ++bar[foo.b];
  ++bar[foo.c];
  ++bar[foo.c];
  ++bar[foo.c];
  {
    int[10] baz;
    bar.prefixsum(baz);
    //bar.writeln;
    bar[foo.a]=1;
    bar[foo.b]=2;
    bar[foo.c]=3;
    //baz.writeln;
  }
}
unittest{
  import std;
  int[100] foo;
  foreach(ref e;foo){
    e=uniform(1,10);
  }
  //foo.writeln;
  struct lyingint{
    int i; alias i this;
    enum max=10;
    this(int a){
      assert(a>-1&& a<10);
      i=a;
    }
  }
  pointerarray!(int,lyingint) bar;
  foreach(e;foo){
    ++bar[lyingint(e)];
  }
  int[100] baz;
  bar.prefixsum(baz);
  foreach(e;foo){
    bar[lyingint(e)]=e;
    --bar[lyingint(e)];
  }
  //assert(baz[]==foo[].sort);
}