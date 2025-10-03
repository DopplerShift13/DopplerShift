
/obj/item/storage/box/alacran_dart
	name = "box of Alacran darts"
	desc = "A box with a mixed array of standard, non-piercing dart rounds for the Alacran platform."
	icon_state = "secbox"

/obj/item/storage/box/alacran_dart/PopulateContents()
	. = ..()
	new /obj/item/ammo_casing/alacran_dart/adrenaline(src)
	new /obj/item/ammo_casing/alacran_dart/morpital(src)
	new /obj/item/ammo_casing/alacran_dart/meridine(src)
	new /obj/item/ammo_casing/alacran_dart/krotozine(src)
	new /obj/item/ammo_casing/alacran_dart/slurry(src)
	new /obj/item/ammo_casing/alacran_dart/sensory_restoration(src)

/obj/item/storage/box/alacran_dart/piercing
	name = "box of piercing Alacran darts"
	desc = "A box with a mixed array of armor piercing dart rounds for the Alacran platform."
	icon_state = "secbox"

/obj/item/storage/box/alacran_dart/piercing/PopulateContents()
	. = ..()
	new /obj/item/ammo_casing/alacran_dart/adrenaline/piercing(src)
	new /obj/item/ammo_casing/alacran_dart/morpital/piercing(src)
	new /obj/item/ammo_casing/alacran_dart/meridine/piercing(src)
	new /obj/item/ammo_casing/alacran_dart/krotozine/piercing(src)
	new /obj/item/ammo_casing/alacran_dart/slurry/piercing(src)
	new /obj/item/ammo_casing/alacran_dart/sensory_restoration/piercing(src)
