#pragma once

#include <Windows.h>

#include <cstdint>

namespace sade {

constexpr std::uint32_t kExternalRawInputMagic = 0x53414445U;
constexpr std::uint32_t kExternalRawInputVersion = 1U;

// Shared only between the ASI and its companion process. All mutable fields use
// Win32 interlocked operations, so neither side needs to block the input path.
struct ExternalRawInputShared {
  std::uint32_t magic = kExternalRawInputMagic;
  std::uint32_t version = kExternalRawInputVersion;
  volatile LONG64 pending_x = 0;
  volatile LONG64 pending_y = 0;
  volatile LONG64 last_qpc = 0;
  volatile LONG64 packet_count = 0;
};

}  // namespace sade
