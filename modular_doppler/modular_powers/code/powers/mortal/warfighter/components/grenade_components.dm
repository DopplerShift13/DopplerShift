/**
 * Shows a live detonation countdown on the grenade's hand HUD icon.
 * Visible to explosives specialists and to observers watching the holder.
 * Spread into two parts: grenade_timer_hud is the inhand timer, grenade_timer_ground is the ground timer.
 * The global manager centralizes countdown math; components handle their own visuals.
 */
/datum/component/grenade_timer_hud
	/// The grenade the component is attached to
	var/obj/item/grenade/parent_grenade
	/// The mob currently holding the grenade
	var/mob/holder
	/// The visible timer element on the grenade within the hud
	var/atom/movable/screen/timer_hud
	/// Stored time for when the grenade should explode (roundtime)
	var/explodes_at = 0
	/// reference ID to the timer instance
	var/timer_id
	/// Everyone that can currently see the grenade.
	var/list/current_viewers = list()

/datum/component/grenade_timer_hud/Initialize()
	if(!istype(parent, /obj/item/grenade))
		return COMPONENT_INCOMPATIBLE
	parent_grenade = parent

/datum/component/grenade_timer_hud/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GRENADE_ARMED, PROC_REF(on_armed))
	RegisterSignal(parent, COMSIG_GRENADE_DETONATE, PROC_REF(on_detonate))
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/component/grenade_timer_hud/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_GRENADE_ARMED,
		COMSIG_GRENADE_DETONATE,
		COMSIG_ITEM_PICKUP,
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED,
	))
	stop_timer()
	remove_hud()

/// Listener for when the grenade is armed
/datum/component/grenade_timer_hud/proc/on_armed(datum/source, det_time, delayoverride)
	SIGNAL_HANDLER
	var/delay = isnull(delayoverride) ? det_time : delayoverride
	explodes_at = world.time + delay
	if(!holder && ismob(parent_grenade.loc))
		holder = parent_grenade.loc
		update_viewers()
	start_timer()

/// Listener for when the grenade explodes
/datum/component/grenade_timer_hud/proc/on_detonate(datum/source, lanced_by)
	SIGNAL_HANDLER
	stop_timer()
	remove_hud()

/// Listener for when the grenade is picked up
/datum/component/grenade_timer_hud/proc/on_pickup(datum/source, mob/living/user)
	SIGNAL_HANDLER
	holder = user
	update_viewers()

/// Listener for when the grenade is equipped on our person
/datum/component/grenade_timer_hud/proc/on_equipped(datum/source, mob/living/user, slot)
	SIGNAL_HANDLER
	holder = user
	update_viewers()

