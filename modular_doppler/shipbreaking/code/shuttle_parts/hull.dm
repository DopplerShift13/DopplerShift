/turf/closed/wall/mineral/nanocarbon
	name = "nanocarbon hull"
	desc = "A durable nanocarbon-metal alloy hull used commonly in high endurance ships."
	icon = 'modular_doppler/shipbreaking/icons/turfs/nanocarbon_wall.dmi'
	icon_state = "nanocarbon_wall-0"
	base_icon_state = "nanocarbon_wall"
	explosive_resistance = 3
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD
	sheet_type = /obj/item/stack/sheet/mineral/titanium
	hardness = 20
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS
	custom_materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2)
	rust_resistance = RUST_RESISTANCE_ABSOLUTE

/turf/closed/wall/mineral/nanocarbon/nodiagonal
	icon = MAP_SWITCH('modular_doppler/shipbreaking/icons/turfs/nanocarbon_wall.dmi', 'modular_doppler/shipbreaking/icons/turfs/walls_misc.dmi')
	icon_state = MAP_SWITCH("nanocarbon_wall-0", "nanocarbon_nd")
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/wall/mineral/nanocarbon/black
	color = COLOR_DARK

/turf/closed/wall/mineral/nanocarbon/nodiagonal/black
	color = COLOR_DARK

/turf/closed/wall/mineral/nanocarbon/standard
	color = COLOR_SILVER

/turf/closed/wall/mineral/nanocarbon/nodiagonal/standard
	color = COLOR_SILVER

/turf/closed/wall/mineral/nanocarbon/red
	color = COLOR_BUBBLEGUM_RED

/turf/closed/wall/mineral/nanocarbon/nodiagonal/red
	color = COLOR_BUBBLEGUM_RED

/turf/closed/wall/mineral/nanocarbon/green
	color = COLOR_IRISH_GREEN

/turf/closed/wall/mineral/nanocarbon/nodiagonal/green
	color = COLOR_IRISH_GREEN

/turf/closed/wall/mineral/nanocarbon/blue
	color = COLOR_COMMAND_BLUE

/turf/closed/wall/mineral/nanocarbon/nodiagonal/blue
	color = COLOR_COMMAND_BLUE

/turf/closed/wall/mineral/nanocarbon/yellow
	color = COLOR_GOLD

/turf/closed/wall/mineral/nanocarbon/nodiagonal/yellow
	color = COLOR_GOLD

/turf/closed/wall/mineral/aluminum
	name = "aluminum wall"
	desc = "A thin aluminum wall, commonly used to plate the interior of ships."
	icon = 'modular_doppler/shipbreaking/icons/turfs/aluminum_wall.dmi'
	icon_state = "aluminum_wall-0"
	base_icon_state = "aluminum_wall"
	sheet_type = /obj/item/stack/sheet/mineral/titanium
	hardness = 50
	explosive_resistance = 0
	smoothing_groups = SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_TITANIUM_WALLS
	custom_materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT*2)
	rust_resistance = RUST_RESISTANCE_BASIC
