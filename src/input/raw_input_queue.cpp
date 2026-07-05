#include "input/raw_input_queue.h"

namespace sade {

RawInputQueue::RawInputQueue(std::size_t capacity) : buffer_(capacity == 0 ? 1 : capacity) {}

void RawInputQueue::reset() {
  std::lock_guard lock(mutex_);
  head_ = 0;
  size_ = 0;
  stats_ = {};
  pending_x_ = 0;
  pending_y_ = 0;
}

void RawInputQueue::push(const RawInputEvent& event) {
  std::lock_guard lock(mutex_);
  if (buffer_.empty()) {
    ++stats_.overflow;
    return;
  }

  const auto index = (head_ + size_) % buffer_.size();
  if (size_ == buffer_.size()) {
    head_ = (head_ + 1) % buffer_.size();
    ++stats_.overflow;
  } else {
    ++size_;
  }

  buffer_[index] = event;
  ++stats_.observed;
  stats_.duplicates += event.deduplicated ? 1 : 0;
  if (!event.deduplicated) {
    stats_.accumulated_x += event.x;
    stats_.accumulated_y += event.y;
    pending_x_ += event.x;
    pending_y_ += event.y;
  }
}

void RawInputQueue::record_buffered_observed() {
  std::lock_guard lock(mutex_);
  ++stats_.buffered_observed;
}

void RawInputQueue::record_size_query() {
  std::lock_guard lock(mutex_);
  ++stats_.size_queries;
}

void RawInputQueue::record_buffer_size_query() {
  std::lock_guard lock(mutex_);
  ++stats_.buffer_size_queries;
}

void RawInputQueue::record_non_mouse() {
  std::lock_guard lock(mutex_);
  ++stats_.non_mouse;
}

void RawInputQueue::record_error() {
  std::lock_guard lock(mutex_);
  ++stats_.errors;
}

void RawInputQueue::record_buffer_error() {
  std::lock_guard lock(mutex_);
  ++stats_.buffer_errors;
}

void RawInputQueue::record_registration() {
  std::lock_guard lock(mutex_);
  ++stats_.registrations;
}

void RawInputQueue::record_wm_input_message() {
  std::lock_guard lock(mutex_);
  ++stats_.wm_input_messages;
}

std::pair<std::int64_t, std::int64_t> RawInputQueue::consume_pending_delta() {
  std::lock_guard lock(mutex_);
  const auto delta = std::pair{pending_x_, pending_y_};
  pending_x_ = 0;
  pending_y_ = 0;
  return delta;
}

std::vector<RawInputEvent> RawInputQueue::drain() {
  std::lock_guard lock(mutex_);
  std::vector<RawInputEvent> out;
  out.reserve(size_);
  for (std::size_t i = 0; i < size_; ++i) {
    out.push_back(buffer_[(head_ + i) % buffer_.size()]);
  }
  head_ = 0;
  size_ = 0;
  return out;
}

RawInputStatistics RawInputQueue::statistics() const {
  std::lock_guard lock(mutex_);
  auto copy = stats_;
  return copy;
}

std::size_t RawInputQueue::capacity() const {
  return buffer_.size();
}

bool RawInputDeduplicator::is_duplicate(HRAWINPUT handle, const RAWMOUSE& mouse, std::int64_t qpc) {
  std::lock_guard lock(mutex_);
  for (const auto& entry : entries_) {
    if (entry.handle == handle && entry.x == mouse.lLastX && entry.y == mouse.lLastY && entry.flags == mouse.usFlags &&
        entry.button_flags == mouse.usButtonFlags && entry.button_data == mouse.usButtonData) {
      return true;
    }
  }

  entries_[next_] = Entry{handle, mouse.lLastX, mouse.lLastY, mouse.usFlags, mouse.usButtonFlags, mouse.usButtonData, qpc};
  next_ = (next_ + 1) % kHistory;
  return false;
}

void RawInputDeduplicator::reset() {
  std::lock_guard lock(mutex_);
  for (auto& entry : entries_) {
    entry = {};
  }
  next_ = 0;
}

}  // namespace sade
