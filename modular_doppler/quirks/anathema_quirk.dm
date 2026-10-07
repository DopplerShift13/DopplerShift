/datum/quirk/anathema
	name = "Anathema"
	desc = "Reality anchors and resonant-suppressing effects will boil away your body, causing grievous burns when active nearby."
	gain_text = span_danger("Your surroundings feel soft.")
	lose_text = span_notice("The world feels more solid again.")
	medical_record_text = "Subject's body is harmed by reality anchoring effects."
	value = -4
	icon = FA_ICON_ALIGN_JUSTIFY
	mob_trait = TRAIT_ANATHEMA // we use a trait for this instead of just checking against the quirk so that powers/species/etc can also use the anathema trait
