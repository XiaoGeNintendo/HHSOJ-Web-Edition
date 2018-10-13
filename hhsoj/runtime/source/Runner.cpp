
#include <bits/stdc++.h>
using namespace std;

int main(int argc,char** argv){
	if(argc!=2){
		return 1;
	}
	
	int exitcode=system(argv[1]);
	ofstream os;
	os.open("sandbox.txt");
	os<<clock()<<endl;
	os.close();
	return exitcode;
} 
