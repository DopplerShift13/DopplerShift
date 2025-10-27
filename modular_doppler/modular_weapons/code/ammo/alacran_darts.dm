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
	base_icon_state = "alacran_dart"
	greyscale_config = /datum/greyscale_config/alacran_dart
	greyscale_colors = "#bb2222#bb2222"	//plume color, casing color
	caliber = CALIBER_ALACRAN
	projectile_type = /obj/projectile/bullet/dart/alacran_dart
	harmful = FALSE
	custom_price = PAYCHECK_COMMAND
	/// A list of the reagents in our payload
	var/list/dart_reagents

/obj/item/ammo_casing/alacran_dart/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)
	if(dart_reagents)
		var/reagent_volume = counterlist_sum(dart_reagents)
		create_reagents(reagent_volume, SEALED_CONTAINER)
		reagents.add_reagent_list(dart_reagents)

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
	dart_reagents = list(
		/datum/reagent/determination = 5,
		/datum/reagent/medicine/inaprovaline = 3,
		/datum/reagent/medicine/synaptizine = 2,
		/datum/reagent/toxin/lipolicide = 5
	)

/obj/item/ammo_casing/alacran_dart/adrenaline/piercing
	name = "\improper Puya adrenaline dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart
	custom_price = PAYCHECK_COMMAND * 1.2

/obj/item/ammo_casing/alacran_dart/krotozine
	name = "\improper Puya krotozine manipulative dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of stimulants and weak healing agents."
	greyscale_colors = "#905ea9#905ea9"
	custom_price = PAYCHECK_COMMAND * 2
	dart_reagents = list(
		/datum/reagent/medicine/ondansetron = 3,
		/datum/reagent/drug/kronkaine = 5,
		/datum/reagent/medicine/omnizine/protozine = 2,
		/datum/reagent/drug/maint/tar = 5,
	)

/obj/item/ammo_casing/alacran_dart/krotozine/piercing
	name = "\improper Puya krotozine manipulative dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart
	custom_price = PAYCHECK_COMMAND * 2.4

/obj/item/ammo_casing/alacran_dart/rootbeer	// no piercing version on purpose
	name = "\improper Puya 'sharpshooter' dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of stimulants and nootropics purported to assist in firearms use."
	custom_price = PAYCHECK_COMMAND * 1.1
	greyscale_colors = "#663300#663300"
	dart_reagents = list(
		/datum/reagent/consumable/rootbeer = 13,
		/datum/reagent/toxin/lipolicide = 2,
	)

/obj/item/ammo_casing/alacran_dart/beepsky_smash
	name = "\improper Puya 'electric wizard' experimental tranquilizer dart"
	desc = "A proprietary dart for the Alacran platform. This one contains an experimental sedative for use in apprehending suspected criminals. All rights reserved. \
	Not recommended for use on assailants with pre-existing heart conditions."
	custom_price = PAYCHECK_COMMAND * 1.1
	greyscale_colors = "#800000#808080"
	dart_reagents = list(
		/datum/reagent/consumable/ethanol/beepsky_smash = 10,
		/datum/reagent/consumable/gakster_energy = 5,
	)

// some secret ones for the black market with mostly silly mixes in them

/obj/item/ammo_casing/alacran_dart/earthsblood
	name = "third-party 'Earthsblood' dart"
	desc = "A third party imitation of Deforest-branded darts for the Alacran platform. This one contains a mix of experimental healing chemicals and exotic nootropics \
	and bears a disconcertingly nonspecific warning regarding side effects. Caveat injector."
	greyscale_colors = "#8987ff#4d9be6"
	custom_price = PAYCHECK_COMMAND * 0.9
	dart_reagents = list(
		/datum/reagent/medicine/earthsblood = 6,
		/datum/reagent/toxin/lipolicide = 3,
		/datum/reagent/inverse/spaceacillin = 3,
		/datum/reagent/drug/maint/powder = 3,
	)

/obj/item/ammo_casing/alacran_dart/earthsblood/piercing
	name = "third-party 'Earthsblood' dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/equestrian_stimulants	// more potent kroto, expensive and harder to get
	name = "third-party 'Equestrian Stimulants' dart"
	desc = "A third party imitation of Deforest-branded darts for the Alacran platform. This one contains a mix of stimulants intended for, among other animals, race horses, \
	and bears a disconcertingly nonspecific warning regarding side effects. Caveat injector."
	greyscale_colors = "#f8f8f8#bc4646"
	dart_reagents = list(
		/datum/reagent/drug/maint/tar = 5,
		/datum/reagent/drug/kronkaine = 5,
		/datum/reagent/drug/pumpup = 5,
	)

