#define INDICATOR_COMBAT "combat"
#define INDICATOR_ALERT "alert"
#define INDICATOR_PARLEY "de-escalate"
/// The time for which the sound effect and `emote_popup` alert are disabled, but the CI swapping effect is not
#define COMBAT_NOTICE_COOLDOWN (5 SECONDS)

GLOBAL_LIST_INIT(combat_indicator_overlays, generate_combat_overlays())

/proc/generate_combat_overlays()
	return list(
		INDICATOR_COMBAT = mutable_appearance('modular_doppler/indicators/icons/combat_indicator.dmi', INDICATOR_COMBAT, FLY_LAYER, appearance_flags = APPEARANCE_UI_IGNORE_ALPHA|KEEP_APART),
		INDICATOR_ALERT = mutable_appearance('modular_doppler/indicators/icons/combat_indicator.dmi', INDICATOR_ALERT, FLY_LAYER, appearance_flags = APPEARANCE_UI_IGNORE_ALPHA|KEEP_APART),
		INDICATOR_PARLEY = mutable_appearance('modular_doppler/indicators/icons/combat_indicator.dmi', INDICATOR_PARLEY, FLY_LAYER, appearance_flags = APPEARANCE_UI_IGNORE_ALPHA|KEEP_APART)
	)

/datum/config_entry/flag/combat_indicator

/mob/living
	/// What combat indicator is enabled for this mob? "none", "combat", "alert" and "de-escalate"
	var/combat_indicator = "none"
	/// When is the next time this mob will be able to use flick_emote?
	var/nextcombatpopup = 0

/**
 * Called whenever a mob inside a vehicle/sealed/ toggles CI status.
 *
 * Tied to the COMSIG_MOB_CI_TOGGLED signal, said signal is assigned when a mob enters a vehicle and unassigned when the mob exits, and is sent whenever set_combat_indicator is called.
 *
 * Arguments:
 * * source -- The mob in question that toggled CI status.
 */

/obj/vehicle/sealed/proc/mob_toggled_ci(mob/living/source, state)
	SIGNAL_HANDLER
	if ((src.max_occupants > src.max_drivers) && (!(source in return_drivers())) && (src.driver_amount() > 0)) // Only returms true if the mob in question has the driver control flags and/or there are drivers.
		return
	combat_indicator_vehicle = source.combat_indicator	// Sync CI between mob and vehicle.
	if (combat_indicator_vehicle != "none")
		if(world.time > vehicle_next_combat_popup) // As of the time of writing, COMBAT_NOTICE_COOLDOWN is 2 secs, so this is asking "has 2 secs past between last activation of CI?"
			vehicle_next_combat_popup = world.time + COMBAT_NOTICE_COOLDOWN
			flick_emote_popup_on_obj(state, COMBAT_NOTICE_COOLDOWN)
	combat_indicator_vehicle = state
	update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/mob/living/update_overlays()
	. = ..()
	if(combat_indicator != "none")
		. += GLOB.combat_indicator_overlays[combat_indicator]

/obj/vehicle/sealed/update_overlays()
	. = ..()
	if(combat_indicator_vehicle != "none")
		. += GLOB.combat_indicator_overlays[combat_indicator_vehicle]

/**
 * Called whenever a mob's stat changes.
 * Checks if the mob's stat is greater than SOFT_CRIT, and if it is, it will disable CI.
 *
 * Arguments:
 * * source -- The mob in question that toggled CI status.
 * * new_stat -- The new stat of the mob.
 */

/mob/living/proc/ci_on_stat_change(mob/source, new_stat)
	SIGNAL_HANDLER
	if(new_stat <= SOFT_CRIT)
		return
	set_combat_indicator("none", involuntary = TRUE)

/**
 * Called whenever a mob's CI status changes for any reason.
 *
 * Checks if the mob is dead, if config disallows CI, or if the current CI status is the same as state, and if it is, it will change CI status to state.
 *
 * Arguments:
 * * state -- String, can be "none", "combat", "alert" and "de-escalate"
 * * involuntary -- Boolean. If true, the mob is dead or unconscious, and the log will reflect that.
 */

/mob/living/proc/set_combat_indicator(state, involuntary = FALSE)
	if(!CONFIG_GET(flag/combat_indicator))
		return

	if(stat == DEAD || involuntary)
		disable_combat_indicator(involuntary)

	combat_indicator = state

	SEND_SIGNAL(src, COMSIG_MOB_CI_TOGGLED, state)

	if(combat_indicator != "none")
		enable_combat_indicator(state)
	else
		disable_combat_indicator()

/**
 * Called whenever a mob enables CI.
 *
 * Plays a sound, sents a message to chat, updates their overlay, and sets the mob's CI status to true.
 */

/mob/living/proc/enable_combat_indicator(state)
	if(world.time > nextcombatpopup) // As of the time of writing, COMBAT_NOTICE_COOLDOWN is 2 secs, so this is asking "have 2 secs past between last activation of CI?"
		nextcombatpopup = world.time + COMBAT_NOTICE_COOLDOWN
		playsound(src, "modular_doppler/modular_sounds/sound/mobs/humanoids/combat_indicator/[state].ogg", vol = 15, vary = TRUE, extrarange = -6, falloff_exponent = 4, frequency = null, channel = 0, pressure_affected = FALSE, ignore_walls = FALSE, falloff_distance = 1)
		flick_emote_popup_on_mob(state, COMBAT_NOTICE_COOLDOWN)
	combat_indicator = state
	log_message("<font color='red'>[src] has turned ON the combat indicator, to mode '[state]'!</font>", LOG_ATTACK)
	RegisterSignal(src, COMSIG_MOB_STATCHANGE , PROC_REF(ci_on_stat_change), override = TRUE)
	update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/**
 * Called whenever a mob disables CI. Or when they die or fall unconscious.
 *
 * Arguments:
 * * involuntary -- Boolean. If true, the mob is dead or unconscious, and the log will reflect that.
 */

