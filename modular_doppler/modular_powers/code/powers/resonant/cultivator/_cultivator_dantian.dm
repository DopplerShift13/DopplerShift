/// Helper to format the text that gets thrown onto the dantian hud element.
#define FORMAT_DANTIAN_TEXT(charges) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#66c5dd'>[round(charges)]</font></div>")

/datum/component/cultivator_dantian
	dupe_mode = COMPONENT_DUPE_UNIQUE

	// The mob we’re attached to is always `parent`.
	var/mob/living/attached_mob

	// Whatever state your old attached_cultivator_dantian tracked:
	var/dantian = 0
	var/max_dantian = CULTIVATOR_DANTIAN_MAX

	// The UI itself
	var/atom/movable/screen/cultivator_dantian/cultivator_ui

/datum/component/cultivator_dantian/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = parent

	RegisterWithParent()

/datum/component/cultivator_dantian/RegisterWithParent()
	. = ..()
	if(attached_mob.hud_used)
		install_dantian_hud(parent)
	else
		RegisterSignal(attached_mob, COMSIG_MOB_HUD_CREATED, PROC_REF(on_hud_created))

/datum/component/cultivator_dantian/UnregisterFromParent()
	// UnregisterSignal(attached_mob, list(COMSIG_..., COMSIG_...))
	. = ..()
	if(attached_mob) // prevents runtiming when adding/removing duplicate components
		UnregisterSignal(attached_mob, COMSIG_MOB_HUD_CREATED)

/datum/component/cultivator_dantian/Destroy()
	UnregisterFromParent()

	if(!attached_mob)
		return

	if(attached_mob.hud_used && cultivator_ui)
		attached_mob.hud_used.infodisplay -= cultivator_ui
		qdel(cultivator_ui)
		cultivator_ui = null

	attached_mob = null
	return ..()

/datum/component/cultivator_dantian/proc/on_hud_created(datum/source)
	SIGNAL_HANDLER

	var/mob/living/living_holder = attached_mob
	if(!living_holder || !living_holder.hud_used)
		return

	install_dantian_hud(living_holder)

/datum/component/cultivator_dantian/proc/install_dantian_hud(mob/living/living_holder)
	if(cultivator_ui) // already installed
		return

	var/datum/hud/hud_used = living_holder.hud_used
	cultivator_ui = new /atom/movable/screen/cultivator_dantian(null, hud_used)
	hud_used.infodisplay += cultivator_ui

	// Set initial text so it isn't blank until first adjust.
	cultivator_ui.maptext = FORMAT_DANTIAN_TEXT(dantian)

	hud_used.show_hud(hud_used.hud_version)

/datum/component/cultivator_dantian/proc/adjust_dantian(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : max_dantian
	dantian = clamp(dantian + amount, 0, cap_to)

	cultivator_ui?.maptext = FORMAT_DANTIAN_TEXT(dantian)

// UI Elements for dantian
/atom/movable/screen/cultivator_dantian
	name = "dantian"
	icon = 'icons/hud/blob.dmi' // TODO: Get sprites/UI for this.
	icon_state = "block"
	screen_loc = CULTIVATOR_UI_SCREEN_LOC
