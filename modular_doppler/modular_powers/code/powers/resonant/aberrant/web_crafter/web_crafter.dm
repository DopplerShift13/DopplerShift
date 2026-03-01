// Web crafting! Create various doodads associated with web crafting.
/datum/power/aberrant/web_crafter
	name = "Web Crafter"
	desc = "Threads of spidery silk crafted at your leisure. You gain the Web Crafting ability. You can use it to make passive webs in an area (which do not slow you down); or you can use it to make cloth.\
	\n Creating anything using web crafter makes you hungry, and you cannot use it if you are starving."
	value = 3

	required_powers = list(/datum/power/aberrant_root/beastial)
	action_path = /datum/action/cooldown/power/aberrant/web_crafter

// Lets us walk on webs
/datum/power/aberrant/web_crafter/add(client/client_source)
	if(power_holder)
		ADD_TRAIT(power_holder, TRAIT_WEB_SURFER, REF(src))

/datum/power/aberrant/web_crafter/remove()
	if(power_holder)
		REMOVE_TRAIT(power_holder, TRAIT_WEB_SURFER, REF(src))

/datum/action/cooldown/power/aberrant/web_crafter
	name = "Web Crafter"
	desc = "Spend some of your satiation to craft web-like objects!"
	button_icon = 'icons/effects/web.dmi'
	button_icon_state = "webpassage"

	cooldown_time = 10

	/// Entries shown in the radial menu. Other powers can append to this.
	/// Accepts /datum/web_craft_entry instances or typepaths of that datum.
	var/list/web_craft_entries = list(
		/datum/web_craft_entry/cloth,
		/datum/web_craft_entry/stickyweb
	)

/datum/action/cooldown/power/aberrant/web_crafter/use_action(mob/living/user, atom/target)
	var/list/entries = get_web_craft_entries()
	if(!length(entries))
		user.balloon_alert(user, "no web crafts!")
		return FALSE

	var/list/key_to_entry = list()
	var/list/radial_options = build_radial_options(entries, key_to_entry)
	if(!length(radial_options))
		user.balloon_alert(user, "no web crafts!")
		return FALSE

	var/picked_key = show_radial_menu(user, user, radial_options, tooltips = TRUE)

	if(!picked_key)
		return FALSE

	var/datum/web_craft_entry/entry = key_to_entry[picked_key]
	if(!entry)
		return FALSE

	if(!can_craft_entry(user, entry))
		return FALSE

	if(!create_obj(user, entry))
		return FALSE

	if(!HAS_TRAIT(user, TRAIT_NOHUNGER))
		user.adjust_nutrition(-entry.hunger_cost)
	return TRUE

/datum/action/cooldown/power/aberrant/web_crafter/can_use(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	// No using when you're hungry.
	if(!HAS_TRAIT(user, TRAIT_NOHUNGER) && user.nutrition <= NUTRITION_LEVEL_STARVING)
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	return TRUE

// Populates the list of web entries
/datum/action/cooldown/power/aberrant/web_crafter/proc/get_web_craft_entries()
	// Normalize any typepaths to instances.
	for(var/i in 1 to length(web_craft_entries))
		var/entry = web_craft_entries[i]
		if(ispath(entry, /datum/web_craft_entry))
			web_craft_entries[i] = new entry
	return web_craft_entries

// Creates and shows the options in the radial menu.
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

// Check before crafting.
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

// Atually creates the item.
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
