/obj/item/stack/sheet/aluminum
	name = "aluminum blocks"
	singular_name = "aluminum block"
	desc = "Solid blocks of recycled aluminum, ready to be sent off to shipyards or to the back of the local \
		gakster's wagon when you're not looking."
	icon = 'modular_doppler/shipbreaking/icons/stacks.dmi'
	icon_state = "aluminum"
	inhand_icon_state = "aluminum"
	mats_per_unit = list(
		/datum/material/aluminum = SHEET_MATERIAL_AMOUNT,
	)
	material_type = /datum/material/aluminum
	merge_type = /obj/item/stack/sheet/aluminum
	walltype = /turf/closed/wall/mineral/aluminum

/datum/material/aluminum
	name = "aluminum"
	desc = "Common aluminum used most often in spacecraft interiors."
	color = "#9b9893"
	categories = list(
		MAT_CATEGORY_SILO = TRUE,
		MAT_CATEGORY_RIGID = TRUE,
		MAT_CATEGORY_BASE_RECIPES = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL_COMPLEMENTARY = TRUE,
	)
	sheet_type = /obj/item/stack/sheet/aluminum
	ore_type = null
	value_per_unit = 30 / SHEET_MATERIAL_AMOUNT
	minimum_value_override = 20
	mat_rust_resistance = RUST_RESISTANCE_TITANIUM
	mineral_rarity = 0
	points_per_unit = 1 / SHEET_MATERIAL_AMOUNT
	minimum_value_override = 0
	tradable = TRUE
	tradable_base_quantity = MATERIAL_QUANTITY_UNCOMMON
	fish_weight_modifier = 1.1
	strength_modifier = 0.8
	integrity_modifier = 0.8

/datum/material/aluminum/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
	return TRUE

/obj/item/stack/sheet/nanocarbon
	name = "nanocarbon wafers"
	singular_name = "nanocarbon wafer"
	desc = "Processed wafers of recycled nanocarbon alloy. While an excellent material for ship hulls, the material \
		properties require specialist tools to form and make permanent repairs to."
	icon = 'modular_doppler/shipbreaking/icons/stacks.dmi'
	icon_state = "nanocarbon"
	inhand_icon_state = "nanocarbon"
	mats_per_unit = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT,
	)
	material_type = /datum/material/nanocarbon
	merge_type = /obj/item/stack/sheet/nanocarbon
	walltype = /turf/closed/wall/mineral/nanocarbon/standard

/datum/material/nanocarbon
	name = "nanocarbon"
	desc = "Extremely rigid engineered micro-carbon alloy for ship hulls."
	color = "#39373b"
	categories = list(
		MAT_CATEGORY_SILO = TRUE,
		MAT_CATEGORY_RIGID = TRUE,
		MAT_CATEGORY_BASE_RECIPES = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL_COMPLEMENTARY = TRUE,
	)
	sheet_type = /obj/item/stack/sheet/nanocarbon
	ore_type = null
	value_per_unit = 50 / SHEET_MATERIAL_AMOUNT
	minimum_value_override = 40
	mat_rust_resistance = RUST_RESISTANCE_TITANIUM
	mineral_rarity = 0
	points_per_unit = 1 / SHEET_MATERIAL_AMOUNT
	minimum_value_override = 0
	tradable = TRUE
	tradable_base_quantity = MATERIAL_QUANTITY_RARE
	fish_weight_modifier = 0.8
	strength_modifier = 1.5
	integrity_modifier = 0.8 // it shatters instead of denting

/datum/material/nanocarbon/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
	return TRUE

/datum/armor/nanocarbon_anything
	melee = 50
	bullet = 40
	laser = 20
	energy = 20
	bomb = 25
	fire = 100
	acid = 100

/obj/item/nanocarbon_shard
	name = "nanocarbon shard"
	desc = "A wicked looking shard of fractured nanocarbon, number one cause of suit punctures in orbit today."
	icon = 'modular_doppler/shipbreaking/icons/turfs/walls_misc.dmi'
	icon_state = "nanoshard_1"
	base_icon_state = "nanoshard"
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	w_class = WEIGHT_CLASS_SMALL
	max_integrity = 150
	armor_type = /datum/armor/nanocarbon_anything
	force = 5
	throwforce = 10
	sharpness = SHARP_EDGED
	embed_type = /datum/embedding/shard
	custom_materials = list(
		/datum/material/nanocarbon = HALF_SHEET_MATERIAL_AMOUNT
	)
	/// How many variants of shard there are
	var/variants = 5

/obj/item/nanocarbon_shard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = force, paralyze_duration = 2 SECONDS, soundfile = hitsound)
	icon_state = "[base_icon_state]_[rand(1, variants)]"
