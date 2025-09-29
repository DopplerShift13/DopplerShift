/// Horns fixing
/obj/item/organ/horns
	name = "horns"

/datum/bodypart_overlay/mutant/horns
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT | EXTERNAL_BEHIND

/datum/bodypart_overlay/mutant/horns/color_images(list/image/overlays, layer, obj/item/bodypart/limb)
	draw_color = limb.owner?.dna.features["horns_colors"]
	return ..()

//core toggle
/datum/preference/toggle/horns
	savefile_key = "has_horns"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_DEFAULT

/datum/preference/toggle/horns/apply_to_human(mob/living/carbon/human/target, value)
	if(value == FALSE)
		target.dna.features[FEATURE_HORNS] = /datum/sprite_accessory/horns/none::name

/datum/preference/toggle/horns/create_default_value()
	return FALSE

/datum/preference/toggle/horns/is_accessible(datum/preferences/preferences)
	. = ..()
	var/species = preferences.read_preference(/datum/preference/choiced/species)
	if(species in GLOB.species_blacklist_no_mutant)
		return FALSE
	return TRUE

/datum/species/regenerate_organs(mob/living/carbon/target, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE, replace_missing = TRUE)
	. = ..()
	if(target.dna.features[FEATURE_HORNS] && !(type in GLOB.species_blacklist_no_mutant))
		if(target.dna.features[FEATURE_HORNS] != /datum/sprite_accessory/horns/none::name && target.dna.features[FEATURE_HORNS] != /datum/sprite_accessory/blank::name)
			var/obj/item/organ/replacement = SSwardrobe.provide_type(/obj/item/organ/horns)
			replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
			return .
	var/obj/item/organ/old_part = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_HORNS)
	if(old_part)
		old_part.Remove(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		old_part.moveToNullspace()

//sprite selection
/datum/preference/choiced/lizard_horns
	category = PREFERENCE_CATEGORY_CLOTHING

/datum/preference/choiced/lizard_horns/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if(species.type in GLOB.species_blacklist_no_mutant)
		return FALSE
	var/has_horns = preferences.read_preference(/datum/preference/toggle/horns)
	if(has_horns == TRUE)
		return TRUE
	return FALSE

/datum/preference/choiced/lizard_horns/create_default_value()
	return /datum/sprite_accessory/horns/none::name

/datum/preference/choiced/lizard_horns/icon_for(value)
	return generate_horns_icon(SSaccessories.horns_list[value])

/datum/preference/choiced/proc/generate_horns_icon(datum/sprite_accessory/sprite_accessory)
	var/static/datum/universal_icon/body
	if (isnull(body))
		body = uni_icon('icons/mob/human/species/lizard/bodyparts.dmi', "lizard_head")
	var/datum/universal_icon/final_icon = body.copy()

	if(sprite_accessory.icon_state != "none")
		if(icon_exists(sprite_accessory.icon, "m_horns_[sprite_accessory.icon_state]_ADJ"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_horns_[sprite_accessory.icon_state]_ADJ")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_WEBSAFE_DARK_GRAY, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)
		if(icon_exists(sprite_accessory.icon, "m_horns_[sprite_accessory.icon_state]_FRONT"))
			var/datum/universal_icon/accessory_icon = uni_icon(sprite_accessory.icon, "m_horns_[sprite_accessory.icon_state]_FRONT")
			accessory_icon.shift(NORTH, 0)
			accessory_icon.blend_color(COLOR_WEBSAFE_DARK_GRAY, ICON_MULTIPLY)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)

	final_icon.crop(11, 20, 23, 32)
	final_icon.scale(32, 32)

	return final_icon
