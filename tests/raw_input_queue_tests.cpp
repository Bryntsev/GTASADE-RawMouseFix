#include "input/raw_input_queue.h"
#include "test_assert.h"

void raw_input_queue_tests() {
  sade::RawInputQueue queue(3);

  sade::RawInputEvent a;
  a.sequence = 1;
  a.x = 10;
  a.y = 1;
  queue.push(a);

  sade::RawInputEvent b;
  b.sequence = 2;
  b.x = 20;
  b.y = 2;
  queue.push(b);

  auto first = queue.drain();
  REQUIRE_EQ(first.size(), 2u);
  REQUIRE_EQ(first[0].sequence, 1ull);
  REQUIRE_EQ(first[1].sequence, 2ull);

  queue.push(a);
  queue.push(b);
  sade::RawInputEvent c;
  c.sequence = 3;
  queue.push(c);
  sade::RawInputEvent d;
  d.sequence = 4;
  queue.push(d);

  auto overflowed = queue.drain();
  REQUIRE_EQ(overflowed.size(), 3u);
  REQUIRE_EQ(overflowed[0].sequence, 2ull);
  REQUIRE_EQ(overflowed[1].sequence, 3ull);
  REQUIRE_EQ(overflowed[2].sequence, 4ull);
  const auto stats = queue.statistics();
  REQUIRE_EQ(stats.overflow, 1ull);

  RAWMOUSE mouse{};
  mouse.lLastX = 5;
  mouse.lLastY = -2;
  mouse.usFlags = MOUSE_MOVE_RELATIVE;
  sade::RawInputDeduplicator dedup;
  REQUIRE_TRUE(!dedup.is_duplicate(reinterpret_cast<HRAWINPUT>(0x1234), mouse, 100));
  REQUIRE_TRUE(dedup.is_duplicate(reinterpret_cast<HRAWINPUT>(0x1234), mouse, 101));
  mouse.lLastX = 6;
  REQUIRE_TRUE(!dedup.is_duplicate(reinterpret_cast<HRAWINPUT>(0x1234), mouse, 102));
}
