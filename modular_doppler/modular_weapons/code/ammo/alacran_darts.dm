/*
*	bullets representing tamper-proof cartridge darts for security's special dart gun
*/

/obj/item/ammo_casing/alacran_dart
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	projectile_type = /obj/projectile/bullet/dart/alacran_dart
	var/reagent_amount = 15

/obj/item/ammo_casing/alacran_dart/Initialize(mapload)
	. = ..()
	create_reagents(reagent_amount, SEALED_CONTAINER)

/obj/projectile/bullet/dart/alacran_dart
	damage = null
