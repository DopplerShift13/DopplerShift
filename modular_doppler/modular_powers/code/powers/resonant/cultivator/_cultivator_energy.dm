/// Helper to format the text that gets thrown onto the energy hud element.
#define FORMAT_ENERGY_TEXT(charges) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#66c5dd'>[floor(charges)]</font></div>")

/datum/component/cultivator_energy
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// The mob we’re attached to is always parent.
	var/mob/living/attached_mob

	/// Current Energy
	var/energy = 0
	/// Max energy you can store
	var/max_energy = CULTIVATOR_ENERGY_MAX
	/// The UI itself
	var/atom/movable/screen/cultivator_energy/cultivator_ui

	/// Minimum Energy gained from the Aura mechanic
	var/aura_min = CULTIVATOR_MIN_CULTIVATION_BONUS
	/// Maximum Energy gained from the Aura mechanic
	var/aura_max = CULTIVATOR_MAX_CULTIVATION_BONUS

/datum/component/cultivator_energy/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = parent
	RegisterWithParent()
	START_PROCESSING(SSfastprocess, src)

/datum/component/cultivator_energy/RegisterWithParent()
	. = ..()
	if(attached_mob.hud_used)
		install_energy_hud(parent)
	else
		RegisterSignal(attached_mob, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))

/datum/component/cultivator_energy/UnregisterFromParent()
	. = ..()
	if(attached_mob) // prevents runtiming when adding/removing duplicate components
		UnregisterSignal(attached_mob, COMSIG_MOB_HUD_CREATED)

/datum/component/cultivator_energy/Destroy()
	UnregisterFromParent()
	STOP_PROCESSING(SSfastprocess, src)

	if(!attached_mob)
		return

	if(attached_mob.hud_used && cultivator_ui)
		attached_mob.hud_used.infodisplay -= cultivator_ui
		qdel(cultivator_ui)
		cultivator_ui = null

	attached_mob = null
	return ..()

// Processing is responsible for most of the aura farming / 'passive energy gain'.
/datum/component/cultivator_energy/process(seconds_per_tick)
	if(!attached_mob)
		return

	// Handles upkeep for alignment powers.
	for(var/datum/action/cooldown/power/cultivator/alignment/power in attached_mob.actions)
		if(power.active)
			adjust_energy(-(power.alignment_upkeep_cost * seconds_per_tick))
			if(energy <= 0) // disable if we're out of energy
				to_chat(attached_mob, span_boldwarning("You've ran out of Energy!"))
				power.disable_alignment(attached_mob)

	// Aura farming code below
	if(HAS_TRAIT(attached_mob, TRAIT_RESONANCE_SILENCED)) // no aura farming when silenced
		return
	// Just for the sake of future proofing, you can have multiple sources of aura farming.
	var/total = 0
	for(var/datum/action/cooldown/power/cultivator/power in attached_mob.actions)
		if(power.contributes_to_aura_farming && !power.active) // needs to have the contributing flag and not be active
			total += power.aura_farm()

	total = clamp(total, aura_min, aura_max)
	total *= seconds_per_tick // I love spess game time-based maths

	adjust_energy(total)

/// Waits for the HUD to load before installing the UI element
/datum/component/cultivator_energy/proc/on_hud_created(datum/source)
	SIGNAL_HANDLER

	var/mob/living/living_holder = attached_mob
	if(!living_holder || !living_holder.hud_used)
		return

	install_energy_hud(living_holder)

/// Places the energy HUD on the player's UI
/datum/component/cultivator_energy/proc/install_energy_hud(mob/living/living_holder)
	if(cultivator_ui) // already installed
		return

	var/datum/hud/hud_used = living_holder.hud_used
	cultivator_ui = new /atom/movable/screen/cultivator_energy(null, hud_used)
	hud_used.infodisplay += cultivator_ui

	// Set initial text so it isn't blank until first adjust.
	cultivator_ui.maptext = FORMAT_ENERGY_TEXT(energy)

	hud_used.show_hud(hud_used.hud_version)

/// Changes how much energy we have within the confines of our limits, unless overriden.
/datum/component/cultivator_energy/proc/adjust_energy(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : max_energy
	energy = clamp(energy + amount, 0, cap_to)

	cultivator_ui?.maptext = FORMAT_ENERGY_TEXT(energy)

// UI Elements for energy
/atom/movable/screen/cultivator_energy
	name = "energy"
	icon = 'icons/hud/blob.dmi' // TODO: Get sprites/UI for this.
	icon_state = "block"
	screen_loc = CULTIVATOR_UI_SCREEN_LOC
