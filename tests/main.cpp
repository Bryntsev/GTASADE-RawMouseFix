#include <iostream>
#include <exception>

void raw_input_queue_tests();
void statistics_tests();

int main() {
  try {
    raw_input_queue_tests();
    statistics_tests();
  } catch (const std::exception& ex) {
    std::cerr << ex.what() << '\n';
    return 1;
  }

  std::cout << "All tests passed\n";
  return 0;
}
