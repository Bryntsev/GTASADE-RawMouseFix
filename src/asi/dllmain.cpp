#include "bootstrap/observe_only_runtime.h"

#include <Windows.h>

namespace {

DWORD WINAPI start_runtime_thread(LPVOID parameter) {
  try {
    sade::runtime().start(static_cast<HMODULE>(parameter));
  } catch (...) {
    // ObserveOnly must never bring the game down during startup diagnostics.
  }
  return 0;
}

}  // namespace

BOOL APIENTRY DllMain(HMODULE module, DWORD reason, LPVOID) {
  switch (reason) {
    case DLL_PROCESS_ATTACH:
      DisableThreadLibraryCalls(module);
      if (HANDLE thread = CreateThread(nullptr, 0, start_runtime_thread, module, 0, nullptr)) {
        CloseHandle(thread);
      }
      break;
    case DLL_PROCESS_DETACH:
      sade::runtime().stop();
      break;
    default:
      break;
  }
  return TRUE;
}
