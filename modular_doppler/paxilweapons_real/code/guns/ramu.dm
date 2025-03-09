// Giant evil 6 gauge shotgun for blowing people to the nearest planet with

/obj/item/gun/ballistic/shotgun/ramu
	name = "\improper Ramu 6ga Shotgun"
	desc = "A six gauge, monster-sized shotgun with a capacity of four total shells, including one in the chamber."
	icon = 'modular_doppler/paxilweapons_real/icons/shotgun_48.dmi'
	icon_state = "ramu"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "ramu"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "ramu"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	SET_BASE_PIXEL(-8, 0)
	load_sound = 'modular_doppler/paxilweapons_real/sound/ramu/ramu_load.wav'
	fire_sound = 'modular_doppler/paxilweapons_real/sound/ramu/ramu.wav'
	rack_sound = 'modular_doppler/paxilweapons_real/sound/ramu/ramu_pump.wav'
	suppressed_sound = 'modular_doppler/paxilweapons_real/sound/ramu/ramu_silenced.wav'
	can_suppress = TRUE
	can_unsuppress = TRUE
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_heavygun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_heavygun.wav'
	suppressor_x_offset = 12
	can_be_sawn_off = FALSE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	recoil = 2
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/s6gauge

/obj/item/gun/ballistic/shotgun/ramu/add_bayonet_point()
	return

/obj/item/gun/ballistic/shotgun/ramu/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/shotgun/ramu/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/shotgun/ramu/examine_more(mob/user)
	. = ..()
	. += "The Ramu was the marsian solution to a uniquely marsian problem. \
		As most of the planet's residents are either heavily biomodded, or \
		heavily robomodded, police forces on the planet were finding difficulty \
		dealing with many of the criminals using conventional weapons. Rather than \
		make something reasonable, some chief of peacekeeping came up with the idea \
		to simply make the shotguns they were using for riot suppression bigger."
	return .

/obj/item/gun/ballistic/shotgun/ramu/starts_empty
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/s6gauge/starts_empty
