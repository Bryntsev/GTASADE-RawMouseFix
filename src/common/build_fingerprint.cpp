#include "common/build_fingerprint.h"

#include "common/pe_fingerprint.h"

namespace sade {

std::optional<BuildFingerprint> collect_build_fingerprint(const std::wstring& module_path) {
  return read_pe_fingerprint(module_path);
}

}  // namespace sade
