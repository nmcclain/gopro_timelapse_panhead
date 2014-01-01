use <from_thingiverse/5505-publicDomainGearV1_1.scad>;

$fn = 100;

module gopro_base () {    
  gear_guide_layer_height = gear_height+1;
  pin_height = gear_guide_layer_height+(gear_height*3/4);

  union() { // main base
    cube([base_length, base_width, gear_guide_layer_height/4]); // Base layer
    translate([0, 0, gear_guide_layer_height/4]) difference() { // Gear guide + pins layer
      cube([base_length, base_width, gear_guide_layer_height]); // main gear guide layer
      union() {
        translate([large_gear_or+buffer, base_width/2, 0]) difference() { // harge gear hole
          cylinder(gear_guide_layer_height, large_gear_or, large_gear_or);
          cylinder(gear_height-1.5, pin_r, pin_r);
        }
        translate([small_gear_or+large_gear_or*2-tooth_depth, base_width/2, 0]) difference() {
          cylinder(gear_guide_layer_height, small_gear_or, small_gear_or);
          cylinder(gear_height-1.5, pin_r, pin_r);
        }
      }
    }

    // connector pins for top
    translate([buffer+hole, buffer+hole, 0]) cylinder(pin_height, pin_edge_r, pin_edge_r);
    translate([buffer+hole, base_width-(buffer+hole), 0]) cylinder(pin_height, pin_edge_r, pin_edge_r);
    translate([base_length-(buffer+hole), buffer+hole, 0]) cylinder(pin_height, pin_edge_r, pin_edge_r);
    translate([base_length-(buffer+hole), base_width-(buffer+hole), 0]) cylinder(pin_height, pin_edge_r, pin_edge_r);
  }

  // corner pads - to help the thing stick w/o printing a raft layer
  cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
  translate([0, base_width, 0]) cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
  translate([base_length, 0, 0]) cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
  translate([base_length, base_width, 0]) cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
};


module gopro_top () {

  difference() {
   // main top plus servo holder
   union() {
     cube([base_length, base_width, gear_height/4]); // main top layer
     difference () { // servo holder
       translate([15, (base_width/2) - (servo_width+buffer)/2, gear_height/4]) cube([servo_length+buffer*2, servo_width+buffer, servo_bottom_height+4]); 
       translate([15+buffer/2, (base_width/2) - (servo_width)/2 , (gear_height/4)+4]) cube([servo_length, servo_width, servo_bottom_height]); 
     }
   }

   //pins 
   translate([buffer+hole, buffer+hole, 0]) cylinder(gear_height*2, hole, hole);
   translate([buffer+hole, base_width-(buffer+hole), 0]) cylinder(gear_height*2, hole, hole);
   translate([base_length-(buffer+hole), buffer+hole, 0]) cylinder(gear_height*2, hole, hole);
   translate([base_length-(buffer+hole), base_width-(buffer+hole), 0]) cylinder(gear_height*2, hole, hole);
   
   // gear connector holes
   translate([large_gear_or, base_width/2, gear_height/4]) cylinder(servo_bottom_height, servo_width/2, servo_width/2); // large servo hole
   translate([large_gear_or-7, base_width/2, gear_height/4]) cylinder(servo_bottom_height, 3, 3); // small servo hole
   translate([large_gear_or, base_width/2, 0]) cylinder(servo_bottom_height, 4, 4); // smallest servo hole
   translate([small_gear_or+large_gear_or*2-tooth_depth, base_width/2, 0]) cylinder(gear_height, small_gear_or-tooth_depth, small_gear_or-tooth_depth); // small gear gopro mount hole

  }

  // corner pads - to help the thing stick w/o printing a raft layer
  cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
  translate([0, base_width, 0]) cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
  translate([base_length, 0, 0]) cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
  translate([base_length, base_width, 0]) cylinder(corner_pad_height, corner_pad_r, corner_pad_r);
}

module gopro_small_gear ( ) {
  // GoPro mount on small gear:
  small_gear_or = outer_radius(mm_per_tooth=mm_per_tooth,number_of_teeth=small_gear_teeth,clearance=0);
  union() {
    translate([0, -4, gear_height*2]) difference() {
      translate([0, 0, -100]) import("from_thingiverse/117862-gopro_mount.stl");  
      translate([-10, -5, -42]) cube([20,20,40]);
    }
    translate([0, 0, gear_height/2]) cylinder(gear_height, small_gear_or-tooth_depth-1, small_gear_or-tooth_depth-1);
    gear(mm_per_tooth=mm_per_tooth,number_of_teeth=small_gear_teeth,thickness=gear_height,hole_diameter=hole*2);
  }
}


module gopro_large_gear ( ) {
  // servo arm mount on large gear:
  difference() {
    gear(mm_per_tooth=mm_per_tooth,number_of_teeth=large_gear_teeth,thickness=gear_height,hole_diameter=hole*2);

    hull() {
      translate([0, 0, 0]) cylinder(2, servo_arm_mid_r, servo_arm_mid_r, 0);
      translate([servo_arm_len, 0, 0]) cylinder(2, servo_arm_end_r, servo_arm_end_r, 0);
      translate([-servo_arm_len, 0, 0]) cylinder(2, servo_arm_end_r, servo_arm_end_r, 0);
    }
    
    // servo arm screw holes
    translate([11, 0, -5]) cylinder(10, servo_screw_hole_r, servo_screw_hole_r, 0);
    translate([-11, 0, -5]) cylinder(10, servo_screw_hole_r, servo_screw_hole_r, 0);
    translate([7, 0, -5]) cylinder(10, servo_screw_hole_r, servo_screw_hole_r, 0);
    translate([-7, 0, -5]) cylinder(10, servo_screw_hole_r, servo_screw_hole_r, 0);
  }
}

///////////////////////////////////////
buffer = 2;
gear_height = 3;
hole=4;

large_gear_teeth = 20;
small_gear_teeth = 10;
tooth_depth = 2;
mm_per_tooth = 9;

large_gear_or = outer_radius(mm_per_tooth=mm_per_tooth,number_of_teeth=large_gear_teeth,clearance=-1);
small_gear_or = outer_radius(mm_per_tooth=mm_per_tooth,number_of_teeth=small_gear_teeth,clearance=-1);

pin_edge_r = hole-.15;
pin_r = hole-.2;

servo_arm_end_r = 2;
servo_arm_len = 14;
servo_arm_mid_r = 4;
servo_bottom_height = 4.5;
servo_length = 23.5;
servo_width = 12.5;
servo_screw_hole_r = .9;

corner_pad_height = .2;
corner_pad_r = 4;

base_length = small_gear_or*2+large_gear_or*2-tooth_depth+buffer;
base_width = large_gear_or*2 + 2*buffer;

///////////////////////////////////////
// Small Gear
translate([-30, 40, gear_height/2]) gopro_small_gear();

// Large Gear
translate([-35, -20, gear_height/2]) gopro_large_gear();

// Base
translate([0, 3, 0]) gopro_base(gear_height=gear_height, buffer = 2, large_gear_or = large_gear_or, small_gear_or = small_gear_or, tooth_depth = 5, hole=hole);

// Top
translate([0, -2*large_gear_or-5, 0]) gopro_top();

