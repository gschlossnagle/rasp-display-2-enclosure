# Wall Enclosure — Install Guide

For the Pi 5 + Touch Display 2 + PoE-HAT-J semi-recessed wall mount
(`wall_enclosure.scad`). Two mount styles (`flush`, `proud`) x two
orientations (`portrait`, `landscape`) — pick the STL matching your build.

## Hardware needed

The clamp screw is tightened from the **front**, through the frame, into a
thread formed directly in the arm — its length depends on mount style, since
"proud" has much further to travel to reach the arm than "flush" does. Pick
the row matching the STL you printed.

| Item | Spec | Qty |
|---|---|---|
| Clamp screws (`flush`) | M4 x 35mm countersunk machine screw | 4 |
| Clamp screws (`proud`) | M4 x 55mm countersunk machine screw | 4 |
| Frame magnets | 6mm diameter x 3mm thick, round | 4 |
| Display magnets | 6mm diameter x 3mm thick, round (same spec) | 4 |
| Cable grommet | 1.47" OD rubber grommet (panel hole is 1.5" / 38.1mm) | 1 |
| Optional | Small springs between arm and frame, keeps the screw seated while tightening | 4 |

Printed parts, one of each unless noted:
- `wall_enclosure_frame_<style>_<orientation>.stl` — the main body (pick one)
- `wall_enclosure_arm.stl` — print **x4**, the rotating drywall clamps
- `wall_enclosure_cutting_guide_<orientation>.stl` — template for marking the drywall cutout

## Cutout size (drywall hole to cut)

- Portrait: 128.8mm x 197.9mm
- Landscape: 197.9mm x 128.8mm

Use the cutting guide to trace it before cutting.

## Assembly order

The clamp screw always goes in and comes out from the **front** (room side) —
the back of the frame is sealed inside the wall once installed, so that's the
only side you'll ever be able to reach again. There's no glued insert: the M4
thread forms directly into the arm the first time each screw is driven.

Each arm clamps a *different* adjacent edge of the cutout — the top-right arm
clamps the top edge, bottom-right clamps the right edge, top-left clamps the
left edge, bottom-left clamps the bottom edge. This isn't arbitrary: it's what
makes turning every screw **clockwise** (standard tightening direction) splay
its arm open the same way at all 4 corners, so there's one consistent motion
to learn rather than 4 different ones.

1. On the bench (before the frame goes in the wall), drop each `clamping_arm`
   onto its pivot boss on the back of the frame and drive an M4 screw down
   through the frame's clearance hole (from the front) into the arm, just
   enough turns to thread-form and hold loosely — not tight, the arm needs to
   rotate freely.
2. Rotate all 4 arms to "closed" — tucked in toward the center, nothing
   sticking out past the cutout footprint — and feed the frame through the
   wall cutout.
3. Reach in through the frame's open front (before the display is attached)
   and rotate each arm 90° **clockwise** to "open" — now perpendicular to its
   edge, reaching out through the frame's own side wall to sit behind the
   drywall, past the cutout edge. Each arm has a dedicated cut window in the
   shell wall for exactly this swing, so it doesn't bind against printed
   material partway through the turn.
4. Tighten each M4 screw from the front — this draws the arm up flush
   against the inside of the drywall, clamping it between the arm and the
   frame's flange. The arm doesn't rotate any further at this point, it just
   slides straight up the same window as the screw is tightened — rated for
   10–15mm drywall (same range as a standard old-work electrical box), so it
   self-adjusts to whatever thickness your wall actually is. The screw stays
   accessible from the front afterward too (for re-tightening or removal),
   it's just covered by the display once that's on — see step 8.
5. Feed your PoE Ethernet cable through the grommet hole in the back plate
   before connecting it to the PoE-HAT-J. The hole is positioned near the RJ45
   port, not centered — in **landscape**, that's the right edge, vertically
   centered; in **portrait**, orient the Pi5/display/HAT assembly so the
   ethernet port faces the **top** of the frame, to line up with the hole.
6. Glue one magnet into each of the 4 pockets in the frame's front ledge.
   Glue the matching 4 magnets to the back of the display at the same
   positions (mark through the pockets, or measure off the frame).
7. Set the display onto the ledge — the magnets hold it in place, removable
   for maintenance (and for access back to the clamp screws, which sit right
   under the ledge at each corner).

## Notes / things to verify before committing to a full print

- Print `wall_enclosure_corner_test_<style>.stl` and one `arm` first to check
  the M4 thread-forming fit into the arm and the arm's swing/clamping action.
- Print `wall_enclosure_vent_test_<style>.stl` to sanity-check the vent
  channels before committing to the full frame (multi-hour print).
- The magnet positions in the frame are fixed by geometry, but where you glue
  the matching magnets on the actual display isn't verified against real
  hardware — check fit before gluing.
