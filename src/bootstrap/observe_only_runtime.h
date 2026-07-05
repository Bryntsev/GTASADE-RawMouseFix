#pragma once

#include <Windows.h>

namespace sade {

class ObserveOnlyRuntime {
 public:
  bool start(HMODULE self_module);
  void stop();

 private:
  bool running_ = false;
};

ObserveOnlyRuntime& runtime();

}  // namespace sade
