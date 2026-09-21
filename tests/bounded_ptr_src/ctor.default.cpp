//
// Tests for
//  explicit bounded_ptr();
//

#include "test_utils.h"
#include <darwintest.h>
#include <darwintest_utils.h>
#include <libkern/c++/bounded_ptr.h>

#define _assert(...) T_ASSERT_TRUE((__VA_ARGS__), #__VA_ARGS__)

struct T {};

template <typename T> static void tests() {
  {
    test_bounded_ptr<T> p;
    _assert(p == nullptr);
  }
  {
    test_bounded_ptr<T> p{};
    _assert(p == nullptr);
  }
}

T_DECL(ctor_default, "bounded_ptr.ctor.default", T_META_TAG_VM_PREFERRED) {
  tests<T>();
  tests<T const>();
  tests<T volatile>();
  tests<T const volatile>();
}
