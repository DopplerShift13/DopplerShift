/datum/fish_source/sulfur_spring // DO NOT MERGE WITHOUT REMOVING - HI EPHE - Make fishing loot unique and not just lavaland fishing loot
	catalog_description = "Sulfurous springs"
	background = "background_dank"
	radial_state = "fryer"
	overlay_state = "portal_river"
	fish_table = list(
		FISHING_DUD = 5,
		/obj/item/stack/ore/slag = 15,
		/obj/item/fish/lavaloop = 15,
		/obj/structure/closet/crate/necropolis/tendril = 1,
		/obj/item/skeleton_key = 1,
		/obj/item/stack/sheet/mineral/runite = 1,
		/obj/effect/mob_spawn/corpse/human/charredskeleton = 1,
	)
	fish_counts = list(
		/obj/structure/closet/crate/necropolis/tendril = 1,
		/obj/item/skeleton_key = 1,
		/obj/item/stack/sheet/mineral/runite = 2,
	)
	fish_count_regen = list(
		/obj/structure/closet/crate/necropolis/tendril = 27 MINUTES,
		/obj/item/skeleton_key = 13 MINUTES,
		/obj/item/stack/sheet/mineral/runite = 15 MINUTES,
	)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 20
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_NONE
	associated_safe_turfs = list(/turf/open/water/sulfur_spring)

/datum/fish_source/sulfur_spring/reason_we_cant_fish(obj/item/fishing_rod/rod, mob/fisherman, atom/parent)
	. = ..()
	if(!HAS_TRAIT(rod, TRAIT_ROD_LAVA_USABLE))
		return "You'll need reinforced fishing line to fish in there."
