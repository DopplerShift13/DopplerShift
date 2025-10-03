/*
*	bullets representing tamper-proof cartridge darts for security's special dart gun
*/

/obj/item/ammo_casing/alacran_dart
	name = "\improper Puya syringe dart"	//mapuche word for pointy
	desc = "An unloaded syringe dart for use with the Alacran platform. These aren't \
	normally found outside the factory, so where has it come from?"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/ammo_casing/alacran_dart"
	post_init_icon_state = "alacran_dart"
	greyscale_config = /datum/greyscale_config/alacran_dart
	greyscale_colors = "#bb2222#bb2222"	//plume color, casing color
	caliber = CALIBER_ALACRAN
	projectile_type = /obj/projectile/bullet/dart/alacran_dart
	harmful = FALSE
	no_live_state = TRUE
	var/reagent_amount = 15

/obj/item/ammo_casing/alacran_dart/Initialize(mapload)
	. = ..()
	create_reagents(reagent_amount, SEALED_CONTAINER)

/obj/projectile/bullet/dart/alacran_dart
	speed = 1
	damage = null

/obj/projectile/bullet/dart/alacran_piercing_dart
	speed = 1
	damage = null

// many are essentialy a worse version of a similar deforest injector

/obj/item/ammo_casing/alacran_dart/adrenaline
	name = "\improper Puya adrenaline dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture to stimulate physical activity, \
	and a warning label stating no liability for complications that arise from use."
	greyscale_colors = "#af2747#3a373e"

/obj/item/ammo_casing/alacran_dart/adrenaline/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/determination, 5)
	reagents.add_reagent(/datum/reagent/medicine/inaprovaline, 3)
	reagents.add_reagent(/datum/reagent/medicine/synaptizine, 2)
	reagents.add_reagent(/datum/reagent/toxin/lipolicide, 5)

/obj/item/ammo_casing/alacran_dart/adrenaline/piercing
	name = "\improper Puya adrenaline dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/morpital
	name = "\improper Puya morpital regeneration dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of pain relief \
	and restorative stimulants."
	greyscale_colors = "#f0cf56#f0cf56"

/obj/item/ammo_casing/alacran_dart/morpital/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/mine_salve, 2)
	reagents.add_reagent(/datum/reagent/medicine/omnizine, 8)
	reagents.add_reagent(/datum/reagent/toxin/lipolicide, 5)

/obj/item/ammo_casing/alacran_dart/morpital/piercing
	name = "\improper Puya morpital regeneration dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/meridine
	name = "\improper Puya meridine antidote dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of reagents to serve as antidote \
	to most galactic toxins. A warning sticker notes it should not be used if the patient is physically damaged, \
	as it may cause complications."
	greyscale_colors = "#5e5b60#5e5b60"

/obj/item/ammo_casing/alacran_dart/meridine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/c2/multiver, 5)
	reagents.add_reagent(/datum/reagent/medicine/potass_iodide, 5)
	reagents.add_reagent(/datum/reagent/toxin/lipolicide, 5)

/obj/item/ammo_casing/alacran_dart/meridine/piercing
	name = "\improper Puya meridine antidote dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/krotozine
	name = "\improper Puya krotozine manipulative dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of stimulants and weak healing agents."
	greyscale_colors = "#905ea9#905ea9"

/obj/item/ammo_casing/alacran_dart/krotozine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/ondansetron, 3)
	reagents.add_reagent(/datum/reagent/drug/kronkaine, 4)
	reagents.add_reagent(/datum/reagent/medicine/omnizine/protozine, 3)
	reagents.add_reagent(/datum/reagent/drug/maint/tar, 5)

/obj/item/ammo_casing/alacran_dart/krotozine/piercing
	name = "\improper Puya krotozine manipulative dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/slurry
	name = "\improper Puya smart-slurry dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of liquid solder and rapid-repair nanite \
	salves for rapid field repair of synthetic agents."
	greyscale_colors = "#4d65b4#af2747"

/obj/item/ammo_casing/alacran_dart/slurry/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/nanite_slurry, 5)
	reagents.add_reagent(/datum/reagent/medicine/liquid_solder, 5)
	reagents.add_reagent(/datum/reagent/medicine/system_cleaner, 5)

/obj/item/ammo_casing/alacran_dart/slurry/piercing
	name = "\improper Puya smart-slurry dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/sensory_restoration
	name = "\improper Puya occuisate sensory restoration dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of healing chemicals for sensory organs \
	such as the eyes and ears."
	greyscale_colors = "#c5dbd4#4d9be6"

/obj/item/ammo_casing/alacran_dart/sensory_restoration/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/oculine, 5)
	reagents.add_reagent(/datum/reagent/medicine/inacusiate, 5)
	reagents.add_reagent(/datum/reagent/inverse/oculine, 2)
	reagents.add_reagent(/datum/reagent/toxin/lipolicide, 3)

/obj/item/ammo_casing/alacran_dart/sensory_restoration/piercing
	name = "\improper Puya occuisate sensory restoration dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

// some secret ones for the black market with mostly silly mixes in them

/obj/item/ammo_casing/alacran_dart/earthsblood
	name = "\improper third-party 'Earthsblood' dart"
	desc = "A third party imitation of Deforest-branded darts for the Alacran platform. This one contains a mix of experimental healing chemicals and exotic nootropics \
	and bears a disconcertingly nonspecific warning regarding side effects. Caveat injector."
	greyscale_colors = "#8987ff#4d9be6"

/obj/item/ammo_casing/alacran_dart/earthsblood/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/medicine/earthsblood, 6)
	reagents.add_reagent(/datum/reagent/toxin/lipolicide, 3)
	reagents.add_reagent(/datum/reagent/inverse/spaceacillin, 3)
	reagents.add_reagent(/datum/reagent/drug/maint/powder, 3)

/obj/item/ammo_casing/alacran_dart/earthsblood/piercing
	name = "\improper third-party 'Earthsblood' dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/equestrian_stimulants
	name = "\improper third-party 'Equestrian Stimulants' dart"
	desc = "A third party imitation of Deforest-branded darts for the Alacran platform. This one contains a mix of stimulants intended for, among other animals, race horses, \
	and bears a disconcertingly nonspecific warning regarding side effects. Caveat injector."
	greyscale_colors = "#f8f8f8#bc4646"

/obj/item/ammo_casing/alacran_dart/equestrian_stimulants/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/drug/maint/tar, 5)
	reagents.add_reagent(/datum/reagent/drug/kronkaine, 5)
	reagents.add_reagent(/datum/reagent/drug/pumpup, 5)

/obj/item/ammo_casing/alacran_dart/equestrian_stimulants/piercing
	name = "\improper third-party 'Equestrian Stimulants' dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart
