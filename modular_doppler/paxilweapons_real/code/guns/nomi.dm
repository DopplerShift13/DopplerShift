// Drum fed semi-automatic shotgun firing 12ga

/obj/item/gun/ballistic/automatic/nomi_shotgun
	name = "\improper Nomi repeating shotgun"
	desc = "A semi-automatic shotgun that fires 12ga out of a ten shell drum."
	icon = 'modular_doppler/paxilweapons_real/icons/shotgun_48.dmi'
	icon_state = "nomi"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "nomi"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "nomi"
	SET_BASE_PIXEL(-8, 0)
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/c12nomi
	load_sound = 'modular_doppler/paxilweapons_real/sound/nomi/nomi_magin.ogg'
	rack_sound = 'modular_doppler/paxilweapons_real/sound/nomi/nomi_rack.wav'
	fire_sound = 'modular_doppler/paxilweapons_real/sound/nomi/nomi.wav'
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	can_suppress = FALSE
	burst_size = 2
	fire_delay = 0.5 SECONDS
	projectile_wound_bonus = -20
	projectile_damage_multiplier = 0.75
	recoil = 0.5

/obj/item/gun/ballistic/automatic/nomi_shotgun/add_bayonet_point()
	return

/obj/item/gun/ballistic/automatic/nomi_shotgun/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/nomi_shotgun/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/nomi_shotgun/examine_more(mob/user)
	. = ..()
	. += "The Nomi was purpose made for Solfed police operations, who wanted not just a shotgun, \
		but a shotgun that could clear an entire room in as short a time as possible. \
		The solution was to simply make a rifle that fired shotgun shells, an elegant(?) solution \
		to a not-so-elegant problem."
	return .

/obj/item/gun/ballistic/automatic/nomi_shotgun/starts_empty
	spawnwithmagazine = FALSE