/// Listener for when the item is dropped
/datum/component/grenade_timer_hud/proc/on_drop(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(holder == user)
		holder = null
	remove_hud()

/// Starts the tick timer
/datum/component/grenade_timer_hud/proc/start_timer()
	if(timer_id)
		return
	timer_id = addtimer(CALLBACK(src, PROC_REF(tick)), 1 DECISECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/// Ends the tick timer
/datum/component/grenade_timer_hud/proc/stop_timer()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null

/// We use addtimer to psuedo process every deci-second and update the timer as needed.
/datum/component/grenade_timer_hud/proc/tick()
	if(!parent_grenade?.active)
		stop_timer()
		remove_hud()
		return

	update_viewers()
	if(!timer_hud)
		return

	var/remaining = max(explodes_at - world.time, 0)
	var/remaining_seconds = max(CEILING(remaining / 10, 1), 0)
	timer_hud.maptext = "<span class='maptext'>[remaining_seconds]</span>"
	timer_hud.screen_loc = parent_grenade.screen_loc

/// Gets everoyne that can see the grenade
/datum/component/grenade_timer_hud/proc/get_viewers()
	var/list/viewers = list()
	if(holder?.client && HAS_TRAIT(holder, TRAIT_POWER_EXPLOSIVES_SPECIALIST))
		viewers += holder
	if(holder?.observers?.len)
		for(var/mob/dead/observer/O in holder.observers)
			if(O?.client && O.client.eye == holder)
				viewers += O
	return viewers

/// Updates the list of mobs that can view the grenade.
/datum/component/grenade_timer_hud/proc/update_viewers()
	if(!holder || !parent_grenade.active || parent_grenade.loc != holder)
		remove_hud()
		return

	var/list/new_viewers = get_viewers()
	if(!new_viewers.len)
		remove_hud()
		return

	show_hud()

	for(var/mob/M in current_viewers)
		if(!(M in new_viewers))
			M.client?.screen -= timer_hud

	for(var/mob/M in new_viewers)
		if(!(M in current_viewers))
			M.client?.screen += timer_hud

	current_viewers = new_viewers

/// Shows the timer maptext element on the target's HUD.
/datum/component/grenade_timer_hud/proc/show_hud()
	if(timer_hud)
		return
	timer_hud = new /atom/movable/screen
	timer_hud.layer = ABOVE_HUD_PLANE
	timer_hud.plane = HUD_PLANE
	timer_hud.maptext_width = 32
	timer_hud.maptext_height = 16
	timer_hud.maptext = "<span class='maptext'>?</span>"

/// Removes the timer maptext hud element.
/datum/component/grenade_timer_hud/proc/remove_hud()
	if(timer_hud)
		for(var/mob/M in current_viewers)
			M?.client?.screen -= timer_hud
	current_viewers = list()
	QDEL_NULL(timer_hud)

/**
 * Registers armed grenades with the global timer manager.
 */
/datum/component/grenade_timer_ground

/datum/component/grenade_timer_ground/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GRENADE_ARMED, PROC_REF(on_armed))

/datum/component/grenade_timer_ground/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_GRENADE_ARMED)

/// Listener for when the grenade is armed.
/datum/component/grenade_timer_ground/proc/on_armed(datum/source, det_time, delayoverride)
	SIGNAL_HANDLER
	GLOB.grenade_timer_manager.register_grenade(source, det_time, delayoverride)


/**
 * The part 2 that's respnsible for on the ground timers.
 * Because showing text overlays to select characters isn't easy, and ghosts get the easy pass with invisibility flags.
 */

/// Global countdowns for specialists/observers looking at any armed grenade.
GLOBAL_DATUM_INIT(grenade_timer_manager, /datum/grenade_timer_manager, new)

/datum/grenade_timer_manager
	/// List of grenades that are currently armed
	var/list/armed_grenades = list() // /obj/item/grenade -> explode_at (world.time)
	/// List of maptexts that every mob can see
	var/list/viewer_images = list() // mob -> (grenade -> image)
	/// Reference id for the timer instance
	var/timer_id

/// Registers the grenade in the timer manager.
/datum/grenade_timer_manager/proc/register_grenade(obj/item/grenade/G, det_time, delayoverride)
	if(QDELETED(G))
		return
	if(armed_grenades[G])
		return
	var/delay = isnull(delayoverride) ? det_time : delayoverride
	armed_grenades[G] = world.time + delay
	RegisterSignal(G, COMSIG_GRENADE_DETONATE, PROC_REF(on_grenade_detonate))
	RegisterSignal(G, COMSIG_QDELETING, PROC_REF(on_grenade_deleted))
	ensure_timer()

/// Removes a grenade from the timer manager, usually when qdel'd.
/datum/grenade_timer_manager/proc/unregister_grenade(obj/item/grenade/G)
	if(!armed_grenades[G])
		return
	armed_grenades -= G
	UnregisterSignal(G, list(COMSIG_GRENADE_DETONATE, COMSIG_QDELETING))
	remove_grenade_images(G)
	if(!armed_grenades.len)
		stop_timer()

/// Listener for when the grenade goes boom.
/datum/grenade_timer_manager/proc/on_grenade_detonate(datum/source, lanced_by)
	SIGNAL_HANDLER
	unregister_grenade(source)

