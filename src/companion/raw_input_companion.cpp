#include "input/external_raw_input_shared.h"

#include <Windows.h>
#include <shellapi.h>

#include <cstddef>
#include <string>
#include <string_view>
#include <vector>

namespace {

sade::ExternalRawInputShared* g_shared = nullptr;

LRESULT CALLBACK window_proc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
  if (message == WM_INPUT && g_shared != nullptr) {
    UINT size = 0;
    if (GetRawInputData(reinterpret_cast<HRAWINPUT>(lparam), RID_INPUT, nullptr, &size, sizeof(RAWINPUTHEADER)) !=
            static_cast<UINT>(-1) &&
        size >= sizeof(RAWINPUTHEADER) && size <= 4096) {
      std::vector<std::byte> buffer(size);
      if (GetRawInputData(reinterpret_cast<HRAWINPUT>(lparam), RID_INPUT, buffer.data(), &size, sizeof(RAWINPUTHEADER)) == size) {
        const auto* raw = reinterpret_cast<const RAWINPUT*>(buffer.data());
        if (raw->header.dwType == RIM_TYPEMOUSE) {
          InterlockedAdd64(&g_shared->pending_x, raw->data.mouse.lLastX);
          InterlockedAdd64(&g_shared->pending_y, raw->data.mouse.lLastY);
          LARGE_INTEGER now{};
          QueryPerformanceCounter(&now);
          InterlockedExchange64(&g_shared->last_qpc, now.QuadPart);
          InterlockedIncrement64(&g_shared->packet_count);
        }
      }
    }
    return 0;
  }
  return DefWindowProcW(hwnd, message, wparam, lparam);
}

bool parse_arg(const wchar_t* name, int argc, wchar_t** argv, std::wstring& value) {
  for (int index = 1; index + 1 < argc; ++index) {
    if (std::wstring_view(argv[index]) == name) {
      value = argv[index + 1];
      return true;
    }
  }
  return false;
}

}  // namespace

int WINAPI wWinMain(HINSTANCE instance, HINSTANCE, PWSTR, int) {
  int argc = 0;
  wchar_t** argv = CommandLineToArgvW(GetCommandLineW(), &argc);
  if (argv == nullptr) {
    return 2;
  }

  std::wstring mapping_name;
  std::wstring stop_event_name;
  const bool valid_args = parse_arg(L"--mapping", argc, argv, mapping_name) &&
                          parse_arg(L"--stop-event", argc, argv, stop_event_name);
  LocalFree(argv);
  if (!valid_args) {
    return 2;
  }

  HANDLE mapping = OpenFileMappingW(FILE_MAP_ALL_ACCESS, FALSE, mapping_name.c_str());
  if (mapping == nullptr) {
    return 3;
  }
  auto* shared = static_cast<sade::ExternalRawInputShared*>(
      MapViewOfFile(mapping, FILE_MAP_ALL_ACCESS, 0, 0, sizeof(sade::ExternalRawInputShared)));
  if (shared == nullptr || shared->magic != sade::kExternalRawInputMagic ||
      shared->version != sade::kExternalRawInputVersion) {
    if (shared != nullptr) {
      UnmapViewOfFile(shared);
    }
    CloseHandle(mapping);
    return 4;
  }

  HANDLE stop_event = OpenEventW(SYNCHRONIZE, FALSE, stop_event_name.c_str());
  if (stop_event == nullptr) {
    UnmapViewOfFile(shared);
    CloseHandle(mapping);
    return 5;
  }

  constexpr wchar_t kWindowClass[] = L"SADE.HighFpsRawMouseFix.ExternalRawInput";
  WNDCLASSW window_class{};
  window_class.hInstance = instance;
  window_class.lpfnWndProc = window_proc;
  window_class.lpszClassName = kWindowClass;
  RegisterClassW(&window_class);
  HWND window = CreateWindowExW(0, kWindowClass, kWindowClass, 0, 0, 0, 0, 0, nullptr, nullptr, instance, nullptr);
  if (window == nullptr) {
    CloseHandle(stop_event);
    UnmapViewOfFile(shared);
    CloseHandle(mapping);
    return 6;
  }

  g_shared = shared;
  RAWINPUTDEVICE device{};
  device.usUsagePage = 0x01;
  device.usUsage = 0x02;
  device.dwFlags = RIDEV_INPUTSINK;
  device.hwndTarget = window;
  if (!RegisterRawInputDevices(&device, 1, sizeof(device))) {
    DestroyWindow(window);
    CloseHandle(stop_event);
    UnmapViewOfFile(shared);
    CloseHandle(mapping);
    return 7;
  }

  bool running = true;
  while (running) {
    const DWORD wait = MsgWaitForMultipleObjects(1, &stop_event, FALSE, INFINITE, QS_ALLINPUT);
    if (wait == WAIT_OBJECT_0) {
      break;
    }
    MSG message{};
    while (PeekMessageW(&message, nullptr, 0, 0, PM_REMOVE)) {
      if (message.message == WM_QUIT) {
        running = false;
        break;
      }
      TranslateMessage(&message);
      DispatchMessageW(&message);
    }
  }

  g_shared = nullptr;
  DestroyWindow(window);
  CloseHandle(stop_event);
  UnmapViewOfFile(shared);
  CloseHandle(mapping);
  return 0;
}
