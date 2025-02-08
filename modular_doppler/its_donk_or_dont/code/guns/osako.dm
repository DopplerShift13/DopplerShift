/obj/item/gun/ballistic/rifle/osako
	name = "\improper Osako Bolt Blaster"
	desc = "A bolt-worked Donk(tm) blaster."
	icon = 'modular_doppler/its_donk_or_dont/icons/rifle_48.dmi'
	icon_state = "osako"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "osako"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "osako"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	rack_sound = 'modular_doppler/its_donk_or_dont/sound/osako/chokyu_boltout.wav'
	bolt_drop_sound = 'modular_doppler/its_donk_or_dont/sound/osako/chokyu_boltin.wav'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/donk
	internal_magazine = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	can_suppress = FALSE
	can_unsuppress = FALSE
	projectile_damage_multiplier = 2
	projectile_speed_multiplier = 2

/obj/item/gun/ballistic/rifle/osako/add_bayonet_point()
	return

/obj/item/gun/ballistic/rifle/osako/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/rifle/osako/scoped
	desc = "A bolt-worked Donk(tm) blaster firing the new Donk(tm) super dart. This one has a scope on it."
	icon_state = "osako_scoped"

/obj/item/gun/ballistic/rifle/osako/scoped/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)
