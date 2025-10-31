#define TESHARI_TEMP_OFFSET -10 // K, added to comfort/damage limit etc
#define TESHARI_HEATMOD 1.3
#define TESHARI_COLDMOD 0.67 // Except cold.

/mob/living/carbon/human/species/teshari
	race = /datum/species/teshari

/datum/species/teshari
	name = "Teshari"
	plural_form = "Teshari"
	id = SPECIES_TESHARI
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_NO_UNDERWEAR,
	)
	digitigrade_customization = DIGITIGRADE_NEVER
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.0
	mutanttongue = /obj/item/organ/tongue/teshari
	coldmod = TESHARI_COLDMOD
	heatmod = TESHARI_HEATMOD
	bodytemp_normal = BODYTEMP_NORMAL + TESHARI_TEMP_OFFSET
	bodytemp_heat_damage_limit = (BODYTEMP_HEAT_DAMAGE_LIMIT + TESHARI_TEMP_OFFSET)
	bodytemp_cold_damage_limit = (BODYTEMP_COLD_DAMAGE_LIMIT + TESHARI_TEMP_OFFSET)
	species_language_holder = /datum/language_holder/teshari
	mutantears = /obj/item/organ/ears/teshari
	//mutantlungs = /obj/item/organ/lungs/adaptive/cold
	//body_size_restricted = TRUE
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/teshari,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/teshari,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/teshari,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/teshari,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/teshari,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/teshari,
	)
	meat = /obj/item/food/meat/slab/chicken/human

/datum/language_holder/teshari
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/schechi = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/schechi = list(LANGUAGE_ATOM))


/obj/item/organ/tongue/teshari
	liked_foodtypes = SEAFOOD | VEGETABLES | NUTS
	disliked_foodtypes = GROSS | GRAIN

/datum/species/teshari/prepare_human_for_preview(mob/living/carbon/human/tesh)
	var/base_color = "#c0965f"
	var/ear_color = "#e4c49b"

	tesh.dna.features[FEATURE_MUTANT_COLOR] = base_color
	tesh.dna.features[FEATURE_EARS] = list(MUTANT_INDEX_NAME = "Teshari Feathers Upright", MUTANT_INDEX_COLOR_LIST = list(ear_color, ear_color, ear_color))
	tesh.dna.features[FEATURE_TAIL_OTHER] = list(MUTANT_INDEX_NAME = "Teshari (Default)", MUTANT_INDEX_COLOR_LIST = list(base_color, base_color, ear_color))
	regenerate_organs(tesh, src, visual_only = TRUE)
	tesh.update_body(TRUE)

/datum/species/teshari/on_species_gain(mob/living/carbon/human/new_teshari, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	passtable_on(new_teshari, SPECIES_TRAIT) // TODO make it a toggleable ability

/datum/species/teshari/on_species_loss(mob/living/carbon/C, datum/species/new_species, pref_load)
	. = ..()
	passtable_off(C, SPECIES_TRAIT)

/datum/species/teshari/create_pref_unique_perks()
	var/list/perk_descriptions = list()

	perk_descriptions += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_RUNNING,
		SPECIES_PERK_NAME = "Tablerunning",
		SPECIES_PERK_DESC = "A being of extreme agility, you can jump on tables just by running into them!"
	))

	return perk_descriptions

/datum/species/teshari/get_species_description()
	return list(
		"todo"
	)

/datum/species/teshari/get_species_lore()
	return list(
		"no lore yet",
	)

/datum/species/teshari/generate_custom_worn_icon_fallback(item_slot, obj/item/item, mob/living/carbon/human/human_owner)
	. = ..()
	if(.)
		return

	// If there isn't even a fallback, use snouted sprites for masks and helmets, but offsetted
	if((item_slot == OFFSET_FACEMASK || item_slot == OFFSET_HEAD) && (item.supported_bodyshapes & BODYSHAPE_SNOUTED))
		var/obj/item/bodypart/head/my_head = human_owner.get_bodypart(BODY_ZONE_HEAD)
		var/datum/worn_feature_offset/selected_offset
		var/human_icon = item.bodyshape_icon_files[BODYSHAPE_SNOUTED_T]
		var/human_icon_state = item.worn_icon_state || item.icon_state
		if(item_slot == OFFSET_HEAD)
			selected_offset = my_head?.worn_head_offset
		else
			selected_offset = my_head?.worn_mask_offset

		// Did the snout variation flag lie to us?
		if(!icon_exists(human_icon, human_icon_state))
			return

		// Use already resolved icon
		use_custom_worn_icon_cached()
		var/icon/cached_icon = get_custom_worn_icon_cached(human_icon, human_icon_state, "m")
		if(cached_icon)
			return cached_icon

		// Generate muzzled icon, but offset
		var/icon/new_icon = icon('icons/blanks/32x32.dmi', "nothing")
		new_icon.Blend(icon(human_icon, human_icon_state), ICON_OVERLAY, x = selected_offset.offset_x["north"], y = selected_offset.offset_y["north"])
		new_icon.Insert(new_icon, human_icon_state)
		set_custom_worn_icon_cached(human_icon, human_icon_state, "m", new_icon)
		return new_icon
