
/obj/machinery/fax
	/// Weakref to the encryption key we use for deciding our internal radio channels.
	var/datum/weakref/encryption_key_ref
	/// What channel do we announce over without a key, for subtypes to override.
	var/default_announcement_channel = RADIO_CHANNEL_COMMON
	/// Whether we announce our faxes over radio.
	var/announce_over_radio = FALSE

/obj/machinery/fax/Initialize(mapload)
	. = ..()
	if(mapload)
		set_mapload_radio()

/obj/machinery/fax/Destroy()
	QDEL_NULL(encryption_key_ref)
	return ..()

/obj/machinery/fax/attack_hand_secondary(mob/user, list/modifiers)
	var/obj/item/encryptionkey/encryption_key = encryption_key_ref?.resolve()
	if(encryption_key)
		user.put_in_hands(encryption_key)
		encryption_key_ref = null
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

/obj/machinery/fax/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/encryptionkey))
		return encryption_key_act(user, tool)
	return ..()

/obj/machinery/fax/multitool_act_secondary(mob/living/user, obj/item/tool)
	announce_over_radio = !announce_over_radio
	balloon_alert(user, "radio [announce_over_radio ? "on": "off"]")
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/fax/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(isnull(held_item))
		var/obj/item/encryptionkey/encryption_key = encryption_key_ref?.resolve()
		if(encryption_key)
			context[SCREENTIP_CONTEXT_RMB] = "Remove encryption key"
			return CONTEXTUAL_SCREENTIP_SET
		return .

	if(held_item?.tool_behaviour == TOOL_MULTITOOL)
		context[SCREENTIP_CONTEXT_RMB] = "Turn [announce_over_radio ? "off" : "on"] radio messages"
		return CONTEXTUAL_SCREENTIP_SET
	if(istype(held_item, /obj/item/encryptionkey))
		var/obj/item/encryptionkey/encryption_key = encryption_key_ref?.resolve()
		context[SCREENTIP_CONTEXT_LMB] = "[encryption_key ? "Swap" : "Add"] encryption key"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/fax/examine()
	. = ..()
	if(panel_open)
		var/obj/item/encryptionkey/encryption_key = encryption_key_ref?.resolve()
		if(encryption_key)
			. += span_notice("Its encryption key slot is occupied by [encryption_key].")
		else
			. += span_notice("Its encryption key slot is unoccupied.")

	. += span_notice("[EXAMINE_HINT("Right-Click")] with a multitool to turn [announce_over_radio ? "off" : "on"] received faxes being announced over radio.")

	if(announce_over_radio)
		var/list/announcement_channels = list()
		for(var/channel_name in get_radio_channels())
			var/channel_span_class = get_radio_span(GLOB.default_radio_channels[channel_name])
			announcement_channels += "<li><b>[span_class(channel_span_class, channel_name)]</b></li>"
		. += span_notice("It is currently announcing received faxes on the following frequencies:")
		. += span_notice("<ul style='display:inline-block; margin: 0; list-style: square;'>[announcement_channels.Join()]</ul>")
	else
		. += span_notice("It is not currently announcing received faxes.")



/// Sets the encryption key and radio based on our current area. Use for mapload.
/obj/machinery/fax/proc/set_mapload_radio()
	var/area/current_area = get_area(src)
	if(isnull(current_area.fax_encryption_key_type))
		return
	var/obj/item/encryptionkey/new_key = new current_area.fax_encryption_key_type(src)
	encryption_key_ref = WEAKREF(new_key)
	announce_over_radio = TRUE

/// Handles interacting with this fax machine using an encryption key.
/obj/machinery/fax/proc/encryption_key_act(mob/living/user, obj/item/encryptionkey/new_key)
	if(!panel_open)
		balloon_alert(user, "open panel first!")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(new_key, src, silent = FALSE))
		balloon_alert(user, "stuck to hands!")
		return ITEM_INTERACT_BLOCKING

	var/obj/item/encryptionkey/existing_key = encryption_key_ref?.resolve()
	if(existing_key)
		user.put_in_hands(existing_key)
	encryption_key_ref = WEAKREF(new_key)
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	return ITEM_INTERACT_SUCCESS

/// Gets the list of radio channels to use when announcing a fax.
/obj/machinery/fax/proc/get_radio_channels()
	var/obj/item/encryptionkey/encryption_key = encryption_key_ref?.resolve()
	if(encryption_key)
		return encryption_key.channels
	else
		return list(default_announcement_channel)

/// Announces the arrival of a fax over AAS, if need be.
/obj/machinery/fax/proc/announce_fax_arrival(sender_name)
	if(!announce_over_radio)
		return
	var/list/channels = get_radio_channels()
	aas_config_announce(/datum/aas_config_entry/fax_received, list("SENDER" = sender_name, "FAX" = fax_name), null, channels)



/datum/aas_config_entry/fax_received
	name = "Departmental: Fax Received Announcement"
	announcement_lines_map = list(
		"Message" = "Fax received from %SENDER at %FAX!")
	vars_and_tooltips_map = list(
		"SENDER" = "will be replaced with the Sender's name.",
		"FAX" = "will be replaced with the Fax Machine's name.")
