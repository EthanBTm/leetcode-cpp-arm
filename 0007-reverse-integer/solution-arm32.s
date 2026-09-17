.syntax unified
.text

.global reverseInteger

reverseInteger:
    push {r4-r8, lr}

    // r4 = x
    mov r4, r0

    // r5 = result
    mov r5, #0

    // r6 = 10
    mov r6, #10


loop:
    cmp r4, #0
    beq done

    // quotient = x / 10
    sdiv r7, r4, r6

    // digit = x - quotient * 10
    mul r8, r7, r6
    sub r8, r4, r8

    // x = quotient
    mov r4, r7


    // --------------------------------
    // overflow check
    //
    // INT_MAX / 10 = 214748364
    // INT_MIN / 10 = -214748364
    // --------------------------------

    ldr r0, =214748364

    cmp r5, r0
    bgt overflow

    bne check_min_edge

    // result == INT_MAX / 10
    cmp r8, #7
    bgt overflow


check_min_edge:
    ldr r0, =-214748364

    cmp r5, r0
    blt overflow

    bne build_result

    // result == INT_MIN / 10
    cmp r8, #-8
    blt overflow


build_result:
    // result = result * 10 + digit
    mul r5, r5, r6
    add r5, r5, r8

    b loop


overflow:
    mov r0, #0
    pop {r4-r8, pc}


done:
    mov r0, r5
    pop {r4-r8, pc}