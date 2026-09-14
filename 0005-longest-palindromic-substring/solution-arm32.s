.syntax unified 
.text

.global longestPalindrome

longestPalindrome:
    push {r4-r11, lr}

    // r0 = s
    // r1 = length
    // r2 = outStart
    // r3 = outLength

    mov r4, r0  // string
    mov r5, r1  // length
    mov r6, r2  // outStart
    mov r7, r3  // outLength

    // bestStart = 0
    mov r8, #0

    // bestLength = 1
    mov r9, #1

    // i = 0
    mov r10, #0


main_loop:
    cmp r10, r5
    bge done


    // -----------------------------------
    // odd palindrome
    // left = i
    // right = i
    // -----------------------------------

    mov r0, r10
    mov r1, r10


odd_loop:
    cmp r0, #0
    blt even_setup

    cmp r1, r5
    bge even_setup

    ldrb r2, [r4, r0]
    ldrb r3, [r4, r1]

    cmp r2, r3
    bne even_setup

    // len = right - left + 1
    sub r11, r1, r0
    add r11, r11, #1

    cmp r11, r9
    ble odd_expand

    mov r9, r11
    mov r8, r0

odd_expand:
    sub r0, r0, #1
    add r1, r1, #1
    b odd_loop


even_setup:
    // left = i
    // right = i + 1

    mov r0, r10
    add r1, r10, #1


even_loop:
    cmp r10, #0
    blt next_center

    cmp r1, r5
    bge next_center

    ldrb r2, [r4, r0]
    ldrb r3, [r4, r1]

    cmp r2, r3
    bne next_center

    // len = right - left + 1
    sub r11, r1, r0
    add r11, r11, #1

    cmp r11, r9
    ble even_expand

    mov r9, r11
    mov r8, r0


even_expand:
    sub r0, r0, #1
    add r1, r1, #1
    b even_loop


next_center:
    add r10, r10, #1
    b main_loop


done:
    // *outStart = bestStart
    str r8, [r6]

    // *outLength = bestLength
    str r9, [r7]

    pop {r4-r11, pc}
