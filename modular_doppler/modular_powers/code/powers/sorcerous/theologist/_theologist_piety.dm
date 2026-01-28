/// Helper to format the text that gets thrown onto the piety hud element.
#define FORMAT_PIETY_TEXT(charges) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#ddd166'>[round(charges)]</font></div>")

/datum/component/theologist_piety
	dupe_mode = COMPONENT_DUPE_UNIQUE

	// The mob we’re attached to is always `parent`.
	var/mob/living/attached_mob

	// Whatever state your old attached_theologist_piety tracked:
	var/piety = 0
	var/max_piety = PIETY_MAX

	// The UI itself
	var/atom/movable/screen/theologist_piety/theologist_ui

/datum/component/theologist_piety/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = parent


	// If your old system used signals, register them here.
	RegisterWithParent()

	// If your old system processed over time, start that here.
	// START_PROCESSING(SSprocessing, src) // only if you actually need processing

/datum/component/theologist_piety/RegisterWithParent()
	. = ..()
	if(attached_mob.hud_used)
		install_piety_hud(parent)
	else
		RegisterSignal(attached_mob, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))
	// Examples (swap for your real signals):
	// RegisterSignal(attached_mob, COMSIG_MOB_LIFE, PROC_REF(on_life))
	// RegisterSignal(attached_mob, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/theologist_piety/UnregisterFromParent()
	// UnregisterSignal(attached_mob, list(COMSIG_..., COMSIG_...))
	. = ..()
	UnregisterSignal(attached_mob, COMSIG_MOB_HUD_CREATED)

/datum/component/theologist_piety/Destroy()
	UnregisterFromParent()

	if(!attached_mob)
		return

	if(attached_mob.hud_used && theologist_ui)
		attached_mob.hud_used.infodisplay -= theologist_ui
		qdel(theologist_ui)
		theologist_ui = null

	attached_mob = null
	return ..()

/datum/component/theologist_piety/proc/on_hud_created(datum/source)
	SIGNAL_HANDLER

	var/mob/living/living_holder = attached_mob
	if(!living_holder || !living_holder.hud_used)
		return

	install_piety_hud(living_holder)

/datum/component/theologist_piety/proc/install_piety_hud(mob/living/living_holder)
	if(theologist_ui) // already installed
		return

	var/datum/hud/hud_used = living_holder.hud_used
	theologist_ui = new /atom/movable/screen/theologist_piety(null, hud_used)
	hud_used.infodisplay += theologist_ui

	// Set initial text so it isn't blank until first adjust.
	theologist_ui.maptext = FORMAT_PIETY_TEXT(piety)

	// THIS is the missing “why it only appears after changeling”
	hud_used.show_hud(hud_used.hud_version)

/datum/component/theologist_piety/proc/adjust_piety(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : max_piety
	piety = clamp(piety + amount, 0, cap_to)

	theologist_ui?.maptext = FORMAT_PIETY_TEXT(piety)

// UI Elements for Piety
/atom/movable/screen/theologist_piety
	name = "piety"
	icon = 'icons/hud/blob.dmi' // TODO: Get sprites/UI for this.
	icon_state = "block"
	screen_loc = "WEST,CENTER-2:15" // TODO: Define & Move this.

/*

/datum/power/theologist_piety
	name = "Piety"
	desc = "Responsible for managing Piety."
	abstract_parent_type = /datum/power
	value = 0

	mob_trait = TRAIT_ARCHETYPE_SORCEROUS
	archetype = POWER_ARCHETYPE_SORCEROUS
	path = POWER_PATH_THEOLOGIST
	priority = POWER_PRIORITY_ROOT

	// Used as a resource. We permit decimal numbers, but the UI will always show non-decimals.
	var/piety = 0

	//At what point do we cap out piety?
	var/max_piety = PIETY_MAX

	// The UI itself
	var/atom/movable/screen/theologist_piety/theologist_ui

/datum/power/theologist_piety/post_add()
	. = ..()

	if(!power_holder)
		return

	var/mob/living/living_holder = power_holder
	if(living_holder.hud_used)
		install_piety_hud(living_holder)
	else
		RegisterSignal(living_holder, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))

/datum/power/theologist_piety/remove()
	. = ..()

	if(!power_holder)
		return

	var/mob/living/living_holder = power_holder
	UnregisterSignal(living_holder, COMSIG_MOB_HUD_CREATED)

	if(living_holder.hud_used && theologist_ui)
		living_holder.hud_used.infodisplay -= theologist_ui
		qdel(theologist_ui)
		theologist_ui = null

/datum/power/theologist_piety/proc/on_hud_created(datum/source)
	SIGNAL_HANDLER

	var/mob/living/living_holder = power_holder
	if(!living_holder || !living_holder.hud_used)
		return

	install_piety_hud(living_holder)

/datum/power/theologist_piety/proc/install_piety_hud(mob/living/living_holder)
	if(theologist_ui) // already installed
		return

	var/datum/hud/hud_used = living_holder.hud_used
	theologist_ui = new /atom/movable/screen/theologist_piety(null, hud_used)
	hud_used.infodisplay += theologist_ui

	// Set initial text so it isn't blank until first adjust.
	theologist_ui.maptext = FORMAT_PIETY_TEXT(piety)

	// THIS is the missing “why it only appears after changeling”
	hud_used.show_hud(hud_used.hud_version)

// UI Elements for Piety
/atom/movable/screen/theologist_piety
	name = "piety"
	icon = 'icons/hud/blob.dmi' // TODO: Get sprites/UI for this.
	icon_state = "block"
	screen_loc = "WEST,CENTER-2:15" // TODO: Define & Move this.


/datum/power/theologist_piety/proc/adjust_piety(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : max_piety
	piety = clamp(piety + amount, 0, cap_to)

	theologist_ui?.maptext = FORMAT_PIETY_TEXT(piety)
*/
