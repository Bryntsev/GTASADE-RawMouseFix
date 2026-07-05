#pragma once

#include <Windows.h>

#include <mutex>
#include <string>
#include <vector>

namespace sade {

class IatHookSet {
 public:
  std::size_t install_all_loaded_modules(const char* imported_module,
                                         const char* function_name,
                                         void* replacement,
                                         HMODULE skip_module = nullptr);
  bool uninstall();
  std::size_t count() const;

 private:
  bool install_module(HMODULE module, const char* imported_module, const char* function_name, void* replacement);
  bool has_slot(void** slot) const;

  struct Slot {
    void** address = nullptr;
    void* original = nullptr;
  };

  mutable std::mutex mutex_;
  std::vector<Slot> slots_;
};

}  // namespace sade
