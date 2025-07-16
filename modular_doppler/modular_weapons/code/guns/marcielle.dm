/obj/item/gun/ballistic/automatic/marcielle
	name = "\improper Marcielle 2490"
	desc = "Faline Saint-Marciele Modele 2490, a powerful rifle built with wood from grow ops on New Gibraltar itself."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "marcielle_mil"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "marcielle_mil"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "marcielle_mil"
	SET_BASE_PIXEL(-8, 0)
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/marcielle
	fire_sound = 'modular_doppler/modular_weapons/sounds/rifle_heavy.ogg'
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0.45 SECONDS
	actions_types = list()
	spread = 3
	recoil = 0.5

// Semi auto only version

/obj/item/gun/ballistic/automatic/marcielle/sport
	name = "\improper Marcielle 2490 sporte"
	desc = "Faline Saint-Marciele Modele 2490, a powerful rifle built with wood from grow ops on New Gibraltar itself. \
		This is a special sporting version, having slightly more accuracy and a scope."
	icon_state = "marcielle_sport"
	worn_icon_state = "marcielle_sport"
	inhand_icon_state = "marcielle_sport"
	spread = 0

/obj/item/gun/ballistic/automatic/marcielle/sport/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

// Magazines

/obj/item/ammo_box/magazine/marcielle
	name = "\improper Marcielle magazine (.34)"
	desc = "A short magazine for the Marcielle rifles, holds five rounds."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "marcielle_mag"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_TINY
	ammo_type = /obj/item/ammo_casing/c34nb
	caliber = CALIBER_34NB
	max_ammo = 5

/obj/item/ammo_box/magazine/marcielle/special
	name = "\improper Marcielle magazine (.34 Special)"
	ammo_type = /obj/item/ammo_casing/c34nb/special

/obj/item/ammo_box/magazine/marcielle/squash
	name = "\improper Marcielle magazine (.34 Squash)"
	ammo_type = /obj/item/ammo_casing/c34nb/rubber

/obj/item/ammo_box/magazine/marcielle/starts_empty
	start_empty = TRUE

// RND designs

/datum/design/c38_mag
	name = "Magazine (.34) (Lethal)"
	desc = "Designed for the Faline Saint-Marcielle rifles, holds regular lethal ammunition."
	build_path = /obj/item/ammo_box/magazine/marcielle

/datum/design/c38_iceblox_mag
	name = "Magazine (.34 Special) (Lethal/Very Lethal (Friendlies))"
	desc = "Designed for the Faline Saint-Marcielle rifles, holds high reflectivity match rounds."
	build_path = /obj/item/ammo_box/magazine/marcielle/special

/datum/design/c38_rubber_mag
	name = "Magazine (.34 Squash) (Less Lethal)"
	desc = "Designed for the Faline Saint-Marcielle rifles, holds less-lethal metal squash ammunition."
	build_path = /obj/item/ammo_box/magazine/marcielle/squash
