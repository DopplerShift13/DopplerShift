/// How many wetstacks does the status effect apply to its wearer
#define STATUS_EFFECT_STACKS 5

/datum/component/wetting
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/wetting/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(apply_status_effect))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(remove_status_effect))

/datum/component/wetting/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED,
	))

///
/datum/component/wetting/proc/apply_status_effect(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER
	user.apply_status_effect(/datum/status_effect/grouped/wetting, REF(source))

///
/datum/component/wetting/proc/remove_status_effect(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER
	user.remove_status_effect(/datum/status_effect/grouped/wetting, REF(source))

///
/datum/status_effect/grouped/wetting
	id = "wetting"
	alert_type = null
	tick_interval = 5 SECONDS

/datum/status_effect/grouped/wetting/tick(seconds_between_ticks)
	owner.set_wet_stacks(stacks = STATUS_EFFECT_STACKS, remove_fire_stacks = FALSE)

#undef STATUS_EFFECT_STACKS
