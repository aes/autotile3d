# Autotile 3D

Toolkit and asset pipeline for automatically tiling 3D gridmap
environments, from tile modeling through rough block-out to dynamic
re-tiling.

## Basic idea

Same as in two dimensions, have users to decide the region of corners
and leave the computer to pick the appropriate tiles.

In 3D, some parts become more difficult and some easier: We don't need
to consider crossovers between all different kinds of regions, because
we only need to consider inside walls, (floor, ceilings), and we can
normally get away with only rendering the region the camera is in.
(This one's a bit of a head-scratcher: Exteriors are just the
interiors of the outdoors.)

The number of corners make the tile-sets annoyingly large however.
With four corners in 2D and two region types, we get 2**4, or 16
different tiles, without symmetry, and 6 if using all symmetries.

(none, 1-corner, 2 contiguous, 2 opposite (checkerboard), 3-corners,
full) Or, if you prefer, (all sea, a corner of sand, straight beach,
touching corners, a corner of sea, all sand).

In 3D, that's eight corners, and 2**8, or 256 different tiles, without
symmetry, and 22 if using all symmetries. (One of which is the tile
without any transition in it, used for both empty and full)

## Features

- Example (21) models for using all symmetries

- Utility for stepping through the 256 corner combinations to make /
  inspect a tile mapping table

- Auto-tiler capable of generating both insides and outsides

- Project is simple at all stages, and easy to modify

## Usage

To use this, first examine the demo_scene in auto_map and copy what
you need and adapt it to your own project. The reason for this
recommendation is that requirements for different uses are going to
diverge to the point where trying to support them directly is
hopeless.

One simple way to get something useful is to simply sketch out a nice
level in the editor by dropping some cubes in the SourceMap and simply
copy the resulting gridmap(s) to your game. (The AutoMap script is a
`@tool` and renders the InnerMap and OuterMap a few times a second)

At present, there's only the full symmetries mesh library, but there's
nothing to stop you from making one with a different choice. Patches
welcome!

### Mesh library work flow

To make a mesh library, load the included blender file and model away.

#### Modeling

If you're modeling, I don't need to explain how the mesh edges need to
match up, but it *is* hard, and there are a lot of tiles. I would
start with the all-symmetries meshes and modify the boundaries to be
more like the style I intend. Make one example of the most common
interior corner, but don't bother to copy it out until you know you
can make acceptable geometries for the strange saddle-shape cases.

Again, note that all walls are interior walls, as the exterior walls
are just the interior walls of the outdoors. Since walls run in the
middle of the unit cube, they're set back from the exact center, a bit
like the middle field of a tri-color Nordic cross flag.

#### Export

In Blender, name the meshes sensibly, it seems to control the order
meshes get put in the mesh library later. (Generally, try to get
everything right as far upstream as possible) Select the actual tile
meshes (and whatever supplementary tiles you want in the mesh library)
and exclude markers and dummies you use only for modeling. Export as
`glb`, making sure to (a) export selected and (b) save the export
settings.

#### Conversion to mesh library

In Godot, open the `glb` file using the "New Inherited Scene" context
menu action and export using main menu -> Scene -> Export as -> MeshLibrary.

#### Map meshes to corner cases

Load the MapConfigurator scene and (IMPORTANT!) uncomment the input
lines for saving the table, the FILE_NAME constant and set your mesh
library on the GridMap.

Run it and go through the 256 cases, and for each, choose the correct
mesh of the 22 (or more, if you have less symmetry) and set it in the
correct orientation (of the 24 possible) to cover the visible balls
and red labels. (IMPORTANT!) **Save**. Preferably early, often, and in
version control.

Yes, this is tedious, but it not quite as horrible as it sounds,
especially if you don't screw up the mesh naming if/when you go back
and edit them.

Pro tip: Since the mapping resource file is JSON, you can work out
some of the data in the programming language of your choice so you
don't have puzzle each and every last one into place.

#### Putting it all together

This is where paths will diverge because use-cases are different, but
one way is to set the mesh libraries on the InnerMap and the OuterMap,
and the table file and plonking down cubes in the SourceMap to design
something and copy the result.
