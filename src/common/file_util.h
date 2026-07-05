#pragma once

#include <string>

namespace sade {

std::wstring module_directory(void* module_handle);
std::wstring process_exe_path();
std::wstring join_path(const std::wstring& left, const std::wstring& right);

}  // namespace sade
