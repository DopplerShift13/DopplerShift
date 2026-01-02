/// 1 tile down
#define UI_ENERGY_DISPLAY "WEST:0,CENTER-1:0"

///Maptext define for Hemophage HUDs
#define FORMAT_ANDROID_HUD_TEXT(valuecolor, value) MAPTEXT("<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='[valuecolor]'>[round((value/1000000), 0.01)]MJ</font></div>")

/atom/movable/screen/android
	icon = 'modular_doppler/modular_species/species_types/android/icons/android_hud.dmi'

/atom/movable/screen/android/energy
	name = "Energy Tracker"
	icon_state = "energy_display"
	screen_loc = UI_ENERGY_DISPLAY
	maptext_width = 48

	/// The threshold below which we're considered low on charge.
	var/low_charge_threshold = 0

/atom/movable/screen/android/energy/Initialize(mapload, datum/hud/hud_owner, low_charge_threshold)
	. = ..()
	src.low_charge_threshold = low_charge_threshold

/atom/movable/screen/android/energy/proc/update_energy_hud(current_energy)
	maptext = FORMAT_ANDROID_HUD_TEXT(hud_text_color(current_energy), current_energy)
	if(current_energy <= low_charge_threshold)
		icon_state = "energy_display_low"
	else
		icon_state = "energy_display"

/atom/movable/screen/android/energy/proc/hud_text_color(current_energy)
	return current_energy > low_charge_threshold ? "#ffffff" : "#b64b4b"

#undef UI_ENERGY_DISPLAY
#undef FORMAT_ANDROID_HUD_TEXT
