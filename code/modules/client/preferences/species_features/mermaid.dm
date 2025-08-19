/datum/preference/color/mermaid_tail
	priority = PREFERENCE_PRIORITY_BODYPARTS
	savefile_key = "feature_mermaid_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/fish/mermaid

/datum/preference/color/mermaid_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_MERMAID_COLOR] = value

/datum/preference/color/mermaid_tail/create_default_value()
	return pick(GLOB.carp_colors)
