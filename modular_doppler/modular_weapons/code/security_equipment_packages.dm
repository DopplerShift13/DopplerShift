/obj/item/signature_beacon/security_equipment_package
	name = "Port Safety Field Loadout Injector"
	desc = "The bleeding edge in JIT supply chains, this device minimizes equipment warehousing costs by ensuring that employee gear remains \
	offset until such time as the employee arrives for work."

	selection_base_type = /datum/signature_equipment/security_equipment_package

/datum/signature_equipment/security_equipment_package/gunnery_kit
	name = "Gunnery Kit"
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "avispa"
	spawned_item_type = /obj/item/storage/toolbox/guncase/modular/sportsco_large_case/security_gunnery_package

/datum/signature_equipment/security_equipment_package/cannoneer_kit
	name = "Cannoneer Kit"
	icon = 'icons/obj/weapons/cannons.dmi'
	icon_state = "falconet_patina"
	spawned_item_type = /obj/item/storage/toolbox/guncase/modular/sportsco_large_case/security_cannoneer_package/

/datum/signature_equipment/security_equipment_package/support_kit
	name = "Support Kit"
	icon = 'modular_doppler/modular_weapons/icons/obj/gunsets.dmi'
	icon_state = "security_support_package"
	spawned_item_type = /obj/item/storage/toolbox/guncase/modular/sportsco_large_case/security_support_package

/datum/signature_equipment/security_equipment_package/jitte_belt
	name = "Jitte Belt"
	icon_item_type = /obj/item/storage/belt/secsword/full
	spawned_item_type = /obj/item/storage/belt/secsword/full

/obj/item/storage/belt/security/webbing/full/PopulateContents()
	. = ..()
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/assembly/flash/handheld(src)

/obj/item/book/granter/tactical_gun_tosser
	name = "sketchy pamphlet from the shuttlestop bathroom"
	desc = "Not generally considered great literature, but honestly, there's some pretty good articles in here."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "pamphlet"
	remarks = list(
		"Gun fu, or the utilization of firearms in a martial art...",
		"Once unweighted of ammo, the pistol becomes a compact and lethal throwing weapon...",
		"Great care must be taken when practicing gun throws...",
		"Mig Bauer pistols are specifically not recommended for practice.",
		"Remember to detach the optic first.",
	)

/obj/item/book/granter/tactical_gun_tosser/Initialize()
	name = pick(list(
		"sketchy pamphlet from the shuttlestop bathroom",
		"Tac-Tech Weekly",
		"Bushido: The Warrior's Way for Today's Private Security",
		"The Discipliner",
		"Sun Tzu's The Art of War, Abridged",
	))
	. = ..()

/obj/item/book/granter/tactical_gun_tosser/on_reading_finished(mob/living/user)
	..()
	to_chat(user, span_notice("You can throw guns really well! That's something!"))
	user.add_traits(list(TRAIT_TOSS_GUN_HARD), INNATE_TRAIT)

//Begin Cannon Loadout Stuff

/obj/item/book/granter/tactical_cannoneer
	name = "sketchy pamphlet from a toy store"
	desc = "A guide to making the most of pneumatic cannons. Strange, you figured this would be about siege weapons."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "pamphlet"
	remarks = list(
		"Wealth, fame, power... How is this supposed to get you any of those?",
		"In the back is a glossary of useful terms like stress, sublimation, and scurvy...",
		"Steady hands, a firm stance...",
		"Shoot from the heart, not from the hip...",
		"Light the fuse and recite a prayer...",
		"What's a sea dog anyway?",
	)

/obj/item/book/granter/tactical_cannoneer/Initialize()
	name = pick(list(
		"A Seadog's Guide To Shootin'",
		"Salty Dan's Cannoneer Compendium",
		"Blastin' Boys 2: Boys on Pluto",
		"Crusoe's Cannons",
		"Pneumatic Pnowledge",
	))
	. = ..()

/obj/item/book/granter/tactical_cannoneer/on_reading_finished(mob/living/user)
	..()
	to_chat(user, span_notice("You're pretty sure you now know how to use a pneumatic cannon without knocking yourself flat, and how to speak like a pirate."))
	user.add_traits(list(TRAIT_CANNONEER), INNATE_TRAIT)
	user.grant_language(/datum/language/piratespeak)
