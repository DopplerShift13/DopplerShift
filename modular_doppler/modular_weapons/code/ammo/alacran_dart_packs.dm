
/obj/item/storage/box/alacran_dart
	name = "box of Alacran darts"
	desc = "A box with a mixed array of standard, non-piercing dart rounds for the Alacran platform."
	icon_state = "secbox"
	custom_price = PAYCHECK_COMMAND * 5.5

/obj/item/storage/box/alacran_dart/PopulateContents()
	. = ..()
	var/static/list/items_inside = list(
		/obj/item/ammo_casing/alacran_dart/krotozine = 3,
		/obj/item/ammo_casing/alacran_dart/adrenaline = 3,
		/obj/item/ammo_casing/alacran_dart/rootbeer = 1,
		/obj/item/ammo_casing/alacran_dart/beepsky_smash = 1,
	)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/alacran_dart/piercing
	name = "box of piercing Alacran darts"
	desc = "A box with a mixed array of armor piercing dart rounds for the Alacran platform."
	custom_price = PAYCHECK_COMMAND * 5.5

/obj/item/storage/box/alacran_dart/piercing/PopulateContents()
	. = ..()
	var/static/list/items_inside = list(
		/obj/item/ammo_casing/alacran_dart/krotozine/piercing = 3,
		/obj/item/ammo_casing/alacran_dart/adrenaline/piercing = 3,
	)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/alacran_dart/secret_admin_funpack	// this one has all the healing and some gimmick darts, so admins can easily spawn them for ERTs
	name = "box of SPEC-OPS Alacran darts"
	desc = "A very special box of dart rounds held exclusively for the very most specialist of operators."

/obj/item/storage/box/alacran_dart/secret_admin_funpack/PopulateContents()
	. = ..()
	var/static/list/items_inside = list(
		/obj/item/ammo_casing/alacran_dart/morpital = 1,
		/obj/item/ammo_casing/alacran_dart/meridine = 1,
		/obj/item/ammo_casing/alacran_dart/slurry = 1,
		/obj/item/ammo_casing/alacran_dart/sensory_restoration = 1,
		/obj/item/ammo_casing/alacran_dart/quadruple_sec = 1,
		/obj/item/ammo_casing/alacran_dart/quadruple_sec = 1,
	)
	generate_items_inside(items_inside, src)
