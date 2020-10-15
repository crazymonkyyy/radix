//nicked from rangematch, see that project for syntax

enum suit{clubs,diamond,spades,heart}
// apperently suit ordering is regional... making this example strange, oh well, hearts are the most important 
struct card{
  int value;
  suit suit_;
}
alias hand=card[5];
enum handclass{royalflush,straightflush,fourofakind,fullhouse,flush,straight,threeofakind,
    twopair,onepair,high}
    //ops reverse order, will fix it with some math
handclass classifyhand(hand a){
  import std.algorithm;import std.array; import std.range;
  auto groupsizes(T)(T[] a){
    return cast(int[])
    a.sort!("a<b").group
    .map!"a[1]".array
    .sort!("a>b").array;
  }
  assert(groupsizes([1,2,2,2,1])==[3,2]);
  auto isstaight(int[] a){
    return a==iota(a[0],a[0]+5).array;
  }
  assert(isstaight([9,10,11,12,13]));
  assert(! isstaight([8,10,11,12,13]));
  struct processeddata{
    int[] suitgroups;
    int[] valuegroups;
    bool royal;
    bool staight;
    this(card[] hand_){
      suitgroups =groupsizes(hand_.map!"a.suit_".array);
      valuegroups=groupsizes(hand_.map!"a.value".array);
      royal= ! hand_.map!"a.value".array.any!"a>=2 && a<=9";
      staight=isstaight(hand_.map!"a.value".array.sort.array)||
          isstaight(hand_.map!"a.value".map!"a==1? 14:a".array.sort.array);
    }
  }
  import rangematch;
  mixin rangematchsetup!(processeddata,handclass);
  with(handclass){
    return processeddata(a)|
      pattern(suitgroups=[5],valuegroups          ,royal=true,staight=true,royalflush   )|
      pattern(suitgroups=[5],valuegroups          ,royal     ,staight=true,straightflush)|
      pattern(suitgroups    ,valuegroups=[4,1]    ,royal     ,staight     ,fourofakind  )|
      pattern(suitgroups    ,valuegroups=[3,2]    ,royal     ,staight     ,fullhouse    )|
      pattern(suitgroups=[5],valuegroups          ,royal     ,staight     ,flush        )|
      pattern(suitgroups    ,valuegroups          ,royal     ,staight=true,straight     )|
      pattern(suitgroups    ,valuegroups=[3,1,1]  ,royal     ,staight     ,threeofakind )|
      pattern(suitgroups    ,valuegroups=[2,2,1]  ,royal     ,staight     ,twopair      )|
      pattern(suitgroups    ,valuegroups=[2,1,1,1],royal     ,staight     ,onepair      )|
      pattern(suitgroups    ,valuegroups          ,royal     ,staight     ,high         );
  }
}

//--------

import std; import radix;

auto highcard(hand a){
  static struct radixcard{
    card c; alias c this;
    suit opRadix(int N:0)(){
      return c.suit_;
    }
    auto opRadix(int N:1)(){
      struct lyingint{
        int i; alias i this;
        enum max=14;
        this(int a){
          assert(a>-1&& a<14);
          i=a;
          if(a==1){i=14;}
        }
      }
      return lyingint(c.value);
    }
  }
  radixcard[5] foo;
  foreach(i;0..5){
    foo[i]=a[i];
  }
  foo.radixsort;
  return foo[0];
}
struct radixhand{
  hand h; alias h this;
  auto opRadix(int N:0)(){return h.highcard.suit_;}
  auto opRadix(int N:1)(){return h.highcard.opRadix!1;}
  auto opRadix(int N:2)(){
    return cast(handclass)(
        handclass.max-h.classifyhand);
  }
}
unittest{
  radixhand[100000] foo;
  foreach(ref e;foo){
  foreach(i;0..5){
    e[i]=card(uniform(1,13+1),uniform!suit);
  }}
  foo.radixsort;
  foreach(e;foo){
    e.write;e.classifyhand.writeln;
  }
}