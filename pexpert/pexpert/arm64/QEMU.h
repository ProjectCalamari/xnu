/* Board support for QEMU's aarch64 virt machine with a Cortex-A53 CPU. */
#ifndef _PEXPERT_ARM64_QEMU_H
#define _PEXPERT_ARM64_QEMU_H

#define NO_MONITOR 1
#define QEMU 1
#define OSS_HARDWARE 1
#define NO_ECORE 1
#define CORE_NCTRS 6

/* Leave __ARM_16K_PG__ undefined: this board uses 4K pages. */
#define __ARM_RANGE_TLBI__ 0
#define ARM_PARAMETERIZED_PMAP 1

#include <pexpert/arm64/apple_arm64_common.h>
#undef BTI_ENFORCED
#define BTI_ENFORCED 0
#undef __ARM64_PMAP_SUBPAGE_L1__
#undef __ARM64_PMAP_KERN_SUBPAGE_L1__
#undef __ARM_V8_CRYPTO_EXTENSIONS__
#undef APPLE_ARM64_ARCH_FAMILY

#define PL011_UART 1

#ifndef ASSEMBLER
#define PLATFORM_PANIC_LOG_DISABLED
#endif

#define GIC_SPURIOUS_IRQ 1023
#define GICD_PHYS_BASE 0x08000000ULL
#define GICD_SIZE 0x1000
#define GICC_PHYS_BASE 0x08010000ULL
#define GICC_SIZE 0x1000

#define GICD_CTLR 0x0
#define GICD_CTLR_ENABLEGRP0 0x1
#define GICD_CTLR_ENABLEGRP1 0x2

#define GICC_CTLR 0x0
#define GICC_PMR 0x4
#define GICC_BPR 0x8
#define GICC_IAR 0xc
#define GICC_EOIR 0x10
#define GICC_CTLR_ENABLEGRP0 0x1
#define GICC_CTLR_ENABLEGRP1 0x2

#endif /* !_PEXPERT_ARM64_QEMU_H */
