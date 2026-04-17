/// Helper to format the text that gets thrown onto the piety hud element.
#define FORMAT_PIETY_TEXT(charges) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#ddd166'>[round(charges)]</font></div>")

/datum/component/theologist_piety
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// The mob we’re attached to is always `parent`.
	var/mob/living/attached_mob

	/// current piety
	var/piety = 0
	/// max piety
	var/max_piety = THEOLOGIST_PIETY_MAX

	/// The UI itself
	var/atom/movable/screen/theologist_piety/theologist_ui

/datum/component/theologist_piety/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = parent

	// Clearly the Chaplain is VERY pious.
	if(is_chaplain_job(attached_mob.mind?.assigned_role))
		max_piety *= 2

	RegisterWithParent()

/datum/component/theologist_piety/RegisterWithParent()
	. = ..()
	if(attached_mob.hud_used)
		install_piety_hud(parent)
	else
		RegisterSignal(attached_mob, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))

/datum/component/theologist_piety/UnregisterFromParent()
	// UnregisterSignal(attached_mob, list(COMSIG_..., COMSIG_...))
	. = ..()
	if(attached_mob) // prevents runtiming when adding/removing duplicate components
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

/// Signal handler when the base hud has finished initializing.
/datum/component/theologist_piety/proc/on_hud_created(datum/source)
	SIGNAL_HANDLER

	var/mob/living/living_holder = attached_mob
	if(!living_holder || !living_holder.hud_used)
		return

	install_piety_hud(living_holder)

/// Applies the piety hud to the mob's UI.
/datum/component/theologist_piety/proc/install_piety_hud(mob/living/living_holder)
	if(theologist_ui) // already installed
		return

	var/datum/hud/hud_used = living_holder.hud_used
	theologist_ui = new /atom/movable/screen/theologist_piety(null, hud_used)
	// If the cultivator energy UI is present, use the alternate screen loc to avoid overlap.
	if(living_holder.GetComponent(/datum/component/cultivator_energy))
		theologist_ui.screen_loc = THEOLOGIST_ALT_UI_SCREEN_LOC
	hud_used.infodisplay += theologist_ui

	// Set initial text so it isn't blank until first adjust.
	theologist_ui.maptext = FORMAT_PIETY_TEXT(piety)

	hud_used.show_hud(hud_used.hud_version)

/// Handler for adjusting piety.
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
	screen_loc = THEOLOGIST_UI_SCREEN_LOC
