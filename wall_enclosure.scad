// ============================================================
// Semi-recessed wall enclosure — Pi 5 + Touch Display 2 + PoE-HAT-J
// "Arm-locking" mount, adapted from The Stock Pot's Home Assistant
// Wall Display design (printables.com/model/1405500), rebuilt around
// a deeper keep-out volume to fit the PoE-HAT-J stack behind the Pi 5.
// https://www.printables.com/model/1405500 — CC BY-NC 4.0, credit
// The Stock Pot if you publish a remix of this.
//
// FIRST DRAFT. Print just one clamping_arm + a corner-section test
// piece, and a vent_test strip, before committing to a full frame
// print.
//
// Mechanism: the frame is a deep box (fits the Pi5+HAT stack) with a
// front lip that sits ~reveal mm proud of the finished wall — two
// selectable mount_style variants: "flush" (~3mm, the original
// low-profile look) and "proud" (20mm, room for taller/higher-volume
// venting). Four clamping arms, each threaded directly (M4 thread-
// formed into the arm itself), pivot on a boss inside the shell —
// the shell's own side wall gets an actual cut window at each pivot
// (clamp_swing_windows()) so the arm has a real path from that pivot to
// the exterior: it rotates 90° through that window, from "closed"
// (tangential, tucked parallel to the edge for insertion through the
// cutout) to "open" (radial, perpendicular to the edge, reaching past
// the cutout to catch the drywall) — always as a CLOCKWISE turn (the
// installer's view, facing the wall), the same direction the screw
// itself turns to drive in, so tightening naturally splays each arm
// open rather than trying to close it. Each corner clamps a different
// adjacent edge to make that possible for all 4 at once — see
// clamp_radial_angle()'s "pinwheel" comment. The screw is tightened from the
// FRONT — through a plain clearance hole in the frame's gusset,
// reachable only from the room side once the frame is in the wall —
// drawing the arm up flush against the wall's inner face; the same
// window stays open above the rotation band purely as a straight
// travel slot, so the arm can slide to whatever depth clamps the
// drywall in your wall (drywall_min..drywall_max), same as an
// old-work box's ears. That clearance hole passes under the ledge and
// breaks through at the ledge's own top surface, so the screw heads
// end up hidden under the display once it's on (see
// clamp_clearance_holes()). Clamping itself is anchored to flange_t
// (the wall-surface plane), not reveal, so it stays correct regardless
// of how far the lip sticks out. The display itself isn't part of this
// file — it mounts to the frame's front ledge via magnets (glue 4 to
// the frame, 4 to the back of the display) so it can be popped off for
// maintenance (and to access the clamp screws).
//
// Venting: raised vent strips on 3 of the 4 edges (not the top), tall
// enough (vent_housing_min_t) even on the flush variant, taller still
// on the proud variant so more rows of slots stack in that height —
// see vent_n_rows. Each notch is a genuine through-opening: cut
// radially from inside the electronics cavity (past the lip's ledge,
// not just the shell wall — see vent_inner_reach) all the way out to
// the true outer wall — the edge/profile, only visible from the side.
// The room-facing top surface stays completely flat and uncut.
// ============================================================

$fn = 64;

// ---------- measured keep-out volume ----------
raw_device_w = 120.24;  // display+Pi5 width, as measured (portrait orientation)
raw_device_h = 189.32;  // display+Pi5 height, as measured
device_d     = 55.7;    // depth incl. PoE-HAT-J stack (33.3 display+Pi5 + 22.4 HAT stack)

// "portrait" keeps the measured orientation; "landscape" swaps width/height for a
// sideways install. Render each once per orientation — see the part selector at
// the bottom, and re-render "frame" + "cutting_guide" for both (arm doesn't
// depend on orientation).
orientation = "portrait"; // "portrait" | "landscape"
device_w = (orientation == "landscape") ? raw_device_h : raw_device_w;
device_h = (orientation == "landscape") ? raw_device_w : raw_device_h;

