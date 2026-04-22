
/datum/quirk/crusoes_local
	name = "Crusoe's Local"
	desc = "You've spent enough time living and interacting locally to have developed a sense for the local colonists' attempts to communicate irregardless of language barriers, \
	and consequentially know how to interpret the resulting pidgins."
	icon = FA_ICON_ARROWS_DOWN_TO_PEOPLE
	value = 0
	gain_text = span_notice("Some of the words of the people around you certainly aren't yours, but together you can make do.")
	lose_text = span_notice("You seem to have forgotten the local pidgin language.")
	medical_record_text = "Patient seems to have gotten accustomed to the local colonists' pidgins forming in Crusoe's Rest."

/datum/quirk/crusoes_local/add(client/client_source)
	quirk_holder.grant_language(/datum/language/crusoeslocal, source = LANGUAGE_QUIRK)

/datum/quirk/crusoes_local/remove()
	if(QDELING(quirk_holder))
		return
	quirk_holder.remove_language(/datum/language/crusoeslocal, source = LANGUAGE_QUIRK)
