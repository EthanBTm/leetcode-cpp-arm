.syntax unified
.text

.global longestCommonPrefix

longestCommonPrefix:
    push {r4-r10, lr}

    // r4 = strings
    mov r4, r0

    // r5 = count
    mov r5, r1

    // r6 = output
    mov r6, r2

    // if count == 0
    cmp r5, #0
    beq empty_result

    // r7 = first string
    ldr r7, [r4]

    // prefix index
    mov r8, #0


char_loop:
    // current character from first string
    ldrb r9, [r7, r8]

    // end of first string
    cmp r9, #0
    beq finish

    // compare this character with all other strings
    mov r10, #1


string_loop:
    cmp r10, r5
    bge character_matches_all

    // load strings[r10]
    ldr r0, [r4, r10, lsl #2]

    // load strings[r10][r8]
    ldrb r1, [r0, r8]

    // if end of string
    cmp r1, #0
    beq finish

    // if character differs
    cmp r1, r9
    bne finish

    add r10, r10, #1
    b string_loop


character_matches_all:
    // output[r8] = character
    strb r9, [r6, r8]

    add r8, r8, #1
    b char_loop


finish:
    // null terminate output
    mov r0, #0
    strb r0, [r6, r8]

    // return prefix length
    mov r0, r8

    pop {r4-r10, pc}


empty_result:
    mov r0, #0
    strb r0, [r6]

    pop {r4-r10, pc}