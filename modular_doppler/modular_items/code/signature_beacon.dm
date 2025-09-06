
/obj/item/signature_beacon
	name = "signature beacon"
	desc = "Use this to select the form your signature equipment takes, \
	but in this case report it because it's an abstract parent type."
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "generic_delivery"
	inhand_icon_state = "generic_delivery"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'

	/// The abstract base type we get the subtypes for, determining our options.
	var/datum/signature_equipment/selection_base_type

/obj/item/signature_beacon/interact(mob/user)
	. = ..()
	attempt_selection(user)

/obj/item/signature_beacon/proc/generate_equipment_options()
	var/static/list/equipment_option_list
	if(equipment_option_list)
		return equipment_option_list

	equipment_option_list = list()
	for(var/datum/signature_equipment/signature_equipment as anything in subtypesof(selection_base_type))
		equipment_option_list[signature_equipment::name] = signature_equipment
	sort_list(equipment_option_list)
	return equipment_option_list

/obj/item/signature_beacon/proc/generate_radial_options()
	var/static/list/radial_option_list
	if(radial_option_list)
		return radial_option_list

	var/list/equipment_option_list = generate_equipment_options()
	radial_option_list = list()
	for(var/equipment_option as anything in equipment_option_list)
		var/datum/signature_equipment/signature_equipment = equipment_option_list[equipment_option]
		var/obj/item/icon_item_type = signature_equipment::icon_item_type
		var/datum/radial_menu_choice/radial_option = new()

		radial_option.name = equipment_option
		if(signature_equipment::desc)
			radial_option.info = span_italics(signature_equipment::desc)
		var/option_icon = signature_equipment::icon ? signature_equipment::icon : icon_item_type::icon
		var/option_icon_state = signature_equipment::icon_state ? signature_equipment::icon_state : icon_item_type::icon_state
		radial_option.image = image(icon = option_icon, icon_state = option_icon_state)

		radial_option_list[equipment_option] = radial_option
	sort_list(radial_option_list)

	return radial_option_list

/obj/item/signature_beacon/proc/check_option_menu(mob/user)
	if(QDELETED(src))
		return FALSE
	if(!istype(user))
		return FALSE
	if(user.incapacitated)
		return FALSE
	return TRUE

/obj/item/signature_beacon/proc/attempt_selection(mob/living/user)
	if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 40, TRUE)
		return

	var/list/radial_option_list = generate_radial_options()
	var/chosen_option = show_radial_menu(
		user,
		src,
		radial_option_list,
		custom_check = CALLBACK(src, PROC_REF(check_option_menu), user),
		require_near = TRUE,
		tooltips = TRUE,
	)

	if(isnull(chosen_option))
		return
	var/list/equipment_option_list = generate_equipment_options()
	var/datum/signature_equipment/chosen_signature_type = equipment_option_list[chosen_option]
	if(isnull(chosen_signature_type))
		return

	var/datum/signature_equipment/chosen_signature = new chosen_signature_type()
	do_sparks(3, FALSE, user)
	qdel(src)
	chosen_signature.grant_equipment(user)
	qdel(chosen_signature)


/datum/signature_equipment
	/// The name for this equipment.
	var/name
	/// The description used for our radial option tooltip, if any.
	var/desc

	/// The item type we use to automatically generate our radial image.
	var/obj/item/icon_item_type
	/// The icon to use for our radial option image, for granular control.
	var/icon
	/// The icon state to use for our radial option image, for granular control.
	var/icon_state

	/// The item type to spawn in upon selecting this.
	var/obj/item/spawned_item_type

/// Grants given user our equipment. Override to apply other effects.
/datum/signature_equipment/proc/grant_equipment(mob/living/user)
	playsound(user, 'sound/effects/phasein.ogg', 20, TRUE)
	var/obj/item/spawned_item = new spawned_item_type()
	user.put_in_hands(spawned_item)
