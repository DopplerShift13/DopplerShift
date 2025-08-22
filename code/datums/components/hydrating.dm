///
/datum/component/hydrating
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// the kind of status effect that will be given by the component holder
	var/datum/status_effect/grouped/hydrating/status_effect_type

/datum/component/hydrating/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(apply_status_effect))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(remove_status_effect))

/datum/component/hydrating/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED,
	))

///
/datum/component/hydrating/proc/apply_status_effect(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER
	user.apply_status_effect(/datum/status_effect/grouped/hydrating, REF(source))

///
/datum/component/hydrating/proc/remove_status_effect(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER
	user.remove_status_effect(/datum/status_effect/grouped/hydrating, REF(source))

///
/datum/status_effect/grouped/hydrating
	id = "hydrating"
	alert_type = null
	tick_interval = 5 SECONDS
	/// how many wet stacks it will add
	var/stacks_to_add = 1
	/// will it remove fire stacks
	var/dousing = FALSE

/datum/status_effect/grouped/hydrating/tick(seconds_between_ticks)
	var/datum/status_effect/fire_handler/wet_stacks/wet_status = owner.has_status_effect(/datum/status_effect/fire_handler/wet_stacks)
	if(wet_status?.stacks <= stacks_to_add)
		owner.set_wet_stacks(stacks = stacks_to_add, remove_fire_stacks = dousing)
