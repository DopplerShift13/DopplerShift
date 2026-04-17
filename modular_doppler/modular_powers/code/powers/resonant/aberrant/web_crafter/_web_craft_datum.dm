// Used to store what web crafter can make and pass it back to the power. Partially so other powers can add onto it without too much hasle.
/datum/web_craft_entry
	/// Type spawned by this entry
	var/obj/spawn_type
	/// Hunger cost to craft
	var/hunger_cost = 0
	/// Time to craft (do_after). 0 for instant.
	var/craft_time = 0
	/// Display name for the radial
	var/display_name
	/// Description shown in tooltip
	var/desc
	/// Icon data for radial choice
	var/icon
	var/icon_state
	/// Whether this should be placed on the turf instead of in hands
	var/is_structure = FALSE

/datum/web_craft_entry/New()
	. = ..()
	if(ispath(spawn_type, /obj/structure))
		is_structure = TRUE
	if(ispath(spawn_type))
		if(!display_name)
			display_name = spawn_type.name
		if(!desc)
			desc = spawn_type.desc
		if(!icon)
			icon = spawn_type.icon
		if(!icon_state)
			icon_state = spawn_type.icon_state

/// Populates the list of radial menu choices.
/datum/web_craft_entry/proc/get_radial_choice()
	if(!display_name || !icon || !icon_state)
		return null
	var/datum/radial_menu_choice/choice = new()
	choice.name = display_name
	choice.image = image(icon = icon, icon_state = icon_state)
	var/list/info_bits = list()
	if(desc)
		info_bits += desc
	info_bits += "Cost: [hunger_cost] hunger"
	if(craft_time > 0)
		info_bits += "Time: [craft_time/10]s"
	choice.info = jointext(info_bits, "<br>")
	return choice

/// Checks if the related web entry can be placed.
/datum/web_craft_entry/proc/can_place(mob/living/user, turf/target_turf)
	return TRUE

/// In the event we need to pass data to the object, e.g tripwire webs or do other fancy stuff on spawn
/datum/web_craft_entry/proc/spawn_entry(mob/living/user, turf/target_turf)
	if(is_structure)
		return spawn_structure(user, target_turf)
	return spawn_item(user)

/// Spawns the appropriate item
/datum/web_craft_entry/proc/spawn_item(mob/living/user)
	return new spawn_type(user)

/// Spawns physical structures
/datum/web_craft_entry/proc/spawn_structure(mob/living/user, turf/target_turf)
	return new spawn_type(target_turf)

/datum/web_craft_entry/stickyweb/can_place(mob/living/user, turf/target_turf)
	if(HAS_TRAIT(target_turf, TRAIT_SPINNING_WEB_TURF))
		user.balloon_alert(user, "already being webbed!")
		return FALSE
	if(locate(/obj/structure/spider/stickyweb) in target_turf)
		user.balloon_alert(user, "already webbed!")
		return FALSE
	return TRUE
