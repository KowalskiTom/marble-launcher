// Gravitrax Compatible Vertical Slam Launcher (Curved Top - Fixed Bounding Box)

$fn = 60;

// --- Core Parameters ---
marble_dia = 11.5;
clearance = 0.4;         
hex_radius = 60 / sqrt(3); // 60 mm edge-to-edge
base_height = 10;
shaft_height = 70;       
shaft_outer_dia = 16.75;
shaft_inner_dia = marble_dia + 2;

// --- Split Parameters ---
split_z = 40;
sleeve_height = 12;
sleeve_outer_dia = shaft_outer_dia + 6;

// --- Bend Parameters ---
bend_radius = 20;        
exit_length = 25;        

// --- Mechanism Geometry ---
lever_length = 26;
lever_width = 8;
lever_thickness = 5;
pivot_x = -14;           
button_x = -21;          

// --- Rendering Control ---
// Set to "assembly", "layout", "housing_bottom", "housing_top", "lever", "piston", "button", or "pin"
render_mode = "assembly"; 

if (render_mode == "assembly") {
    housing_bottom();
    housing_top();
    color("Orange") translate([pivot_x, 0, 5]) lever();
    color("SteelBlue") translate([0, 0, 6]) piston();
    color("FireBrick") translate([button_x, 0, 10]) button();
    color("Silver") translate([pivot_x, 0, 5]) rotate([90, 0, 0]) pin();
} else if (render_mode == "layout") {
    // Print Layout (all parts flat)
    housing_bottom();
    translate([0, 50, 0]) translate([0, 0, -split_z]) housing_top();
    translate([35, 35, lever_thickness/2]) lever();
    translate([65, 35, 0]) piston();
    translate([85, 35, 0]) button();
    translate([100, 45, 1.5]) rotate([0, 90, 0]) pin();
} else if (render_mode == "housing_bottom") {
    housing_bottom();
} else if (render_mode == "housing_top") {
    translate([0, 0, -split_z]) housing_top();
} else if (render_mode == "lever") {
    lever();
} else if (render_mode == "piston") {
    piston();
} else if (render_mode == "button") {
    button();
} else if (render_mode == "pin") {
    pin();
}

