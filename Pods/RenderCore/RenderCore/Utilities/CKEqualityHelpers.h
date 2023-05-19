/*
 *  Copyright (c) 2014-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#import <RenderCore/CKDefines.h>

#if CK_NOT_SWIFT

#import <Foundation/Foundation.h>

#import <string>
#import <vector>

// From folly:
// This is the Hash128to64 function from Google's cityhash (available
// under the MIT License).  We use it to reduce multiple 64 bit hashes
// into a single hash.
inline uint64_t CKHashCombine(const uint64_t upper, const uint64_t lower) {
  // Murmur-inspired hashing.
  const uint64_t kMul = 0x9ddfea08eb382d69ULL;
  uint64_t a = (lower ^ upper) * kMul;
  a ^= (a >> 47);
  uint64_t b = (upper ^ a) * kMul;
  b ^= (b >> 47);
  b *= kMul;
  return b;
}

// fnv-1 hash function
inline uint64_t CKHashCString(const char *str)
{
  uint64_t retval = 0;
  unsigned char *s = (unsigned char *)str;

  while (*s) {
    retval *= (uint64_t)0x100000001b3ULL;
    retval ^= (uint64_t)*s++;
  }

  return retval;
}

#if __LP64__
inline size_t CKHash64ToNative(uint64_t key) {
  return key;
}
#else
// Thomas Wang downscaling hash function
inline size_t CKHash64ToNative(uint64_t key) {
  key = (~key) + (key << 18);
  key = key ^ (key >> 31);
  key = key * 21;
  key = key ^ (key >> 11);
  key = key + (key << 6);
  key = key ^ (key >> 22);
  return (uint32_t) key;
}
#endif

NSUInteger CKIntegerArrayHash(const NSUInteger *subhashes, NSUInteger count);

namespace CK {
  // Default is not an ObjC class
  template<typename T, typename V = bool>
  struct is_objc_class : std::false_type { };

  // Conditionally enable this template specialization on whether T is convertible to id, makes the is_objc_class a true_type
  template<typename T>
  struct is_objc_class<T, typename std::enable_if<std::is_convertible<T, id>::value, bool>::type> : std::true_type { };

  // CKUtils::hash<T>()(value) -> either std::hash<T> if c++ or [o hash] if ObjC object.
  template <typename T, typename Enable = void> struct hash;

  // For non-objc types, defer to std::hash
  template <typename T> struct hash<T, typename std::enable_if<!is_objc_class<T>::value>::type> {
    size_t operator ()(const T& a) const {
      return std::hash<T>()(a);
    }
  };

  // For objc types, call [o hash]
  template <typename T> struct hash<T, typename std::enable_if<is_objc_class<T>::value>::type> {
    size_t operator ()(id o) const {
      return [o hash];
    }
  };

  template <typename T, typename Enable = void> struct is_equal;

  // For non-objc types use == operator
  template <typename T> struct is_equal<T, typename std::enable_if<!is_objc_class<T>::value>::type> {
    bool operator ()(const T& a, const T& b) const {
      return a == b;
    }
  };

  // For objc types, check pointer equality, then use -isEqual:
  template <typename T> struct is_equal<T, typename std::enable_if<is_objc_class<T>::value>::type> {
    bool operator ()(id a, id b) const {
      return a == b || [a isEqual:b];
    }
  };

};

namespace CKTupleOperations
{
  // Recursive case (hash up to Index)
  template <class Tuple, size_t Index = std::tuple_size<Tuple>::value - 1>
  struct _hash_helper
  {
    static size_t hash(Tuple const& tuple)
    {
      size_t prev = _hash_helper<Tuple, Index-1>::hash(tuple);
      using TypeForIndex = typename std::tuple_element<Index,Tuple>::type;
      size_t thisHash = CK::hash<TypeForIndex>()(std::get<Index>(tuple));
      return CKHash64ToNative(CKHashCombine(prev, thisHash));
    }
  };

  // Base case (hash 0th element)
  template <class Tuple>
  struct _hash_helper<Tuple, 0>
  {
    static size_t hash(Tuple const& tuple)
    {
      using TypeForIndex = typename std::tuple_element<0,Tuple>::type;
      return CK::hash<TypeForIndex>()(std::get<0>(tuple));
    }
  };

  // Recursive case (elements equal up to Index)
  template <class Tuple, size_t Index = std::tuple_size<Tuple>::value - 1>
  struct _eq_helper
  {
    static bool equal(Tuple const& a, Tuple const& b)
    {
      bool prev = _eq_helper<Tuple, Index-1>::equal(a, b);
      using TypeForIndex = typename std::tuple_element<Index,Tuple>::type;
      auto aValue = std::get<Index>(a);
      auto bValue = std::get<Index>(b);
      return prev && CK::is_equal<TypeForIndex>()(aValue, bValue);
    }
  };

  // Base case (0th elements equal)
  template <class Tuple>
  struct _eq_helper<Tuple, 0>
  {
    static bool equal(Tuple const& a, Tuple const& b)
    {
      using TypeForIndex = typename std::tuple_element<0,Tuple>::type;
      auto& aValue = std::get<0>(a);
      auto& bValue = std::get<0>(b);
      return CK::is_equal<TypeForIndex>()(aValue, bValue);
    }
  };


  template <typename ... TT> struct hash;

  template <typename ... TT>
  struct hash<std::tuple<TT...>>
  {
    size_t operator()(std::tuple<TT...> const& tt) const
    {
      return _hash_helper<std::tuple<TT...>>::hash(tt);
    }
  };


  template <typename ... TT> struct equal_to;

  template <typename ... TT>
  struct equal_to<std::tuple<TT...>>
  {
    bool operator()(std::tuple<TT...> const& a, std::tuple<TT...> const& b) const
    {
      return _eq_helper<std::tuple<TT...>>::equal(a, b);
    }
  };

}

/** Correctly equates two objects, including cases where both objects are nil (where `isEqual:` would return NO). */
inline BOOL CKObjectIsEqual(id<NSObject> obj, id<NSObject> otherObj)
{
  return obj == otherObj || [obj isEqual:otherObj];
}

typedef BOOL (^CKEqualityComparisonBlock)(id object, id comparisonObject);

/**
 * Correctly executes the comparisonBlock for two objects, including cases one of the objects is nil or
 * of a different type (where `isEqual:` would return NO).
 */
inline BOOL CKCompareObjectEquality(id object, id comparisonObject, CKEqualityComparisonBlock comparisonBlock) {
  if (object == comparisonObject) {
    return YES;
  } else if (!object || !comparisonObject || ![comparisonObject isKindOfClass:[object class]]) {
    return NO;
  }
  return comparisonBlock(object, comparisonObject);
}

/** Correctly equates two vectors of keys (scope state key) */
inline bool CKKeyVectorsEqual(const std::vector<id<NSObject>> &a, const std::vector<id<NSObject>> &b)
{
  if (a.size() != b.size()) {
    return false;
  }
  return std::equal(a.begin(), a.end(), b.begin(), [](id<NSObject> x, id<NSObject> y){
    return CKObjectIsEqual(x, y); // be pedantic and use a lambda here becuase BOOL != bool
  });
}

#endif
