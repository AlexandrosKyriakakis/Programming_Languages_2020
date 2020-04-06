#include<iostream>
#include<math.h>
#include <list> 
#include <iterator> 
using namespace std;

void printlist(list <int> g){
	list <int>::iterator it,id;
	cout<<"[";
	it=g.begin();
	id=g.begin();
	id++;
	while(it!=g.end()){
		if(id!=g.end())cout<<*it<<",";	
        else {
		   cout<<*it;
		   break;
	    }
        ++it;
        ++id;
		}
	cout<<"]";
	cout<<"\n";
}
int main(){
	int T;
	cin>>T;
	//cout<<"\n";
	int N[T],K[T];
	int L,M;
	for(int i=0; i<T; i++){
		cin>>N[i];
		cin>>K[i];
		//cout<<"\n";
		
	}
	for(int i=0; i<T; i++){
        list <int> A;//output 
		L= ceil(log2(N[i]))+1; 
        int B[L];
        M=N[i];
		for (int j=0; j<L;j++)B[j]=0;//array for the binary bits of N(i)
        int counter=0;//the digits of the input variable in binary form
		while (M!=0){
            if (M%2!=0)B[counter++]=1;
            else counter++;
		    M/=2;	
		}
		counter=0;
        //O(log2(N)) και γράφτηκαν τα ψηφία του Ν στον πίνακα Β
    
        /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
        int S=0;
        for(int k=0; k<L;k++){
    	S+=B[k];
	    }
		//O(log2(N) maintains
	    if (K[i]>N[i]){
			printlist(A);
	    	continue;
		}
		else if(K[i]==N[i]){
	        A.push_back(K[i]);
	        printlist(A);
	        continue;
		}
		else{
		
		if(S>K[i]){
			printlist(A);
			continue;
		}
		else if(S==K[i]){
		    int *ptr=&B[L-1];
			while((*ptr==0)&&(ptr!=0)){
				ptr--;
				counter++;
			}
			if(*ptr==0){
				printlist(A);
				continue;
			}
			else{
			    for(int z=0; z<L-counter; z++)A.push_back(B[z]);
			    printlist(A);
			    continue;
			}
		}
		counter=0;
	    int w=1;
	    while(K[i]>S){
	        //Επειδή 2^i=2*2^(i-1) το (Β(i)-=1)Λ(Β(i-1)+=2)=(B[i]) 
			if(B[0]==K[i]){
	    		printlist(A);
	    		continue;//poly amfibolo continue????
			}
			if(B[w]==0)w++;
		    else {
			    B[w]+=-1;
			    S+=1;
			    B[w-1]+=2;
			    --w;
			    }
			if(w==0)w++;		    	
		}
	        w=L-1;
			while(B[w]==0 && w!=0){
				--w;
				counter++;
			}
			if(B[w]==0){
				printlist(A);
				continue;
			}
			else{
			    for(int z=0; z<L-counter; z++){
				A.push_back(B[z]);
			    }
			    printlist(A);
			    continue;
			}
	   }
		//αντέγραψε τα στοιχεία του Β σε μια λίστα με ανάποδη σειρά από την στιγμή που βρεθεί Β[i]!=0
		//reverse the list and print it
		 
	}//αν S=ΣΒ[i], και K=> O(K). Όμως το ψάξιμο 0 σε μια λίστα Log2(N) είναι όσο το μήκος της.
	//Στη χειρ. περ. που όλα τα ψηφία Β[i]=1 τότε ο αλγόριθμος θα πάει πάνω κάτω[(1+1)+(2+2)+..+(L+L)=L(L+1)=> 0((log2(N))^2). 
	// Ο(Κ(log2(N))^2)
    return 0;
}
	

