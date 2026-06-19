/obj/item/ammo_casing/europan4mm
	name = "4mm Callistan casing"
	desc = "A small caseless round for use in the Karim Electrics pulse rifle."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "4mm_europa"
	caliber = CALIBER_4MMEUROPAN
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/europan4mm
	projectile_type = /obj/projectile/bullet/europan4mm

/obj/item/ammo_casing/europan4mm/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/europan4mm/tcc
	name = "4mm Callistan TCC casing"
	desc = "A small military-grade caseless round for use in the Karim Electrics pulse rifle, with a tungsten-carbide core designed to defeat modern body armor."
	icon_state = "4mm_europa_tcc"
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/europan4mm/tcc
	projectile_type = /obj/projectile/bullet/europan4mm/tcc

/obj/item/ammo_casing/europan4mm/minebot
	name = "4mm Callistan passthrough casing"
	desc = "A small caseless round for use in the Karim Electrics pulse rifle. These bullets dodge around minebots."
	projectile_type = /obj/projectile/bullet/europan4mm/minebot

/obj/projectile/bullet/europan4mm
	name = "4mm bullet"
	icon_state = "shortbullet"
	icon = 'modular_doppler/modular_weapons/icons/projectiles.dmi'
	damage = 15
	speed = 2
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 0.5
	light_color = LIGHT_COLOR_FAINT_BLUE
	light_on = FALSE

/obj/projectile/bullet/europan4mm/fire(fire_angle, atom/direct_target)
	. = ..()
	set_light(l_on = TRUE)

/obj/projectile/bullet/europan4mm/tcc
	damage = 30
	armour_penetration = 40
	speed = 3

/obj/projectile/bullet/europan4mm/minebot
	speed = 1.5

/obj/projectile/bullet/europan4mm/minebot/prehit_pierce(atom/target)
	if(istype(target, /mob/living/basic/mining_drone))
		return PROJECTILE_PIERCE_PHASE
	return ..()

/obj/item/ammo_box/magazine/ammo_stack/europan4mm
	name = "4mm Callistan casings"
	desc = "A stack of 4mm Callistan cartridges."
	caliber = CALIBER_4MMEUROPAN
	ammo_type = /obj/item/ammo_casing/europan4mm
	max_ammo = 25
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/europan4mm/prefilled
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/europan4mm/tcc
	name = "4mm Callistan TCC casings"
	desc = "A stack of 4mm Callistan Tungsten-Carbide Core cartridges."
	ammo_type = /obj/item/ammo_casing/europan4mm/tcc

/obj/item/ammo_box/magazine/ammo_stack/europan4mm/tcc/prefilled
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/europan4mm/prefilled/minebot
	ammo_type = /obj/item/ammo_casing/europan4mm/minebot

// Magazine for the Karim rifle

/obj/item/ammo_box/magazine/karim
	name = "\improper Karim pulse rifle magazine"
	desc = "A standard size magazine for Karim pulse rifles, holds fifty rounds."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "karim_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/europan4mm
	caliber = CALIBER_4MMEUROPAN
	max_ammo = 50
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/magazine/karim/spawns_empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/karim/minebot
	name = "\improper Karim pulse rifle passthrough magazine"
	desc = "A standard size magazine for Karim pulse rifles, holds fifty rounds. These bullets dodge around minebots for less \
		friendly fire."
	icon_state = "karim_mag_minebot"
	ammo_type = /obj/item/ammo_casing/europan4mm/minebot

// Void Corps pulse rifle/heavy pulse rifle magazines with evil ammunition

/obj/item/ammo_box/magazine/karim/tcc
	name = "\improper Karim pulse rifle TCC magazine"
	desc = "A standard size magazine for Karim pulse rifles, holds fifty armor-piercing rounds."
	icon_state = "karim_mag_tcc"
	ammo_type = /obj/item/ammo_casing/europan4mm/tcc

/obj/item/ammo_box/magazine/karim/minhir
	name = "\improper Minhir heavy pulse rifle belt box"
	desc = "A high-capacity belt box for the Minhir heavy pulse rifle, holding a whopping three hundred armor-piercing rounds."
	icon_state = "minhir_box"
	max_ammo = 300
	w_class = WEIGHT_CLASS_NORMAL
