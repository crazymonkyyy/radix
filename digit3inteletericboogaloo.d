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

digit3int[k] manualksmallest(size_t k,size_t n)(digit3int[n] a_array){
	digit3int[k] out_;
	size_t o=0;
	size_t k_=k;
	int l=0;
	int p=0;
	{
		size_t[10] counts;
		foreach(e;a_array){
			++counts[e.opRadix!2];}
		size_t j;
		int i=0;
		for(; i<k_; j++){
			i+=counts[j];}
		j--;
		l=0;
		if(i==k){j++;}
		foreach(ref e;a_array){
			auto t=e.opRadix!2;
			if(t<j){
				out_[o]=e; o++;}
			if(t==j){
				a_array[l]=e;l++;
				if(&e!=&a_array[l-1])e=digit3int.max;}
		}
		k_=k-o;
	}
	import std;
	out_.writeln;
	a_array[0..l].writeln;
	{
		size_t[10] counts;
		foreach(e;a_array[0..l]){
			++counts[e.opRadix!1];}
		size_t i=0;
		size_t j=0;
		for(; i<k_; j++){
			i+=counts[j];}
		j--;
		//l=0;
		if(i==k_){j++;}
		foreach(ref e;a_array[0..l]){
			auto t=e.opRadix!1;
			if(t<j){
				out_[o]=e; o++;}
			if(t==j){
				a_array[l]=e;p++;
				if(&e!=&a_array[p-1])e=digit3int.max;}
		}
	}
	"---".writeln;
	out_.writeln;
	a_array[0..l].writeln;
	a_array.writeln;
	return out_;
}
/*
unittest{
	import std;
	digit3int[30] foo;
	foreach(ref e;foo){
		e=uniform(1,999);
	}
	foo.writeln;
	foo.manualksmallest!3;
}
*/
digit3int[] manualksmallest2(size_t n)(digit3int[] a_array,size_t k){
	digit3int[] out_;
	size_t o;
	void push(ref digit3int a){
		out_~=a;o++;}
	auto countarray(size_t n)(ref digit3int[] slice){
		alias key=typeof(digit3int.opRadix!n());
		size_t[key().max+1] count;
		foreach(e;slice){
			++count[e.opRadix!n];}
		return count;
	}
	auto findpivot(size_t[] counts,size_t k){
		struct pivot{
			size_t n;
			bool clean;
			size_t leftovers;
			int newk;
		}
		pivot p;
		//p.newk=k;
		import std;
		int k_=k.to!int;//cause int(k) was to comfy
		p.newk=k_;
		for(int i=0;k_>0;i++){
			p.n++;k_-=counts[i];}
		p.n--;//bloody off by one errors
		p.clean= (k_==0);
		p.leftovers=counts[p.n];
		foreach(e;counts[0..p.n]){
			p.newk-=e;}
		writeln(p);
		return p;
	}
	void uncleancopy(size_t n)(digit3int[] slice,size_t pivot){
		size_t i;
		foreach(e;slice){
			auto temp=e.opRadix!n;
			if(temp<pivot){
				push(e);}
			if(temp==pivot){
				slice[i]=e; i++;}
	}}
	void cleancopy(size_t n)(ref digit3int[] slice,size_t pivot){
			foreach(e;slice){
				auto temp=e.opRadix!n;
				if(temp<=pivot){
					push(e);}
	}}
	void pushk(ref digit3int[] slice,int k){
		foreach(e;slice[0..k]){push(e);}}
	import std; "hi".writeln;
	auto a=countarray!2(a_array);
	auto p=findpivot(a[],k);
	if(p.clean){
		cleancopy!2(a_array,p.n); return out_;}
	uncleancopy!2(a_array,p.n);
	out_.writeln("current state");
	a_array[0..p.leftovers].writeln("leftovers");
	auto b_array=a_array[0..p.leftovers];
	
	//2nd block
	"2nd".writeln;
	
	auto a2=countarray!1(b_array);
	auto p2=findpivot(a2[],p.newk);
	if(p2.clean){
		cleancopy!1(b_array,p2.n); return out_;}
	uncleancopy!1(b_array,p2.n);
	out_.writeln("current state");
	b_array[0..p2.leftovers].writeln("leftovers");

	auto c_array=b_array[0..p2.leftovers];
	//2nd block
	"3nd".writeln;
	
	auto a3=countarray!0(c_array);
	auto p3=findpivot(a3[],p2.newk);
	if(p3.clean){
		cleancopy!0(c_array,p3.n); return out_;}
	uncleancopy!0(c_array,p3.n);
	out_.writeln("current state");
	c_array[0..p3.leftovers].writeln("leftovers");
	auto d_array=c_array[0..p3.leftovers];
	pushk(d_array,p3.newk);
	return out_;
}
/+
unittest{
	import std;
	/*digit3int[100000] foo;
	foreach(ref e;foo){
		e=uniform(1,999);
	}*/
	digit3int[] foo;
	foreach(i;1..10000000){
		foo~=digit3int(uniform(1,999));
	}
	enum k=276;
	auto std_=topN(foo[],k).array; 
	foo.writeln;

	auto o=manualksmallest2!2(foo[],k);
	"finished".writeln;
	o.writeln;
	//foo.writeln;
	assert(o.length==k,o.length.to!string);
	assert(std_.length==k, "this better not fail");
	std_.writeln;
	assert(equal(o.sort,std_.sort));
}
+/

