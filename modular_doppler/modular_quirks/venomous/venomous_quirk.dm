/datum/quirk/venomous_bite
	name = "Venomous Bite"
	desc = "You have a venom gland, and can bite people to inject them with a toxin of your choosing. \
		Limited to Lizardfolk."
	icon = FA_ICON_SYRINGE
	value = 1
	gain_text = span_notice("You feel a venom gland in the back of your throat.")
	lose_text = span_warning("Your venom gland vanishes.")
	medical_record_text = "Patient possesses venomous glands."

/datum/quirk/venomous_bite/add(client/client_source)
	var/datum/reagent/reagent = text2path(client_source?.prefs?.read_preference(/datum/preference/choiced/venomous_bite_venom))
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/action/cooldown/mob_cooldown/venomous_bite/action = new /datum/action/cooldown/mob_cooldown/venomous_bite(human_holder, our_reagent = reagent)
	action.Grant(human_holder)

/datum/quirk/venomous_bite/remove()
	var/datum/action/cooldown/mob_cooldown/venomous_bite/action = locate(/datum/action/cooldown/mob_cooldown/venomous_bite) in quirk_holder.actions
	action?.Remove()
	return ..()

/datum/quirk/venomous_bite/is_species_appropriate(datum/species/mob_species)
	if(mob_species != /datum/species/lizard)
		return FALSE
	return ..()

/datum/quirk_constant_data/venomous_bite
	associated_typepath = /datum/quirk/venomous_bite
	customization_options = list(/datum/preference/choiced/venomous_bite_venom)

/datum/preference/choiced/venomous_bite_venom
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "venomous_bite_venom"
	savefile_identifier = PREFERENCE_CHARACTER
	/// Format: (reagent typepath -> list(amount to inject per bite, cooldown))
	var/static/list/venomous_bite_choice_specs = list(
		// Enterprise resource planning? What are you talking about?
		/datum/reagent/toxin/tizirian = list(7, 180 SECONDS),
		/datum/reagent/toxin/tizirian/less = list(7, 180 SECONDS),
	)

/datum/preference/choiced/venomous_bite_venom/init_possible_values()
	var/list/choices = list()
	for (var/entry in venomous_bite_choice_specs)
		choices += "[entry]"
	return choices

/datum/preference/choiced/venomous_bite_venom/create_default_value()
	return "/datum/reagent/toxin/tizirian/less"

/datum/preference/choiced/venomous_bite_venom/compile_constant_data()
	var/list/data = ..()
	var/list/titles = list()
	for(var/datum/reagent/entry as anything in venomous_bite_choice_specs)
		var/list/specs = venomous_bite_choice_specs[entry]
		var/inject = specs[1]
		var/cooldown = specs[2]
		var/name = entry::name
		titles["[entry]"] = "[name] ([inject]u, [cooldown / 10]s cooldown)"
	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = titles
	return data

/datum/preference/choiced/venomous_bite_venom/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE
	return "Venomous Bite" in preferences.all_quirks

/datum/preference/choiced/venomous_bite_venom/apply_to_human(mob/living/carbon/human/target, value)
	return
