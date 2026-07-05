#pragma once

#include <Windows.h>

#include <cstdint>

namespace sade {

struct RawInputEvent {
  std::uint64_t sequence = 0;
  std::int64_t qpc = 0;
  HRAWINPUT handle = nullptr;
  HANDLE device = nullptr;
  std::uint32_t command = 0;
  std::uint32_t flags = 0;
  std::int32_t x = 0;
  std::int32_t y = 0;
  std::uint32_t button_flags = 0;
  std::uint32_t button_data = 0;
  std::uint32_t deduplicated = 0;
};

struct RawInputStatistics {
  std::uint64_t observed = 0;
  std::uint64_t buffered_observed = 0;
  std::uint64_t duplicates = 0;
  std::uint64_t size_queries = 0;
  std::uint64_t buffer_size_queries = 0;
  std::uint64_t non_mouse = 0;
  std::uint64_t errors = 0;
  std::uint64_t buffer_errors = 0;
  std::uint64_t registrations = 0;
  std::uint64_t wm_input_messages = 0;
  std::uint64_t overflow = 0;
  std::int64_t accumulated_x = 0;
  std::int64_t accumulated_y = 0;
};

}  // namespace sade
