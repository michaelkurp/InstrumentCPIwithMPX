#include <stdint.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/syscall.h>

#define __CPI_INLINE __attribute__((always_inline)) __attribute__((weak))

__CPI_INLINE void __cpi__init() {
	syscall(SYS_prctl, 43, 0, 0, 0, 0);
}
