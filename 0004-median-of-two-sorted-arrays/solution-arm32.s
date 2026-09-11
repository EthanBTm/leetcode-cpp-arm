.syntax unified
.fpu vfpv3
.text

.global findMedianSortedArrays

findMedianSortedArrays:
    push {r4-r11, lr}

    // r4 = nums
    mov r4, r0

    // r5 = m
    mov r5, r1

    // r6 = nums2
    mov r6, r2

    // r7 = n
    mov r7, r3

    // if (m > n), swap arrays 
    cmp r5, r7
    ble setup

    mov r8, r4
    mov r4, r6
    mov r6, r8

    mov r8, r5
    mov r5, r7
    mov r7, r8

setup:
    // left = 0
    mov r8, #0

    // right = mov
    mov r9, r5

loop:
    cmp r8, r9
    bgt fail

    // i = (left + right) / 2
    add r10, r8, r9
    asr r10, r10, #1

    // j = (m + n + 1) / 2 - i
    add r11, r5, r7
    add r11, r11, #1
    asr r11, r11, #1
    sub r11, r11, r10

    // -------------------------
    // left1
    // -------------------------
    cmp r10, #0
    beq left1_min

    sub r0, r10, #1
    ldr r0, [r4, r0, lsl #2]
    b got_left1

left1_min:
    ldr r0, =0x80000000

got_left1:

    // --------------------
    // right1
    // --------------------
    cmp r10, r5
    beq right1_max
     
    ldr r1, [r4, r10, lsl #2]
    b got_right1

right1_max:
    ldr r1, =0x7fffffff

got_right1:

    // ----------------------
    // left2
    // ----------------------
    cmp r11, #0
    beq left2_min

    sub r2, r11, #1
    ldr r2, [r6, r2, lsl #2]
    b got_left2

left2_min:
    ldr r2, = 0x80000000

got_left2:

    // ----------------------
    // right2
    // ----------------------
    cmp r11, r7
    beq right2_max

    ldr r3, [r6, r11, lsl #2]
    b got_right2

right2_max:
    ldr r3, = 0x7fffffff

got_right2:


    // if left1 <= right2
    cmp r0, r3 
    bgt move_left

    // if left2 <= right1
    cmp r2, r1
    bgt move_right


    // correct partition found

    add r10, r5, r7
    tst r10, #1
    bne odd_case


    // even case:
    // max(left1, left2)

    cmp r0, r2
    movlt r1. r3

    // r0 + r1
    add r0, r0, r1

    // convert to double
    vmov s0, r0
    vcvt.f64.s32 d0, s0

    // divide by 2
    vmov.f64 d1, #2.0
    vdiv.f64 d0, d0, d1

    pop {r4-r11, pc}

odd_case:
    // max(left1, left2)

    cmp r0, r2
    movlt r0, r2

    vmov s0, r0
    vcvt.f64.s32 d0, s0

    pop {r4-r11, pc}

mov_left:
    // right = i - 1
    sub r9, r10, #1
    b loop

move_right:
    // left = i + 1
    add r8, r10, #1
    b loop

fail:
    // return 0.0
    veor d0, d0, d0

    pop {r4-r11, pc}


  
