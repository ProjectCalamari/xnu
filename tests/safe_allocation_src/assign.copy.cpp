//
// Tests for
//  safe_allocation& operator=(safe_allocation const&) = delete;
//

#include "test_utils.h"
#include <darwintest.h>
#include <libkern/c++/safe_allocation.h>
#include <type_traits>

struct T {};

T_DECL(assign_copy, "safe_allocation.assign.copy", T_META_TAG_VM_PREFERRED) {
  static_assert(!std::is_copy_assignable_v<test_safe_allocation<T>>);
  T_PASS("safe_allocation.assign.copy passed");
}