// ---------- design parameters (edit to taste) ----------
wall_t          = 2.5;    // shell wall thickness
clearance       = 1.5;    // clearance around device, per side
drywall_min     = 10;     // clamp range, matching the reference design
drywall_max     = 15;
flange_overhang = 12;     // flange extends this far beyond the cutout, per side
flange_t        = 3;      // flange thickness
corner_r        = 0;      // shell/lip/flange-inner-cut corners — plain sharp rectangle.
bezel_corner_r  = 0;      // flange's outer corner — plain sharp rectangle (4 sides, no
                           // rounding at all). The hull-of-circles construction used for
                           // r>0 was producing a small triangular facet artifact right at
                           // the corner tip, not a clean curve — going fully sharp removes
                           // that geometry path entirely rather than trying to tune it.
ledge_w         = 9;      // inward ledge the display's back panel rests on — wide enough to
                           // fully contain a 6mm magnet pocket with margin on both sides

// "flush" keeps the original low-profile look (~3mm proud); "proud" sits 20mm off
// the wall with room for taller, higher-volume venting. Render each once — see the
// part selector at the bottom (frame, cutting_guide are orientation-dependent;
// corner_test and vent_test are mount_style-dependent; arm is shared by everything).
mount_style = "proud"; // "flush" | "proud"
reveal = (mount_style == "proud") ? 20 : 3;

screw_d         = 3.4;    // M4 clearance hole through the frame's gusset (M4 shaft ~4mm;
                           // loose clearance — this is the unthreaded path the screw travels)
screw_pilot_d   = 3.3;    // thread-forming pilot hole, now in the arm itself (M4 self-tap)
screw_head_d    = 7;      // M4 countersunk head diameter (ISO 7046 nominal ~7.5mm; kept
                           // slightly under to leave margin inside boss_d)
screw_head_recess = 2.2;  // countersink depth at the room-facing end, so the flat head
                           // seats flush with the ledge's top surface
boss_d          = 10;     // clamping arm pivot/screw boss diameter
boss_h          = drywall_max + 6;  // cavity-side reach only — screw travel covers the 10-15mm range, doesn't need to match exactly
corner_inset    = 8;      // how far the arm pivot sits in from each corner
arm_reach       = flange_overhang + 6;  // pivot-to-tip length, lands under the flange with margin
arm_t           = 4;
arm_boss_extra_t = 2;     // extra thickness at the arm's pivot, on top of arm_t, purely for
                           // M4 thread engagement depth — arm_t alone (4mm) is thin for a
                           // thread-formed hole; combined (6mm) gives a decent bite. Capped
                           // at 2 (not more) because the arm's total thickness has to fit
                           // under the flange even when fully drawn up against the thinnest
                           // rated drywall (drywall_min) — see clamp_swing_windows() for the
                           // headroom math. Printed as part of the flat arm so it keeps the
                           // arm's naturally well-oriented (flat-printed) hole axis.
arm_swing_clear = 0.6;    // extra clearance around the arm's swept footprint when cutting its
                           // path through the shell wall — printed parts, not a precision fit
arm_clear_z_margin = 0.5; // extra Z clearance above/below the arm's own thickness in that cut

magnet_d        = 6;      // 6x3mm round magnets, per the reference BOM
magnet_h        = 3;
magnet_edge_inset = 25;   // magnet distance in from each corner, along the edge — clear of
                           // both the rounded corner and the clamp gusset footprint

grommet_hole_d  = 38.1;   // 1.5" hole — takes a 1.47"-OD rubber grommet (push-fit) for the
                           // PoE cable. Rest of the back plate stays solid.
                           // Position (grommet_x/y) is set below, once body_w/body_h exist.

vent_housing_min_t = 4;   // minimum extra housing depth beyond flange_t, even when reveal
                           // is small (flush). Total rim depth is max(reveal, this) +
                           // flange_t — at 4mm that's 7mm on flush (was 10, giving an
                           // unintentional 13mm rim that stuck out past the display's own
                           // front face — not "flush" at all). Only fits 1 vent row instead
                           // of 2 at that depth; proud is unaffected since reveal (20)
                           // already exceeds this minimum.
