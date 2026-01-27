/// Helper to format the text that gets thrown onto the piety hud element.
#define FORMAT_PIETY_TEXT(charges) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#ddd166'>[round(charges)]</font></div>")

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
	var/max_piety = 20

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
