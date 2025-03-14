/datum/species/grey
	name = "\improper Grey"
	plural_form = "Grey"
	id = SPECIES_GREY
	preview_outfit = /datum/outfit/ramatan_preview
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_PREVENT_BLINKING,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	payday_modifier = 1.0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/grey,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/grey,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/grey,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/grey,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/grey,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/grey,
	)
