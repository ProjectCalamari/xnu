/*!
 * @header
 * Shims for the kernel extension.
 */
#ifndef __IMG4_SHIM_XNU_H
#define __IMG4_SHIM_XNU_H

#ifndef __IMG4_INDIRECT
#error "Please #include <img4/firmware.h> instead of this file directly"
#endif // __IMG4_INDIRECT

#if !XNU_KERNEL_PRIVATE
#include <Availability.h>
#include <TargetConditionals.h>
#endif

#include <os/base.h>
#include <stdbool.h>
#include <stdint.h>
#include <sys/cdefs.h>
#include <sys/linker_set.h>

#endif // __IMG4_SHIM_XNU_H
