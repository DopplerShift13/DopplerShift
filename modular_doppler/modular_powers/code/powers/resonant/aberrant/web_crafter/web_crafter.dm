// Web crafting! Create various doodads associated with web crafting.
/datum/power/aberrant/web_crafter
	name = "Web Crafter"
	desc = "Threads of spidery silk crafted at your leisure. You gain the Web Crafting ability. You can use it to make passive webs in an area (which do not slow you down); or you can use it to make cloth.\
	\n Creating anything using web crafter makes you hungry, and you cannot use it if you are starving.\
	\n Double-tap to quickly create the last item you crafted."
	mob_trait = TRAIT_WEB_SURFER // lets us walk on webs
	security_record_text = "Subject can create spider-like silk from their body."
	value = 3

	required_powers = list(/datum/power/aberrant_root/beastial)
	action_path = /datum/action/cooldown/power/aberrant/web_crafter

/datum/action/cooldown/power/aberrant/web_crafter
	name = "Web Crafter"
	desc = "Spend some of your satiation to craft web-like objects! Double-tap to quickly create the last item you crafted."
	button_icon = 'icons/effects/web.dmi'
	button_icon_state = "webpassage"

	/// Double-tap window to quick-craft the last made item.
	var/double_tap_window = 0.8 SECONDS
	/// World time of the last menu tap.
	var/last_menu_tap_time = 0
	/// Most recently crafted entry, if any.
	var/datum/web_craft_entry/last_crafted_entry

	/// Entries shown in the radial menu. Other powers can append to this.
	/// Accepts /datum/web_craft_entry instances or typepaths of that datum.
	var/list/web_craft_entries = list(
		/datum/web_craft_entry/cloth,
		/datum/web_craft_entry/stickyweb
	)

/datum/action/cooldown/power/aberrant/web_crafter/use_action(mob/living/user, atom/target)
	var/current_time = world.time
	var/radial_uniqueid = get_radial_uniqueid(user)
	var/datum/radial_menu/menu = GLOB.radial_menus[radial_uniqueid]
	// Doublet-tap interaction to quickly make last item
	if(menu && current_time <= last_menu_tap_time + double_tap_window)
		if(menu)
			menu.finished = TRUE
		if(!last_crafted_entry)
			user.balloon_alert(user, "no recent craft!")
			return FALSE
		if(!can_craft_entry(user, last_crafted_entry))
			return FALSE
		if(!do_after(user, last_crafted_entry.craft_time, target = user))
			return FALSE
		// Craft the item.
		if(!create_obj(user, last_crafted_entry))
			return FALSE
		last_menu_tap_time = current_time
		return TRUE
	else if(menu) // if you're too slow, activating the action again will just close it if the menu is open
		menu.finished = TRUE
		last_menu_tap_time = current_time
		return FALSE

	// stores last tap so we know if its a double-time
	last_menu_tap_time = current_time
	var/list/entries = get_web_craft_entries()
	if(!length(entries))
		user.balloon_alert(user, "no web crafts!")
		return FALSE

	var/list/key_to_entry = list()
	var/list/radial_options = build_radial_options(entries, key_to_entry)
	if(!length(radial_options))
		user.balloon_alert(user, "no web crafts!")
		return FALSE

	var/picked_key = show_radial_menu(user, user, radial_options, uniqueid = radial_uniqueid, tooltips = TRUE)

	if(!picked_key)
		return FALSE

	var/datum/web_craft_entry/entry = key_to_entry[picked_key]
	if(!entry)
		return FALSE

	if(!can_craft_entry(user, entry))
		return FALSE

	// Small craft time so its a tad more defensive.
	if(entry.craft_time > 0)
		if(!do_after(user, entry.craft_time, target = user))
			return FALSE

	if(!create_obj(user, entry))
		return FALSE
	last_crafted_entry = entry
	return TRUE

/datum/action/cooldown/power/aberrant/web_crafter/on_action_success(mob/living/user, atom/target)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_NOHUNGER))
		user.adjust_nutrition(-last_crafted_entry.hunger_cost)

/datum/action/cooldown/power/aberrant/web_crafter/can_use(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	// No using when you're hungry.
	if(!HAS_TRAIT(user, TRAIT_NOHUNGER) && user.nutrition <= NUTRITION_LEVEL_STARVING)
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	return TRUE

/// Populates the list of web entries
/datum/action/cooldown/power/aberrant/web_crafter/proc/get_web_craft_entries()
	// Normalize any typepaths to instances.
	for(var/i in 1 to length(web_craft_entries))
		var/entry = web_craft_entries[i]
		if(ispath(entry, /datum/web_craft_entry))
			web_craft_entries[i] = new entry
	return web_craft_entries

/// Creates and shows the options in the radial menu.
/datum/action/cooldown/power/aberrant/web_crafter/proc/build_radial_options(list/entries, list/key_to_entry)
	var/list/options = list()
	for(var/datum/web_craft_entry/entry as anything in entries)
		if(!istype(entry))
			continue
		var/datum/radial_menu_choice/choice = entry.get_radial_choice()
		if(!choice)
			continue
		var/key = entry.display_name
		if(!key)
			key = "[entry.type]"
		var/original_key = key
		var/dupe_index = 2
		while(options[key])
			key = "[original_key] ([dupe_index])"
			dupe_index++
		options[key] = choice
		key_to_entry[key] = entry
	return options

/// Unique radial menu id for this action and user.
/datum/action/cooldown/power/aberrant/web_crafter/proc/get_radial_uniqueid(mob/living/user)
	return "web_crafter_[REF(user)]"

/// Check before crafting.
/datum/action/cooldown/power/aberrant/web_crafter/proc/can_craft_entry(mob/living/user, datum/web_craft_entry/entry)
	// Are we hungy?
	if(!HAS_TRAIT(user, TRAIT_NOHUNGER) && user.nutrition <= NUTRITION_LEVEL_STARVING)
		user.balloon_alert(user, "too hungry!")
		return FALSE
	// Are we silenced. Yes, shooting strings from your body is resonant; you go ahead and explain how spiderman does it with your fancy psuedo-science..
	if(HAS_TRAIT(user, TRAIT_RESONANCE_SILENCED))
		user.balloon_alert(user, "silenced!")
		return FALSE
	// We don't have the entry?
	if(!entry)
		return FALSE
	// Special requirements for structure placement.
	if(entry.is_structure)
		if(!isturf(user.loc))
			user.balloon_alert(user, "invalid location!")
			return FALSE
		var/turf/target_turf = get_turf(user)
		if(!entry.can_place(user, target_turf))
			return FALSE
	return TRUE

// Actually creates the item.
/datum/action/cooldown/power/aberrant/web_crafter/proc/create_obj(mob/living/user, datum/web_craft_entry/entry)
	if(entry.is_structure)
		var/turf/target_turf = get_turf(user)
		if(!target_turf)
			return FALSE
		entry.spawn_entry(user, target_turf)
		return TRUE

	var/obj/item/new_item = entry.spawn_entry(user, null)
	user.put_in_hands(new_item)
	return TRUE
