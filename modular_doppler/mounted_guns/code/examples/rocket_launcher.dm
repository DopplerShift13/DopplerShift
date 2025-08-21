/obj/item/gun/ballistic/rifle/recoilless_rifle
	name = "\improper heavy rocket launcher"
	desc = "A massive tube for the dispensing of rockets out the end of. How'd you get your hands on such a thing anyways?"
	icon = 'modular_doppler/mounted_guns/icons/examples/obj.dmi'
	icon_state = "rocket"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "rocket"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/items/weapons/gun/general/rocket_launch.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/recoilless_rifle
	internal_magazine = TRUE
	w_class = WEIGHT_CLASS_HUGE
	can_suppress = FALSE
	can_unsuppress = FALSE
	projectile_damage_multiplier = 1.5 // FUCK YOU BALTIMORE!
	recoil = 1

/obj/item/gun/ballistic/rifle/recoilless_rifle/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deployable_turret, 5 SECONDS, /obj/vehicle/ridden/mounted_turret, 'sound/items/tools/ratchet.ogg', 'modular_doppler/mounted_guns/icons/examples/turrets.dmi')

/obj/item/gun/ballistic/rifle/recoilless_rifle/one_ammo_debug
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/recoilless_rifle/one_ammo_max

/obj/item/gun/ballistic/rifle/crash/add_bayonet_point()
	return

/obj/item/ammo_box/magazine/internal/recoilless_rifle
	name = "recoilless rifle tube"
	desc = "GET SOME!!"
	ammo_type = /obj/item/ammo_casing/rocket
	caliber = CALIBER_84MM
	max_ammo = 0
	multiload = FALSE

/obj/item/ammo_box/magazine/internal/recoilless_rifle/one_ammo_max
	max_ammo = 1
