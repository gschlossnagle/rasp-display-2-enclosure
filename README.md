# rasp-display-2-enclosure

Semi-recessed wall enclosure for a Raspberry Pi 5 + Raspberry Pi Touch Display 2 +
Waveshare PoE-HAT-J, with an "arm-locking" old-work drywall mount (adapted from
[The Stock Pot's Home Assistant Wall Display](https://www.printables.com/model/1405500),
CC BY-NC 4.0 — credit required if you publish a remix).

## Files

- `wall_enclosure.scad` — parametric OpenSCAD source. Edit the parameters at the
  top and re-render for each part (see the `part` / `mount_style` / `orientation`
  selectors near the bottom of the file).
- `wall_enclosure_frame_<style>_<orientation>.stl` — the main body. Two mount
  styles (`flush` ≈ 3mm proud, `proud` = 20mm proud with taller venting) x two
  orientations (`portrait`, `landscape`). Pick one.
- `wall_enclosure_arm.stl` — print x4, the rotating drywall clamps.
- `wall_enclosure_screw_support.stl` — print x4, glue-in threaded inserts for the
  clamp screws.
- `wall_enclosure_cutting_guide_<orientation>.stl` — flat template for marking
  the drywall cutout.
- `wall_enclosure_corner_test_<style>.stl`, `wall_enclosure_vent_test_<style>.stl`
  — small test prints for the clamp mechanism and vent channels, worth printing
  before committing to a full frame (multi-hour print).

## Build instructions

See [INSTALL.md](INSTALL.md) for hardware list and assembly order.

## Requirements

OpenSCAD 2021.01+ to edit/re-render `wall_enclosure.scad`.
