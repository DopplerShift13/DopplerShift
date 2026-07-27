
/* Enigmatist content is getting commented out for now and getting developed later.
/datum/power/enigmatist_spell
	name = "Abstract Enigmatist Spell"
	desc = "The true art of seeing into the seventh dimension: \
	seeing this debug code. Please report this!"
	abstract_parent_type = /datum/power/enigmatist_spell

	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_ENIGMATIST
	required_powers = list(/datum/power/enigmatist_root)

	/// The type of Enigmatist spell this is. Use ENIGMATIST_RESONANT/X flags.
	var/enigmatist_type = ENIGMATIST_RESONANT

	/// The icon used for us in chalk radial selections.
	var/option_icon = 'icons/obj/art/crayons.dmi'
	/// The icon_state used for us in chalk radial selections.
	var/option_icon_state = "crayonwhite"
	/// The name to use in chalk radial selections instead of our basic name.
	var/option_name
	/// The description to use in chalk radial selections instead of our basic description.
	var/option_desc

/datum/power/enigmatist_spell/add(client/client_source)
	RegisterSignal(power_holder, COMSIG_ENIGMATIST_CHALK_SELECTION, PROC_REF(get_spell_option))

/datum/power/enigmatist_spell/remove()
	UnregisterSignal(power_holder, COMSIG_ENIGMATIST_CHALK_SELECTION)


/datum/power/enigmatist_spell/proc/get_option_name()
	return option_name || name

/datum/power/enigmatist_spell/proc/get_option_desc()
	return option_desc || desc

/datum/power/enigmatist_spell/proc/get_spell_option(datum/source, enigmatist_flags, list/spell_options)
	SIGNAL_HANDLER
	message_admins("get_spell_option -<br>enigmatist_type: [enigmatist_type]<br>enigmatist_flags: [enigmatist_flags]<br>both: [enigmatist_type & enigmatist_flags]")
	if(enigmatist_type & enigmatist_flags)
		spell_options[name] = src
	message_admins("get_spell_option TWO -<br>spell_options length: [length(spell_options)]")


/datum/power/enigmatist_spell/proc/chalk_add_context(
	obj/item/enigmatist_chalk/held_chalk,
	list/context,
	obj/item/held_item,
	mob/user,
)
	return NONE

/datum/power/enigmatist_spell/proc/chalk_add_item_context(
	obj/item/enigmatist_chalk/held_chalk,
	list/context,
	atom/target,
	mob/living/user,
)
	return NONE


/datum/power/enigmatist_spell/proc/chalk_selected_spell(mob/user, obj/item/enigmatist_chalk/used_chalk)
	return

/datum/power/enigmatist_spell/proc/chalk_reset_spell(mob/user, obj/item/enigmatist_chalk/used_chalk)
	return


/datum/power/enigmatist_spell/proc/chalk_attack_self(obj/item/enigmatist_chalk/used_chalk, mob/user, modifiers)
	return

/datum/power/enigmatist_spell/proc/chalk_interact_with_atom(obj/item/enigmatist_chalk/used_chalk, atom/interacting_with, mob/living/user, list/modifiers)
	return NONE

/datum/power/enigmatist_spell/proc/chalk_interact_with_atom_secondary(obj/item/enigmatist_chalk/used_chalk, atom/interacting_with, mob/living/user, list/modifiers)
	return chalk_interact_with_atom(used_chalk, interacting_with, user, modifiers)


/datum/power/enigmatist_spell/proc/damage_chalk(obj/item/enigmatist_chalk/used_chalk, mob/living/user, damage)
	if(!used_chalk.use_integrity(damage, user))
		used_chalk.balloon_alert(user, "too damaged!")
		return FALSE
	return TRUE
*/
