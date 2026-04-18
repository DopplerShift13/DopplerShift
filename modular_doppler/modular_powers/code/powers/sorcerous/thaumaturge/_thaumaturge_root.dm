
/datum/power/thaumaturge_root
	name = "Spell Preparation"
	desc = "Grants you a Spell Focus, an unique item that allows you to charge your Thaumaturge spells while sleeping, and enhance them by holding it. Use the Spell Focus in your hand to change it's form."
	security_record_text = "Subject is capable of performing feats of thaumaturgic magic while in possession of a spell focus."
	action_path = /datum/action/cooldown/power/thaumaturge/thaumaturge_root

	value = 3
	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THAUMATURGE
	priority = POWER_PRIORITY_ROOT

/datum/power/thaumaturge_root/add_unique(client/client_source)
	var/obj/item/spell_focus/spell_focus = new(get_turf(power_holder))
	give_item_to_holder(spell_focus, list(LOCATION_BACKPACK, LOCATION_HANDS))

/datum/power/thaumaturge_root/post_add()
	if(!power_holder) // So it doesn't runtime at init
		return
	// Spell preperation is so complicated we basically handle it all in a component, including the UI part.
	power_holder.AddComponent(/datum/component/thaumaturge_preparation, power_holder)
	. = ..()

/datum/action/cooldown/power/thaumaturge/thaumaturge_root
	name = "Spell Preperation"
	desc = "Adjust the amount of charges your spells have! Requires sleeping with a Spell Focus on your person to apply (except the first time in a round)."
	button_icon = 'icons/obj/service/library.dmi'
	button_icon_state = "bookcharge"

	// Makes it not interact with the charges system.
	max_charges = null
	// Lets you tweak it while you sleep.
	disabled_by_incapacitate = FALSE

/datum/action/cooldown/power/thaumaturge/thaumaturge_root/use_action(mob/living/user, atom/target)
	var/datum/component/thaumaturge_preparation/prep_component = user.GetComponent(/datum/component/thaumaturge_preparation)
	if(!prep_component)
		to_chat(user, span_warning("Something terrible has happened; you're missing your preperation component. Yell at devs!"))
		return FALSE
	prep_component.build_spells() // We call it here so all the spells are loaded when we open it.
	prep_component.ui_interact(user)
	return TRUE
