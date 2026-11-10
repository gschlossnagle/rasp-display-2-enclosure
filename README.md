# rasp-display-2-enclosure

Semi-recessed wall enclosure for a Raspberry Pi 5 + Raspberry Pi Touch Display 2 +
Waveshare PoE-HAT-J, with an "arm-locking" old-work drywall mount (adapted from
[The Stock Pot's Home Assistant Wall Display](https://www.printables.com/model/1405500),
CC BY-NC 4.0 — credit required if you publish a remix).

## Files

- `wall_enclosure.scad` — parametric OpenSCAD source. Edit the parameters at the
  top and re-render for each part (see the `part` / `mount_style` / `orientation`
  selectors near the bottom of the file).
- Every part is provided as both `.stl` and `.3mf`. Prefer the `.3mf` for slicing
  (e.g. Creality Print): it carries units (millimeters) explicitly, so there's no
  import-scale guesswork. File names below are given as `.stl`.
- `wall_enclosure_frame_<style>_<orientation>.stl` — the main body. Two mount
  styles (`flush` ≈ 3mm proud, `proud` = 20mm proud with taller venting) x two
  orientations (`portrait`, `landscape`). Pick one.
- `wall_enclosure_arm.stl` — print x4, the rotating drywall clamps. The clamp
  screw thread-forms directly into the arm (M4) — no separate insert. The
  screw is driven and later re-accessed from the front, through the frame,
  and ends up hidden under the display once it's mounted.
- `wall_enclosure_cutting_guide_<orientation>.stl` — flat template for marking
  the drywall cutout.
- `wall_enclosure_corner_test_<style>.stl`, `wall_enclosure_vent_test_<style>.stl`
  — small test prints for the clamp mechanism and vent channels, worth printing
  before committing to a full frame (multi-hour print).

## Build instructions

See [INSTALL.md](INSTALL.md) for hardware list and assembly order.

## Requirements

OpenSCAD 2021.01+ to edit/re-render `wall_enclosure.scad`.
