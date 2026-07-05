#include "common/csv_trace.h"

#include <Windows.h>

namespace sade {

bool CsvTrace::open(const std::wstring& path, const std::string& header) {
  std::lock_guard lock(mutex_);
  file_ = CreateFileW(path.c_str(), GENERIC_WRITE, FILE_SHARE_READ, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
  if (file_ == INVALID_HANDLE_VALUE) {
    return false;
  }
  buffer_.clear();
  const std::string line = header + "\r\n";
  buffer_ += line;
  flush_locked();
  return true;
}

void CsvTrace::write_row(const std::string& row) {
  std::lock_guard lock(mutex_);
  if (file_ == nullptr || file_ == INVALID_HANDLE_VALUE) {
    return;
  }
  const std::string line = row + "\r\n";
  buffer_ += line;
  if (buffer_.size() >= 64 * 1024) {
    flush_locked();
  }
}

void CsvTrace::close() {
  std::lock_guard lock(mutex_);
  if (file_ != nullptr && file_ != INVALID_HANDLE_VALUE) {
    flush_locked();
    CloseHandle(file_);
  }
  file_ = nullptr;
  buffer_.clear();
}

void CsvTrace::flush_locked() {
  if (file_ == nullptr || file_ == INVALID_HANDLE_VALUE || buffer_.empty()) {
    return;
  }
  DWORD written = 0;
  WriteFile(file_, buffer_.data(), static_cast<DWORD>(buffer_.size()), &written, nullptr);
  buffer_.clear();
}

}  // namespace sade