vent_slot_len   = 16;     // slot length along the edge
vent_slot_w     = 3;      // slot opening width (in the housing's depth/Z direction)
vent_slot_gap   = 5;      // gap between adjacent slots
vent_row_gap    = 3;      // gap between stacked rows (Z direction)
vent_margin     = 14;     // keeps slots clear of the corners / clamp gussets

// ---------- derived ----------
body_w = device_w + 2*clearance + 2*wall_t;
body_h = device_h + 2*clearance + 2*wall_t;
body_d = device_d + clearance + wall_t;   // back plate has an opening (back_margin) + open front

cutout_w = body_w + 0.6;  // drywall hole to cut (slip fit, +0.3 per side)
cutout_h = body_h + 0.6;

flange_w = body_w + 2*flange_overhang;
flange_h = body_h + 2*flange_overhang;

corner_xy = [ [-1,-1], [1,-1], [1,1], [-1,1] ];  // 4 corners, arm + magnet positions

// Grommet position: user-measured, landscape front view — the RJ45 port on the
// PoE-HAT-J sits on the right edge, ~25mm in from it (perpendicular to the edge),
// vertically centered. Portrait is the same internals rotated 90° — since the
// landscape position is vertically centered, that rotation lands it horizontally
// centered in portrait, 25mm in from the top edge. Which physical edge "top" ends
// up as in portrait is just a labeling choice here, not a derived fact — when you
// install the portrait version, orient the Pi5/display/HAT assembly so the
// ethernet port faces the top of the frame, to match this hole.
//
// port_edge_inset is the 25mm measured distance plus 5mm of extra clearance for
// the grommet itself (pulls the hole further from the port edge, away from the
// shell's inner wall) — 30mm total.
port_edge_inset = 30;
grommet_x = (orientation == "landscape") ? (body_w/2 - port_edge_inset) : 0;
grommet_y = (orientation == "landscape") ? 0 : (body_h/2 - port_edge_inset);

// ---------- helpers ----------
// r <= 0 gives a plain sharp-cornered rectangle (4 sides). r > 0 gives a rounded
// rect via hull-of-4-circles — used for the shell/lip only, not the outer bezel.
module rounded_rect(w, h, r) {
    if (r <= 0) {
        square([w, h], center = true);
    } else {
        hull()
            for (x = [-1, 1], y = [-1, 1])
                translate([x*(w/2 - r), y*(h/2 - r)])
                    circle(r = r);
    }
}

// ---------- per-corner clamp geometry: which edge each arm clamps ----------
// Each arm needs to rotate "closed" (tangential, tucked for insertion) -> "open"
// (radial, perpendicular to whichever edge it clamps) as a CLOCKWISE turn, viewed
// by the installer standing in the room facing the wall — the same direction a
// standard right-hand-thread screw naturally turns when driven in. Angle 0 = +X,
// 90 = +Y, increasing counterclockwise (OpenSCAD's normal rotate([0,0,a]) sense),
// so "clockwise" here means going from tangential to radial via -90.
//
// The radial direction is fixed by which edge the arm actually needs to clamp —
// that's not a free choice. Making the tangential (closed) direction always point
// toward the shape's center (the only direction with enough clearance for
// arm_reach to stay inside the cutout — see the numeric check that motivated this)
// AND always be exactly +90 from radial (so the swing is uniformly clockwise) turns
// out to be satisfiable for every corner only by having each corner clamp a
// DIFFERENT adjacent edge — a "pinwheel": top-right clamps the top edge,
// bottom-right the right edge, top-left the left edge, bottom-left the bottom edge.
// The simpler-looking "all 4 corners clamp left/right" scheme (the original
// choice here) can satisfy clockwise-consistency for at most 2 of the 4 corners at
// once — the other 2 end up turning the wrong way, or (worse, if left
// uncorrected) sweeping the long way around a full 270° arc.
function clamp_radial_angle(c) =
    (c[0] ==  1 && c[1] ==  1) ?  90 :
    (c[0] ==  1 && c[1] == -1) ?   0 :
    (c[0] == -1 && c[1] ==  1) ? 180 : 270;  // c == [-1,-1]
function clamp_tangential_angle(c) = clamp_radial_angle(c) + 90;