/obj/item/ammo_casing/alacran_dart/equestrian_stimulants/piercing
	name = "third-party 'Equestrian Stimulants' dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

// a couple were axed from the main line up for potentially stepping on medical's gameplay if given to security, but are retained here
// because they can have a second life for ERT loadouts, antags, etc.

/obj/item/ammo_casing/alacran_dart/morpital
	name = "\improper Puya morpital regeneration dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of pain relief \
	and restorative stimulants."
	greyscale_colors = "#f0cf56#f0cf56"
	dart_reagents = list(
		/datum/reagent/medicine/mine_salve = 2,
		/datum/reagent/medicine/omnizine = 8,
		/datum/reagent/toxin/lipolicide = 5,
	)

/obj/item/ammo_casing/alacran_dart/morpital/piercing
	name = "\improper Puya morpital regeneration dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart
	custom_price = PAYCHECK_COMMAND * 1.2

/obj/item/ammo_casing/alacran_dart/meridine
	name = "\improper Puya meridine antidote dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of reagents to serve as antidote \
	to most galactic toxins. A warning sticker notes it should not be used if the patient is physically damaged, \
	as it may cause complications."
	greyscale_colors = "#5e5b60#5e5b60"
	dart_reagents = list(
		/datum/reagent/medicine/c2/multiver = 5,
		/datum/reagent/medicine/potass_iodide = 5,
		/datum/reagent/toxin/lipolicide = 5,
	)

/obj/item/ammo_casing/alacran_dart/meridine/piercing
	name = "\improper Puya meridine antidote dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart

/obj/item/ammo_casing/alacran_dart/slurry
	name = "\improper Puya smart-slurry dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of liquid solder and rapid-repair nanite \
	salves for rapid field repair of synthetic agents."
	greyscale_colors = "#4d65b4#af2747"
	dart_reagents = list(
		/datum/reagent/medicine/nanite_slurry = 5,
		/datum/reagent/medicine/liquid_solder = 5,
		/datum/reagent/medicine/system_cleaner = 5,
	)

/obj/item/ammo_casing/alacran_dart/slurry/piercing
	name = "\improper Puya smart-slurry dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart
	custom_price = PAYCHECK_COMMAND * 1.2

/obj/item/ammo_casing/alacran_dart/sensory_restoration
	name = "\improper Puya occuisate sensory restoration dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of healing chemicals for sensory organs \
	such as the eyes and ears."
	greyscale_colors = "#c5dbd4#4d9be6"
	dart_reagents = list(
		/datum/reagent/medicine/oculine = 5,
		/datum/reagent/medicine/inacusiate = 5,
		/datum/reagent/inverse/oculine = 2,
		/datum/reagent/toxin/lipolicide = 3,
	)

/obj/item/ammo_casing/alacran_dart/sensory_restoration/piercing
	name = "\improper Puya occuisate sensory restoration dart - armor piercing"
	projectile_type = /obj/projectile/bullet/dart/alacran_piercing_dart
	custom_price = PAYCHECK_COMMAND * 1.2

/obj/item/ammo_casing/alacran_dart/quadruple_sec
	name = "\improper Puya experimental salve dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of healing chemicals that target the specific physiology of \
	law enforcement and security guards."
	dart_reagents = list(
		/datum/reagent/consumable/ethanol/quadruple_sec = 7,
		/datum/reagent/toxin/lipolicide = 5,
		/datum/reagent/medicine/mine_salve = 3,
	)

/obj/item/ammo_casing/alacran_dart/quintuple_sec
	name = "\improper Puya HIGHLY experimental salve dart"
	desc = "A proprietary dart for the Alacran platform. This one contains a mixture of healing chemicals that target the specific physiology of \
	law enforcement and security guards. A skull is emblazoned on the casing, along with some sort of label that's too small to read."
	greyscale_colors = "#cc9900#800000"
	dart_reagents = list(
		/datum/reagent/consumable/ethanol/quintuple_sec = 7,
		/datum/reagent/drug/blastoff = 8,
	)
