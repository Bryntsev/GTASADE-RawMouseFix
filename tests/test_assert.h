#pragma once

#include <stdexcept>
#include <sstream>
#include <string>

inline void require_true(bool value, const char* expression, const char* file, int line) {
  if (!value) {
    throw std::runtime_error(std::string(file) + ":" + std::to_string(line) + " failed: " + expression);
  }
}

#define REQUIRE_TRUE(expr) require_true((expr), #expr, __FILE__, __LINE__)

template <typename Actual, typename Expected>
inline void require_eq(const Actual& actual, const Expected& expected, const char* actual_expr, const char* expected_expr,
                       const char* file, int line) {
  if (!(actual == expected)) {
    std::ostringstream message;
    message << file << ':' << line << " failed: " << actual_expr << " == " << expected_expr << " (actual=" << actual
            << ", expected=" << expected << ')';
    throw std::runtime_error(message.str());
  }
}

#define REQUIRE_EQ(actual, expected) require_eq((actual), (expected), #actual, #expected, __FILE__, __LINE__)
