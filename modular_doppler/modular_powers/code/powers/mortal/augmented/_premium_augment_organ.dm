// File containing modular edits to obj/item/organ

/obj/item/organ
	/// Whether this organ supports premium augment mechanics.
	var/premium = FALSE
	/// Component for premium augment mechanics.
	var/datum/component/premium_augment/premium_component

/// Overrides attackby to allow premium mechanics to handle it in their refurbish action
/obj/item/organ/attackby(obj/item/tool, mob/user, params)
	if(premium_component && premium_component.handle_refurbish_interaction(user, tool, src))
		return
	return ..()

/// Default premium action hook. Override per organ.
/obj/item/organ/proc/use_action()
	return FALSE

/// Premium augments can override this to report their "on" state for button overlays.
/obj/item/organ/proc/is_action_active()
	return FALSE