// ---------- clamp mounting gusset + front clearance hole ----------
// The boss sits corner_inset in from the edge, well inside the shell's hollow
// interior — a bare cylinder there would float disconnected from the shell/
// flange (wall_t is only 2.5mm). Each gusset is hulled with a stub positioned
// out in the flange's solid ring so the two fuse into one connected part.
//
// The gusset spans from the cavity-side anchor (gusset_z0, where the arm pivots —
// matches the drywall clamp range, independent of reveal) up to the room-facing
// ledge top (gusset_z1 = body_d + reveal + flange_t) — mount-style dependent, since
// "proud" has to reach much further to daylight than "flush". The M4 thread isn't
// cut into this gusset at all: it's a plain clearance hole all the way through (see
// clamp_clearance_holes()) — the thread lives in the arm instead, which prints flat
// and naturally gets a well-oriented pilot hole, avoiding the weak-layer-line thread
// problem of cutting a hole sideways through this frame boss.
module clamp_gusset_solid(bx, by, ex, ey, h) {
    hull() {
        translate([bx, by, 0]) cylinder(d = boss_d, h = h);
        translate([ex, ey, 0]) cylinder(d = boss_d, h = h);
    }
}

// The gusset reaches straight toward whichever edge that corner's arm clamps (see
// clamp_radial_angle()) — X-direction for left/right-clamping corners, Y-direction
// for top/bottom-clamping ones — never diagonally toward the corner vertex.
// Clipping a diagonal reach to the flange's sharp corner (an earlier attempt, back
// when every gusset reached sideways in X) turned the round boss surface into a fan
// of arc facets exactly at the corner vertex, which is the notch that was actually
// chasing. Reaching straight along one axis instead means the gusset is never near
// the corner at all, so there's no boundary interaction to create that artifact.
//
// The boss is one continuous post spanning its full height (gusset_z0 to gusset_z1),
// but the structural bridge tying it to the flange ring only occupies the flange
// ring's own band (body_d to body_d+flange_t) — that band is unconditionally solid in
// both mount styles and sits well clear of both the arm's swing/travel window below
// (see clamp_swing_windows()) and any vent cuts above it. The rest of the boss, both
// below and above that bridge, is a plain unsupported extension of the same printed
// piece — fine for a stubby, thick post with a single solid anchor point.
module clamp_gussets_solid() {
    gusset_z0 = body_d + flange_t - boss_h;      // cavity-side anchor — arm pivots here
    gusset_z1 = body_d + reveal + flange_t;      // room-facing top — the ledge's true surface
    for (c = corner_xy) {
        bx = c[0] * (body_w/2 - corner_inset);
        by = c[1] * (body_h/2 - corner_inset);
        radial_angle = clamp_radial_angle(c);
        ex = (radial_angle ==   0) ?  (body_w/2 + wall_t + 2) :
             (radial_angle == 180) ? -(body_w/2 + wall_t + 2) : bx;
        ey = (radial_angle ==  90) ?  (body_h/2 + wall_t + 2) :
             (radial_angle == 270) ? -(body_h/2 + wall_t + 2) : by;
        translate([bx, by, gusset_z0])
            cylinder(d = boss_d, h = gusset_z1 - gusset_z0);
        translate([0, 0, body_d])
            clamp_gusset_solid(bx, by, ex, ey, flange_t);
    }
}

// ---------- arm swing/travel clearance through the shell's side wall ----------
// The shell's side wall is otherwise a continuous, unbroken ring — without this cut the
// gusset sits inside a fully sealed compartment and the arm has no physical path from
// its pivot to the true exterior, no matter how far it can reach. Two bands, both
// capped below body_d (the wall-surface plane) so neither one reaches into the flange
// ring or vent housing above it:
//
//  - lower band: the full swept arc from "closed" (tangential — parallel to the
//    nearest edge, tucked in for insertion through the cutout) to "open" (radial —
//    perpendicular to that edge, reaching out to catch the drywall). This is where the
//    arm actually rotates, once, before the frame goes into the wall.
//  - upper band: just the fixed "open" footprint, extended up to cover the screw's
//    full tightening travel against the thinnest rated drywall (drywall_min) — the arm
//    doesn't rotate here, it slides straight up as it's drawn tight, the same way an
//    old-work box's ears do to accommodate different drywall thicknesses.
module arm_footprint_at(angle) {
    offset(r = arm_swing_clear)
        rotate([0, 0, angle])
            hull() {
                circle(d = boss_d + 4);
                translate([arm_reach, 0]) circle(d = 9);
            }
}

