// ============================================================
// Semi-recessed wall enclosure — Pi 5 + Touch Display 2 + PoE-HAT-J
// "Arm-locking" mount, adapted from The Stock Pot's Home Assistant
// Wall Display design (printables.com/model/1405500), rebuilt around
// a deeper keep-out volume to fit the PoE-HAT-J stack behind the Pi 5.
// https://www.printables.com/model/1405500 — CC BY-NC 4.0, credit
// The Stock Pot if you publish a remix of this.
//
// FIRST DRAFT. Print just one clamping_arm + screw_support + a
// corner-section test piece, and a vent_test strip, before committing
// to a full frame print.
//
// Mechanism: the frame is a deep box (fits the Pi5+HAT stack) with a
// front lip that sits ~reveal mm proud of the finished wall — two
// selectable mount_style variants: "flush" (~3mm, the original
// low-profile look) and "proud" (20mm, room for taller/higher-volume
// venting). Four clamping arms, each on an M4 screw thread-formed into
// a glued-in screw_support insert, rotate to tuck within the cutout
// footprint for insertion, then swing out ~90° once behind the drywall.
// Tightening the same screw draws each arm flush against the wall's
// inner face — clamping is anchored to flange_t (the wall-surface
// plane), not reveal, so it stays correct regardless of how far the
// lip sticks out. The display itself isn't part of this file — it
// mounts to the frame's front ledge via magnets (glue 4 to the frame,
// 4 to the back of the display) so it can be popped off for
// maintenance.
//
// Venting: raised vent strips on 3 of the 4 edges (not the top), tall
// enough (vent_housing_min_t) even on the flush variant, and taller
// still on the proud variant so more rows of slots stack in that
// height — see vent_n_rows. All slots on all three edges are straight,
// uniform cuts (no angling) that stop short of the true outer face —
// see vent_outer_margin — so that face stays completely smooth all
// the way around.
// ============================================================

$fn = 64;

// ---------- measured keep-out volume ----------
raw_device_w = 120.24;  // display+Pi5 width, as measured (portrait orientation)
raw_device_h = 189.32;  // display+Pi5 height, as measured
device_d     = 55.7;    // depth incl. PoE-HAT-J stack (33.3 display+Pi5 + 22.4 HAT stack)

// "portrait" keeps the measured orientation; "landscape" swaps width/height for a
// sideways install. Render each once per orientation — see the part selector at
// the bottom, and re-render "frame" + "cutting_guide" for both (arm and
// screw_support don't depend on orientation).
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
// corner_test and vent_test are mount_style-dependent; arm and screw_support are
// shared by everything).
mount_style = "proud"; // "flush" | "proud"
reveal = (mount_style == "proud") ? 20 : 3;

screw_d         = 3.4;    // M4 clearance hole through the arm (M4 shaft ~4mm; loose clearance for rotation)
screw_pilot_d   = 3.3;    // thread-forming pilot hole in the screw_support (M4 self-tap)
boss_d          = 10;     // clamping arm pivot/screw boss diameter
boss_h          = drywall_max + 6;  // generous — screw travel covers the 10-15mm range, doesn't need to match exactly
corner_inset    = 8;      // how far the arm pivot sits in from each corner
arm_reach       = flange_overhang + 6;  // pivot-to-tip length, lands under the flange with margin
arm_t           = 4;

magnet_d        = 6;      // 6x3mm round magnets, per the reference BOM
magnet_h        = 3;
magnet_edge_inset = 25;   // magnet distance in from each corner, along the edge — clear of
                           // both the rounded corner and the clamp gusset footprint

grommet_hole_d  = 38.1;   // 1.5" hole — takes a 1.47"-OD rubber grommet (push-fit) for the
                           // PoE cable. Rest of the back plate stays solid.
                           // Position (grommet_x/y) is set below, once body_w/body_h exist.

vent_housing_min_t = 10;  // minimum extra housing depth beyond flange_t, even when reveal
                           // is small (flush) — keeps a reasonable housing depth regardless
                           // of mount_style, independent of the vent cut style itself
vent_slot_w     = 3;      // slot opening width (in the housing's depth/Z direction)
vent_slot_len   = 16;     // slot length along the edge
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

// ---------- clamp mounting gusset + socket for the glued-in screw_support ----------
// The boss sits corner_inset in from the edge, well inside the shell's hollow
// interior — a bare cylinder there would float disconnected from the shell/
// flange (wall_t is only 2.5mm). Each gusset is hulled with a stub positioned
// out in the flange's solid ring so the two fuse into one connected part.
//
// The gusset itself is solid, printed as part of the frame. The M4 thread
// doesn't cut directly into it — printing a hole sideways through a boss that's
// part of a large flat frame gives layer-line-weak threads. Instead each
// gusset gets a socket that the separate screw_support part glues into,
// printed standing up so its own pilot hole runs along the strong (vertical)
// print axis, matching the reference design's approach.
module clamp_gusset_solid(bx, by, ex, ey) {
    hull() {
        translate([bx, by, 0]) cylinder(d = boss_d, h = boss_h);
        translate([ex, ey, 0]) cylinder(d = boss_d, h = boss_h);
    }
}

// The gusset reaches straight sideways (constant y = by) into the flange ring, not
// diagonally toward the corner — clipping the diagonal version to the flange's sharp
// corner (an earlier attempt) turned the round boss surface into a fan of arc facets
// exactly at the corner vertex, which is the notch this was actually chasing. Going
// straight sideways instead means the gusset is never near the corner at all, so
// there's no boundary interaction to create that artifact in the first place.
module clamp_gussets_solid() {
    gusset_z0 = body_d + flange_t - boss_h;
    for (c = corner_xy) {
        bx = c[0] * (body_w/2 - corner_inset);
        by = c[1] * (body_h/2 - corner_inset);
        ex = c[0] * (body_w/2 + wall_t + 2);   // lands inside the flange's solid ring
        // anchored to flange_t (the wall-surface plane), NOT reveal — the clamp
        // has to sit at the drywall regardless of how far the lip sits proud of it
        translate([0, 0, gusset_z0])
            clamp_gusset_solid(bx, by, ex, by);
    }
}

