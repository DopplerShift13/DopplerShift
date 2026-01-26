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

/datum/power/theologist_piety/New()
	. = ..()
	//Grants the UI element for Piety
	if(power_holder) // Prevents runtiming at init
		if(power_holder.hud_used)
			var/datum/hud/hud_used = power_holder.hud_used

			theologist_ui = new /atom/movable/screen/theologist_piety(null, hud_used)
			hud_used.infodisplay += theologist_ui

// UI Elements for Piety
/atom/movable/screen/theologist_piety
	name = "piety"
	icon = 'icons/hud/blob.dmi'
	icon_state = "corehealth"
	screen_loc = "WEST,CENTER-1:15" // TODO: Define & Move this.


/datum/power/theologist_piety/proc/adjust_piety(amount, override_cap)
	if(!isnum(amount))
		return
	var/cap_to = isnum(override_cap) ? override_cap : max_piety
	piety = clamp(piety + amount, 0, cap_to)

	theologist_ui?.maptext = FORMAT_PIETY_TEXT(piety)
