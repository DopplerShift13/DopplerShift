/// The starter amount for the android's core
#define ENERGY_START_AMT 5 MEGA JOULES
/// The amount at which mob energy decreases
#define ENERGY_DRAIN_AMT 2.5 KILO JOULES

/datum/species/android
	name = "Android"
	id = SPECIES_ANDROID
	preview_outfit = /datum/outfit/android_preview
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_GENELESS,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOBREATH,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTLOWPRESSURE,
		/*TG traits we remove
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_PIERCEIMMUNE,
		TRAIT_OVERDOSEIMMUNE,
		TRAIT_TOXIMMUNE,
		TRAIT_NOFIRE,
		TRAIT_NOBLOOD,
		TRAIT_NOHUNGER, // Handled by the stomach type.
		TRAIT_NO_UNDERWEAR,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,*/
		TRAIT_UNHUSKABLE,
		TRAIT_STABLEHEART,
		TRAIT_STABLELIVER,
	)
	reagent_flags = PROCESS_SYNTHETIC
	body_markings = list(/datum/bodypart_overlay/simple/body_marking/lizard = "None")
	mutantheart = /obj/item/organ/heart/cybernetic/tier2
	mutantstomach = /obj/item/organ/stomach/charging/power_cord
	mutantbrain = /obj/item/organ/brain/cybernetic
	mutantears = /obj/item/organ/ears/android
	mutanttongue = /obj/item/organ/tongue/robot/android
	mutantliver = /obj/item/organ/liver/cybernetic/tier2
	exotic_bloodtype = BLOOD_TYPE_SYNTHETIC

	bodytemp_heat_damage_limit = (BODYTEMP_NORMAL + 146) // 456 K / 183 C
	bodytemp_cold_damage_limit = (BODYTEMP_NORMAL - 80) // 230 K / -43 C
	death_sound = 'sound/mobs/non-humanoids/cyborg/borg_deathsound.ogg'

/obj/item/organ/brain/cybernetic
	name = "cybernetic brain"
	desc = "A mechanical brain found inside of androids. Not to be confused with a positronic brain."
	icon = 'icons/obj/devices/assemblies.dmi'
	icon_state = "posibrain"
	organ_flags = ORGAN_ROBOTIC | ORGAN_VITAL
	zone = BODY_ZONE_CHEST
	failing_desc = "seems to be broken, and will not work without repairs."

/obj/item/organ/ears/android
	name = "audio receiver"
	desc = "A listening device commonly found within androids. It is designed to be put in the torso."
	icon = 'icons/obj/devices/artefacts.dmi'
	icon_state = "prototype3"
	organ_flags = ORGAN_ROBOTIC
	zone = BODY_ZONE_CHEST
	failing_desc = "seems to be broken."

/obj/item/organ/tongue/robot/android
	name = "android voicebox"
	desc = "A voice synthesizer unique to androids. It is designed to be put in the torso."
	zone = BODY_ZONE_CHEST

/datum/outfit/android_preview
	name = "Android (Species Preview)"
	// nude

/datum/species/android/spec_revival(mob/living/carbon/human/target)
	playsound(target.loc, 'sound/machines/chime.ogg', 50, TRUE)
	target.visible_message(span_notice("[target]'s LEDs flicker to life!"), span_notice("All systems nominal. You're back online!"))

/datum/species/android/spec_life(mob/living/carbon/human/target, seconds_per_tick, times_fired)
	. = ..()
	if(target.stat == SOFT_CRIT || target.stat == HARD_CRIT)
		target.adjustFireLoss(1 * seconds_per_tick) //Still deal some damage in case a cold environment would be preventing us from the sweet release to robot heaven
		target.adjust_bodytemperature(13 * seconds_per_tick) //We're overheating!!
		if(prob(10))
			to_chat(target, span_warning("Alert: Critical damage taken! Cooling systems failing!"))
			do_sparks(3, FALSE, target)

/datum/species/android/prepare_human_for_preview(mob/living/carbon/human/robot_for_preview)
	robot_for_preview.dna.ear_type = CYBERNETIC
	robot_for_preview.dna.features["ears"] = "TV Antennae"
	robot_for_preview.dna.features[FEATURE_EARS_COLORS][1] = "#333333"
	robot_for_preview.dna.features["frame_list"] = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/android/sgm,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/android/sgm,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/android/sgm,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/android/sgm,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/android/sgm,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/android/sgm)
	regenerate_organs(robot_for_preview)
	robot_for_preview.update_body(is_creating = TRUE)

/datum/species/android/get_physical_attributes()
	return "Androids are almost, but not quite, identical to fully augmented humans. \
	Unlike those, though, they're completely immune to toxin damage, don't have blood or organs (besides their head), don't get hungry, and can reattach their limbs! \
	That said, an EMP will devastate them and they cannot process any chemicals."

/datum/species/android/get_species_description()
	return "Androids are an entirely synthetic species."

/datum/species/android/get_species_lore()
	return list(
		"Androids are a synthetic species created by the Port Authority as an intermediary between humans and cyborgs."
	)

/datum/movespeed_modifier/android_nocharge
	multiplicative_slowdown = CRAWLING_ADD_SLOWDOWN
	flags = IGNORE_NOSLOW

#undef ENERGY_START_AMT
#undef ENERGY_DRAIN_AMT
