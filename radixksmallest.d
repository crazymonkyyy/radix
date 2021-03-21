int findopradix(T,size_t n=0)(){
	static if(is(typeof(T().opRadix!(n+1)()))){
		return findopradix!(T,n+1);}
	else {
		return n;
}}

T[] ksmallest(T)(T[] a_array,size_t k){
	T[] out_;
	size_t o;
	void push(ref T a){
		out_~=a;o++;}
	auto countarray(size_t n)(ref T[] slice){
		alias key=typeof(T.opRadix!n());
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
		//writeln(p);
		return p;
	}
	void uncleancopy(size_t n)(T[] slice,size_t pivot){
		size_t i;
		foreach(e;slice){
			auto temp=e.opRadix!n;
			if(temp<pivot){
				push(e);}
			if(temp==pivot){
				slice[i]=e; i++;}
	}}
	void cleancopy(size_t n)(ref T[] slice,size_t pivot){
			foreach(e;slice){
				auto temp=e.opRadix!n;
				if(temp<=pivot){
					push(e);}
	}}
	void pushk(ref T[] slice,int k){
		foreach(e;slice[0..k]){push(e);}}
		
	void iteration(size_t n)(T[] slice,size_t k){
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
	
	enum biggestopradix=findopradix!T;
	
	iteration!biggestopradix(a_array,k);
	return out_;
}