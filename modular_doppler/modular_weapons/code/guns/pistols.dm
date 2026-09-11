// the kieran; a small semi-automatic handgun that takes sindaryo magazines
/obj/item/gun/ballistic/automatic/pistol/kieran
	name = "\improper Kieran pistol"
	desc = "A surprisingly modular handgun firing standard New Gibraltar 6mm rounds. This specific version \
		is an updated variant of the older Zomushi, rechambered in a modern caliber and instead fitted to \
		take Sindaryo magazines."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "kieran"
	rack_sound = 'modular_doppler/modular_weapons/sounds/pistol_rack.wav'
	fire_sound = 'modular_doppler/modular_weapons/sounds/pistol_light.wav'
	suppressed_sound = 'modular_doppler/modular_weapons/sounds/pistol_light_suppressed.wav'
	pickup_sound = 'modular_doppler/modular_weapons/sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/modular_weapons/sounds/drop_lightgun.wav'
	fire_sound_volume = 50
	bolt_wording = "slide"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/wt550m9
	can_suppress = TRUE
	suppressor_x_offset = 7
	suppressor_y_offset = 0
	fire_delay = 0.25 SECONDS
	recoil = 0.25

/obj/item/gun/ballistic/automatic/pistol/kieran/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/pistol/kieran/starts_empty
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/sneakybreeki = new(src)
	install_suppressor(sneakybreeki)

/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed/starts_empty
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/pistol/kieran/mindshield_pin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed/mindshield_pin
	pin = /obj/item/firing_pin/implant/mindshield

/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed/syndicate_pin
	pin = /obj/item/firing_pin/implant/pindicate

// syndicate pin desert eagle; because sometimes u gotta blow a dude's head smoove off
/obj/item/gun/ballistic/automatic/pistol/deagle/syndicate_pin
	pin = /obj/item/firing_pin/implant/pindicate

// the défenseur; a new gibraltar made service pistol partially designed for civilian and port safety usage.
/obj/item/gun/ballistic/automatic/pistol/defenseur
	name = "\improper Défenseur 2520"
	desc = "Défenseur Modele 2520, a handgun chambered in the regional New Gibraltar 6mm cartridge. It was \
		designed by a first-generation New Gibraltar gunsmith, and the first gun uniquely designed for the \
		planet. It also features a high-visiblity polymer frame."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "defenseur"
	rack_sound = 'modular_doppler/modular_weapons/sounds/pistol_rack.wav'
	fire_sound = 'modular_doppler/modular_weapons/sounds/pistol_light.wav'
	pickup_sound = 'modular_doppler/modular_weapons/sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/modular_weapons/sounds/drop_lightgun.wav'
	fire_sound_volume = 50
	bolt_wording = "slide"
	w_class = WEIGHT_CLASS_SMALL
	accepted_magazine_type = /obj/item/ammo_box/magazine/defenseur
	can_suppress = FALSE
	fire_delay = 0.25 SECONDS

/obj/item/gun/ballistic/automatic/pistol/defenseur/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_PORT_AUTHORITY)

/obj/item/gun/ballistic/automatic/pistol/defenseur/starts_empty
	spawnwithmagazine = FALSE

// defenseur magazines
/obj/item/ammo_box/magazine/defenseur
	name = "\improper Défenseur magazine (6mm)"
	desc = "A short magazine for the Défenseur handgun, holds eight rounds."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "defenseur_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/c6ng
	caliber = CALIBER_6MMGIBRALTAR
	max_ammo = 8

/obj/item/ammo_box/magazine/defenseur/match
	name = "\improper Défenseur magazine (6mm Ultrasport)"
	ammo_type = /obj/item/ammo_casing/c6ng/match

/obj/item/ammo_box/magazine/defenseur/rubber
	name = "\improper Défenseur magazine (6mm Rubber)"
	ammo_type = /obj/item/ammo_casing/c6ng/rubber

/obj/item/ammo_box/magazine/defenseur/starts_empty
	start_empty = TRUE

// R&D Designs
/datum/design/defenseur_mag
	name = "Magazine (6mm) (Lethal)"
	desc = "An 8 round magazine for the Défenseur 2520."
	build_path = /obj/item/ammo_box/magazine/defenseur

/datum/design/defenseur_mag_match
	name = "Magazine (6mm Ultrasport) (Lethal)"
	desc = "An 8 round matchgrade magazine for the Défenseur 2520."
	build_path = /obj/item/ammo_box/magazine/defenseur/match

/datum/design/defenseur_mag_rubber
	name = "Magazine (6mm Rubber) (Less Lethal)"
	desc = "An 8 round rubber magazine designed for the Défenseur 2520."
	build_path = /obj/item/ammo_box/magazine/defenseur/rubber
