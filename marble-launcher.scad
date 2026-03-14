// Gravitrax Compatible Vertical Slam Launcher (Curved Top - Fixed Bounding Box)

$fn = 60;

// --- Core Parameters ---
marble_dia = 11.5;
clearance = 0.4;         
hex_radius = 60 / sqrt(3); // 60 mm edge-to-edge
base_height = 10;
shaft_height = 70;       
shaft_outer_dia = 20;
shaft_inner_dia = marble_dia + 2;

// --- Bend Parameters ---
bend_radius = 20;        
exit_length = 25;        

// --- Mechanism Geometry ---
lever_length = 26;
lever_width = 8;
lever_thickness = 5;
pivot_x = -11;           
button_x = -22;          

// --- Rendering Control ---
// Set to "assembly", "layout", "housing", "lever", "piston", or "button"
render_mode = "assembly"; 

if (render_mode == "assembly") {
    housing();
    color("Orange") translate([pivot_x, 0, 5]) lever();
    color("SteelBlue") translate([0, 0, 6]) piston();
    color("FireBrick") translate([button_x, 0, 10]) button();
} else if (render_mode == "layout") {
    // Print Layout (all parts flat)
    housing();
    translate([0, 35, lever_thickness/2]) lever();
    translate([30, 35, 0]) piston();
    translate([50, 35, 0]) button();
} else if (render_mode == "housing") {
    housing();
} else if (render_mode == "lever") {
    lever();
} else if (render_mode == "piston") {
    piston();
} else if (render_mode == "button") {
    button();
}

module housing() {
    difference() {
        union() {
            // Main Hex Base
            cylinder(r=hex_radius, h=base_height, $fn=6);
            
            // Vertical Shaft
            cylinder(d=shaft_outer_dia, h=shaft_height);
            
            // Shaft Fillet/Support for strength
            translate([0, 0, base_height]) cylinder(r1=hex_radius-2, r2=shaft_outer_dia/2, h=15);
            
            // Button Guide Housing
            translate([button_x, 0, 0]) cylinder(d=16, h=base_height + 4);
            
            // Top Curve Outer (Smooth 90 degree bend)
            translate([bend_radius, 0, shaft_height]) {
                intersection() {
                    rotate([90, 0, 0]) rotate_extrude($fn=$fn) 
                        translate([bend_radius, 0, 0]) circle(d=shaft_outer_dia);
                    // FIXED: Expanded bounding box to include the pipe thickness
                    translate([-(bend_radius + shaft_outer_dia), -shaft_outer_dia, 0]) 
                        cube([bend_radius + shaft_outer_dia, shaft_outer_dia*2, bend_radius + shaft_outer_dia]);
                }
            }
            
            // Horizontal Exit Outer Barrel
            translate([bend_radius, 0, shaft_height + bend_radius])
                rotate([0, 90, 0]) cylinder(d=shaft_outer_dia, h=exit_length);
        }

        // Central Shaft Internal Bore
        translate([0, 0, -1]) cylinder(d=shaft_inner_dia, h=shaft_height + 2);

        // Top Curve Internal Bore
        translate([bend_radius, 0, shaft_height]) {
            intersection() {
                rotate([90, 0, 0]) rotate_extrude($fn=$fn) 
                    translate([bend_radius, 0, 0]) circle(d=shaft_inner_dia);
                // FIXED: Expanded bounding box to include the inner pipe thickness
                translate([-(bend_radius + shaft_outer_dia), -shaft_outer_dia, -1]) 
                    cube([bend_radius + shaft_outer_dia, shaft_outer_dia*2, bend_radius + shaft_outer_dia + 1]);
            }
        }

        // Horizontal Exit Internal Bore
        translate([bend_radius - 1, 0, shaft_height + bend_radius])
            rotate([0, 90, 0]) cylinder(d=shaft_inner_dia, h=exit_length + 2);
            
        // Open the top of the horizontal exit barrel so it can transition to a track
        translate([bend_radius, -shaft_inner_dia/2, shaft_height + bend_radius])
            cube([exit_length + 2, shaft_inner_dia, shaft_inner_dia]);

        // Marble Input Track (Standard 10mm height matching Gravitrax tiles)
        translate([0, 0, base_height + 2]) rotate([0, 90, 0])
            cylinder(d=marble_dia + 1, h=hex_radius + 5);
        
        // Cut open the top of the input track
        translate([0, -(marble_dia + 1)/2, base_height + 2])
            cube([hex_radius + 5, marble_dia + 1, marble_dia + 5]);

        // Lever Slot (Bottom cutout)
        translate([pivot_x, 0, 5])
            cube([lever_length + 6, lever_width + 2, lever_thickness + 6], center=true);

        // Pivot Pin Hole
        translate([pivot_x, 0, 5]) rotate([90, 0, 0])
            cylinder(d=3.2, h=hex_radius*2, center=true);

        // Button Guide Hole
        translate([button_x, 0, -1])
            cylinder(d=12 + clearance, h=base_height + 10);
    }
}

module lever() {
    difference() {
        cube([lever_length, lever_width, lever_thickness], center=true);
        rotate([90, 0, 0]) cylinder(d=3.2 + clearance, h=lever_width + 2, center=true);
    }
}

module piston() {
    difference() {
        cylinder(d=shaft_inner_dia - clearance*2, h=12);
        translate([0, 0, 12]) sphere(d=marble_dia);
    }
}

module button() {
    union() {
        translate([0, 0, 14]) cylinder(d=18, h=4);
        cylinder(d=12 - clearance*2, h=14);
    }
}