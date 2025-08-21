/datum/species/human/mermaid
	name = "\improper Mermaid"
	plural_form = "Mermaids"
	id = SPECIES_MERMAID
	mutant_organs = list(/obj/item/organ/tail/fish/mermaid)
	mutantstomach = /obj/item/organ/stomach/fish/mermaid
	mutantliver = /obj/item/organ/liver/fish/mermaid
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right,
		BODY_ZONE_HEAD = /obj/item/bodypart/head,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_AQUATIC

	species_cookie = /obj/item/food/chips/shrimp
//	inert_mutation =
	payday_modifier = 0.9
//	family_heirlooms = list(
//		,
//	)

/datum/species/human/mermaid/get_features()
	var/list/features = ..()
	LAZYOR(features, "feature_fish_lungs_choice")
	return features

/datum/species/human/mermaid/randomize_features()
	var/list/features = ..()
	LAZYSET(features, FEATURE_TAIL_FISH_COLOR, pick(GLOB.carp_colors - COLOR_CARP_SILVER))
	return features

/datum/species/human/mermaid/on_species_gain(mob/living/carbon/human/human_being, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(isdummy(human_being))
		return
	human_being.set_resting(TRUE, silent = TRUE, instant = TRUE)

/datum/species/human/mermaid/pre_equip_species_outfit(datum/job/job, mob/living/carbon/human/equipping, visuals_only)
	put_in_wheelchair(equipping)
	give_important_for_life(equipping)

/datum/species/human/mermaid/give_important_for_life(mob/living/carbon/human/human_to_equip)
	human_to_equip.equip_in_one_of_slots(
		equipping = SSwardrobe.provide_type(/obj/item/clothing/accessory/vaporizer, human_to_equip),
		slots = list(LOCATION_LPOCKET, LOCATION_RPOCKET, LOCATION_HANDS, LOCATION_BACKPACK),
		qdel_on_fail = FALSE,
		indirect_action = TRUE,
	)

/datum/species/human/mermaid/prepare_human_for_preview(mob/living/carbon/human/preview_human)
	preview_human.set_haircolor("#a54ea1", update = FALSE)
	preview_human.set_hairstyle("Ponytail (Country)", update = TRUE)
	preview_human.dna.features[TRAIT_USES_SKINTONES] = "asian1"
	preview_human.dna.features[FEATURE_TAIL_FISH_COLOR] = COLOR_CARP_TEAL
	regenerate_organs(preview_human)
	preview_human.update_body(is_creating = TRUE)

/datum/species/human/mermaid/get_species_description()
	return "Nothing yet."

/datum/species/human/mermaid/get_species_lore()
	return list(
		"Nothing yet.",
	)

#define MERMAID_ORGAN_COLOR "#6d5287"
#define MERMAID_SCLERA_COLOR COLOR_WHITE
#define MERMAID_PUPIL_COLOR COLOR_BLUE
#define MERMAID_COLORS MERMAID_ORGAN_COLOR + MERMAID_SCLERA_COLOR + MERMAID_PUPIL_COLOR

/obj/item/organ/tail/fish/mermaid
	name = "large fish tail"
//	desc = ""
	fillet_amount = 12
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/fish/mermaid
	greyscale_colors = MERMAID_ORGAN_COLOR
	external_bodyshapes = BODYSHAPE_MERMAID
	restyle_flags = NONE
	organ_traits = list(
		TRAIT_FREE_FLOAT_MOVEMENT,
		TRAIT_FLOPPING,
		TRAIT_SWIMMER,
	)

/obj/item/organ/tail/fish/mermaid/Initialize(mapload)
	. = ..()
	set_greyscale(pick(GLOB.carp_colors - COLOR_CARP_SILVER))

/obj/item/organ/tail/fish/mermaid/on_mob_insert(mob/living/carbon/owner, special, movement_flags)
	. = ..()
	get_your_sealegs(owner)

/obj/item/organ/tail/fish/mermaid/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	if(QDELING(owner))
		return
	owner.bodyshape &= ~BODYSHAPE_MERMAID //just2bsure
	owner.adjustBruteLoss(rand(-35, -45))
	if(owner.blood_volume)
		owner.blood_volume -= (BLOOD_VOLUME_MAXIMUM / 3)
		owner.spray_blood(REVERSE_DIR(owner.dir))
		owner.visible_message(span_warning("[src] detaches, spilling out liters of [LOWER_TEXT(owner.get_bloodtype()?.name)]!"))
		playsound(src, 'sound/effects/cartoon_sfx/cartoon_splat.ogg', 50, TRUE)

/obj/item/organ/tail/fish/mermaid/mutate_feature(features, mob/living/carbon/human/human)
	return //no mutation

/// Remove legs on insertion, if we had any
/obj/item/organ/tail/fish/mermaid/proc/get_your_sealegs(mob/living/carbon/owner)
	var/obj/item/bodypart/right_leg = owner.get_bodypart(BODY_ZONE_R_LEG)
	var/obj/item/bodypart/left_leg = owner.get_bodypart(BODY_ZONE_L_LEG)
	if(right_leg)
		right_leg.dismember()
	if(left_leg)
		left_leg.dismember()

/// The bodypart overlay
/datum/bodypart_overlay/mutant/tail/fish/mermaid
	layers = EXTERNAL_BEHIND|EXTERNAL_ADJACENT

/datum/bodypart_overlay/mutant/tail/fish/mermaid/randomize_appearance()
	set_appearance(/datum/sprite_accessory/tails/fish/mermaid)

/datum/bodypart_overlay/mutant/tail/fish/mermaid/override_color(obj/item/bodypart/limb)
	return limb.owner.dna.features[FEATURE_TAIL_FISH_COLOR]

/datum/bodypart_overlay/mutant/tail/fish/mermaid/can_draw_on_bodypart(obj/item/bodypart/limb)
	return TRUE //always draw

/obj/item/organ/lungs/fish/mermaid
//	name = ""
//	desc = ""

/obj/item/organ/stomach/fish/mermaid
//	name = ""
//	desc = ""
	greyscale_colors = MERMAID_COLORS

/obj/item/organ/liver/fish/mermaid
//	name = ""
//	desc = ""
	greyscale_colors = MERMAID_COLORS

#undef MERMAID_ORGAN_COLOR
#undef MERMAID_SCLERA_COLOR
#undef MERMAID_PUPIL_COLOR
#undef MERMAID_COLORS
