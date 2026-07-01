// .980 Tydhouer underbarrels for the Karim pulse rifle

/obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel/tydhouer
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/grenadelauncher/tydhouer

/obj/item/ammo_box/magazine/internal/grenadelauncher/tydhouer
	ammo_type = /obj/item/ammo_casing/c980grenade
	caliber = CALIBER_980TYDHOUER
	max_ammo = 1

// subtype for standard mining karims so they don't start loaded with an HEDP round
/obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel/tydhouer/safer
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/grenadelauncher/tydhouer/safer

/obj/item/ammo_box/magazine/internal/grenadelauncher/tydhouer/safer
	start_empty = TRUE

// .980 Tydhouer rotary grenade launcher for the PARC

/obj/item/gun/ballistic/revolver/rotary_gl
	name = "\improper XM90 Munin"
	desc = "A terrifyingly simple six-shot rotary grenade launcher with an integrated rangefinder and forward \
		grip to ensure ease of usage. Though it lacks the advanced features of magazine-fed launchers firing the \
		same .980 shells, the Munin's rangefinder retains the ability to set a timed fuse in each fired grenade."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "munin"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "munin"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	fire_sound = 'sound/items/weapons/gun/general/grenade_launch.ogg'
	inhand_icon_state = "munin"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti/munin
	var/target_range = 14
	var/maximum_target_range = 14

/obj/item/gun/ballistic/revolver/rotary_gl/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_PORT_AUTHORITY)

/obj/item/gun/ballistic/revolver/rotary_gl/examine(mob/user)
	. = ..()
	. += span_notice("<b>Right Click</b> anywhere to set a range at which the launcher's shells will automatically detonate.")

/obj/item/gun/ballistic/revolver/rotary_gl/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!interacting_with || !user)
		return ITEM_INTERACT_BLOCKING
	var/distance_ranged = get_dist(user, interacting_with)
	if(distance_ranged > maximum_target_range)
		user.balloon_alert(user, "out of range")
		return ITEM_INTERACT_BLOCKING
	target_range = distance_ranged
	user.balloon_alert(user, "range set: [target_range]")
	return ITEM_INTERACT_SUCCESS

/obj/item/ammo_box/magazine/internal/cylinder/grenademulti/munin
	ammo_type = /obj/item/ammo_casing/c980grenade
	caliber = CALIBER_980TYDHOUER