digit3int[] manualksmallest3(size_t n)(digit3int[] a_array,size_t k){
	digit3int[] out_;
	size_t o;
	void push(ref digit3int a){
		out_~=a;o++;}
	auto countarray(size_t n)(ref digit3int[] slice){
		alias key=typeof(digit3int.opRadix!n());
		size_t[key().max+1] count;
		foreach(e;slice){
			++count[e.opRadix!n];}
		return count;
	}
	struct pivot{
		size_t n;
		bool clean;
		size_t leftovers;
		int newk;
	}
	auto findpivot(size_t[] counts,size_t k){
		pivot p;
		//p.newk=k;
		import std;
		int k_=k.to!int;//cause int(k) was to comfy
		p.newk=k_;
		for(int i=0;k_>0;i++){
			p.n++;k_-=counts[i];}
		p.n--;//bloody off by one errors
		p.clean= (k_==0);
		p.leftovers=counts[p.n];
		foreach(e;counts[0..p.n]){
			p.newk-=e;}
		writeln(p);
		return p;
	}
	void uncleancopy(size_t n)(digit3int[] slice,size_t pivot){
		size_t i;
		foreach(e;slice){
			auto temp=e.opRadix!n;
			if(temp<pivot){
				push(e);}
			if(temp==pivot){
				slice[i]=e; i++;}
	}}
	void cleancopy(size_t n)(ref digit3int[] slice,size_t pivot){
			foreach(e;slice){
				auto temp=e.opRadix!n;
				if(temp<=pivot){
					push(e);}
	}}
	void pushk(ref digit3int[] slice,int k){
		foreach(e;slice[0..k]){push(e);}}
		
	void iteration(size_t n)(digit3int[] slice,size_t k){
		auto a=countarray!n(slice);
		auto p=findpivot(a[],k);
		if(p.clean){
			cleancopy!n(slice,p.n); return;}
		uncleancopy!n(slice,p.n);
		auto newslice=slice[0..p.leftovers];
		static if(n!=0){
			iteration!(n-1)(newslice,p.newk);}
		else{
			pushk(newslice,p.newk);}
	}
	iteration!2(a_array,k);
	return out_;
}
/+
unittest{
	import std;
	/*digit3int[100000] foo;
	foreach(ref e;foo){
		e=uniform(1,999);
	}*/
	digit3int[] foo;
	foreach(i;1..100000000){
		foo~=digit3int(uniform(1,999));
	}
	enum k=1000007;
	auto std_=topN(foo[],k).array; 
	//foo.writeln;

	//auto o=manualksmallest3!2(foo[],k);
	"finished".writeln;
	//o.writeln;
	//foo.writeln;
	//assert(o.length==k,o.length.to!string);
	assert(std_.length==k, "this better not fail");
	//std_.writeln;
	//assert(equal(o.sort,std_.sort));
}+/
unittest{
	import std;
	/*digit3int[100000] foo;
	foreach(ref e;foo){
		e=uniform(1,999);
	}*/
	digit3int[] foo;
	foreach(i;1..100000000){
		foo~=digit3int(uniform(1,999));
	}
	enum k=1000007;
	auto std_=topN(foo[],k).array; 
	//foo.writeln;
	import radixksmallest;
	auto o=ksmallest(foo[],k);
	"finished".writeln;
	//o.writeln;
	//foo.writeln;
	assert(o.length==k,o.length.to!string);
	assert(std_.length==k, "this better not fail");
	//std_.writeln;
	assert(equal(o.sort,std_.sort));
}