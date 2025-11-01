// new dopplerian cargo suits

/obj/item/clothing/suit/jacket/cargo_coat
	name = "warehouse coat"
	desc = "A rugged wrap coat in synthetic nylon fabric, closed with clasp and belt."
	icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_obj.dmi'
	icon_state = "cargo_coat"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_mob.dmi'
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/boxcutter,
		/obj/item/dest_tagger,
		/obj/item/stamp,
		/obj/item/storage/bag/mail,
		/obj/item/universal_scanner,
	)

/obj/item/clothing/suit/jacket/cargo_coat/fancy
	name = "dress coat"
	desc = "Shimmerweave sharkskin - the fabric, not the hide - fabricated into a drop shoulder raglan number."
	icon_state = "cargo_fancy_jacket"

/obj/item/clothing/suit/jacket/cargo_coat/high_vis
	name = "high-vis jacket"
	desc = "This thigh length nylon shell comes with retroreflective panels. Hopefully the tug pilot spots them before \
	you're pasted on the cargo pad."
	icon_state = "cargo_highvis"

/obj/item/clothing/suit/jacket/cargo_coat/chore
	name = "chore coat"
	desc = "A brown jacket made of a synthetic fiber in a tightly woven duck fabric."
	icon_state = "cargo_chore_coat"

/obj/item/clothing/suit/jacket/cargo_coat/cargo_shearling
	name = "shearling coat"
	desc = "A hide coat with soft wool turned towards the neckline. The tag inside is frighteningly nonspecific about \
	the animal this hide came from."
	icon_state = "cargo_shearling"
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

/obj/item/clothing/suit/jacket/cargo_coat/cargo_greatcoat
	name = "greatcoat"
	desc = "A shin-skimming shearling coat with pockets sizeable enough to carry your drink, your book, and your gun."
	icon_state = "cargo_greatcoat"
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo
