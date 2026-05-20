// Regular walls

/turf/closed/wall
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/r_wall
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/reinforced_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/ice
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/icedmetal_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

// Mineral walls

/turf/closed/wall/mineral/silver
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/silver_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/uranium
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/uranium_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/wood
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/wood_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/iron
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/iron_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/titanium
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/shuttle_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ|SMOOTH_DIAGONAL_CORNERS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/titanium/nodiagonal
	icon = MAP_SWITCH('modular_doppler/sprite_swaps/icons/turfs/walls/shuttle_wall.dmi', 'icons/turf/walls/misc_wall.dmi')
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/titanium/overspace
	icon = MAP_SWITCH('modular_doppler/sprite_swaps/icons/turfs/walls/shuttle_wall.dmi', 'icons/turf/walls/misc_wall.dmi')
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ|SMOOTH_DIAGONAL_CORNERS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/titanium/survival
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/survival_pod_walls.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/wall/mineral/titanium/survival/nodiagonal
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/survival_pod_walls.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

// Material walls

/turf/closed/wall/material
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/material_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

// Indestructible walls

/turf/closed/indestructible/reinforced
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/reinforced_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/reinforced/titanium
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/shuttle_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/riveted
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/riveted.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/riveted/uranium
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/uranium_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/wood
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/wood_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/iron
	icon = 'modular_doppler/sprite_swaps/icons/turfs/walls/iron_wall.dmi'
	smoothing_flags = SMOOTH_BITMASK|SMOOTH_OBJ
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
