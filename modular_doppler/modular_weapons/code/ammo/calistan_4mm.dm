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
	light_power = 1.4
	light_color = LIGHT_COLOR_FAINT_BLUE
	light_on = FALSE

/obj/projectile/bullet/europan4mm/fire(fire_angle, atom/direct_target)
	. = ..()
	set_light(l_on = TRUE)

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
