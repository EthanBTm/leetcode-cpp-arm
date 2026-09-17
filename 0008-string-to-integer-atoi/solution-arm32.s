.syntax unified
.text

.global myAtoi

myAtoi:
    push {r4-r9, lr}

    // r4 = string pointer
    mov r4, r0

    // r5 = result
    mov r5, #0

    // r6 = sign
    mov r6, #1


// -----------------------------------------
// Skip leading spaces
// -----------------------------------------
skip_spaces:
    ldrb r7, [r4]

    cmp r7, #' "
    bne check_sign

    add r4, r4, #1
    b skip_spaces


// ----------------------------------------
// Check optional sign
// ----------------------------------------
check_sign:
    cmp r7, #'-'
    bne check_plus

    mov r6, #-1
    add r4, r4, #1
    b digit_loop


check_plus:
    cmp r7, #'+'
    bne digit_loop

    add r4, r4, #1


// ---------------------------------------
// Read digits
// ---------------------------------------
digit_loop:
    ldrb r7, [r4]

    // if char < '0'
    cmp r7, #'0'
    blt finish

    // if char > '9'
    cmp r7, #'9'
    bgt finish

    // digit = char - '0'
    sub r8, r7, #'0'


    // -----------------------------------
    // Overflow check
    // 
    // INT_MAX / 10 = 214748364
    // -----------------------------------

    ldr r9, =214748364

    cmp r5, r9
    bgt overflow

    bne build_number

    // result == INT_MAX / 10
    cmp r8, #7
    bgt overflow


build_number:
    // result = result * 10 + digit

    mov r9, #10
    mul r5, r5, r9
    add r5, r5, r8

    add r4, r4, #1
    b digit_loop


// -----------------------------------
// Overflow
// -----------------------------------
overflow:
    cmp r6, #1
    beq max_value

    // INT_MIN
    ldr r0, =0x80000000
    pop {r4-r9, pc}


// ----------------------------------
// Apply sign and return
// ----------------------------------
finish:
    cmp r6, #1
    beq positive

    rsb r5, r5, #0


positive:
    mov r0, r5

    pop {r4-r9, pc}