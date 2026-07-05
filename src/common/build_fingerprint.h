#pragma once

#include <optional>
#include <cstdint>
#include <string>

namespace sade {

struct BuildFingerprint {
  std::wstring path;
  std::uint64_t size = 0;
  std::string sha256;
  std::string text_sha256;
  std::string file_version;
  std::uint32_t pe_timestamp = 0;
  std::uint64_t image_base = 0;
  std::uint32_t entry_point_rva = 0;
  std::uint32_t size_of_image = 0;
  bool is_x64 = false;
};

std::optional<BuildFingerprint> collect_build_fingerprint(const std::wstring& module_path);

}  // namespace sade
