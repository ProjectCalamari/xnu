#ifndef TESTS_INTRUSIVE_SHARED_PTR_ABI_HELPER_H
#define TESTS_INTRUSIVE_SHARED_PTR_ABI_HELPER_H

#include "test_policy.h"
#include <darwintest.h>
#include <libkern/c++/intrusive_shared_ptr.h>

struct T {
  int i;
};

#if defined USE_SHARED_PTR
template <typename T>
using SharedPtr = libkern::intrusive_shared_ptr<T, test_policy>;
#else
template <typename T> using SharedPtr = T *;
#endif

extern SharedPtr<T> return_shared_as_raw(T *);
extern SharedPtr<T> return_raw_as_shared(T *);

#endif // !TESTS_INTRUSIVE_SHARED_PTR_ABI_HELPER_H
