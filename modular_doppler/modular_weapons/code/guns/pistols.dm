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
