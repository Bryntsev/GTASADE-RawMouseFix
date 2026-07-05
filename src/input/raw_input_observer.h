#pragma once

#include "common/csv_trace.h"
#include "input/raw_input_queue.h"

#include <Windows.h>

#include <atomic>
#include <cstdint>

namespace sade {

class RawInputObserver {
 public:
  using GetRawInputDataFn = UINT(WINAPI*)(HRAWINPUT, UINT, LPVOID, PUINT, UINT);
  using GetRawInputBufferFn = UINT(WINAPI*)(PRAWINPUT, PUINT, UINT);
  using RegisterRawInputDevicesFn = BOOL(WINAPI*)(PCRAWINPUTDEVICE, UINT, UINT);
  using RawMouseMutatorFn = void (*)(RAWMOUSE&);

  RawInputObserver(RawInputQueue& queue, CsvTrace& csv);

  void set_originals(GetRawInputDataFn data, GetRawInputBufferFn buffer, RegisterRawInputDevicesFn register_devices);
  void set_mouse_mutator(RawMouseMutatorFn mutator);
  GetRawInputDataFn original_data() const;
  GetRawInputBufferFn original_buffer() const;
  RegisterRawInputDevicesFn original_register_devices() const;
  UINT observe_data(HRAWINPUT input, UINT command, LPVOID data, PUINT size, UINT header_size, std::uintptr_t caller_rva);
  UINT observe_buffer(PRAWINPUT data, PUINT size, UINT header_size);
  BOOL observe_register_devices(PCRAWINPUTDEVICE devices, UINT count, UINT size);
  void observe_get_proc_address_request(const char* function_name, bool replaced);
  void observe_message(const char* source, const MSG& message);
  void observe_cursor_point(
      const char* source, BOOL result, LONG x, LONG y, std::uintptr_t caller_rva, std::uintptr_t parent_rva);
  void observe_cursor_rect(const char* source,
                           BOOL result,
                           const RECT* rect,
                           std::uintptr_t caller_rva,
                           std::uintptr_t parent_rva);
  RawInputStatistics statistics() const;

 private:
  void observe_mouse(const char* source, HRAWINPUT input, UINT command, RAWINPUT& raw, UINT result, std::uintptr_t caller_rva);

  RawInputQueue& queue_;
  CsvTrace& csv_;
  RawInputDeduplicator dedup_;
  std::atomic<GetRawInputDataFn> original_data_{nullptr};
  std::atomic<GetRawInputBufferFn> original_buffer_{nullptr};
  std::atomic<RegisterRawInputDevicesFn> original_register_devices_{nullptr};
  std::atomic<RawMouseMutatorFn> mouse_mutator_{nullptr};
  std::atomic<std::uint64_t> sequence_{0};
};

}  // namespace sade