module clamp_swing_windows(steps = 9) {
    gusset_z0   = body_d + flange_t - boss_h;
    arm_total_t = arm_t + arm_boss_extra_t;
    lo_z0       = gusset_z0 - arm_clear_z_margin;
    lo_h        = arm_total_t + 2*arm_clear_z_margin;
    clamp_z_max = body_d + flange_t - drywall_min;   // highest the arm travels — thinnest rated drywall
    hi_z1       = clamp_z_max + arm_total_t + arm_clear_z_margin;

    for (c = corner_xy) {
        bx = c[0] * (body_w/2 - corner_inset);
        by = c[1] * (body_h/2 - corner_inset);
        radial_angle     = clamp_radial_angle(c);      // "open" — points out through this corner's clamped edge
        tangential_angle = clamp_tangential_angle(c);  // "closed" — tucked, toward center
        translate([bx, by, 0]) {
            // fixed -90° sweep (clockwise, installer's view) by construction — see
            // clamp_radial_angle()'s comment — rather than interpolating toward
            // radial_angle directly, which wraps the wrong (270°) way for some corners
            translate([0, 0, lo_z0])
                linear_extrude(height = lo_h)
                    for (i = [0 : steps - 1])
                        arm_footprint_at(tangential_angle - i * 90 / (steps - 1));
            translate([0, 0, lo_z0 + lo_h])
                linear_extrude(height = max(hi_z1 - (lo_z0 + lo_h), 0))
                    arm_footprint_at(radial_angle);
        }
    }
}

// A plain round clearance hole through the full gusset — from the cavity-side anchor
// up through the ledge to its true top surface — with a countersink at that top end
// for the M4 flat head. This is the surface the screw is actually accessible from
// once the frame is in the wall: the cavity side is sealed inside the wall after
// install, so the screw must be reachable from the room, and this hole is what makes
// that true (previously it stopped short at flange_t and dead-ended inside the ledge
// — see the header comment for why that was wrong). Because the gusset sits inside
// body_w/2 (under the ledge, not out in the visible flange trim), reaching daylight
// here means reaching under the display — the screw heads end up hidden by the
// display itself once it's on, no separate bezel needed.
module clamp_clearance_holes() {
    gusset_z0 = body_d + flange_t - boss_h;
    gusset_z1 = body_d + reveal + flange_t;
    gusset_len = gusset_z1 - gusset_z0;
    for (c = corner_xy) {
        bx = c[0] * (body_w/2 - corner_inset);
        by = c[1] * (body_h/2 - corner_inset);
        translate([bx, by, gusset_z0 - 1])
            union() {
                cylinder(d = screw_d, h = gusset_len + 2);
                translate([0, 0, gusset_len + 1 - screw_head_recess])
                    cylinder(d1 = screw_d, d2 = screw_head_d, h = screw_head_recess);
            }
    }
}

// ---------- magnet pockets for mounting the display to the front ledge ----------
// Cut into the lip's actual top surface (where the display rests), radially centered
// in the ledge ring, offset along the left/right edges clear of both the rounded
// corners and the clamp gussets. Glue matching magnets to the back of the display at
// the same 4 positions.
module magnet_pockets() {
    lip_top = body_d + reveal + flange_t;
    for (c = corner_xy)
        translate([c[0] * (body_w/2 - ledge_w/2), c[1] * (body_h/2 - magnet_edge_inset), lip_top - magnet_h + 0.01])
            cylinder(d = magnet_d + 0.2, h = magnet_h + 0.5);
}

