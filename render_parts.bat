@echo off
rem Script to render all parts of the marble launcher to STL files
rem Requires OpenSCAD to be installed and accessible in PATH

set SCAD_FILE=marble-launcher.scad
set RENDER_DIR=renders
set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"

rem Create renders directory if it doesn't exist
if not exist "%RENDER_DIR%" (
    mkdir "%RENDER_DIR%"
    echo Created directory %RENDER_DIR%
)

rem Define parts to render: mode -> output filename
rem We'll render housing_bottom, housing_top, lever, piston, button, pin, assembly, layout
set PARTS=housing_bottom housing_top lever piston button pin assembly layout

for %%M in (%PARTS%) do (
    echo Rendering %%M...
    %OPENSCAD% -o "%RENDER_DIR%\marble-launcher-v1-%%M.stl" -D "render_mode=\"%%M\"" "%SCAD_FILE%"
    if errorlevel 1 (
        echo Error rendering %%M. Make sure OpenSCAD is installed and in PATH.
        exit /b 1
    )
    echo Rendered %%M to marble-launcher-v1-%%M.stl
)

echo All parts rendered successfully.