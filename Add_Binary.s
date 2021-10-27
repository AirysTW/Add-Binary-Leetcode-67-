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