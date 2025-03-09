// Casing and projectile for the plasma thrower (yeah this is sorted out of order bog off!!)

/obj/item/ammo_casing/energy/laser/plasma_glob
	projectile_type = /obj/projectile/beam/laser/plasma_glob
	fire_sound = 'modular_doppler/paxilweapons_real/sound/laser_firing/incinerate.ogg'

/obj/item/ammo_casing/energy/laser/plasma_glob/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/beam/laser/plasma_glob
	name = "plasma globule"
	icon = 'modular_doppler/paxilweapons_real/icons/projectiles.dmi'
	icon_state = "plasma_glob"
	damage = 16
	speed = 1.5
	bare_wound_bonus = 55
	pass_flags = PASSTABLE | PASSGRILLE

// Plasma thrower 'magazine'

/obj/item/ammo_box/magazine/recharge/plasma_battery
	name = "plasma power pack"
	desc = "A rechargeable, detachable battery that serves as a power source for plasma projectors."
	icon = 'modular_doppler/paxilweapons_real/icons/magazines_and_boxes.dmi'
	base_icon_state = "plasma_battery"
	icon_state = "plasma_battery"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/energy/laser/plasma_glob
	caliber = CALIBER_LASER
	max_ammo = 20

/obj/item/ammo_box/magazine/recharge/plasma_battery/update_icon_state() // FUCK YOU /OBJ/ITEM/AMMO_BOX/MAGAZINE/RECHARGE
	. = ..()
	icon_state = base_icon_state
