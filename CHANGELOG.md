# Changelog

## v0.1.0-test - 2026-07-05

Initial public test release candidate.

- Adds the `v27-rawinput-companion` mouse fix path.
- Uses a companion process to collect physical Raw Input mouse deltas.
- Applies input to the gameplay camera path from the ASI plugin.
- Tested by the author with a 1000 Hz mouse polling rate.
- Known issue: menu item highlighting can behave oddly, but menu actions remain usable in testing.
- Known limitation: the in-game FPS cap is not reliably changed by the mod.
