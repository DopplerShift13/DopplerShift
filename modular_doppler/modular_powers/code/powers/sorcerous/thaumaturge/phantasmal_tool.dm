/*
	For the people that don't want to hunt for tools, or are just too bothered to carry one.
*/
/datum/power/thaumaturge/phantasmal_tool
	name = "Phantasmal Tool"
	desc = "Summons a basic tool of your choice in your hand, that disappears after a duration, or if it is dropped/used to attack a person. \
	\nRequires Affinity 1 to cast. Affinity gives a chance to not consume charges on cast."
	security_record_text = "Subject can conjure ephemeral tools out of thin air."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	action_path = /datum/action/cooldown/power/thaumaturge/phantasmal_tool
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/phantasmal_tool
	name = "Phantasmal Tool"
	desc = "Summons a basic tool of your choice in your hand, that disappears after a duration, or if it is dropped/used to attack a person."
	button_icon = 'icons/obj/weapons/club.dmi'
	button_icon_state = "hypertool"

	required_affinity = 1
	prep_cost = 3

/datum/action/cooldown/power/thaumaturge/phantasmal_tool/use_action(mob/living/user, atom/target)
	if(user.get_active_held_item() && user.get_inactive_held_item())
		user.balloon_alert(user, "hands are not empty!")

	var/list/tool_type_to_image = get_phantasmal_tool_radial_images()

	// show_radial_menu returns the key from the assoc list.
	var/selected_tool_type = show_radial_menu(
		user,
		user, // "anchor" just for placement; using the user keeps it simple
		tool_type_to_image,
		tooltips = TRUE
	)

	if(!selected_tool_type)
		return FALSE

	// Creates item, adds the special phantasmal tool properties, give to user.
	var/obj/item/new_tool_item = new selected_tool_type(user)
	new_tool_item.AddElement(/datum/element/phantasmal_tool)
	if(!user.put_in_hands(new_tool_item))
		qdel(new_tool_item) // destroys the item if it fails to put it in our hands, as it shouldn't ever exist out of hands.
	playsound(user, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	return TRUE

// To potentially refund it, we run a small check.
/datum/action/cooldown/power/thaumaturge/phantasmal_tool/on_action_success(mob/living/user, atom/target, override_charges)
	var/chance_to_refund = clamp(THAUMATURGE_REFUND_MULT_AFFINITY * affinity + THAUMATURGE_REFUND_MULT_BASE, 0, THAUMATURGE_REFUND_MAX)
	if(prob(chance_to_refund))
		override_charges = 0
		to_chat(owner, span_notice("Your [name] spell did not consume a charge!"))
	else if(chance_to_refund >= 51) // At this point it's more common that it does not consume a charge, so we invert them and tell them when it does consume a charge!
		to_chat(owner, span_warning("Your [name] spell consumed a charge!"))
	return ..(user, target, override_charges)

/// Checks if we're capable of using the menu
/datum/action/cooldown/power/thaumaturge/phantasmal_tool/proc/phantasmal_tool_menu_check(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated)
		return FALSE
	return TRUE

/// Gets all the images of the tools within phantasmal tool
/datum/action/cooldown/power/thaumaturge/phantasmal_tool/proc/get_phantasmal_tool_radial_images()
	var/static/list/tool_type_to_image
	if(tool_type_to_image)
		return tool_type_to_image

	tool_type_to_image = list()

	var/list/allowed_tool_types = list(
		/obj/item/weldingtool,
		/obj/item/screwdriver,
		/obj/item/wirecutters,
		/obj/item/crowbar,
		/obj/item/wrench,
		/obj/item/multitool
	)

	for(var/tool_type in allowed_tool_types)
		// One-time temporary instance to fetch icon/icon_state reliably
		var/obj/item/temporary_tool = new tool_type
		tool_type_to_image[tool_type] = image(temporary_tool.icon, temporary_tool.icon_state)
		qdel(temporary_tool)


	return tool_type_to_image


// The element we attach with phantasmal tool. Handles making it harmless, duration and disappearing on.
/datum/element/phantasmal_tool
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

	/// The item we're attached to.
	var/obj/item/attached_item

/datum/element/phantasmal_tool/Attach(datum/target)
	. = ..()
	attached_item = target
	attached_item.item_flags = DROPDEL | ABSTRACT
	attached_item.alpha = 200
	attached_item.color = "#66cbdd"
	attached_item.AddElementTrait(TRAIT_ON_HIT_EFFECT, REF(src), /datum/element/on_hit_effect)
	RegisterSignal(attached_item, COMSIG_ON_HIT_EFFECT, PROC_REF(break_on_hit))
	RegisterSignal(attached_item, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/element/phantasmal_tool/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ON_HIT_EFFECT)
	UnregisterSignal(source, COMSIG_ATOM_DISPEL)
	REMOVE_TRAIT(source, TRAIT_ON_HIT_EFFECT, REF(src))
	return ..()

/// Listener so that we shatter on hit
/datum/element/phantasmal_tool/proc/break_on_hit(datum/source, atom/damage_target, hit_zone, throw_hit)
	SIGNAL_HANDLER
	if(ismob(damage_target))
		playsound(attached_item, 'sound/items/ceramic_break.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		qdel(attached_item)

/// On dispel, we shatter too.
/datum/element/phantasmal_tool/proc/on_dispel(datum/source, atom/dispeller)
	SIGNAL_HANDLER
	if(attached_item)
		playsound(attached_item, 'sound/items/ceramic_break.ogg', 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		qdel(attached_item)
