 # Assignment1: RISC-V Assembly and Instruction Pipeline

## Add Binary--Leetcode 67
The main idea here is that we would get **two binary number in string format**, then we need to change the this two binary to real **binary format**. Finally we would **sum this two binary** number then print out the final answer!
## C code
### Include library
In Add_Binary.c, we would use below libary source.
``` c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
```
### Main funciton
And here is the main function of Add_Binary.c . We use the `a[8]="1010"` and ` b[8]="1011"` as our two given input binary number in string format.
```c
int main()
{
    char a[8]="1010", b[8]="1011";                                                     // testing data
    printf(" a : %s \n b : %s \n add two binary : %s \n",a,b,addBinary(a,b));          // final consequence print out
    return 0;
}
```
In this code, we would define two function by ourself. 
### First function : char* addBinary(char a[], char b[])
First one is `
char* addBinary(char a[], char b[])` . In this function, we would need to pass **two string as input**, which are previous we defined in main function. And then finally we would get the string output which is the **summation between previous two string form binary numbers**.

Main process is that First we would do **zero padding** about these two string, hope these two string form binary numbers could have same length. After padding, we would compare each bit number then summation them. Finally save the summation in new string as our return string.

```c
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
```
### Second  function : int max(int a, int b)
Second function here is that we want to get **the greatest number** between `a`and`b`, then finally return the greater one. 
```c
int max(int a, int b)
{
    if(a<b) return b;
    if(b<=a) return a;
    return 0;
};
```
## Assembly code
### Compare to C code
At this part, there is a little diffrient between C code concept I wrote . In C code, we still use string format and decimal number to simulate the binary sumation **(fake binary summation)** . But approach here is that we do the **transformation between string and binary**. After completely transform to binary, we add them to get the final summation directly.
### Two mainly part in assembly code
In Add_Binary.s, we have two big part here, `.data` and `.text`.

First one is to save some string we would need in memory, and second one here is to save the main function and other function later we would need.
### How to get final summation?
Data process here is like that we would use `decoder` first to decode the **string to binary** number. And then we could get the **return value** `a1`. After two string had been decoded, we would use `addBinary` to get the **final summation** `s1`, Finallly we call `print` to print out the two array and summation in hex.


