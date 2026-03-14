# GraviTrax Compatible Vertical Slam Launcher

This repository contains an OpenSCAD model for a custom, 3D-printable add-on designed to be compatible with the **GraviTrax** marble run system.

## Overview
This part functions as a **Vertical Slam Launcher**. When a marble enters the base unit, the user can strike the built-in button. This mechanism transfers the force through a pivot lever to a piston, rapidly launching the marble up a vertical shaft. At the top of the shaft, a 90-degree curved guide smoothly redirects the marble horizontally onto a higher track.

## Components
The model is composed of four main printable parts:
1. **Housing (`housing`)**: The main body featuring the hexagonal GraviTrax base, marble input track, vertical launch shaft, and the curved top exit track.
2. **Button (`button`)**: The external plunger you strike to activate the launcher.
3. **Lever (`lever`)**: An internal pivoting beam that reverses the downward motion of the button into an upward motion.
4. **Piston (`piston`)**: A cupped cylinder that sits beneath the marble and shoots it upward through the central shaft when struck by the lever.

## How to Render & Export
The `marble-launcher.scad` file uses a centralized `render_mode` variable to control what is displayed and rendered. To export the parts for 3D printing, simply change the `render_mode` variable on line 27 of the `.scad` file.

Available modes:
* `"assembly"`: Displays the fully assembled model with colors (great for visualizing how the parts fit together).
* `"layout"`: Lays out all four parts flat on the build plate, ready to be exported as a single STL for printing.
* `"housing"`, `"lever"`, `"piston"`, `"button"`: Renders only the individual, corresponding part.

## Parameters
The script is heavily parameterized. If you need to tweak the design for different clearances (depending on your 3D printer's tolerances) or modify the height of the launch shaft, you can easily adjust the variables at the top of the `.scad` file:

* `marble_dia`: Size of the marble (default 11.5mm)
* `clearance`: Tolerance between moving parts (default 0.4mm)
* `shaft_height`: How high the launcher shoots before the curve (default 70mm)
* `bend_radius` and `exit_length`: Controls the geometry of the top exit curve.

## Assembly
You will need a small pin or piece of filament (approx. 3.2mm diameter) to act as the hinge for the lever. Insert the lever into the bottom slot, string the pin through the housing and lever, drop the piston down the main shaft, and insert the button into the side guide hole.
