/datum/power/theologist_root
	name = "Abstract Theologist Root"
	desc = "There's no 4th theologist root; this is just debug code. \
	Please report this!"
	abstract_parent_type = /datum/power/theologist_root

	// Used as a resource. We permit decimal numbers, but the UI will always show non-decimals.
	var/piety = 0

	// The UI itself
	var/atom/movable/screen/theologist_piety/theologist_ui

/datum/power/theologist_root/New()
	. = ..()
	//Grants the UI element for Piety
/*
// UI Elements for Piety
/atom/movable/screen/theologoist_resource
	name = "piety"
	icon = 'icons/hud/blob.dmi'
	icon_state = "corehealth"
	screen_loc = "EAST+0:23,NORTH-1:5" // We really need to use a define for this but currently I'm lazy

/atom/movable/screen/theologist_framework
	name = "piety framework"
	icon_state = "block"
	screen_loc = ui_health
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = ABOVE_HUD_PLANE

	var/piety_ui = new /atom/movable/screen/theologoist_resource
	infodisplay += piety_ui

*/
