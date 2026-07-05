#include "common/config.h"

#include <Windows.h>

#include <filesystem>
#include <fstream>
#include <cwchar>
#include <string>

namespace sade {
namespace {

bool read_bool(const wchar_t* section, const wchar_t* key, bool fallback, const std::wstring& path) {
  const auto value = GetPrivateProfileIntW(section, key, fallback ? 1 : 0, path.c_str());
  return value != 0;
}

std::uint32_t read_u32(const wchar_t* section,
                       const wchar_t* key,
                       std::uint32_t fallback,
                       const std::wstring& path) {
  return GetPrivateProfileIntW(section, key, fallback, path.c_str());
}

std::int32_t read_i32(const wchar_t* section,
                      const wchar_t* key,
                      std::int32_t fallback,
                      const std::wstring& path) {
  return GetPrivateProfileIntW(section, key, fallback, path.c_str());
}

float read_float(const wchar_t* section, const wchar_t* key, float fallback, const std::wstring& path) {
  wchar_t buffer[64]{};
  wchar_t fallback_buffer[64]{};
  swprintf_s(fallback_buffer, L"%.6f", static_cast<double>(fallback));
  GetPrivateProfileStringW(section, key, fallback_buffer, buffer, static_cast<DWORD>(std::size(buffer)), path.c_str());
  wchar_t* end = nullptr;
  const double value = std::wcstod(buffer, &end);
  if (end == buffer) {
    return fallback;
  }
  return static_cast<float>(value);
}

}  // namespace

void write_default_config_if_missing(const std::wstring& ini_path) {
  if (std::filesystem::exists(ini_path)) {
    return;
  }

  std::wofstream out(ini_path);
  out << L"[Diagnostics]\n";
  out << L"ObserveRawInput=1\n";
  out << L"ObserveGetProcAddress=0\n";
  out << L"ObserveCursorApis=0\n";
  out << L"ObserveCaptureApis=0\n";
  out << L"ObserveTiming=1\n";
  out << L"ObserveInternalCandidateA=0\n";
  out << L"ObserveInternalSite12=0\n";
  out << L"ObserveInternalSite13=0\n";
  out << L"ObserveMarkers=0\n";
  out << L"ObserveGameplayState=0\n";
  out << L"InternalTraceDelayMs=15000\n";
  out << L"InternalTraceMaxRows=20000\n";
  out << L"LogSizeQueries=0\n";
  out << L"RingCapacity=65536\n";
  out << L"LogDirectory=.\n";
  out << L"\n[Experimental]\n";
  out << L"ExperimentalMouseFix=0\n";
  out << L"ExperimentalMouseFixV2=0\n";
  out << L"ForceUnlimitedFps=1\n";
  out << L"ExperimentalMouseFixMode=2\n";
  out << L"ExperimentalMouseFixGainX=1.0\n";
  out << L"ExperimentalMouseFixGainY=1.0\n";
  out << L"ExperimentalMouseFixMaxAgeMs=50\n";
  out << L"ExperimentalMouseFixCenterX=1920\n";
  out << L"ExperimentalMouseFixCenterY=1080\n";
}

Config load_config(const std::wstring& ini_path, const std::wstring& default_log_directory) {
  write_default_config_if_missing(ini_path);

  Config config;
  config.observe_raw_input = read_bool(L"Diagnostics", L"ObserveRawInput", true, ini_path);
  config.observe_get_proc_address = read_bool(L"Diagnostics", L"ObserveGetProcAddress", false, ini_path);
  config.observe_cursor_apis = read_bool(L"Diagnostics", L"ObserveCursorApis", false, ini_path);
  config.observe_capture_apis = read_bool(L"Diagnostics", L"ObserveCaptureApis", false, ini_path);
  config.observe_timing = read_bool(L"Diagnostics", L"ObserveTiming", true, ini_path);
  config.observe_internal_candidate_a = read_bool(L"Diagnostics", L"ObserveInternalCandidateA", false, ini_path);
  config.observe_internal_site12 = read_bool(L"Diagnostics", L"ObserveInternalSite12", false, ini_path);
  config.observe_internal_site13 = read_bool(L"Diagnostics", L"ObserveInternalSite13", false, ini_path);
  config.observe_markers = read_bool(L"Diagnostics", L"ObserveMarkers", false, ini_path);
  config.observe_gameplay_state = read_bool(L"Diagnostics", L"ObserveGameplayState", false, ini_path);
  config.experimental_mouse_fix = read_bool(L"Experimental", L"ExperimentalMouseFix", false, ini_path);
  config.experimental_mouse_fix_v2 = read_bool(L"Experimental", L"ExperimentalMouseFixV2", false, ini_path);
  config.force_unlimited_fps = read_bool(L"Experimental", L"ForceUnlimitedFps", true, ini_path);
  config.experimental_mouse_fix_mode = read_u32(L"Experimental", L"ExperimentalMouseFixMode", 2, ini_path);
  config.experimental_mouse_fix_gain_x = read_float(L"Experimental", L"ExperimentalMouseFixGainX", 1.0F, ini_path);
  config.experimental_mouse_fix_gain_y = read_float(L"Experimental", L"ExperimentalMouseFixGainY", 1.0F, ini_path);
  config.experimental_mouse_fix_max_age_ms = read_u32(L"Experimental", L"ExperimentalMouseFixMaxAgeMs", 50, ini_path);
  config.experimental_mouse_fix_center_x = read_i32(L"Experimental", L"ExperimentalMouseFixCenterX", 1920, ini_path);
  config.experimental_mouse_fix_center_y = read_i32(L"Experimental", L"ExperimentalMouseFixCenterY", 1080, ini_path);
  if (config.experimental_mouse_fix_mode < 1 || config.experimental_mouse_fix_mode > 27) {
    config.experimental_mouse_fix_mode = 2;
  }
  if (config.experimental_mouse_fix_max_age_ms < 1) {
    config.experimental_mouse_fix_max_age_ms = 1;
  }
  config.internal_trace_delay_ms =
      read_u32(L"Diagnostics", L"InternalTraceDelayMs", config.internal_trace_delay_ms, ini_path);
  config.internal_trace_max_rows =
      read_u32(L"Diagnostics", L"InternalTraceMaxRows", config.internal_trace_max_rows, ini_path);
  if (config.internal_trace_delay_ms < 1000) {
    config.internal_trace_delay_ms = 1000;
  }
  if (config.internal_trace_max_rows < 1) {
    config.internal_trace_max_rows = 1;
  }
  config.log_size_queries = read_bool(L"Diagnostics", L"LogSizeQueries", false, ini_path);
  config.ring_capacity = read_u32(L"Diagnostics", L"RingCapacity", config.ring_capacity, ini_path);
  if (config.ring_capacity < 1024) {
    config.ring_capacity = 1024;
  }

  wchar_t buffer[MAX_PATH]{};
  GetPrivateProfileStringW(L"Diagnostics", L"LogDirectory", L".", buffer, MAX_PATH, ini_path.c_str());
  std::wstring log_dir = buffer;
  config.log_directory = log_dir == L"." || log_dir.empty() ? default_log_directory : log_dir;
  return config;
}

}  // namespace sade
