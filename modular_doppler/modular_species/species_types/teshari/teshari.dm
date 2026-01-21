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
		TRAIT_STRONG_STOMACH
	)
	mutantears = /obj/item/organ/ears/teshari
	digitigrade_customization = DIGITIGRADE_NEVER
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.0
	mutanttongue = /obj/item/organ/tongue/teshari
	mutanteyes = /obj/item/organ/eyes/teshari
	coldmod = TESHARI_COLDMOD
	heatmod = TESHARI_HEATMOD
	bodytemp_normal = BODYTEMP_NORMAL + TESHARI_TEMP_OFFSET
	bodytemp_heat_damage_limit = (BODYTEMP_HEAT_DAMAGE_LIMIT + TESHARI_TEMP_OFFSET)
	bodytemp_cold_damage_limit = (BODYTEMP_COLD_DAMAGE_LIMIT + TESHARI_TEMP_OFFSET)
	species_language_holder = /datum/language_holder/teshari
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant/teshari,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant/teshari,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant/teshari,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant/teshari,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant/teshari,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant/teshari,
	)
	meat = /obj/item/food/meat/slab/chicken/human
	// species are instanced, so this is ok
	/// The tablerun ability we will give to our teshari.
	var/datum/action/innate/teshari_tablerun/tablerun

/datum/language_holder/teshari
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/schechi = list(LANGUAGE_ATOM)
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/schechi = list(LANGUAGE_ATOM)
	)

/datum/species/teshari/get_scream_sound(mob/living/carbon/human/human)
	return 'modular_doppler/modular_species/species_types/teshari/sounds/raptorscream.ogg'

/obj/item/organ/eyes/teshari
	blink_animation = FALSE

/obj/item/organ/tongue/teshari
	liked_foodtypes = RAW | MEAT | GORE
	disliked_foodtypes = GROSS | CLOTH | BUGS
	toxic_foodtypes = parent_type::toxic_foodtypes | FRUIT

/datum/species/teshari/prepare_human_for_preview(mob/living/carbon/human/tesh)
	var/base_color = "#c0965f"
	var/ear_color = "#e4c49b"

	tesh.dna.ear_type = TESHARI
	tesh.dna.features[FEATURE_MUTANT_COLOR] = base_color
	tesh.dna.features[FEATURE_EARS] = "Teshari Feathers Upright"
	tesh.dna.features[FEATURE_EARS_COLORS][1] = base_color
	tesh.dna.features[FEATURE_EARS_COLORS][2] = ear_color
	regenerate_organs(tesh, src, visual_only = TRUE)
	tesh.update_body(TRUE)

/datum/species/teshari/on_species_gain(mob/living/carbon/human/new_teshari, datum/species/old_species, pref_load, regenerate_icons)
	new_teshari.dna.ear_type = TESHARI
	. = ..()
	tablerun = new /datum/action/innate/teshari_tablerun()
	tablerun.Grant(new_teshari)

/datum/species/teshari/on_species_loss(mob/living/carbon/C, datum/species/new_species, pref_load)
	. = ..()
	QDEL_NULL(tablerun)

/datum/species/teshari/create_pref_unique_perks()
	var/list/perk_descriptions = list()

	perk_descriptions += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_EAR_LISTEN,
		SPECIES_PERK_NAME = "Sensitive Hearing",
		SPECIES_PERK_DESC = "Your ears are extremely sensitive, and can hear whispers. Unfortunately, this also increases ear damage taken..."
	))
	perk_descriptions += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_BIOHAZARD,
		SPECIES_PERK_NAME = "Carrion Eater",
		SPECIES_PERK_DESC = "Your biology is well suited to eating stale food. You don't get disgusted, nor get diseases, from eating old or rotting food."
	))
	perk_descriptions += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_RUNNING,
		SPECIES_PERK_NAME = "Tablerunning",
		SPECIES_PERK_DESC = "A being of extreme agility, you can jump on tables just by running into them!"
	))

	return perk_descriptions

/datum/species/teshari/get_species_description()
	var/static/desc = list(
		"Short of stature, full of heart, the Teshari race has recently entered the galactic stage after a cataclysmic event wrecked their homeworld Sirisai.",
		"Having - somewhat - bounced back, these agile avians are slowly spreading throughout all of space, bringing their death-worship and 'interesting' cuisine (read: carrion) with them.",
	)

	return desc

/datum/species/teshari/get_species_lore()
	var/static/desc = list(
		"A race of feathered, carnivous scavengers, the Teshari descend from the tundra moon Sirisai IV, in orbit around the much larger Sirisai Prime - a gas giant often revered and feared as a portal to the underworld. \
		Teshari are a tribal, scattered people. Making do with scavenged and reverse-engineered technology, the Teshari roam their ruined homeworld to recover their dead, find treasures, and find a new future.",
		"Teshari consider their dead sacred. In order for a soul to be \"light\", the body which houses it must be well kept. Burning a corpse is to damn a Teshari - keeping their bones, embroidering them, preserving their corpse - all ways to make a soul lighter. \
		Some Teshari are even made into meals to be consumed by their tribemates, their lovers, their friends - such an act is extremely meaningful in Teshari culture, even if outside observers are often reviled by it.",
		"",
		"Much of Teshari history is formed, and lost, by and due to the event termed the \"Cataclysm\". Two hundred years ago, what is now understood as stray ordnance from a long-ended war struck the planet, destroying its ecosystem and \
		plunging its inhabitants into a dark age. Its colonies withered and died, many taken over by the Tiziran clan Talunan, while the planet itself was left to recover, with its massively dwindled population.",
		"It is not certain if Teshari were always so self-sufficient, so obsessed with death and rememberence, but it is clear that the cataclysm boosted these ideologies massively. \
		Now, in the modern day, Teshari are seen as eerie, strange, and in violation of more than a few social norms. Yet, they find their place, as difficult as it may be sometimes."
	)

	return desc

/datum/species/teshari/can_regenerate_mutant_feature(feature_key)
	if (feature_key == FEATURE_EARS || feature_key == FEATURE_TAIL_OTHER)
		return TRUE
	return ..()
