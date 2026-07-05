#pragma once

#include <string>
#include <cstdint>

namespace sade {

struct Config {
  bool observe_raw_input = true;
  bool observe_get_proc_address = false;
  bool observe_cursor_apis = false;
  bool observe_capture_apis = false;
  bool observe_timing = true;
  bool observe_internal_candidate_a = false;
  bool observe_internal_site12 = false;
  bool observe_internal_site13 = false;
  bool observe_markers = false;
  bool observe_gameplay_state = false;
  bool experimental_mouse_fix = false;
  bool experimental_mouse_fix_v2 = false;
  bool force_unlimited_fps = true;
  std::uint32_t experimental_mouse_fix_mode = 2;
  float experimental_mouse_fix_gain_x = 1.0F;
  float experimental_mouse_fix_gain_y = 1.0F;
  std::uint32_t experimental_mouse_fix_max_age_ms = 50;
  std::int32_t experimental_mouse_fix_center_x = 1920;
  std::int32_t experimental_mouse_fix_center_y = 1080;
  bool log_size_queries = false;
  std::uint32_t ring_capacity = 65536;
  std::uint32_t internal_trace_delay_ms = 15000;
  std::uint32_t internal_trace_max_rows = 20000;
  std::wstring log_directory;
};

Config load_config(const std::wstring& ini_path, const std::wstring& default_log_directory);
void write_default_config_if_missing(const std::wstring& ini_path);

}  // namespace sade
