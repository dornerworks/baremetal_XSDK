#if defined(__LP64__) || defined(_LP64)
.equ lock, 1
.equ unlock, 0

.global _trylock_mutex
_trylock_mutex:
    ldr     w1, =lock
    ldxr    w2, [x0]
    cmp     w2, w1
    b.eq    locked
    stxr    w2, w1, [x0]
locked:
    dmb     sy
    mov     w0, w2
    ret

.global _unlock_mutex
_unlock_mutex:
    ldr     w1, =unlock
    dmb     sy
    str     w1, [x0]
    ret
#else
.equ lock, 1
.equ unlock, 0

.global _trylock_mutex
_trylock_mutex:
    ldr     r1, =lock
    ldrex   r2, [r0]
    cmp     r2, r1
    strexne r2, r1, [r0]
locked:
    dmb
    mov     r0, r2
    bx      lr

.global _unlock_mutex
_unlock_mutex:
    ldr     r1, =unlock
    dmb
    str     r1, [r0]
    bx      lr
#endif
