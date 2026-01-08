include <BOSL2/std.scad>
include <BOSL2/walls.scad>

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>

pcb_thickness = pcb_thickness(RPI4);

plate_thickness = pcb_thickness(RPI4);
plate_length = 90;
plate_width = 60;
plate_rounding = 5;

ear_thickness = pcb_thickness(RPI4);
ear_length = 10;
ear_width = 8;
ear_offset = 30;
ear_hole = 3;

module ear() {
    diff("ear_remove", "ear_keep") 
        cuboid([ear_width, ear_thickness, ear_length], rounding = -ear_width / 2, edges = [BOT + RIGHT, BOT + LEFT]) {
            tag("ear_remove") attach(FRONT, CENTER) 
                back(ear_length / 2 - ear_width / 2)
                    cylinder(h=5, r=ear_hole / 2);
            tag("ear_remove") edge_profile([TOP + LEFT, TOP + RIGHT]) 
                mask2d_roundover(r=ear_width / 2);
        }
};

module plate() {
    diff("plate_remove", "plate_keep") {
        cuboid([plate_length, plate_width, plate_thickness], rounding=plate_rounding, edges=[FWD + RIGHT, FWD + LEFT, BACK + RIGHT, BACK + LEFT]) {
            attach(BACK, BOT) {
                right(ear_offset) ear();
                left(ear_offset) ear();
            }
            attach(FWD, BOT) {
                right(ear_offset) ear();
                left(ear_offset) ear();
            }
            tag("plate_keep") attach(CENTER,CENTER) {
                hex_panel([plate_length - 5, plate_width - 20, plate_thickness], 2, 14, frame = 0);
            }
        }
        tag("plate_remove") 
            cuboid([plate_length - 5, plate_width - 20, plate_thickness + 1], rounding=plate_rounding, edges=[FWD + RIGHT, FWD + LEFT, BACK + RIGHT, BACK + LEFT]);
    }
}



difference() {
    plate();
    pcb_screw_positions(RPI4) {
        translate_z(plate_thickness)
            screw(M2p5_dome_screw, 10);
    }
}