#pragma once

#include "common/build_fingerprint.h"

#include <optional>
#include <string>

namespace sade {

std::optional<BuildFingerprint> read_pe_fingerprint(const std::wstring& path);

}  // namespace sade
