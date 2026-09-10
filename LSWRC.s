.syntax unified
.text
.global lengthOfLongestSubstring

lengthOfLongestSubstring:
    push {r4-r11, lr}

    // r4 = string pointer
    mov r4, r0

    // r5 = string
    mov r5, r1
    
    // allocate 128 * 4 = 512 bytes for last[]
    sub sp, sp, #512

    // r6 = pointer to last[]
    mov r6, sp

    // ----------------------------
    // initialize last[] to -1
    // ----------------------------

    mov r7, #0
    mvn r8, #0             // r8 = -1

init_loop:
    cmp r7, #128
    bge init_done

    str r8, [r6, r7, lsl #2]

    add r7, r7, #1
    b init_loop

init_done:
    // r7 = left
    mov r7, #0

    // r8 = best
    mov r8, #0

    // r9 = right
    mov r9, #0

loop:
    cmp r9, r5
    bge done

    // c = s[string]
    ldrb r10, [r4, r9]

    // last[c]
    ldr r11, [r6, r10, lsl #2]

    // if (last[c] >= left)
    cmp r11, r7
    blt skip_left_update

    // left = last[c] + 1
    add r7, r11, #1

skip_left_update:
    // last[c] = right
    str r9, [r6, r10, lsl #2]

    // length = right - left + 1
    sub r11, r9, r7
    add r11, r11, #1

    // if (length > best)
    cmp r11, r8
    ble skip_best_update

    mov r8, r11

skip_best_update:
    add r9, r9, #1
    b loop

done:
    // return best
    mov r0, r8

    // free local array
    add sp, sp, #512

    pop {r4-r11, pc}