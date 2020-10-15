###Genertic radix sort

A specialized fast sort, countary to poplur belief radix sort can be used for more then unsigned ints. It will require a bit of work and a bit of thoery, but as the basic unit of computation contains more infomation then the bool of the comparision sorts it should be faster.

#### Thoery

So I think poeple over compicate a radix sort, its simply repeat stable sorts by "digit" in reverse order
![3digitsort.png](3digitsort.png)
For a list of three digit ints, this means sorting by 1's then 10's then 100's. And by virtue of being stable it mantains the lesser sorts.

But these digits could be anything, see poker.d for suits and a handclassifier being used, or more generally a quick a dirty bit shift to make "base-256" """digits"""

#### Useage

```d
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
digit3int[10000] foo;
foo.radixsort;
```

Define opRadix inside a struct using template specifications for the cases of 0..n where n is the number of "digits", such that they return the "digits". opRadix!n+1 *must* fail to compile<sup>1</sup>. The "voldemort" types *must* define .max <sup>2</sup>.

1.Its the stopping condition for a recursive template, expect ugly error messages.
2.Local type defination passed to a scope that doesn't know it, enums define .max automaticly, or mimic lyingint.

####notes

* You can't define opRadix outside the struct, or for that matter trying to define the opRadix!n didn't work for me; I intended both to be possible but d caring about scoping endlessly annoys me.
* partialradixsort is exposed if you want to bodge something together using radix like logic; for example spilting vec2s up by a grid.
* I should probaly throw errors for common typos, I defined opradix!3 not opRadix!3 in one of my example which compiles fine but doesnt run partialradixsort!3. Was irrating. Be careful with that.
* lying int should probaly be a template.
* Mixing in a opCmp made from opRadix should be possible.

