/obj/item/wargame_projector
	name = "holographic wargame projector"
	desc = "A holographic projectors for creating holograms that work in the wargaming system."
	icon = 'modular_doppler/wargaming/icons/projectors_and_holograms.dmi'
	icon_state = "projector"
	base_icon_state = "projector"
	lefthand_file = 'modular_doppler/wargaming/icons/mob/lefthand.dmi'
	righthand_file = 'modular_doppler/wargaming/icons/mob/righthand.dmi'
	inhand_icon_state = "generic"
	worn_icon = 'modular_doppler/wargaming/icons/mob/worn.dmi'
	worn_icon_state = "generic"
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NOBLUDGEON
	/// All of the signs this projector is maintaining
	var/list/projections
	/// The color to give holograms when created
	var/holosign_color = COLOR_WHITE
	/// The type of hologram to spawn on click
	var/holosign_type = /obj/structure/wargame_hologram
	/// A list containing all of the possible holosigns this can choose from
	var/list/holosign_options = list(
		/obj/structure/wargame_hologram,
	)
	/// Contains all of the colors that the holograms can be changed to spawn as
	var/static/list/color_options = list(
		"Red" = COLOR_RED_LIGHT,
		"Orange" = COLOR_LIGHT_ORANGE,
		"Yellow" = COLOR_VIVID_YELLOW,
		"Green" = COLOR_VIBRANT_LIME,
		"Blue" = COLOR_BLUE_LIGHT,
		"Pink" = COLOR_FADED_PINK,
		"White" = COLOR_WHITE,
		"Gray" = COLOR_GRAY,
		"Brown" = COLOR_BROWN,
		"Ice" = COLOR_BLUE_GRAY,
	)
	/// Will hold the choices for radial menu use, populated on init
	var/list/radial_choices = list()
	/// A names to path list for the projections filled out by populate_radial_choice_lists() on init
	var/list/projection_names_to_path = list()

	/// Weakref to a linked base station, required for placing holograms
	var/datum/weakref/linked_base_station
	/// If this projector requires a linked team in order to place holograms as well
	var/requires_linked_team = FALSE
	/// Weakref to a linked team, for drawing color from
	var/datum/weakref/linked_team

/obj/item/wargame_projector/Initialize(mapload)
	. = ..()
	update_appearance()
	populate_radial_choice_lists()

/obj/item/wargame_projector/update_appearance()
	. = ..()
	cut_overlays()
	var/image/color_select_overlay = image(icon = icon, icon_state = "[base_icon_state]_screen")
	color_select_overlay.color = holosign_color
	add_overlay(color_select_overlay)

/obj/item/wargame_projector/examine(mob/user)
	. = ..()
	. += span_notice("Use the projector <b>in hand</b> to change what type of hologram it creates.")
	if(!requires_linked_team)
		. += span_notice("<b>Alt clicking</b> the projector will let you change the color of the next hologram it makes.")
	. += span_warning("<b>Control clicking</b> the projector will allow you to clear all active holograms.")

/obj/item/wargame_projector/proc/populate_radial_choice_lists()
	if(!length(radial_choices) || !length(projection_names_to_path))
		for(var/obj/structure/wargame_hologram/hologram as anything in holosign_options)
			projection_names_to_path[initial(hologram.name)] = hologram
			radial_choices[initial(hologram.name)] = image(icon = initial(hologram.icon), icon_state = initial(hologram.icon_state))

/// Changes the selected hologram to one of the options from the hologram list
/obj/item/wargame_projector/proc/select_hologram(mob/user)
	var/picked_choice = show_radial_menu(
		user,
		src,
		radial_choices,
		require_near = TRUE,
		tooltips = TRUE,
		)
	if(isnull(picked_choice))
		return
	holosign_type = projection_names_to_path[picked_choice]

/obj/item/wargame_projector/attack_self(mob/user)
	select_hologram(user)

/obj/item/wargame_projector/click_alt(mob/user)
	if(requires_linked_team)
		return ..() // Controllers linked to a team are locked to that team's color
	var/selected_color = tgui_input_list(user, "Select a color", "Color Selection", color_options)
	if(isnull(selected_color))
		balloon_alert(user, "no color change")
		return
	var/color_to_set_to = color_options[selected_color]
	holosign_color = color_to_set_to
	balloon_alert(user, "color changed")
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/wargame_projector/item_ctrl_click(mob/user)
	if(tgui_alert(usr,"Clear all currently active holograms?", "Hologram Removal", list("Yes", "No")) == "Yes")
		for(var/hologram as anything in projections)
			qdel(hologram)
	return CLICK_ACTION_SUCCESS

/// Can we place a hologram at the target location?
/obj/item/wargame_projector/proc/check_can_place_hologram(atom/target, mob/user)
	var/obj/item/wargame_base_station/base_station = linked_base_station?.resolve()
	if(isnull(base_station))
		user.balloon_alert(user, "no basestation!")
		return FALSE
	if(base_station.game_phase != WARGAME_PHASE_PLACEMENT)
		user.balloon_alert(user, "wrong game phase!")
		return FALSE
	if(!check_allowed_items(target, not_inside = TRUE))
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(target_turf.is_blocked_turf(TRUE))
		return FALSE
	return TRUE

