// base military rifle
/obj/item/gun/ballistic/automatic/mdni
	name = "\improper NM repeating rifle"
	desc = "NM standing for Nouvo Mond, for New World repeating rifle, the weapon has become the standard for local \
		defense forces and non-special infantry in any military that doesn't produce their own weapons. As repeating rifle \
		implies, the weapon is a self-reloading .25 Europan rifle with extremely basic furniture. Accepts any magazine \
		fitting the 'Atmospheric Corps Standard', or ACS."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "mdni"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "mdni"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "mdni"
	special_mags = TRUE
	SET_BASE_PIXEL(-8, 0)
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/mdni
	fire_sound = 'modular_doppler/modular_weapons/sounds/rifle_heavy.ogg'
	can_suppress = FALSE
	burst_size = 2
	fire_delay = 0.35 SECONDS
	spread = 7
	recoil = 0.25

/obj/item/gun/ballistic/automatic/mdni/Initialize(mapload)
	. = ..()
	add_autofire()

/obj/item/gun/ballistic/automatic/mdni/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 1, offset_y = 0, bayonet_overlay = "bayonet_thin", bayonet_overlay_icon = "modular_doppler/modular_weapons/icons/obj/guns48x.dmi")

/// Overridable proc for adding automatic fire to the gun, used for the range version of the gun
/obj/item/gun/ballistic/automatic/mdni/proc/add_autofire()
	return

/obj/item/gun/ballistic/automatic/mdni/starts_empty
	spawnwithmagazine = FALSE

// precision range version
/obj/item/gun/ballistic/automatic/mdni/range
	name = "\improper NMR range rifle"
	desc = "NMR standing for Nouvo Mond Repeating rifle, the weapon has become the standard for local \
		defense forces and non-special infantry in any military that doesn't produce their own weapons. \
		This variant of the rifle has been granted a longer barrel and a short scope for longer range fire. \
		Accepts any magazine fitting the 'Atmospheric Corps Standard', or ACS."
	icon_state = "mdni_range"
	worn_icon_state = "mdni_range"
	inhand_icon_state = "mdni_range"
	burst_size = 1
	actions_types = list()
	fire_delay = 0.45 SECONDS
	spread = 3
	recoil = 0.10

/obj/item/gun/ballistic/automatic/mdni/range/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 1.5)

/obj/item/gun/ballistic/automatic/mdni/range/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 4, offset_y = 0, bayonet_overlay = "bayonet_thin", bayonet_overlay_icon = "modular_doppler/modular_weapons/icons/obj/guns48x.dmi")

/obj/item/gun/ballistic/automatic/mdni/range/starts_empty
	spawnwithmagazine = FALSE

// smg super blaster
/obj/item/gun/ballistic/automatic/mdni/cqc
	name = "\improper NMR boarding rifle"
	desc = "NMR standing for Nouvo Mond Repeating rifle, the weapon has become the standard for local \
		defense forces and non-special infantry in any military that doesn't produce their own weapons. \
		This variant of the rifle has a significantly shorter barrel and overpowered gas system for faster cycling, at expense of control of the weapon. \
		Accepts any magazine fitting the 'Atmospheric Corps Standard', or ACS."
	icon_state = "mdni_cqc"
	worn_icon_state = "mdni_cqc"
	inhand_icon_state = "mdni_cqc"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	slot_flags = ITEM_SLOT_BACK
	spawn_magazine_type = /obj/item/ammo_box/magazine/mdni/drum
	burst_size = 1
	fire_delay = 0.25 SECONDS
	actions_types = list()
	spread = 12
	recoil = 0.5
	projectile_damage_multiplier = 0.8
	projectile_wound_bonus = -10

/obj/item/gun/ballistic/automatic/mdni/cqc/add_bayonet_point()
	AddComponent(/datum/component/bayonet_attachable, offset_x = 1, offset_y = 0, bayonet_overlay = "bayonet_thin", bayonet_overlay_icon = "modular_doppler/modular_weapons/icons/obj/guns48x.dmi")

/obj/item/gun/ballistic/automatic/mdni/cqc/starts_empty
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/mdni/cqc/add_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)
