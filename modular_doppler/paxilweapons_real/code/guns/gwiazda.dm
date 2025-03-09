// Plasma sharpshooter pistol
// Shoots single, strong plasma blasts at a slow rate

/obj/item/gun/ballistic/automatic/pistol/plasma_marksman
	name = "\improper Gwiazda Plasma Sharpshooter"
	desc = "An outdated sidearm rarely seen in use by some members of the CIN. \
		Uses plasma power packs. \
		Fires relatively accurate globs of searing plasma."
	icon = 'modular_doppler/paxilweapons_real/icons/pistol_32.dmi'
	icon_state = "gwiazda"
	fire_sound = 'modular_doppler/paxilweapons_real/sound/laser_firing/burn.ogg'
	fire_sound_volume = 40 // This thing is comically loud otherwise
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/recharge/plasma_battery
	can_suppress = FALSE
	show_bolt_icon = FALSE
	casing_ejector = FALSE
	empty_indicator = FALSE
	bolt_type = BOLT_TYPE_OPEN
	fire_delay = 0.6 SECONDS
	spread = 2.5
	recoil = 0.25
	projectile_damage_multiplier = 2 //30 damage a shot
	projectile_wound_bonus = 10 // +55 of the base projectile, burn baby burn
	projectile_speed_multiplier = 2
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'

/obj/item/gun/ballistic/automatic/pistol/plasma_marksman/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SZOT)

/obj/item/gun/ballistic/automatic/pistol/plasma_marksman/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/pistol/plasma_marksman/examine_more(mob/user)
	. = ..()
	. += "The 'Gwiazda' is a further refinement of the 'Słońce' design. with improved \
		energy cycling, magnetic launchers built to higher precision, and an overall more \
		ergonomic design. While it still fails to perform against armor, the weapon is \
		significantly more accurate and higher power, at expense of a much lower firerate. \
		Opinions on this weapon within military service were highly mixed, with many preferring \
		the sheer stopping power a spray of plasma could produce, with others loving the new ability \
		to hit something in front of you for once."
	return .