/mob/living/proc/disable_combat_indicator(involuntary = FALSE)
	combat_indicator = "none"
	if(involuntary)
		log_message("<font color='cyan'>[src] has fallen unconsious, has died or dropped connection, and lost their combat indicator!</font>", LOG_ATTACK)
	else
		log_message("<font color='cyan'>[src] has turned OFF the combat indicator!</font>", LOG_ATTACK)
	UnregisterSignal(src, COMSIG_MOB_STATCHANGE)
	update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/**
 * Called whenever the user hits their combat indicator keybind, defaulted to C.
 *
 * If the user is conscious, it will set CI to be whatever the opposite of what it is currently.
 */

/mob/living/proc/user_toggle_combat_indicator(state)
	if(stat != CONSCIOUS)
		return
	if(combat_indicator == state)
		set_combat_indicator("none")
	else
		set_combat_indicator(state)

/**
 * Called whenever a mob enters a vehicle/sealed, after everything else.
 *
 * Sets the vehicle's CI status to that of the mob if the mob is a driver and there are no other drivers, or if the mob is a passenger and there are no drivers.
 *
 * Arguments:
 * * user -- mob/living, the mob that is entering the vehicle.
 */

/obj/vehicle/sealed/proc/handle_ci_migration(mob/living/user)
	if(!typesof(user.loc, /obj/vehicle/sealed)) //Sanity check: If the mob's location (not the tile they are on) is NOT a type of vehicle/sealed, kill the proc.
		return
	//If the vehicle can have more passenger seats than driver seats (note: each driver seat counts as a passenger seat) AND both: The mob is not a driver, and the vehicle has a driver, return.
	if ((src.max_occupants > src.max_drivers) && ((!(user in return_drivers())) && (src.driver_amount() > 0)))
		return
	if (user.combat_indicator != "none" && combat_indicator_vehicle == "none") // Finally, if all conditions prior are not met, and the mob has CI enabled and the vehicle doesn't, enable CI.
		combat_indicator_vehicle = user.combat_indicator
		update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/**
 * Called whenever a mob exits a vehicle/sealed, after everything else.
 *
 * Disables the vehicle's CI if it was enabled, and if it was the only occupant (or there was noone else in the mech with CI enabled).
 *
 * Arguments:
 * * user -- mob/living, the mob that is exiting the vehicle.
 */

/obj/vehicle/sealed/proc/disable_ci(mob/living/user)
	// If the vehicle can have more occupants than drivers, and either 1. The mob is not a driver and the vehicle has drivers, or 2. The user IS a driver but there is an occupant (drivers count as occupants), return.
	if ((src.max_occupants > src.max_drivers) && ((!(user in return_drivers()) && (src.driver_amount() > 0)) || ((user in return_drivers()) && (src.occupant_amount() > 0))))
		return
	// If the preceding conditions are not met, and the vehicle has CI, look at each occupant to see if there is a non-driver with CI enabled. If yes, stop the proc, if no, disable CI.
	if (combat_indicator_vehicle != "none")
		var/has_occupant_with_ci = FALSE
		if (src.occupant_amount() > src.driver_amount())
			for (var/mob/living/vehicle_occupant in return_occupants())
				if (vehicle_occupant in return_drivers()) //this for loop does not account for multiple clowns in clown cars. i will not account for that. fuck that.
					continue
				if (vehicle_occupant.combat_indicator != "none")
					has_occupant_with_ci = TRUE
					break
		if (!has_occupant_with_ci)
			combat_indicator_vehicle = "none"
			update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

#undef COMBAT_NOTICE_COOLDOWN

/*
	Keybind configurations
*/

/datum/keybinding/living/combat_indicator_red
	hotkey_keys = list("C")
	name = "combat_indicator_red"
	full_name = "Combat Indicator"
	description = "Indicates that you're escalating to mechanics."
	keybind_signal = COMSIG_KB_LIVING_COMBAT_INDICATOR_RED

/datum/keybinding/living/combat_indicator_red/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/L = user.mob
	L.user_toggle_combat_indicator(INDICATOR_COMBAT)

/datum/keybinding/living/combat_indicator_yellow
	hotkey_keys = list("ShiftC")
	name = "combat_indicator_yellow"
	full_name = "Dangerous Indicator"
	description = "Indicates that you're escalating to mechanics if hindered."
	keybind_signal = COMSIG_KB_LIVING_COMBAT_INDICATOR_YELLOW

/datum/keybinding/living/combat_indicator_yellow/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/L = user.mob
	L.user_toggle_combat_indicator(INDICATOR_ALERT)

/datum/keybinding/living/combat_indicator_green
	hotkey_keys = list("CtrlC")
	name = "combat_indicator_green"
	full_name = "De-escalate Indicator"
	description = "Indicates that you're de-escalating away from mechanics."
	keybind_signal = COMSIG_KB_LIVING_COMBAT_INDICATOR_GREEN

/datum/keybinding/living/combat_indicator_green/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/L = user.mob
	L.user_toggle_combat_indicator(INDICATOR_PARLEY)

#undef INDICATOR_COMBAT
#undef INDICATOR_ALERT
#undef INDICATOR_PARLEY
