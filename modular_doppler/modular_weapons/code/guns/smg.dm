/obj/item/gun/ballistic/automatic/wt550
	name = "\improper Sindaryo PDW"
	desc = "The high tech PDW that no man wishes to be the maintainer of, lest they be cursed to \
		ill fated attempts to fix the laser ammo display when it inevitably breaks."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "sindaryo"

/obj/item/gun/ballistic/automatic/wt550/add_bayonet_point()
	return

// Magazines

/obj/item/ammo_box/magazine/wt550m9
	name = "\improper Sindaryo magazine (6mm)"
	desc = "A magazine specifically for use with the Sindaryo PDW."
	icon = 'modular_doppler/modular_weapons/icons/obj/casings.dmi'
	icon_state = "sindaryo_mag"
	base_icon_state = "sindaryo_mag"
	ammo_band_icon = null
	ammo_band_color = null
	ammo_type = /obj/item/ammo_casing/c6ng
	caliber = CALIBER_6MMGIBRALTAR
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	max_ammo = 14

/obj/item/ammo_box/magazine/wt550m9/wtap
	name = "\improper Sindaryo magazine (6mm Ultrasport)"
	icon_state = "sindaryo_mag"
	base_icon_state = "sindaryo_mag"
	MAGAZINE_TYPE_ARMORPIERCE
	ammo_type = /obj/item/ammo_casing/c6ng/match

/obj/item/ammo_box/magazine/wt550m9/wtic
	name = "\improper Sindaryo magazine (6mm Rubber)"
	icon_state = "sindaryo_mag"
	base_icon_state = "sindaryo_mag"
	MAGAZINE_TYPE_INCENDIARY
	ammo_type = /obj/item/ammo_casing/c6ng/rubber

// RND designs

/datum/design/mag_autorifle
	name = "Sindaryo Magazine (6mm) (Lethal)"
	desc = "A 14 round magazine for the Sindaryo PDW."
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

/datum/design/mag_autorifle/ap_mag
	name = "Sindaryo Ultrasport Magazine (6mm Ultrasport) (Lethal)"
	desc = "A 14 round match grade magazine for the Sindaryo PDW."
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 6)

/datum/design/mag_autorifle/ic_mag
	name = "Sindaryo Rubber Magazine (4.6x30mm Rubber) (Less Lethal)"
	desc = "A 14 round rubber magazine for the Sindaryo PDW."
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
