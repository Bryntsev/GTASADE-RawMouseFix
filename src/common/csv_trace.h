#pragma once

#include <mutex>
#include <string>

namespace sade {

class CsvTrace {
 public:
  bool open(const std::wstring& path, const std::string& header);
  void write_row(const std::string& row);
  void close();

 private:
  void flush_locked();

  std::mutex mutex_;
  void* file_ = nullptr;
  std::string buffer_;
};

}  // namespace sade