/// Spawn a hologram with pixel offset based on where the user clicked
/obj/item/wargame_projector/proc/create_hologram(atom/target, mob/user, list/modifiers)
	var/obj/structure/wargame_hologram/target_holosign = new holosign_type(get_turf(target), src)
	target_holosign.color = holosign_color
	playsound(loc, 'sound/machines/click.ogg', 20, TRUE)
	if(requires_linked_team)
		target_holosign.team_reference = linked_team
	if(target_holosign.swarming)
		return // Ships use the swarming component and don't get specific pixel offsets
	var/click_x
	var/click_y
	if(LAZYACCESS(modifiers, ICON_X) && LAZYACCESS(modifiers, ICON_Y))
		click_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(world.icon_size/2), world.icon_size/2)
		click_y = clamp(text2num(LAZYACCESS(modifiers, ICON_Y)) - 16, -(world.icon_size/2), world.icon_size/2)
	target_holosign.pixel_x = click_x
	target_holosign.pixel_y = click_y

/obj/item/wargame_projector/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/item/wargame_base_station))
		var/obj/item/wargame_base_station/base_station = interacting_with
		balloon_alert(user, "linking...")
		var/datum/wargaming_team/reference_team
		if(requires_linked_team)
			var/picked_team = tgui_input_list(user, "Pick a team to link to.", "Team Picker", base_station.managed_teams)
			if(isnull(picked_team))
				base_station.balloon_alert(user, "needs team!")
				return NONE
			reference_team = base_station.managed_teams[picked_team]
			reference_team.tracked_projectors += src
			linked_team = WEAKREF(reference_team)
		if(!do_after(user, 3 SECONDS, base_station))
			return NONE
		if(!isnull(reference_team))
			holosign_color = reference_team.team_color
			update_appearance()
		linked_base_station = WEAKREF(base_station)
		return ITEM_INTERACT_SUCCESS
	if(istype(interacting_with, /obj/structure/wargame_hologram))
		qdel(interacting_with)
		return ITEM_INTERACT_SUCCESS
	if(!check_can_place_hologram(interacting_with, user))
		return NONE
	create_hologram(interacting_with, user, modifiers)
	return ITEM_INTERACT_SUCCESS

/obj/item/wargame_projector/Destroy()
	QDEL_LAZYLIST(projections)
	var/datum/wargaming_team/our_team = linked_team?.resolve()
	if(!isnull(our_team))
		our_team.tracked_projectors -= src
	. = ..()

/// Actual projector types, split between the 'categories' of things they can project

/obj/item/wargame_projector/ships
	name = "holographic unit projector"
	desc = "A handy-dandy holographic projector developed by the Port Authority Naval Command for playing wargames with, this one creates markers for 'units'."
	holosign_color = COLOR_BLUE_LIGHT
	holosign_type = /obj/structure/wargame_hologram/ship/ship_marker
	holosign_options = list(
		/obj/structure/wargame_hologram/ship/unidentified,
		/obj/structure/wargame_hologram/missile_warning,
		/obj/structure/wargame_hologram/ship/strike_craft,
		/obj/structure/wargame_hologram/ship/strike_craft_util,
		/obj/structure/wargame_hologram/ship/strike_craft/wing,
		/obj/structure/wargame_hologram/ship/ship_marker,
		/obj/structure/wargame_hologram/ship/ship_marker/medium,
		/obj/structure/wargame_hologram/ship/ship_marker/large,
		/obj/structure/wargame_hologram/ship/ship_marker/large/alternate,
		/obj/structure/wargame_hologram/probe,
		/obj/structure/wargame_hologram/stationary_structure,
		/obj/structure/wargame_hologram/stationary_structure/platform,
	)
	requires_linked_team = TRUE

/obj/item/wargame_projector/ships/red
	holosign_color = COLOR_RED_LIGHT

/obj/item/wargame_projector/terrain
	name = "holographic terrain projector"
	desc = "A handy-dandy holographic projector developed by the Port Authority Naval Command for playing wargames with, this one creates markers for space 'terrain'."
	holosign_color = COLOR_GRAY
	holosign_type = /obj/structure/wargame_hologram/asteroid
	// Some things, like stations, probes, and unidentified contacts, can be in the terrain one just because I can see situations where that's desired
	holosign_options = list(
		/obj/structure/wargame_hologram/ship/unidentified,
		/obj/structure/wargame_hologram/dust,
		/obj/structure/wargame_hologram/asteroid,
		/obj/structure/wargame_hologram/asteroid/large,
		/obj/structure/wargame_hologram/asteroid/cluster,
		/obj/structure/wargame_hologram/planet,
		/obj/structure/wargame_hologram/probe,
		/obj/structure/wargame_hologram/stationary_structure,
		/obj/structure/wargame_hologram/stationary_structure/platform,
	)