// ---------- back-plate grommet hole for the PoE cable ----------
module back_opening() {
    translate([grommet_x, grommet_y, -1])
        cylinder(d = grommet_hole_d, h = wall_t + 2);
}

// ---------- venting: notches on the left/right/bottom EDGES of the flange (not the top
// edge), each opening through the housing's room-facing Z surface ----------
// The plain flange stays solid and full-thickness everywhere (it's the clamp's bearing
// surface). These add a raised trim strip running the full perimeter, spanning the full
// proud depth (reveal + flange_t) rather than just a thin band at the wall. The strip is
// continuous on all 4 edges (top included) for a consistent look; vent_slots_all() only
// cuts notches into 3 of them (left/right/bottom edges) — the top edge gets no strip
// cuts at all, staying fully solid.
vent_z0    = body_d;
vent_z1    = body_d + max(reveal, vent_housing_min_t) + flange_t;
vent_zc    = (vent_z0 + vent_z1) / 2;
vent_zspan = vent_z1 - vent_z0;

// how many rows of slots stack in the available Z depth, margined off the top/bottom
// of the housing so no row's edge clips out of the solid material — the top margin is
// what actually keeps the room-facing face uncut, now that venting is back on the
// outer wall instead of through that face
vent_row_usable = vent_zspan - 4;
vent_n_rows     = max(1, floor((vent_row_usable + vent_row_gap) / (vent_slot_w + vent_row_gap)));
vent_row_span   = vent_n_rows * vent_slot_w + (vent_n_rows - 1) * vent_row_gap;

module vent_housings_solid() {
    // Along-edge extension for each strip: a tiny overlap (~2mm) is enough to avoid a
    // degenerate coincident-edge union, but it is NOT enough to actually reach the
    // corner — flange_overhang is 12mm, so a 2mm overlap left a real, uncovered square
    // gap at every corner (tall housing on the two straight edges, nothing bridging
    // between them). That gap — housing dropping to the shorter plain flange height
    // right at the corner — was the actual notch. Extending each strip the full
    // flange_overhang along its edge means at least one of the two strips meeting at
    // any given corner fully covers it; the intersection below still clips everything
    // to the flange's true outer silhouette, so over-extending here is harmless.
    ov = flange_overhang;
    intersection() {
        union() {
            // bottom strip (extended sideways all the way into both corners)
            translate([-body_w/2 - ov, -flange_h/2, vent_z0])
                cube([body_w + 2*ov, flange_h/2 - body_h/2, vent_zspan]);
            // top strip — same height as the other three, continuing the trim around the
            // whole perimeter, but vent_slots_all() never cuts into this one, so it stays solid
            translate([-body_w/2 - ov, body_h/2, vent_z0])
                cube([body_w + 2*ov, flange_h/2 - body_h/2, vent_zspan]);
            // left strip (extended into both corners, top and bottom)
            translate([-flange_w/2, -body_h/2 - ov, vent_z0])
                cube([flange_w/2 - body_w/2, body_h + 2*ov, vent_zspan]);
            // right strip (extended into both corners, top and bottom)
            translate([body_w/2, -body_h/2 - ov, vent_z0])
                cube([flange_w/2 - body_w/2, body_h + 2*ov, vent_zspan]);
        }
        translate([0, 0, vent_z0 - 1])
            linear_extrude(height = vent_zspan + 2)
                rounded_rect(flange_w, flange_h, bezel_corner_r);
    }
}

// Vents open through the housing's true OUTER WALL (the edge/profile, only visible
// from the side) — the room-facing top surface stays completely flat and uncut. Each
// notch is a thin horizontal slot, radial through-direction, stacked in rows (see
// vent_n_rows) within the housing's Z depth, margined off both vent_z0 and vent_z1 so
// no row's edge clips into either face.
//
// (Two things this keeps from the "vent through the top" version, which was wrong
// about which face is actually room-facing but right about the reach: the inner end
// clears ledge_w — the lip's ledge, not wall_t/the shell's wall, which is what's
// actually in the way at this Z-height — and the magnet-position exclusion below,
// since the radial reach still passes through the same ledge ring the magnets sit in.)
vent_inner_reach = 3;   // how far past the ledge the cut reaches, into the open interior

