#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

char* addBinary(char a[], char b[]);
int max(int a, int b);

int main()
{
    char a[8]="1010", b[8]="1011";                                                  // testing data
    printf(" a : %s \n b : %s \n add two binary : %s \n",a,b,addBinary(a,b));          // final consequence print out
    return 0;
}

char* addBinary(char a[], char b[])                                                 // two string as input
{
    char* ans=(char*)malloc(8);                                                     // final answer
    strcpy(ans,"");                                                                 // ans string initialize
    char aa[8], bb[8];                                                              // argument two local string 
    strcpy(aa,a);                                                                   // two string initialize
    strcpy(bb,b);
    int num_a=strlen(a),num_b=strlen(b),num=max(num_a,num_b),carry=0;               // find max size of strings 
    if(num_a>num_b)                                                                 // let shorter string as long as longer one (zero padding)
    {
        for(int i=0;i<num_a-num_b;i++)
        {
            char tmp[8];                                                            // tmp string to save the current string
            strcpy(tmp,bb);                                                         // initialize the tmp string
            sprintf(bb,"%d%s",0,tmp);                                               // zero padding
        }
    }else if(num_a<num_b)                                                           // same concept about privious one 
    {                                                                               // , but we don't care the equal situation
        for(int i=0;i<num_b-num_a;i++)                                              // ,because that is not necessary
        {
            char tmp[8];
            strcpy(tmp,aa);
            sprintf(aa,"%d%s",0,tmp);
        }
    }
    for(int i=num-1;i>=0;i--)                                                       // add two binary string
    {
        int sum;                                                                    // sum of the current number and carry number
        char tmp[8];                                                                // tmp srting
        strcpy(tmp,ans);                                                            // initialize
        sum=(aa[i]-'0')+(bb[i]-'0')+carry;                                          // sum string a,b number and carry number
        sprintf(ans,"%d%s",sum%2,tmp);                                              // save the residual 
        carry=sum/2;                                                                // save carry
        if(carry!=0 && i-1<0)                                                       // if the current i is final one
        {                                                                           // ,save the carry as the first member of ans
            strcpy(tmp,ans);
            sprintf(ans,"%d%s",carry,tmp);                                          // save the carry to the ans string 
        }
    }
    return ans;
};

int max(int a, int b)
{
    if(a<b) return b;
    if(b<=a) return a;
    return 0;
};