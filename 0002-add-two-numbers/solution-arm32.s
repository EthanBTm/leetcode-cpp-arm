.syntax unified
.text

.global addTwoNumbers
.extern malloc

addTwoNumbers:
    // Save registers and link register
    push {r4-r10, lr}

    // r4 = l1
    mov r4, r0

    // r5 = l2
    mov r5, r1

    // r6 = head
    mov r6, #0

    // r7 = tail
    mov r7, #0

    // r8 = carry
    mov r8, #0


loop:
    // while (l1 != NULL || l2 != NULL || carry != 0)

    cmp r4, #0
    bne process

    cmp r5, #0
    bne process

    cmp r8, #0
    bne process

    b done


process:
    // sum = carry
    mov r9, r8


    // -------------------------
    // if (l1 != NULL)
    // -------------------------
    cmp r4, #0
    beq skip_l1

    // sum += l1->val
    ldr r10, [r4]
    add r9, r9, r10

    // l1 = l1->next
    ldr r4, [r4, #4]

skip_l1:


    // -------------------------
    // if (l2 != NULL)
    // -------------------------
    cmp r5, #0
    beq skip_l2

    // sum += l2->val
    ldr r10, [r5]
    add r9, r9, r10

    // l2 = l2->next
    ldr r5, [r5, #4]

skip_l2:


    // -------------------------
    // Calculate carry and digit
    // -------------------------
    //
    // sum can only be 0..19
    //
    // if sum >= 10:
    //     carry = 1
    //     digit = sum - 10
    // else:
    //     carry = 0
    //     digit = sum
    //

    cmp r9, #10
    blt no_carry

    mov r8, #1
    sub r10, r9, #10
    b make_node


no_carry:
    mov r8, #0
    mov r10, r9


make_node:
    // r10 = digit

    // Save digit because malloc can overwrite r0-r3
    push {r10}

    // sizeof(ListNode) = 8 bytes
    mov r0, #8
    bl malloc

    // r0 = new node

    // Restore digit
    pop {r10}

    // node->val = digit
    str r10, [r0]

    // node->next = NULL
    mov r1, #0
    str r1, [r0, #4]


    // -------------------------
    // Append new node
    // -------------------------

    // if (head != NULL)
    cmp r6, #0
    bne append

    // First node:
    // head = node
    mov r6, r0

    // tail = node
    mov r7, r0

    b loop


append:
    // tail->next = node
    str r0, [r7, #4]

    // tail = node
    mov r7, r0

    b loop


done:
    // return head
    mov r0, r6

    pop {r4-r10, pc}
