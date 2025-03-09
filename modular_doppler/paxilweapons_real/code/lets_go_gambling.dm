/obj/structure/mystery_box/gun_gambling
	name = "sealed arms crate"
	desc = "A mysterious crate wrapped in dull gold, rumored to be sealed for 10000 years. Who knows what you'll find within?"
	icon = 'modular_doppler/paxilweapons_real/icons/gambling.dmi'
	icon_state = "gambling"
	uses_left = 1
	pixel_y = 0
	grant_extra_mag = FALSE
	anchored = FALSE

/obj/structure/mystery_box/gun_gambling/generate_valid_types()
	valid_types = subtypesof(/obj/effect/spawner/gambling_guns)

/obj/structure/mystery_box/gun_gambling/handle_deconstruct(disassembled)
	return

// Cargo stuff

/datum/supply_pack/goody/thermal_single
	special = TRUE

/datum/supply_pack/security/armory/thermal
	special = TRUE

/datum/supply_pack/security/armory/gambling
	name = "Sealed Arms Crate Crate"
	desc = "We ship you a crate inside of a crate, and we don't tell you what's inside either of them! \
		What could it be? Who knows, maybe you want to find out?"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/structure/mystery_box/gun_gambling = 1,
	)
	crate_name = "crate crate"

// Mystery box stuff

/obj/structure/mystery_box/guns/generate_valid_types()
	. = ..()
	valid_types |= subtypesof(/obj/effect/spawner/gambling_guns)

/obj/structure/mystery_box/tdome/generate_valid_types()
	. = ..()
	valid_types |= subtypesof(/obj/effect/spawner/gambling_guns)
