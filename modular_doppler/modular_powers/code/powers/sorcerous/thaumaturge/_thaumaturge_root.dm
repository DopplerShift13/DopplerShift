
/datum/power/thaumaturge_root
	name = "Spell Preparation"
	desc = "Grants you a Spell Focus, an unique item that allows you to charge your Thaumaturge spells while sleeping, and enhance them by holding it. Use the Spell Focus in your hand to change it's form."

	action_path = /datum/action/cooldown/power/thaumaturge/thaumaturge_root

	value = 5
	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THAUMATURGE
	priority = POWER_PRIORITY_ROOT

/* Previous Item Power stuff. TODO: Make Item power a variable rather than a subtype.
/datum/power/item_power/thaumaturge_root/add_unique(client/client_source)
	//var/obj/item/book/random/spellbook = new(get_turf(power_holder))
	//.name = "[power_holder.real_name]'s spellbook"
	//give_item_to_holder(spellbook, list(LOCATION_BACKPACK, LOCATION_HANDS))

/datum/power/item_power/thaumaturge_root/add(client/client_source)
	//var/datum/action/cooldown/spell/touch/prestidigitation/that_magic_touch = new
	//that_magic_touch.Grant(power_holder)
*/

/datum/power/thaumaturge_root/post_add()
	if(!power_holder) // So it doesn't runtime at init
		return
	// Spell preperation is so complicated we basically handle it all in a component, including the UI part.
	power_holder.AddComponent(/datum/component/thaumaturge_preparation, power_holder)
	. = ..()

/datum/action/cooldown/power/thaumaturge/thaumaturge_root
	name = "Spell Preperation"
	desc = "Adjust the amount of charges your spells have! Requires sleeping with a Spell Focus on your person to apply (except the first time in a round)."
	button_icon = 'icons/obj/antags/cult/structures.dmi'
	button_icon_state = "pylon"

/datum/action/cooldown/power/thaumaturge/thaumaturge_root/use_action(mob/living/user, atom/target)
	var/datum/component/thaumaturge_preparation/prep_component = user.GetComponent(/datum/component/thaumaturge_preparation)
	if(!prep_component)
		to_chat(user, span_warning("Something terrible has happened; you're missing your preperation component. Yell at devs!"))
		return FALSE
	prep_component.validate_spells() // We call it here so all the spells are loaded when we open it.
	prep_component.ui_interact(user)
	return TRUE







