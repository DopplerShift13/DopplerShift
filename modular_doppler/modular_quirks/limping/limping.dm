
/**
 * Limping Quirk, uses the same limping status effect as wound limping. Slowdown is cumulative.
 * Edits can be found here:
 * - code/datums/status_effects/wound_effects.dm (/datum/status_effect/limp/proc/update_limp(...))
 */
/datum/quirk/item_quirk/limping
	name = "Limping"
	desc = "For one reason or another, you have a lingering limp in either or both legs."
	icon = FA_ICON_CRUTCH
	quirk_flags = QUIRK_HUMAN_ONLY
	medical_record_text = "Patient has a limp."
	gain_text = "Did your hip joints just crack?"
	lose_text = "You suddenly have a newfound spry in your step!"
	value = -6
	hardcore_value = 6
	mail_goodies = list(/obj/item/cane/crutch)

	/// Amount of time in deciseconds extra per step on this leg.
	var/limp_slowdown = 0
	/// Chance to limp on each step.
	var/limp_chance = 0
	/// Affected side, bitflag.
	var/affected_side

/datum/quirk_constant_data/limping
	associated_typepath = /datum/quirk/item_quirk/limping
	customization_options = list(/datum/preference/choiced/limping_side, /datum/preference/choiced/limping_severity)

/datum/quirk/item_quirk/limping/add_unique(client/client_source)
	give_item_to_holder(
		/obj/item/cane/crutch,
		list(
			LOCATION_HANDS,
			LOCATION_BACKPACK,
		)
	)

/datum/quirk/item_quirk/limping/add(client/client_source)
	var/chosen_side = client_source?.prefs?.read_preference(/datum/preference/choiced/limping_side)
	affected_side = GLOB.side_choice_limping[chosen_side]
	if(isnull(affected_side))  // Client gone or they chose a random side
		chosen_side = pick(GLOB.side_choice_limping)
		affected_side = GLOB.side_choice_limping[chosen_side]

	var/chosen_severity = client_source?.prefs?.read_preference(/datum/preference/choiced/limping_severity)
	var/list/severity_choice_list = GLOB.severity_choice_limping[chosen_severity]
	if(isnull(severity_choice_list))  // Client gone or they chose a random severity
		chosen_severity = pick(GLOB.severity_choice_limping)
		affected_side = GLOB.severity_choice_limping[chosen_severity]

	limp_slowdown = severity_choice_list[LIMPING_SLOWDOWN]
	limp_chance = severity_choice_list[LIMPING_CHANCE]

	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.apply_status_effect(/datum/status_effect/limp)
	RegisterSignal(human_holder, COMSIG_CARBON_ATTACH_LIMB, PROC_REF(reapply_limp))

	medical_record_text = "Patient has a [LOWER_TEXT(chosen_severity)] limp on [(affected_side == LIMPING_SIDE_BOTH) ? "both sides" : "their [LOWER_TEXT(chosen_side)]"]."

/datum/quirk/item_quirk/limping/remove()
	UnregisterSignal(quirk_holder, COMSIG_CARBON_ATTACH_LIMB)
	var/datum/status_effect/limp/limping_effect = quirk_holder.has_status_effect(/datum/status_effect/limp)
	limping_effect.update_limp(src)

/datum/quirk/item_quirk/limping/proc/reapply_limp(datum/source, obj/item/bodypart/new_limb, special)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.apply_status_effect(/datum/status_effect/limp)

/**
 * Allows the limp status effect to update whether it displays its alert,
 * as we only want to display the alert while limping from wounds.
 */
/datum/status_effect/limp/proc/update_alert(should_have_alert)
	if(should_have_alert)
		if(linked_alert)
			return
		var/atom/movable/screen/alert/status_effect/new_alert = owner.throw_alert(id, alert_type)
		new_alert.attached_effect = src
		linked_alert = new_alert
		return

	if(isnull(linked_alert))
		return
	linked_alert = null
	owner.clear_alert(id)

/datum/status_effect/limp/on_creation(mob/living/new_owner, ...)
	. = ..()
	if(!.)
		return
	// Update the limp after creation, so the alert is properly set/unset.
	update_limp(src)