module housing() {
    difference() {
        union() {
            // Main Hex Base
            rotate([0, 0, 30]) cylinder(r=hex_radius, h=base_height, $fn=6);
            
            // Vertical Shaft
            cylinder(d=shaft_outer_dia, h=shaft_height);
            
            // Shaft Fillet/Support for strength
            translate([0, 0, base_height]) cylinder(r1=(hex_radius-2)/2, r2=shaft_outer_dia/2, h=7.5);
            
            // Button Guide Housing
            // Widened to fit the internal flange, heightened for strength
            translate([button_x, 0, 0]) cylinder(d=18, h=base_height + 6);
            
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
            
            // Top Exit Platform (provides bottom for track notches)
            translate([bend_radius + exit_length - 15, -shaft_outer_dia/2, shaft_height + bend_radius - 12])
                cube([15, shaft_outer_dia, 12]);
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

        // --- Top Exit Notches ---
        // Pocket behind the front fence (floor at Z=79.5)
        translate([35, 6.5/2, 79.5])
            cube([43.5 - 35, (marble_dia + 3 - 6.5)/2, 20]);
        translate([35, -(marble_dia + 3)/2, 79.5])
            cube([43.5 - 35, (marble_dia + 3 - 6.5)/2, 20]);

        // Semi-circle cutouts at the back of the pocket
        translate([35, 6.5/2 + (marble_dia + 3 - 6.5)/4, 79.5])
            cylinder(d=(marble_dia + 3 - 6.5)/2, h=20);
        translate([35, -(marble_dia + 3)/2 + (marble_dia + 3 - 6.5)/4, 79.5])
            cylinder(d=(marble_dia + 3 - 6.5)/2, h=20);

        // Cut above the front fence (fence top at Z=80.7, thickness 1.5mm from X=43.5 to X=45)
        translate([43.5, 6.5/2, 80.7])
            cube([10, (marble_dia + 3 - 6.5)/2, 20]);
        translate([43.5, -(marble_dia + 3)/2, 80.7])
            cube([10, (marble_dia + 3 - 6.5)/2, 20]);

        // Marble Input Track (Standard 10mm height matching Gravitrax tiles)
        translate([0, 0, base_height + 2]) rotate([0, 90, 0])
            cylinder(d=marble_dia + 3, h=hex_radius + 5);
        
        // Cut open the top of the input track
        translate([0, -(marble_dia + 3)/2, base_height + 2])
            cube([hex_radius + 5, marble_dia + 3, marble_dia + 5]);

        // Gravitrax entrance notches for track clips
        // Outer width matches the track width (marble_dia + 3), inner tongue is 6.5mm wide
        // Pocket behind the front fence (floor at Z=1.5)
        translate([20, 6.5/2, 1.5])
            cube([28.5 - 20, (marble_dia + 3 - 6.5)/2, base_height + 5]);
        translate([20, -(marble_dia + 3)/2, 1.5])
            cube([28.5 - 20, (marble_dia + 3 - 6.5)/2, base_height + 5]);

        // Semi-circle cutouts at the back of the pocket
        translate([20, 6.5/2 + (marble_dia + 3 - 6.5)/4, 1.5])
            cylinder(d=(marble_dia + 3 - 6.5)/2, h=base_height + 5);
        translate([20, -(marble_dia + 3)/2 + (marble_dia + 3 - 6.5)/4, 1.5])
            cylinder(d=(marble_dia + 3 - 6.5)/2, h=base_height + 5);

        // Cut above the front fence (fence top at Z=2.7, thickness 1.5mm from X=28.5 to X=30)
        translate([28.5, 6.5/2, 2.7])
            cube([10, (marble_dia + 3 - 6.5)/2, base_height + 5]);
        translate([28.5, -(marble_dia + 3)/2, 2.7])
            cube([10, (marble_dia + 3 - 6.5)/2, base_height + 5]);

        // Lever Slot (Bottom cutout)
        translate([pivot_x, 0, 5])
            cube([lever_length + 6, lever_width + 2, lever_thickness + 6], center=true);

        // Pivot Pin Hole
        translate([pivot_x, 0, 5]) rotate([90, 0, 0])
            cylinder(d=3.2, h=hex_radius*2, center=true);

        // Button Flange Clearance (Wider part at bottom to allow button to travel)
        translate([button_x, 0, -1])
            cylinder(d=14 + clearance, h=14);

        // Button Guide Hole (Narrow part at top to stop flange)
        translate([button_x, 0, 12])
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
        cylinder(d=shaft_inner_dia - clearance*2, h=marble_dia/2);
        translate([0, 0, marble_dia/2]) sphere(d=marble_dia);
    }
}

module button() {
    union() {
        cylinder(d=12 - clearance*2, h=20); // Longer shaft to extend above the taller housing
        cylinder(d=14 - clearance*2, h=3);  // Flange at bottom
    }
}

module pin() {
    cylinder(d=3.2 - clearance/2, h=54, center=true);
}

module housing_bottom() {
    difference() {
        union() {
            difference() {
                housing();
                translate([-100, -100, split_z]) cube([200, 200, 200]);
            }
            // Support chamfer
            translate([0, 0, split_z - sleeve_height - 5]) 
                cylinder(d1=shaft_outer_dia, d2=sleeve_outer_dia, h=5.01);
            // Thickened base and sleeve
            translate([0, 0, split_z - sleeve_height]) 
                cylinder(d=sleeve_outer_dia, h=sleeve_height * 2);
        }
        // Original internal bore up to split
        translate([0, 0, -1]) 
            cylinder(d=shaft_inner_dia, h=split_z + 2);
        
        // Sleeve cavity for the top half
        translate([0, 0, split_z]) 
            cylinder(d=shaft_outer_dia, h=sleeve_height + 2);
            
        // Inner chamfer for easy insertion
        translate([0, 0, split_z + sleeve_height - 1.5])
            cylinder(d1=shaft_outer_dia, d2=shaft_outer_dia + 3, h=1.51);
    }
}

module housing_top() {
    difference() {
        housing();
        translate([-100, -100, -100]) cube([200, 200, 100 + split_z]);
    }
}