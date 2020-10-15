import std;
unittest{
  float[1000000] foo;
  foreach(ref e;foo){
    e=cast(float)uniform(int.min,int.max);
  }
  foo[].sort;
  assert(foo[].isSorted);
}