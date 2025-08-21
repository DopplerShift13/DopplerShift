/datum/preference/color/fish_tail_color
	savefile_key = "feature_fish_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/fish/mermaid

/datum/preference/color/fish_tail_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_TAIL_FISH_COLOR] = value

/datum/preference/color/fish_tail_color/create_default_value()
	return pick(GLOB.carp_colors)
