.data
input_a: .word 0x0000000A # 0b1010
input_b: .word 0x0000000B # 0b1011
final_ouput: .word 0x00000000 # initialize
string_1: .string " Number A "
string_2: .string " Number B "    
string_3: .string " Final answer "

.text
main:
    lw t0 input_a     # load word
    lw t1 input_b     # load word
    mv a0 t0          # cp t0->a0
    mv a1 t1          # cp t1->a1 
    jal ra addBinary  # call addBinary funciton
    la t0 final_ouput # load the addtrss of final_output
    sw s1 0(t0)       # save the final answer
    jal print         # call print function 
    j end             # jump to end  

addBinary:
    addi sp sp -8     # malloc 2 bytes
    sw a0 4(sp)       # save a0 
    sw a1 0(sp)       # save a1
    add s1 a0 a1      # add a0 a1 pass from main, and save in s1
    lw a1 0(sp)       # load back a1
    lw a0 4(sp)       # load back a0
    ret               # jamp back (jalr x0 ra x0)
    
print:
    la t0 string_1    # load address of string_1
    lw t1 input_a     # load word
    lw t2 input_b     # load word
    addi a7 x0 4      # ecall print string
    add a0 x0 t0      # print string_1
    ecall
    addi a7 x0 34     # ecall print hex
    add a0 x0 t1      # print A value
    ecall
    addi a7 x0 4      # ecall print string
    la t0 string_2    # load address of string_2
    add a0 x0 t0      # print string_2
    ecall
    addi a7 x0 34     # ecall print hex
    add a0 x0 t2      # print B value
    ecall
    addi a7 x0 4      # ecall print string
    la t0 string_3    # load address of string_3
    add a0 x0 t0      # print string_3
    ecall
    addi a7 x0 34     # ecall print hex
    la t0 final_ouput # load address of final_ouput
    add a0 x0 s1      # print answer value
    ecall
    ret               # jamp back (jalr x0 ra x0)

end:    
    addi a7 x0 10    # return 10 ( ends the program)
    ecall            # back to environmental call