```assembly
.data
input_a: .string "1010" # 0b1010 0x0000000A
input_b: .string "1011" # 0b1011 0x0000000B
final_ouput: .word 0x00000000 # initialize
string_1: .string " Number A "
string_2: .string " Number B "    
string_3: .string " Final answer "
error_msg: .string "input error"

.text
main:
    la a0 input_a             # load word address
    jal ra decoder            # call decoder function
    add s2 a1 x0              # save return value 
    
    la a0 input_b             # load word address
    jal ra decoder            # call decoder function
    add s3 a1 x0              # save return value
    
    mv a0 s2                  # cp t0->a0
    mv a1 s3                  # cp t1->a1 
    jal ra addBinary          # call addBinary funciton
    la t0 final_ouput         # load the addtrss of final_output
    sw s1 0(t0)               # save the final answer
    jal ra print              # call print function 
    j end                     # jump to end      
     
decoder:
    addi sp sp -16            # malloc space 4 bytes
    sw ra 12(sp)              # save return address
    sw a0 8(sp)               # save a0
    addi a1 x0 0x00000000     # initialize the a1 
loop:
    sw a0 4(sp)               # save a0 prepare for loop
    lbu t0 0(a0)              # load 1 byte from passed address
    sw t0 0(sp)               # save t0 
    addi t0 t0 -48            # sub the ascii "0" the get the number
    mv a0 t0                  # a0 = t0 + zero
    jal ra bit_number_decoder # call bit_number_decoder function 
    lw a0 4(sp)               # load a0 
    addi a0 a0 1              # trun to  next byte
    lw t0 0(sp)               # load t0
    bgtz t0 loop              # if to >= 0 go back to loop
    lw a0 8(sp)               # load a0
    lw ra 12(sp)              # load ra
    addi sp sp 16             # free memory 
    ret                       # jamp back (jalr x0 ra x0) 
    
bit_number_decoder:
    lw t0 0(sp)               # load t0 
    bgtz t0 then              # if t0<0 , decoder finished
    ret                       # jamp back (jalr x0 ra x0) 
then:        
    addi sp sp -8             # malloc 2 bytes
    sw ra 4(sp)               # save return address
    sw a0 0(sp)               # save a0
    jal ra bit_taker          # call bit_taker
    lw a0 0(sp)               # load back a0
    lw ra 4(sp)               # load back return address
    addi sp sp 8              # free memery
    ret                       # jamp back (jalr x0 ra x0)
bit_taker:
    slli a1 a1 1              # bitwise for save new bit  
    or a1 a1 a0               # save bit in a1
    ret                       # jamp back (jalr x0 ra x0)
    
error:
    la t0 error_msg           # load error message address
    addi a7 x0 4              # ecall print string 
    add a0 x0 t0              # print string
    ecall
    j end

addBinary:
    addi sp sp -12            # malloc 3 bytes
    sw ra 8(sp)               # save return address
    sw a0 4(sp)               # save a0 
    sw a1 0(sp)               # save a1
    add s1 a0 a1              # add a0 a1 pass from main, and save in s1
    lw a1 0(sp)               # load back a1
    lw a0 4(sp)               # load back a0
    lw ra 8(sp)               # load back return address
    addi sp sp 12             # free memery
    ret                       # jamp back (jalr x0 ra x0)
    
print:
    la t0 string_1            # load address of string_1
    mv t1 s2                  # load word
    mv t2 s3                  # load word
    addi t3 t3 0x0A           # save the ASCII of \n
    
    addi a7 x0 4              # ecall print string
    add a0 x0 t0              # print string_1
    ecall
    addi a7 x0 34             # ecall print hex
    add a0 x0 t1              # print A value
    ecall
    addi a7 x0 11             # ecall prints ASCII character
    add a0 x0 t3              # print string "\n"
    ecall
    
    addi a7 x0 4              # ecall print string
    la t0 string_2            # load address of string_2
    add a0 x0 t0              # print string_2
    ecall
    addi a7 x0 34             # ecall print hex
    add a0 x0 t2              # print B value
    ecall
    addi a7 x0 11             # ecall prints ASCII character
    add a0 x0 t3              # print string "\n"
    ecall
    
    addi a7 x0 4              # ecall print string
    la t0 string_3            # load address of string_3
    add a0 x0 t0              # print string_3
    ecall
    addi a7 x0 34             # ecall print hex
    la t0 final_ouput         # load address of final_ouput
    add a0 x0 s1              # print answer value
    ecall
    addi a7 x0 11             # ecall prints ASCII character
    add a0 x0 t3              # print string "\n"
    ecall
    
    ret                       # jamp back (jalr x0 ra x0)
        
end:    
    addi a7 x0 10             # return 10 ( ends the program)
    ecall                     # back to environmental call
```