module vent_slot_cutter_x(radial_lo, radial_hi, y_pos, z_pos) {
    translate([radial_lo, y_pos - vent_slot_len/2, z_pos - vent_slot_w/2])
        cube([radial_hi - radial_lo, vent_slot_len, vent_slot_w]);
}

module vent_slot_cutter_y(radial_lo, radial_hi, x_pos, z_pos) {
    translate([x_pos - vent_slot_len/2, radial_lo, z_pos - vent_slot_w/2])
        cube([vent_slot_len, radial_hi - radial_lo, vent_slot_w]);
}

module vent_slots_all() {
    n_v = floor((body_h - 2*vent_margin) / (vent_slot_len + vent_slot_gap));
    span_v = n_v * vent_slot_len + (n_v - 1) * vent_slot_gap;
    n_h = floor((body_w - 2*vent_margin) / (vent_slot_len + vent_slot_gap));
    span_h = n_h * vent_slot_len + (n_h - 1) * vent_slot_gap;

    r_in  = body_w/2 - ledge_w - vent_inner_reach;    // right: cavity-side bound
    r_out = flange_w/2;                               // right: all the way to the true outer wall
    l_out = -flange_w/2;                              // left: all the way to the true outer wall
    l_in  = -(body_w/2 - ledge_w - vent_inner_reach); // left: cavity-side bound
    b_out = -flange_h/2;                              // bottom: all the way to the true outer wall
    b_in  = -(body_h/2 - ledge_w - vent_inner_reach); // bottom: cavity-side bound

    // Side (left/right) vents reach through the ledge (see r_in/l_in above), the same
    // ring the magnet pockets are embedded in — magnet_y is where magnet_pockets()
    // puts them. A notch centered anywhere within one slot length of that position
    // would cut straight through a magnet pocket, so skip those.
    magnet_y = body_h/2 - magnet_edge_inset;

    // Also keep clear of the clamp gusset's structural bridge to the flange ring (see
    // clamp_gussets_solid()) — that bridge sits at Z = body_d..body_d+flange_t, which
    // overlaps this vent row's Z range in flush mode. Two of the four corners bridge
    // toward the left/right edges (matching gusset_y below), one bridges toward the
    // bottom edge (gusset_x) — see clamp_radial_angle()'s pinwheel layout. The fourth
    // bridges toward the top edge, which has no vents to protect it from.
    gusset_y = body_h/2 - corner_inset;
    gusset_x = body_w/2 - corner_inset;

    for (r = [0 : vent_n_rows - 1]) {
        z = vent_zc - vent_row_span/2 + r*(vent_slot_w + vent_row_gap) + vent_slot_w/2;

        for (i = [0 : n_v - 1]) {
            y = -span_v/2 + i*(vent_slot_len + vent_slot_gap) + vent_slot_len/2;
            if (abs(abs(y) - magnet_y) > vent_slot_len/2 + magnet_d/2 + 2 &&
                abs(abs(y) - gusset_y) > vent_slot_len/2 + boss_d/2 + 2) {
                vent_slot_cutter_x(r_in, r_out, y, z);
                vent_slot_cutter_x(l_out, l_in, y, z);
            }
        }

        for (i = [0 : n_h - 1]) {
            x = -span_h/2 + i*(vent_slot_len + vent_slot_gap) + vent_slot_len/2;
            if (abs(abs(x) - gusset_x) > vent_slot_len/2 + boss_d/2 + 2) {
                vent_slot_cutter_y(b_out, b_in, x, z);
            }
        }
    }
}

