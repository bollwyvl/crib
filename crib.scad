use <MCAD/gridbeam.scad>
include <MCAD/units.scad>

// SAFETY CONSTRAINTS
// above the mattress at its lowest
mattress_to_top = 26 * inch;
// space between slats
max_slat_slat_gap = (2 + (3/8)) * inch;
// space between slats
max_slat_mattress_gap = 1 * inch;

// some ikea model
mattress_width = 27.5 * inch;
mattress_length = 52 * inch;
mattress_depth = 3.125 * inch;

// from grid beam
beam_width = 1.5 * inch;


// fewer cuts
leg_height = 36 * inch;


mattress_to_floor = leg_height - (mattress_to_top + mattress_depth);


total_gridbeam = 0 * inch;

total_gridbeam = total_gridbeam + beam_width;

module bom_zbeam(len) {
	total_gridbeam = total_gridbeam + (len * beam_width);
	zBeam(len);
}
module bom_ybeam(len) {
	total_gridbeam = total_gridbeam + (len * beam_width);
	yBeam(len);
}
module bom_xbeam(len) {
	total_gridbeam = total_gridbeam + (len * beam_width);
	xBeam(len);
}


// the mattress
translate([0, 0, mattress_to_floor]){
	color("lightcyan") cube([mattress_width, mattress_length, mattress_depth]);
}


module leg() {
	color("BurlyWood") bom_zbeam(leg_height / beam_width);
}

leg_x1 = -beam_width;
leg_x2 = mattress_width;
leg_y1 = 0;
leg_y2 = mattress_length - beam_width;

translate([leg_x1, leg_y1, 0]) leg();
translate([leg_x2, leg_y1, 0]) leg();
translate([leg_x2, leg_y2, 0]) leg();
translate([leg_x1, leg_y2, 0]) leg();


module long_box_side() {
	bom_ybeam(2 + (mattress_length / beam_width));
}

module short_box_side() {
	bom_xbeam(4 + (mattress_width / beam_width));
}

module box(z) {
	translate([-2 * beam_width, -beam_width, z]) long_box_side();
	translate([mattress_width + beam_width, -beam_width, z]) long_box_side();

	translate([-2 * beam_width, -beam_width, z + beam_width]) short_box_side();
	translate([-2 * beam_width, mattress_length, z + beam_width]) short_box_side();
}

box(mattress_to_floor - beam_width);
box(leg_height - (2 * beam_width));


module slat_support() {
	bom_ybeam((mattress_length / beam_width) - 2);
}

translate([0, beam_width, mattress_to_floor]) {
	translate([-beam_width, 0, 0]) slat_support();
	translate([mattress_width, 0, 0]) slat_support();
}


module slat() {
	translate([0, -beam_width, mattress_to_floor + beam_width]) {
		bom_zbeam(((mattress_to_top + mattress_depth) / beam_width) - 2);
	}
}

module slats(n) {
	for (i = [0: n]) {
		translate([2 * i * beam_width, 0,0]) slat();
	}
}

translate([beam_width, 0, 0]) slats(8);
translate([beam_width, mattress_length + beam_width, 0]) slats(8);

rotate([0,0,90]) {
	translate([2 * beam_width, beam_width, 0]) slats(15);
	translate([2 * beam_width, -mattress_width, 0]) slats(15);
}

echo(total_gridbeam);