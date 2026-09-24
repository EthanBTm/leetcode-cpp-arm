.syntax unified
.text

.global romanToInt

romanToInt:
    push {r4-r10, lr}

    // r4 = string pointer
    mov r4, r0

    // r5 = result
    mov r5, #0


loop:
    // current character
    ldrb r6, [r4]

    // if '\0', done
    cmp r6, #0
    beq done

    // convert current Roman character to value
    mov r0, r6
    bl romanValue

    // r7 = current value
    mov r7, r0

    // next character
    ldrb r6, [r4, #1]

    // if no next character, add current
    cmp r6, #0
    beq add_current

    // convert next Roman character to value
    mov r0, r6
    bl romanValue

    // r8 = next value
    mov r8, r0

    // if current < next, subtract current
    cmp r7, r8
    blt subtract_current


add_current:
    add r5, r5, r7
    b advance


subtract_current:
    sub r5, r5, r7


advance:
    add r4, r4, #1
    b loop


done:
    mov r0, r5
    pop {r4-r10, pc}


// ---------------------------------
// romanValue
//
// input:
// r0 = character
//
// output:
// r0 = integer value
// ---------------------------------

romanValue:
    cmp r0, #'I'
    beq value_I

    cmp r0, #'V'
    beq value_V

    cmp r0, #'X'
    beq value_X

    cmp r0, #'L'
    beq value_L

    cmp r0, #'C'
    beq value_C

    cmp r0, #'D'
    beq value_D

    cmp r0, #'M'
    beq value_M

    mov r0, #0
    bx lr


value_I:
    mov r0, #1
    bx lr

value_V:
    mov r0, #5
    bx lr

value_X:
    mov r0, #10
    bx lr

value_L:
    mov r0, #50
    bx lr

value_C:
    mov r0, #100
    bx lr

value_D:
    mov r0, #500
    bx lr

value_M:
    mov r0, #1000
    bx lr