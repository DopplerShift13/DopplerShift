// .35 Sol pistol

/obj/item/gun/ballistic/automatic/pistol/sol
	name = "\improper Mavu Pistol"
	desc = "The standard issue service pistol of SolFed's various military branches. Uses .35 Sol and comes with an attached light."
	icon = 'modular_doppler/paxilweapons_real/icons/pistol_32.dmi'
	icon_state = "mavu"
	fire_sound = 'modular_doppler/paxilweapons_real/sound/pistol/pistol_light.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	special_mags = TRUE
	suppressor_x_offset = 5
	suppressor_y_offset = 0
	fire_delay = 0.3 SECONDS
	recoil = 0.25
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'

/obj/item/gun/ballistic/automatic/pistol/sol/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_TRAPPISTE)

/obj/item/gun/ballistic/automatic/pistol/sol/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
		)

/obj/item/gun/ballistic/automatic/pistol/sol/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/pistol/sol/examine_more(mob/user)
	. = ..()
	. += "The Mavu is a pistol that was made entirely for military use. \
		Required to use a standard round, standard magazines, and be able \
		to function in all of the environments that SolFed operated in \
		commonly. These qualities just so happened to make the weapon \
		popular in frontier space and is likely why you are looking at \
		one now."
	return .

/obj/item/gun/ballistic/automatic/pistol/sol/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/sol/evil
	desc = "The standard issue service pistol of SolFed's various military branches. Comes with attached light. This one is painted tacticool black."
	icon_state = "mavu_evil"

/obj/item/gun/ballistic/automatic/pistol/sol/evil/no_mag
	spawnwithmagazine = FALSE
