.syntax unified
.text

.global maxArea

maxArea:
    push {r4-r10, lr}

    // r4 = height
    mov r4, r0

    // r5 = n
    mov r5, r1

    // left = 0
    mov r6, #0

    // right = n - 1
    sub r7, r5, #1

    // best = 0
    mov r8, #0


loop:
    // while (left < right)
    cmp r6, r7
    bge done

    // height[left]
    ldr r9, [r4, r6, lsl #2]

    // height[right]
    ldr r10, [r4, r7, lsl #2]

    // width = right - left
    sub r1, r7, r6

    // h = min(height[left], height[right])
    cmp r9, r10
    movle r2, r9
    movgt r2, r10

    // area = width * h
    mul r3, r1, r2

    // if (area > best)
    cmp r3, r8
    movgt r8, r3

    // if (height[left] < height[right])
    cmp r9, r10
    blt move_left

    // otherwise right--
    sub r7, r7, #1
    b loop


move_left:
    add r6, r6, #1
    b loop


done:
    mov r0, r8

    pop {r4-r10, pc}