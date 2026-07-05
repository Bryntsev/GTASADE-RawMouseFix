#pragma once

#include "input/raw_input_event.h"

#include <atomic>
#include <cstddef>
#include <mutex>
#include <utility>
#include <vector>

namespace sade {

class RawInputQueue {
 public:
  explicit RawInputQueue(std::size_t capacity = 65536);

  void reset();
  void push(const RawInputEvent& event);
  void record_buffered_observed();
  void record_size_query();
  void record_buffer_size_query();
  void record_non_mouse();
  void record_error();
  void record_buffer_error();
  void record_registration();
  void record_wm_input_message();
  std::pair<std::int64_t, std::int64_t> consume_pending_delta();
  std::vector<RawInputEvent> drain();
  RawInputStatistics statistics() const;
  std::size_t capacity() const;

 private:
  mutable std::mutex mutex_;
  std::vector<RawInputEvent> buffer_;
  std::size_t head_ = 0;
  std::size_t size_ = 0;
  RawInputStatistics stats_{};
  std::int64_t pending_x_ = 0;
  std::int64_t pending_y_ = 0;
};

class RawInputDeduplicator {
 public:
  bool is_duplicate(HRAWINPUT handle, const RAWMOUSE& mouse, std::int64_t qpc);
  void reset();

 private:
  static constexpr std::size_t kHistory = 128;

  struct Entry {
    HRAWINPUT handle = nullptr;
    LONG x = 0;
    LONG y = 0;
    USHORT flags = 0;
    USHORT button_flags = 0;
    USHORT button_data = 0;
    std::int64_t qpc = 0;
  };

  std::mutex mutex_;
  Entry entries_[kHistory]{};
  std::size_t next_ = 0;
};

}  // namespace sade
