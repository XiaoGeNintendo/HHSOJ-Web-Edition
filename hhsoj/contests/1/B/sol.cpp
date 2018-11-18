#include <iostream>
#include <algorithm>
#include <vector>
#include <set>
#include <queue>
#include <map>
#include <string.h>
#include <math.h>
#include <stdio.h>


using namespace std;
#define ll long long
#define pii pair<int,int>
int main(int argc,char* argv[]){
//	freopen("fatherIN.txt","r",stdin);
//	freopen("fatherOUT.txt","w",stdout);
	int v=0,n;
	cin>>n;
	for(int i=0;i<n;i++){
		string s;
		cin>>s;
		if(s=="father"){
			v++;
		}else{
			if(s=="son"){
				v--;
			}else{
				cout<<"nth"<<endl;
				return 0;
			}
		}
	}
	
	if(v>=1){
		cout<<"ei";
	}else{
		cout<<"...";
	}
	return 0;
}

