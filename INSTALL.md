# Wall Enclosure — Install Guide

For the Pi 5 + Touch Display 2 + PoE-HAT-J semi-recessed wall mount
(`wall_enclosure.scad`). Two mount styles (`flush`, `proud`) x two
orientations (`portrait`, `landscape`) — pick the STL matching your build.

## Hardware needed

| Item | Spec | Qty |
|---|---|---|
| Clamp screws | M4 x 25mm countersunk machine screw | 4 |
| Frame magnets | 6mm diameter x 3mm thick, round | 4 |
| Display magnets | 6mm diameter x 3mm thick, round (same spec) | 4 |
| Cable grommet | 1.47" OD rubber grommet (panel hole is 1.5" / 38.1mm) | 1 |
| Glue | For seating the `screw_support` inserts (CA/epoxy) | — |
| Optional | Small springs between arm and frame, keeps the screw seated while tightening | 4 |

Printed parts, one of each unless noted:
- `wall_enclosure_frame_<style>_<orientation>.stl` — the main body (pick one)
- `wall_enclosure_arm.stl` — print **x4**, the rotating drywall clamps
- `wall_enclosure_screw_support.stl` — print **x4**, glue-in threaded inserts
- `wall_enclosure_cutting_guide_<orientation>.stl` — template for marking the drywall cutout

## Cutout size (drywall hole to cut)

- Portrait: 128.8mm x 197.9mm
- Landscape: 197.9mm x 128.8mm

Use the cutting guide to trace it before cutting.

## Assembly order

1. Glue the 4 `screw_support` inserts into their sockets on the back of the
   frame (visible from inside the cavity, near each corner). Let the glue cure
   before proceeding.
2. Loosely thread an M4 screw through each `clamping_arm`, into its
   `screw_support` — just enough for the arm to rotate freely, not tight yet.
3. Rotate all 4 arms to "closed" (tucked within the cutout footprint) and
   feed the frame through the wall cutout.
4. From inside the cavity, rotate each arm ~90° outward so it sits behind the
   drywall, past the cutout edge.
5. Tighten each M4 screw — this draws the arm flush against the inside of the
   drywall, clamping it between the arm and the frame's flange.
6. Feed your PoE Ethernet cable through the grommet hole in the back plate
   before connecting it to the PoE-HAT-J. The hole is positioned near the RJ45
   port, not centered — in **landscape**, that's the right edge, vertically
   centered; in **portrait**, orient the Pi5/display/HAT assembly so the
   ethernet port faces the **top** of the frame, to line up with the hole.
7. Glue one magnet into each of the 4 pockets in the frame's front ledge.
   Glue the matching 4 magnets to the back of the display at the same
   positions (mark through the pockets, or measure off the frame).
8. Set the display onto the ledge — the magnets hold it in place, removable
   for maintenance.

## Notes / things to verify before committing to a full print

- Print `wall_enclosure_corner_test_<style>.stl` and one `arm` +
  `screw_support` first to check the M4 thread-forming fit and arm swing.
- Print `wall_enclosure_vent_test_<style>.stl` to sanity-check the vent
  channels before committing to the full frame (multi-hour print).
- The magnet positions in the frame are fixed by geometry, but where you glue
  the matching magnets on the actual display isn't verified against real
  hardware — check fit before gluing.