module clamp_sockets() {
    for (c = corner_xy) {
        bx = c[0] * (body_w/2 - corner_inset);
        by = c[1] * (body_h/2 - corner_inset);
        translate([bx, by, body_d + flange_t - boss_h - 1])
            cylinder(d = boss_d + 0.3, h = boss_h + 2);  // receives the glued-in screw_support
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

// ---------- venting: straight slats on the sides + bottom of the flange (not the top) ----------
// The plain flange stays solid and full-thickness everywhere (it's the clamp's bearing
// surface). These add a raised trim strip running the full perimeter, spanning the full
// proud depth (reveal + flange_t) rather than just a thin band at the wall — with reveal
// now 20mm there's real room for multiple stacked rows of slots. The strip is continuous
// on all 4 edges for a consistent look; vent_slots_all() only cuts into 3 of them (sides
// + bottom), so the top stays solid.
vent_z0    = body_d;
vent_z1    = body_d + max(reveal, vent_housing_min_t) + flange_t;
vent_zc    = (vent_z0 + vent_z1) / 2;
vent_zspan = vent_z1 - vent_z0;

// how many rows of slots stack in the available Z depth, margined off the top/bottom
// of the housing so no row's edge clips out of the solid material
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

// All three edges use the same straight (unangled) cutter style — matching what the
// bottom edge always used. Each cut reaches vent_inner_reach past the shell's inner
// wall (real airflow into the cavity) but stops vent_outer_margin short of the true
// outer face, so that face stays completely uncut/smooth all the way around. This
// trades away the earlier angled-channel dust-blocking (a straight-through slot has
// a direct, if narrow, sightline) for a uniform look and an unbroken outer surface.
vent_outer_margin = 2;
vent_inner_reach  = 3;

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

    r_in  = body_w/2 - wall_t - vent_inner_reach;    // right: cavity-side bound
    r_out = flange_w/2 - vent_outer_margin;          // right: stops short of the outer face
    l_out = -(flange_w/2 - vent_outer_margin);       // left: stops short of the outer face
    l_in  = -(body_w/2 - wall_t - vent_inner_reach); // left: cavity-side bound
    b_out = -(flange_h/2 - vent_outer_margin);       // bottom: stops short of the outer face
    b_in  = -(body_h/2 - wall_t - vent_inner_reach); // bottom: cavity-side bound

    for (r = [0 : vent_n_rows - 1]) {
        z = vent_zc - vent_row_span/2 + r*(vent_slot_w + vent_row_gap) + vent_slot_w/2;

        for (i = [0 : n_v - 1]) {
            y = -span_v/2 + i*(vent_slot_len + vent_slot_gap) + vent_slot_len/2;
            vent_slot_cutter_x(r_in, r_out, y, z);
            vent_slot_cutter_x(l_out, l_in, y, z);
        }

        for (i = [0 : n_h - 1]) {
            x = -span_h/2 + i*(vent_slot_len + vent_slot_gap) + vent_slot_len/2;
            vent_slot_cutter_y(b_out, b_in, x, z);
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
        clamp_sockets();
        back_opening();
        vent_slots_all();
    }
}

// ---------- clamping arm (print x4, separate part) ----------
module clamping_arm() {
    linear_extrude(height = arm_t)
        difference() {
            hull() {
                circle(d = boss_d + 4);
                translate([arm_reach, 0]) circle(d = 9);
            }
            circle(d = screw_d);
        }
}

// ---------- screw support (print x4 standing up, glue into the frame's socket) ----------
// Printed as its own upright part so the pilot hole runs along the vertical
// (strong) print axis rather than sideways through the frame's layer lines.
module screw_support() {
    difference() {
        cylinder(d = boss_d, h = boss_h);              // glue-fits the socket (boss_d + 0.3 dia)
        translate([0, 0, -1])
            cylinder(d = screw_pilot_d, h = boss_h + 2); // M4 thread-forms in on first tightening
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
    for (c = corner_xy) {
        translate([c[0] * (body_w/2 - corner_inset), c[1] * (body_h/2 - corner_inset), body_d + flange_t - boss_h + arm_t])
            rotate([0, 0, atan2(c[1], c[0])])  // point outward along the true corner diagonal — open/clamping position
                color("OrangeRed") clamping_arm();
    }
}

// ---------- corner test print: just one clamp corner, fast to print/verify ----------
// Print this + one clamping_arm + one screw_support before committing to the
// full frame (which is a multi-hour print at ~152x221x66mm).
module corner_test() {
    intersection() {
        enclosure_frame();
        translate([body_w/2 - 40, body_h/2 - 40, -1])
            cube([50, 50, vent_z1 + 5]);  // vent_z1 >= reveal+flange_t always, covers both mount styles
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
part = "frame"; // "frame" | "arm" | "screw_support" | "cutting_guide" | "corner_test" | "vent_test" | "preview"

if (part == "frame") enclosure_frame();
else if (part == "arm") clamping_arm();
else if (part == "screw_support") screw_support();
else if (part == "cutting_guide") cutting_guide();
else if (part == "corner_test") corner_test();
else if (part == "vent_test") vent_test();
else if (part == "preview") preview_assembly();
