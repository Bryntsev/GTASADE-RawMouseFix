#include "input/raw_input_queue.h"
#include "test_assert.h"

void statistics_tests() {
  sade::RawInputQueue queue(8);

  sade::RawInputEvent a;
  a.x = 4;
  a.y = -1;
  queue.push(a);

  sade::RawInputEvent b;
  b.x = -2;
  b.y = 3;
  b.deduplicated = 1;
  queue.push(b);

  const auto stats = queue.statistics();
  REQUIRE_EQ(stats.observed, 2ull);
  REQUIRE_EQ(stats.duplicates, 1ull);
  REQUIRE_EQ(stats.accumulated_x, 4ll);
  REQUIRE_EQ(stats.accumulated_y, -1ll);
  REQUIRE_EQ(stats.overflow, 0ull);

  queue.record_size_query();
  queue.record_non_mouse();
  queue.record_error();
  queue.record_wm_input_message();
  const auto extended = queue.statistics();
  REQUIRE_EQ(extended.size_queries, 1ull);
  REQUIRE_EQ(extended.non_mouse, 1ull);
  REQUIRE_EQ(extended.errors, 1ull);
  REQUIRE_EQ(extended.wm_input_messages, 1ull);
}