// ---------- main frame: recessed box + proud front lip/ledge ----------
module enclosure_frame() {
    difference() {
        union() {
            // deep box: houses the Pi5+HAT stack, open front, back opened up below
            difference() {
                linear_extrude(height = body_d)
                    rounded_rect(body_w, body_h, corner_r);
                translate([0, 0, wall_t])
                    linear_extrude(height = body_d)
                        rounded_rect(body_w - 2*wall_t, body_h - 2*wall_t, max(corner_r - wall_t, 1));
            }
            // front lip: sits proud of the wall by `reveal`, display's ledge to rest on
            translate([0, 0, body_d])
                linear_extrude(height = reveal + flange_t)
                    difference() {
                        rounded_rect(body_w, body_h, corner_r);
                        rounded_rect(body_w - 2*ledge_w, body_h - 2*ledge_w, max(corner_r - ledge_w, 1));
                    }
            // flange: flush against the wall surface, behind the lip
            translate([0, 0, body_d])
                linear_extrude(height = flange_t)
                    difference() {
                        rounded_rect(flange_w, flange_h, bezel_corner_r);
                        rounded_rect(body_w, body_h, corner_r);
                    }
            clamp_gussets_solid();
            vent_housings_solid();
        }
        magnet_pockets();
        clamp_clearance_holes();
        clamp_swing_windows();
        back_opening();
        vent_slots_all();
    }
}

// ---------- clamping arm (print x4, separate part) ----------
// The M4 thread now forms directly into this part instead of a separate glued-in
// insert — the arm prints flat, so its pilot hole is naturally along a
// well-supported axis (through the layer stack, not sideways across it). The pivot
// end gets a raised boss (arm_boss_extra_t on top of arm_t) purely to give the
// thread more engagement depth than the arm's own base thickness would alone; it
// sits on the side facing the frame's gusset, i.e. the same side the screw
// approaches from.
module clamping_arm() {
    difference() {
        union() {
            linear_extrude(height = arm_t)
                hull() {
                    circle(d = boss_d + 4);
                    translate([arm_reach, 0]) circle(d = 9);
                }
            cylinder(d = boss_d, h = arm_t + arm_boss_extra_t);
        }
        translate([0, 0, -1])
            cylinder(d = screw_pilot_d, h = arm_t + arm_boss_extra_t + 2);
    }
}

// ---------- cutting guide: flat template for marking the drywall hole ----------
module cutting_guide() {
    linear_extrude(height = 2)
        difference() {
            rounded_rect(cutout_w + 20, cutout_h + 20, corner_r);
            rounded_rect(cutout_w, cutout_h, corner_r);
        }
}

// ---------- assembly preview (visual sanity check only — not for printing) ----------
module preview_assembly() {
    color("SlateGray") enclosure_frame();
    gusset_z0 = body_d + flange_t - boss_h;
    for (c = corner_xy) {
        radial_angle = clamp_radial_angle(c);  // "open" — perpendicular to this corner's clamped edge
        translate([c[0] * (body_w/2 - corner_inset), c[1] * (body_h/2 - corner_inset), gusset_z0])
            rotate([0, 0, radial_angle])
                color("OrangeRed") clamping_arm();
    }
}

// ---------- corner test print: just one clamp corner, fast to print/verify ----------
// Print this + one clamping_arm before committing to the full frame (which is a
// multi-hour print at ~152x221x66mm). This captures the top-right corner, whose arm
// clamps the TOP edge (see clamp_radial_angle()'s pinwheel layout) — so the box is
// sized generously in +Y (the "open" reach direction) rather than +X.
module corner_test() {
    intersection() {
        enclosure_frame();
        translate([body_w/2 - 40, body_h/2 - 40, -1])
            cube([45, 65, vent_z1 + 5]);  // vent_z1 >= reveal+flange_t always, covers both mount styles
    }
}

// ---------- vent test print: a chunk of the left vent strip, fast to print/verify ----------
module vent_test() {
    intersection() {
        enclosure_frame();
        translate([-flange_w/2 - 2, -20, vent_z0 - 2])
            cube([flange_w/2 - body_w/2 + wall_t + 10, 40, vent_zspan + 4]);
    }
}

// ---------- part selector: change this and re-render for each STL ----------
part = "frame"; // "frame" | "arm" | "cutting_guide" | "corner_test" | "vent_test" | "preview"

if (part == "frame") enclosure_frame();
else if (part == "arm") clamping_arm();
else if (part == "cutting_guide") cutting_guide();
else if (part == "corner_test") corner_test();
else if (part == "vent_test") vent_test();
else if (part == "preview") preview_assembly();