## Analysis
### Simulator
This time we use [Ripes](https://github.com/mortbopet/Ripes) simulator to simulate our assembly code. And we choose default **5-Stage RISC-V Processor** as our process .
![](https://i.imgur.com/aHSKw2H.png)
### ASM code
It's very obviously to see that the code here is diffrient to assembly code privious wrote. That is because before execute it, the Ripe would **replace the pseudo code** which I wrote, and change the registor name **from ABI to original registor name**.

```asm
00000000 <main>:
	0:		10000517		auipc x10 0x10000
	4:		00050513		addi x10 x10 0
	8:		038000ef		jal x1 56 <decoder>
	c:		00058933		add x18 x11 x0
	10:		10000517		auipc x10 0x10000
	14:		ff550513		addi x10 x10 -11
	18:		028000ef		jal x1 40 <decoder>
	1c:		000589b3		add x19 x11 x0
	20:		00090513		addi x10 x18 0
	24:		00098593		addi x11 x19 0
	28:		0b0000ef		jal x1 176 <addBinary>
	2c:		10000297		auipc x5 0x10000
	30:		fde28293		addi x5 x5 -34
	34:		0092a023		sw x9 0 x5
	38:		0c8000ef		jal x1 200 <print>
	3c:		1600006f		jal x0 352 <end>

00000040 <decoder>:
	40:		ff010113		addi x2 x2 -16
	44:		00112623		sw x1 12 x2
	48:		00a12423		sw x10 8 x2
	4c:		00000593		addi x11 x0 0

00000050 <loop>:
	50:		00a12223		sw x10 4 x2
	54:		00054283		lbu x5 0 x10
	58:		00512023		sw x5 0 x2
	5c:		fd028293		addi x5 x5 -48
	60:		00028513		addi x10 x5 0
	64:		024000ef		jal x1 36 <bit_number_decoder>
	68:		00412503		lw x10 4 x2
	6c:		00150513		addi x10 x10 1
	70:		00012283		lw x5 0 x2
	74:		fc504ee3		blt x0 x5 -36 <loop>
	78:		00812503		lw x10 8 x2
	7c:		00c12083		lw x1 12 x2
	80:		01010113		addi x2 x2 16
	84:		00008067		jalr x0 x1 0

00000088 <bit_number_decoder>:
	88:		00012283		lw x5 0 x2
	8c:		00504463		blt x0 x5 8 <then>
	90:		00008067		jalr x0 x1 0

00000094 <then>:
	94:		ff810113		addi x2 x2 -8
	98:		00112223		sw x1 4 x2
	9c:		00a12023		sw x10 0 x2
	a0:		014000ef		jal x1 20 <bit_taker>
	a4:		00012503		lw x10 0 x2
	a8:		00412083		lw x1 4 x2
	ac:		00810113		addi x2 x2 8
	b0:		00008067		jalr x0 x1 0

000000b4 <bit_taker>:
	b4:		00159593		slli x11 x11 1
	b8:		00a5e5b3		or x11 x11 x10
	bc:		00008067		jalr x0 x1 0

000000c0 <error>:
	c0:		10000297		auipc x5 0x10000
	c4:		f7328293		addi x5 x5 -141
	c8:		00400893		addi x17 x0 4
	cc:		00500533		add x10 x0 x5
	d0:		00000073		ecall
	d4:		0c80006f		jal x0 200 <end>

000000d8 <addBinary>:
	d8:		ff410113		addi x2 x2 -12
	dc:		00112423		sw x1 8 x2
	e0:		00a12223		sw x10 4 x2
	e4:		00b12023		sw x11 0 x2
	e8:		00b504b3		add x9 x10 x11
	ec:		00012583		lw x11 0 x2
	f0:		00412503		lw x10 4 x2
	f4:		00812083		lw x1 8 x2
	f8:		00c10113		addi x2 x2 12
	fc:		00008067		jalr x0 x1 0

00000100 <print>:
	100:		10000297		auipc x5 0x10000
	104:		f0e28293		addi x5 x5 -242
	108:		00090313		addi x6 x18 0
	10c:		00098393		addi x7 x19 0
	110:		00ae0e13		addi x28 x28 10
	114:		00400893		addi x17 x0 4
	118:		00500533		add x10 x0 x5
	11c:		00000073		ecall
	120:		02200893		addi x17 x0 34
	124:		00600533		add x10 x0 x6
	128:		00000073		ecall
	12c:		00b00893		addi x17 x0 11
	130:		01c00533		add x10 x0 x28
	134:		00000073		ecall
	138:		00400893		addi x17 x0 4
	13c:		10000297		auipc x5 0x10000
	140:		edd28293		addi x5 x5 -291
	144:		00500533		add x10 x0 x5
	148:		00000073		ecall
	14c:		02200893		addi x17 x0 34
	150:		00700533		add x10 x0 x7
	154:		00000073		ecall
	158:		00b00893		addi x17 x0 11
	15c:		01c00533		add x10 x0 x28
	160:		00000073		ecall
	164:		00400893		addi x17 x0 4
	168:		10000297		auipc x5 0x10000
	16c:		ebc28293		addi x5 x5 -324
	170:		00500533		add x10 x0 x5
	174:		00000073		ecall
	178:		02200893		addi x17 x0 34
	17c:		10000297		auipc x5 0x10000
	180:		e8e28293		addi x5 x5 -370
	184:		00900533		add x10 x0 x9
	188:		00000073		ecall
	18c:		00b00893		addi x17 x0 11
	190:		01c00533		add x10 x0 x28
	194:		00000073		ecall
	198:		00008067		jalr x0 x1 0

0000019c <end>:
	19c:		00a00893		addi x17 x0 10
	1a0:		00000073		ecall

```
### Efficiency about execution
#### L1 data chache
![](https://i.imgur.com/2URVq4g.png)
#### L1 instruction chache
![](https://i.imgur.com/3xrGh1U.png)

### Console (final output)
![](https://i.imgur.com/t8PytqG.png)
