.data
blk_in:
    .word 0, 1, 2, 3
blk_out:
    .word 0, 0, 0, 0
keys:
    .word 1, 2, 3, 4, 5, 6

.text
.global _start

_start:
    # Inicialize os registradores
    la a0, blk_in
    la a1, blk_out
    la a2, keys

    # Loop para processar cada bloco
    li t6, 4         # Contador de blocos
loop:
    # Carregar um bloco de entrada
    lw t0, 0(a0)
    lw t1, 4(a0)
    lw t2, 8(a0)
    lw t3, 12(a0)

    # Carregar as chaves
    lw t4, 0(a2)
    lw t5, 4(a2)
    lw t6, 8(a2)
    lw t0, 12(a2)
    lw t1, 16(a2)
    lw t2, 20(a2)

    # Implementar aqui as operações do algoritmo IDEA (multiplicações, adições, etc.)

    # Armazenar o resultado no bloco de saída
    sw t0, 0(a1)
    sw t1, 4(a1)
    sw t2, 8(a1)
    sw t3, 12(a1)

    # Atualizar os ponteiros
    addi a0, a0, 16  # Avançar para o próximo bloco de entrada
    addi a1, a1, 16  # Avançar para o próximo bloco de saída
    addi a2, a2, 24  # Avançar para as próximas chaves

    # Decrementar o contador de blocos
    addi t6, t6, -1
    bnez t6, loop    # Se t6 != 0, continuar o loop

    # Fim do programa
    li a7, 10         # Código de saída do programa
    ecall
