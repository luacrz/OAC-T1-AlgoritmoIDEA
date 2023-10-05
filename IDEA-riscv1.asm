.data
    .align 2
blk_in:
    .word 0, 1, 2, 3
blk_out:
    .word 0, 0, 0, 0
keys:
    .word 1, 2, 3, 4, 5, 6
output_format:
    .string "Saida[%d] = %d\n"
    
.text
.globl main

main:
    # Inicializa registros
    la t0, blk_in
    la t1, blk_out
    la t2, keys

    # Chamada da função idea_round
    jal ra, idea_round

    # Impressão dos resultados
    li t6, 0  # Inicializa contador
loop:
    lw t3, 0(t1)  # Carrega palavra de blk_out

    # Prepara argumentos para a chamada de sistema write
    li a0, 1        # Carrega o valor 1 em a0 (descritor de arquivo para stdout)
    la a1, output_format  # Endereço do formato
    mv a2, t6       # �?ndice do elemento
    mv a3, t3       # Valor a ser impresso

    # Chamada de sistema write
    li a7, 64       # Código de chamada de sistema para write
    ecall

    addi t1, t1, 4  # Avança para o próximo elemento de blk_out
    addi t6, t6, 1  # Incrementa o contador

    # Verifica se o loop deve continuar
    bne t6, t4, loop  #  t4 contador

    # Saída do programa
    li a7, 10 
    ecall

idea_round:
   # Carrega os argumentos da função
    lw a0, 0(t0)  # Carrega word1 de blk_in
    addi t0, t0, 4  # Avança para o próximo elemento de blk_in
    lw a1, 0(t0)  # Carrega word2 de blk_in
    addi t0, t0, 4  # Avança para o próximo elemento de blk_in
    lw a2, 0(t0)  # Carrega word3 de blk_in
    addi t0, t0, 4  # Avança para o próximo elemento de blk_in
    lw a3, 0(t0)  # Carrega word4 de blk_in
    addi t0, t0, 4  # Avança para o próximo elemento de blk_in

    # Implementação função mul
    mul a4, a0, a1  # a4 = x * y
    beqz a4, zero_case  # Verifica se p == 0 

    srli t6, a4, 2  # t6 = a4 >> 2 (equivale a dividir por 4)
    mv a0, t6     # x = t6

    sub a0, a1, a0  # x = y - x
    blt a1, a0, add_65537  # Verifica se y < x
    j continue_round

zero_case:
    li t5, 65537  # Carrega o valor imediato 65537 em t5
    mv a1, t5     # Move o valor de t5 para a1

add_65537:
    add a0, a0, a1  # x += 65537

continue_round:
    # Implementação idea_round
    xor a5, a0, a2  # t2 = word1 ^ word3
    mul a5, a5, a3  # t2 = t2 * key
    xor a6, a5, a1  # t1 = t2 ^ word2 ^ word4
    mul a6, a6, a4  # t1 = t1 * key
    add a5, a6, a5  # t2 = t1 + t2
    xor a0, a0, a6  # word1 ^= t1
    xor a3, a3, a5  # word4 ^= t2
    xor a5, a5, a2  # t2 ^= word2
    xor a2, a2, a1  # word2 = word3 ^ t1
    mv a1, a5  # word3 = t2

    # Armazena os resultados de volta em blk_out
    sw a0, 0(t1)  # Armazena word1 em blk_out
    addi t1, t1, 4  # Avança para o próximo elemento de blk_out
    sw a2, 0(t1)  # Armazena word2 em blk_out
    addi t1, t1, 4  # Avança para o próximo
    sw a3, 0(t1)  # Armazena word3 em blk_out
    addi t1, t1, 4  # Avança para o próximo elemento de blk_out
    sw a4, 0(t1)  # Armazena word4 em blk_out

    ret

