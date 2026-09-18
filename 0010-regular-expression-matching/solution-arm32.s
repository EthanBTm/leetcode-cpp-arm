.syntax unified
.text

.glogal regexMatch

regexMatch:
    push {r4-r11, lr}

    // r4 = s
    mov r4, r0

    // r5 = sLen
    mov r5, r1

    // r6 = p
    mov r6, r2

    // r7 = plan
    mov r7, r3

    // We use a fixed 21 x 21 byte DP table
    // because constraints are <= 20

    sub sp, sp, #448
    mov t8, sp

    // ----------------------------------------
    // Clear DP table
    // ----------------------------------------

    mov r9, #0

clear_loop:
    cmp r9, #441
    bge clear_done

    mov r10, #0
    strb r10, [r8, r9]

    add r9, r9, #1
    b clear_loop


clear_done:
    // dp[0][0] = 1
    mov r9, #1
    strb r9, [r8]


    // ---------------------------------------
    // Initialize empty-string matches
    // ---------------------------------------
    mov r9, #2

init_empty:
    cmp r9, r7
    bgt main_i

    sub r10, r9, #1
    ldrb r11, [r6, r10]

    cmp r11, #'*'
    bne init_next

    // index = j
    // dp[0][j] = dp[0][j-2]
    sub r10, r9, #2
    ldrb r11, [r8, r10]
    strb r11, [r8, r9]

init_next:
    add r9, r9, #1
    b init_empty


    // -----------------------------------------
    // i = 1
    // -----------------------------------------
main_i:
    mov r9, #1

i_loop:
    cmp r9, r5
    bgt finish

    mov r10, #1


j_loop:
    cmp r10, r7
    bgt next_i

    // p[j-1]
    sub r0, r10, #1
    ldrb r1, [r6, r0]

    // s[i-1]
    sub r0, r9, #1
    ldrb r2, [r4, r0]

    // ------------------------------------------
    // if p[j-1] == '.' or s[i-1]
    // ------------------------------------------

    cmp r1, #'.'
    beq normal_match

    cmp r1, r2
    beq normal_match

    cmp r1, #'*'
    beq star_case

    b next_j


normal_match:
    // dp[i][j] = dp[i-1][j-1]

    sub r0, r9, #1
    mov r1, #21
    mul r0, r0, r1

    sub r1, r10, #1
    add r0, r0, r1

    ldrb r2, [r8, r0]

    mov r0, #21
    mul r1, r9, r0
    add r1, r1, r10

    strb r2, [r8, r1]

    b next_j


star_case:
    // dp[i][j] = dp[i][j-2]

    mov r0, #21
    mul r1, r9, r0

    sub r2, r10, #2
    add r3, r1, r2

    ldrb r11, [r8, r3]

    add r3, r1, r10
    strb r11, [r8, r3]

    // check p[j-2]

    sub r0, r10, #2
    ldrb r1, [r6, r0]

    sub r0, r9, #1
    ldrb r2, [r4, r0]

    cmp r1, #'.'
    beq star_match

    cmp r1, r2
    bne next_j


star_match:
    // if dp[i-1][j] == 1
    // set dp[i][j] = 1

    sub r0, r9, #1
    mov r1, #21
    mul r0, r0, r1
    add r0, r0, r10

    ldrb r1, [r8, r0]

    cmp r1, #0
    beq next_j

    mov r0, #21
    mul r1, r9, r0
    add r1, r1, r10

    mov r0, #1
    strb r0, [r8, r1]


next_j:
    add r10, r10, #1
    b j_loop


next_i:
    add r9, r9, #1
    b i_loop


finish:
    // return dp[sLen][pLen]

    mov r0, #21
    mul r1, r5, r0
    add r1, r1, r7

    ldrb r0, [r8, r1]

    add sp, sp, #448
    pop {r4-r11, pc}

    