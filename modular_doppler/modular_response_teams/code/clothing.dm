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

// Slimmer combat uniforms that look better with a deactivated/mid-activation MOD because the pants don't have giant baggy pockets
/obj/item/clothing/under/syndicate/combat/eva
	name = "exoatmospheric combat uniform"
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "exo_combat"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/clothing/under/syndicate/combat/shocktrooper
	name = "shocktrooper combat uniform"
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "shocktrooper_combat"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

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
	desc = "An armored helmet with a UV-shielded visor, fully sealed against the dangers of space. Features an \
		advanced visor system that can swap between HUD types."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "pressure_helmet"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	clothing_flags = STOPSPRESSUREDAMAGE|THICKMATERIAL|SNUG_FIT|STACKABLE_HELMET_EXEMPT|HEADINTERNALS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/response_team_armored

/// The work vest inherits the specular emissive type from its hazard vest parent, which magnifies light received
/// This helmet, however, is meant to glow in the dark properly
/obj/item/clothing/head/helmet/pressurehelmet/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_BLOOM)

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

/obj/item/clothing/head/helmet/alt/heavy_ballistic
	name = "low-cut ballistic helmet"
	desc = "An up-armored low-cut helmet that more effectively covers the sides of the user's head than most contemporary \
		helmets. The standard-issue visor has been taken out to replace its fixtures within the helmet with yet more armor."
	icon_state = "helmet-novisor"
	armor_type = /datum/armor/armor_heavy

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

/obj/item/clothing/suit/armor/heavy_ballistic
	name = "heavy armor suit"
	desc = "A modified Type III ballistic vest with improved protection and a number of aftermarket upgrades to ensure it \
		protects every bit of the wearer's body, save for their head. Though useful and remarkably effective at allowing \
		a wearer to shrug off small-arms fire, systems like these are ludicrously heavy, and far worse at protecting against \
		laser or energy-based threats."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "heavy_battle_armor"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	w_class = WEIGHT_CLASS_HUGE
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	strip_delay = 12 SECONDS
	slowdown = 0.7
	armor_type = /datum/armor/armor_heavy

/obj/item/clothing/suit/hazardvest/parc
	name = "PA-RC work vest"
	desc = "A high-visibility vest designed to help crew identify members of the Port Authority Response Corps."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "workvest"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/storage/backpack/rucksack
	name = "rucksack"
	desc = "A larger variety of backpack with a carefully-weighted set of straps, so as to not disturb the wearer's movement \
		in spite of its remarkable size."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "rucksack"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	/// Duffel-type slightly extra back storage, without the cost of having to care about the zipper
	storage_type = /datum/storage/duffel

/obj/item/clothing/head/soft/parc
	name = "PA-RC cap"
	desc = "A nice brown baseball cap representing the Port Authority Response Corps."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "workhat"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	dog_fashion = null
	soft_type = "work"
	soft_suffix = "hat"

/obj/item/radio/headset/headset_frontier_colonist/ert
	keyslot = /obj/item/encryptionkey/headset_cent
	keyslot2 = /obj/item/encryptionkey/heads/captain
	resistance_flags = FIRE_PROOF

/obj/item/radio/headset/headset_frontier_colonist/ert/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection)

/obj/item/radio/headset/headset_frontier_colonist/ert/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_EARS)
		ADD_TRAIT(user, TRAIT_SPEECH_BOOSTER, CLOTHING_TRAIT)

/obj/item/radio/headset/headset_frontier_colonist/ert/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SPEECH_BOOSTER, CLOTHING_TRAIT)

/obj/item/radio/headset/headset_frontier_colonist/ert/parc
	name = "PA-RC radio headset"
	desc = "A bulky headset designed to survive the most unruly of conditions. Though not as heavy as a standard frontier \
		radio headset, it's still significantly larger than the usual earpieces. These Port Authority Response Corps variants \
		feature active audio balancing to help mitigate the impact of incredibly loud noises, while also keeping the wearer \
		verbally audible in low-pressure environments."

/obj/item/radio/headset/headset_frontier_colonist/ert/voidcorps
	name = "void corps radio headset"
	desc = "A bulky headset designed to survive the most unruly of conditions. Though not as heavy as a standard frontier \
		radio headset, it's still significantly larger than the usual earpieces. These 4CA Void Corps variants feature active \
		audio balancing to help mitigate the impact of incredibly loud noises, while also keeping the wearer verbally audible \
		in low-pressure environments."

/obj/item/radio/headset/headset_frontier_colonist/ert/shocktrooper
	name = "active radio headset"
	desc = "A bulky headset designed to survive the most unruly of conditions. Though not as heavy as a standard frontier \
		radio headset, it's still significantly larger than the usual earpieces. These after-market variants feature active \
		audio balancing to help mitigate the impact of incredibly loud noises, while also keeping the wearer verbally audible \
		in low-pressure environments."

/obj/item/radio/headset/headset_frontier_colonist/ert/shocktrooper/Initialize(mapload)
	. = ..()
	make_syndie()

/obj/item/storage/toolset
	name = "toolset pouch"
	desc = "A large pouch fitted just right to hold a full suite of tools while keeping your waist nice and free."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "toolset"
	equip_sound = 'sound/items/equip/toolbelt_equip.ogg'
	pickup_sound = SFX_CLOTH_PICKUP
	drop_sound = SFX_CLOTH_DROP
	/// This is just straight up a pocket toolbelt. I didn't want to remove ammo from the Void Corps Combat Tech so he gets this
	storage_type = /datum/storage/utility_belt
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_BULKY

/obj/item/storage/toolset/full/PopulateContents()
	new /obj/item/screwdriver/power(src)
	new /obj/item/crowbar/power(src)
	new /obj/item/weldingtool/experimental(src)
	new /obj/item/multitool(src)
	new /obj/item/construction/rcd/combat(src)
	new /obj/item/extinguisher/mini(src)
	new /obj/item/stack/cable_coil(src)
