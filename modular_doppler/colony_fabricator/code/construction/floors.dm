// Stacks of floor tiles

/obj/item/stack/tile/catwalk_tile/colony_lathe
	icon = 'modular_doppler/colony_fabricator/icons/tiles_item.dmi'
	icon_state = "prefab_catwalk"
	mats_per_unit = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT)
	turf_type = /turf/open/floor/catwalk_floor/colony_fabricator
	merge_type = /obj/item/stack/tile/catwalk_tile/colony_lathe
	tile_reskin_types = null

/obj/item/stack/tile/iron/colony
	name = "high-strength plastic floor tiles"
	singular_name = "high-strength plastic floor tile"
	desc = "A stack of large floor tiles of a high-strength plasma plastic, perfect for spilling on and having to clean later."
	icon = 'modular_doppler/colony_fabricator/icons/tiles_item.dmi'
	icon_state = "colony_grey"
	turf_type = /turf/open/floor/iron/colony
	merge_type = /obj/item/stack/tile/iron/colony
	tile_reskin_types = list(
		/obj/item/stack/tile/iron/colony,
		/obj/item/stack/tile/iron/colony/texture,
		/obj/item/stack/tile/iron/colony/bolts,
		/obj/item/stack/tile/iron/colony/white,
		/obj/item/stack/tile/iron/colony/white/texture,
		/obj/item/stack/tile/iron/colony/white/bolts,
	)

// Grated floor tile, for seeing wires under

/turf/open/floor/catwalk_floor/colony_fabricator
	icon = 'modular_doppler/colony_fabricator/icons/tiles.dmi'
	icon_state = "prefab_above"
	catwalk_type = "prefab"
	baseturfs = /turf/open/floor/plating
	floor_tile = /obj/item/stack/tile/catwalk_tile/colony_lathe

// "Normal" floor tiles

/obj/item/stack/tile/iron/colony/texture
	icon_state = "colony_grey_texture"
	turf_type = /turf/open/floor/iron/colony/texture

/obj/item/stack/tile/iron/colony/bolts
	icon_state = "colony_grey_bolts"
	turf_type = /turf/open/floor/iron/colony/bolts

/turf/open/floor/iron/colony
	icon = 'modular_doppler/colony_fabricator/icons/tiles.dmi'
	icon_state = "colony_grey"
	base_icon_state = "colony_grey"
	floor_tile = /obj/item/stack/tile/iron/colony
	tiled_dirt = FALSE

/turf/open/floor/iron/colony/texture
	icon_state = "colony_grey_texture"
	base_icon_state = "colony_grey_texture"
	floor_tile = /obj/item/stack/tile/iron/colony/texture

/turf/open/floor/iron/colony/bolts
	icon_state = "colony_grey_bolts"
	base_icon_state = "colony_grey_bolts"
	floor_tile = /obj/item/stack/tile/iron/colony/bolts

// White variants of the above tiles

/obj/item/stack/tile/iron/colony/white
	icon_state = "colony_white"
	turf_type = /turf/open/floor/iron/colony/white

/obj/item/stack/tile/iron/colony/white/texture
	icon_state = "colony_white_texture"
	turf_type = /turf/open/floor/iron/colony/white/texture

/obj/item/stack/tile/iron/colony/white/bolts
	icon_state = "colony_white_bolts"
	turf_type = /turf/open/floor/iron/colony/white/bolts

/turf/open/floor/iron/colony/white
	icon_state = "colony_white"
	base_icon_state = "colony_white"
	floor_tile = /obj/item/stack/tile/iron/colony/white

/turf/open/floor/iron/colony/white/texture
	icon_state = "colony_white_texture"
	base_icon_state = "colony_white_texture"
	floor_tile = /obj/item/stack/tile/iron/colony/white/texture

/turf/open/floor/iron/colony/white/bolts
	icon_state = "colony_white_bolts"
	base_icon_state = "colony_white_bolts"
	floor_tile = /obj/item/stack/tile/iron/colony/white/bolts
