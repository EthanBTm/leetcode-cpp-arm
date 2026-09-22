.syntax unified
.text

.global intToRoman

intToRoman:
    push {r4-r10, lr}

    // r4 = num
    mov r4, r0

    // r5 = output pointer
    mov r5, r1

    // r6 = current output index
    mov r6, #0


    // -------------------------
    // 1000 -> M
    // -------------------------
check_1000:
    cmp r4, #1000
    blt check_900

    sub r4, r4, #1000
    mov r7, #'M'
    strb r7, [r5, r6]
    add r6, r6, #1
    b check_1000


    // -------------------------
    // 900 -> CM
    // -------------------------
check_900:
    cmp r4, #900
    blt check_500

    sub r4, r4, #900

    mov r7, #'C'
    strb r7, [r5, r6]
    add r6, r6, #1

    mov r7, #'M'
    strb r7, [r5, r6]
    add r6, r6, #1

    b check_900


    // -------------------------
    // 500 -> D
    // -------------------------
check_500:
    cmp r4, #500
    blt check_400

    sub r4, r4, #500
    mov r7, #'D'
    strb r7, [r5, r6]
    add r6, r6, #1
    b check_500


    // -------------------------
    // 400 -> CD
    // -------------------------
check_400:
    cmp r4, #400
    blt check_100

    sub r4, r4, #400

    mov r7, #'C'
    strb r7, [r5, r6]
    add r6, r6, #1

    mov r7, #'D'
    strb r7, [r5, r6]
    add r6, r6, #1

    b check_400


    // -------------------------
    // 100 -> C
    // -------------------------
check_100:
    cmp r4, #100
    blt check_90

    sub r4, r4, #100
    mov r7, #'C'
    strb r7, [r5, r6]
    add r6, r6, #1
    b check_100


    // -------------------------
    // 90 -> XC
    // -------------------------
check_90:
    cmp r4, #90
    blt check_50

    sub r4, r4, #90

    mov r7, #'X'
    strb r7, [r5, r6]
    add r6, r6, #1

    mov r7, #'C'
    strb r7, [r5, r6]
    add r6, r6, #1

    b check_90


    // -------------------------
    // 50 -> L
    // -------------------------
check_50:
    cmp r4, #50
    blt check_40

    sub r4, r4, #50
    mov r7, #'L'
    strb r7, [r5, r6]
    add r6, r6, #1
    b check_50


    // -------------------------
    // 40 -> XL
    // -------------------------
check_40:
    cmp r4, #40
    blt check_10

    sub r4, r4, #40

    mov r7, #'X'
    strb r7, [r5, r6]
    add r6, r6, #1

    mov r7, #'L'
    strb r7, [r5, r6]
    add r6, r6, #1

    b check_40


    // -------------------------
    // 10 -> X
    // -------------------------
check_10:
    cmp r4, #10
    blt check_9

    sub r4, r4, #10
    mov r7, #'X'
    strb r7, [r5, r6]
    add r6, r6, #1
    b check_10


    // -------------------------
    // 9 -> IX
    // -------------------------
check_9:
    cmp r4, #9
    blt check_5

    sub r4, r4, #9

    mov r7, #'I'
    strb r7, [r5, r6]
    add r6, r6, #1

    mov r7, #'X'
    strb r7, [r5, r6]
    add r6, r6, #1

    b check_9


    // -------------------------
    // 5 -> V
    // -------------------------
check_5:
    cmp r4, #5
    blt check_4

    sub r4, r4, #5
    mov r7, #'V'
    strb r7, [r5, r6]
    add r6, r6, #1
    b check_5


    // -------------------------
    // 4 -> IV
    // -------------------------
check_4:
    cmp r4, #4
    blt check_1

    sub r4, r4, #4

    mov r7, #'I'
    strb r7, [r5, r6]
    add r6, r6, #1

    mov r7, #'V'
    strb r7, [r5, r6]
    add r6, r6, #1

    b check_4


    // -------------------------
    // 1 -> I
    // -------------------------
check_1:
    cmp r4, #1
    blt done

    sub r4, r4, #1
    mov r7, #'I'
    strb r7, [r5, r6]
    add r6, r6, #1

    b check_1


done:
    // null terminator
    mov r7, #0
    strb r7, [r5, r6]

    pop {r4-r10, pc}