.syntax unified
.text

.global zigzagConvert

zigzagConvert:
    push {r4-r11, lr}

    // r4 = input
    mov r4, r0

    // r5 = length
    mov r5, r1

    // r6 = numRows
    mov r6, r2

    // r7 = output
    mov r7, r3

    // output index
    mov r8, #0

    // if numRows == 1
    cmp r6, #1
    beq copy_all

    // cycle = 2 * numRows - 2
    lsl r9, r6, #1
    sub r9, r9

    // row = 0
    mov r10, #0


row_Loop:
    cmp r10, r6
    bge done

    // i = row
    mov r11, r10


index_loop:
    cmp r11, r5
    bge next_row

    // output[outIndex++] = input[i]
    ldrb r0, [r4, r11]
    strb r0, [r7, r8]
    add r8, r8, #1

    // middle rows can have diagonal character
    cmp r10, #0
    beq skip_diagonal

    sub r1, r6, #1
    cmp r10, r1
    beq skip_diagonal

    // diagonal = i + cycle - 2*row
    lsl r1, r10, #1
    sub r1, r9, r1
    add r1, r11, r1

    cmp r1, r5
    bge skip_diagonal

    ldrb r0, [r4, r1]
    strb r0, [r7, r8]
    add r8, r8, #1


skip_diagonal:
    // i += cycle
    add r11, r11, r9
    b index_loop


next_row:
    add r10, r10, #1
    b row_Loop


copy_all;
    mov r10, #0

copy_loop:
    cmp r10, r5
    bge done

    ldrb r0, [r4, r10]
    strb r0, [r7, r10]

    add r10, r10, #1
    b copy_loop


done:
    // null terminator
    mov r0, #0
    strb r0, [r7, r8]

    pop {r4-r11, pc}