/// Listener for when the grenade is DELETED
/datum/grenade_timer_manager/proc/on_grenade_deleted(datum/source)
	SIGNAL_HANDLER
	unregister_grenade(source)

/// Adds an active timer to the grenade when the grenade is registered and armed.
/datum/grenade_timer_manager/proc/ensure_timer()
	if(timer_id)
		return
	timer_id = addtimer(CALLBACK(src, PROC_REF(tick)), 1 DECISECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/// Stops the timer (I didn't know timers could be stopped on live grenades)
/datum/grenade_timer_manager/proc/stop_timer()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null

/// Tick proc called every decisecond by the timer.
/datum/grenade_timer_manager/proc/tick()
	if(!armed_grenades.len)
		stop_timer()
		return

	var/list/eligible_viewers = get_eligible_viewers()

	// Remove viewers who are no longer eligible
	for(var/mob/M in viewer_images)
		if(!(M in eligible_viewers))
			remove_all_images_from(M)
			viewer_images -= M

	// Update grenade images per eligible viewer
	for(var/obj/item/grenade/G as anything in armed_grenades)
		if(QDELETED(G) || !G.active)
			unregister_grenade(G)
			continue

		var/remaining = max(armed_grenades[G] - world.time, 0)
		var/remaining_seconds = max(CEILING(remaining / 10, 1), 0)

		for(var/mob/M in eligible_viewers)
			if(can_view_grenade(M, G))
				update_image(M, G, remaining_seconds)
			else
				remove_image(M, G)

/// Get all mobs that can see the grenade in range.
/datum/grenade_timer_manager/proc/get_eligible_viewers()
	var/list/viewers = list()
	for(var/mob/M in GLOB.player_list)
		if(!M?.client)
			continue
		if(HAS_TRAIT(M, TRAIT_POWER_EXPLOSIVES_SPECIALIST) || isobserver(M))
			viewers += M
	return viewers

/// Checks ifa mob has Line of Sight on the grenade or otherwise can see it.
/datum/grenade_timer_manager/proc/can_view_grenade(mob/M, obj/item/grenade/G)
	var/atom/eye = M.client?.eye || M
	if(!eye || eye.z != G.z)
		return FALSE
	var/list/view_range = getviewsize(M.client?.view)
	if(!view_range || view_range.len < 2)
		return FALSE
	var/range = max(view_range[1], view_range[2])
	return get_dist(eye, G) <= range

/// Updates the maptext image on the grenade.
/datum/grenade_timer_manager/proc/update_image(mob/M, obj/item/grenade/G, remaining_seconds)
	if(!viewer_images[M])
		viewer_images[M] = list()

	var/image/I = viewer_images[M][G]
	if(!I)
		I = image('icons/blanks/32x32.dmi', loc = G, icon_state = "nothing")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = FLOAT_LAYER
		I.dir = SOUTH
		I.maptext_width = 32
		I.maptext_height = 16
		I.appearance_flags |= RESET_TRANSFORM|RESET_COLOR|KEEP_APART
		viewer_images[M][G] = I
		M.client.images += I

	I.maptext = "<span class='maptext'>[remaining_seconds]</span>"

/// Removes the maptext image from the grenade
/datum/grenade_timer_manager/proc/remove_image(mob/M, obj/item/grenade/G)
	var/list/images = viewer_images[M]
	if(!images)
		return
	var/image/I = images[G]
	if(I)
		M.client?.images -= I
		images -= G

/// Removes ALL maptext images that the mob can see.
/datum/grenade_timer_manager/proc/remove_all_images_from(mob/M)
	var/list/images = viewer_images[M]
	if(!images)
		return
	for(var/image/I in images)
		M.client?.images -= I
	images.Cut()

/// Removes ALL maptext images on the grenades
/datum/grenade_timer_manager/proc/remove_grenade_images(obj/item/grenade/G)
	for(var/mob/M in viewer_images)
		remove_image(M, G)

