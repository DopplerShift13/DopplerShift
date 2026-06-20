/obj/item/clothing/under/rank/engineering/breach_skinsuit/pressuresuit
	name = "pressure-resistant bodysuit"
	desc = "A space-worthy bodysuit designed to fit snugly around the wearer's body, allowing them \
		to enter the vacuum of space without requiring a bulky, dedicated spacesuit. This version is \
		streamlined, both easier to move in than standard breach skinsuits and with extra built-in \
		protective padding."
	supported_bodyshapes = list(BODYSHAPE_HUMANOID)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	)
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "pressure_suit"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	slowdown = 0
	armor_type = /datum/armor/clothing_under/pressure_suit

/datum/armor/clothing_under/pressure_suit
	melee = 10
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 40
	wound = 10

/obj/item/clothing/shoes/combat/pressureboots
	name = "pressure-sealed combat boots"
	desc = "High-speed, low drag boots with a seal around the top that connects snugly to a pressure-resistant \
		bodysuit. Rubberized soles prevent slipping in dangerous environments."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "pressure_boots"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	clothing_traits = list(TRAIT_NO_SLIP_WATER)
	resistance_flags = FIRE_PROOF
	fastening_type = SHOES_STRAPS

/obj/item/clothing/gloves/combat/pressuregloves
	name = "pressure-sealed combat gloves"
	desc = "Dextrous combat gloves, both fireproof and electrically insulated. They feature a seal at the wrist \
		that connects to a pressure-resistant bodysuit."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "pressure_gloves"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	greyscale_colors = null
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/helmet/pressurehelmet
	name = "sealed combat helmet"
	desc = "An armored helmet with a UV-shielded visor, fully sealed against the dangers of space."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "pressure_helmet"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	clothing_flags = STOPSPRESSUREDAMAGE|THICKMATERIAL|SNUG_FIT|STACKABLE_HELMET_EXEMPT|HEADINTERNALS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	flags_cover = HEADCOVERSEYES| EADCOVERSMOUTH|PEPPERPROOF
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/response_team_armored

/datum/armor/response_team_armored
	melee = 50
	bullet = 40
	laser = 50
	energy = 50
	bomb = 50
	bio = 100
	fire = 100
	acid = 90
	wound = 10

/obj/item/clothing/suit/armor/vest/combatarmor
	name = "plated combat armor"
	desc = "An armored vest that fully covers the torso, with added shoulder guards and a lap protector. Though \
		not spaceproof in its own right, the extra insulation provided pairs effectively with the often-accompanying \
		pressure-resistant bodysuit, while spine reinforcements allow the wearer to resist shoves in close-quarters."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "combat_armor"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	resistance_flags = FIRE_PROOF
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)
	armor_type = /datum/armor/response_team_armored

/obj/item/storage/backpack/rucksack
	name = "rucksack"
	desc = "A larger variety of backpack with a carefully-weighted set of straps, so as to not disturb the wearer's movement \
		in spite of its remarkable size."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "rucksack"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	/// Duffel-type slightly extra back storage, without the cost of having to care about the zipper
	storage_type = /datum/storage/duffel
