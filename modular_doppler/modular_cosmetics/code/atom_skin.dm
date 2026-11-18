// Adds some missing functionality such as worn icon
/datum/atom_skin/doppler
	abstract_type = /datum/atom_skin/doppler
	/// Specifies the left hand inhand icon file. Don't forget to set the right hand file as well.
	var/new_lefthand_file
	/// Specifies the right hand inhand icon file. Don't forget to set the left hand file as well.
	var/new_righthand_file
	/// Specifies the worn icon file.
	var/new_worn_file
	/// Specifies the new worn icon state
	var/new_worn_icon_state

/datum/atom_skin/doppler/apply(obj/item/kinetic_crusher/apply_to)
	. = ..()
	APPLY_VAR_OR_RESET_INITIAL(apply_to, lefthand_file, new_lefthand_file, reset_missing)
	APPLY_VAR_OR_RESET_INITIAL(apply_to, righthand_file, new_righthand_file, reset_missing)
	APPLY_VAR_OR_RESET_INITIAL(apply_to, worn_icon, new_worn_file, reset_missing)
	APPLY_VAR_OR_RESET_INITIAL(apply_to, worn_icon_state, (new_worn_icon_state ? new_worn_icon_state : new_icon_state), reset_missing)

/datum/atom_skin/doppler/clear_skin(obj/item/kinetic_crusher/clear_from)
	. = ..()
	RESET_INITIAL_IF_SET(clear_from, lefthand_file, new_lefthand_file)
	RESET_INITIAL_IF_SET(clear_from, righthand_file, new_righthand_file)
	RESET_INITIAL_IF_SET(clear_from, worn_icon, new_worn_file)
	RESET_INITIAL_IF_SET(clear_from, worn_icon_state, (new_worn_icon_state ? new_worn_icon_state : new_icon_state))
