/// Undersuits - breach skinsuits, Port Authority clothing, etc

/obj/item/clothing/under/rank/centcom/portauthority
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	inhand_icon_state = "dg_suit"

/obj/item/clothing/under/rank/centcom/portauthority/work
	name = "\improper Port Authority work uniform"
	desc = "A drab green polo shirt and almost-but-not-quite shorts. You're either on an internship \
		or enjoying the great outdoors!"
	icon_state = "work"
	can_adjust = FALSE

/obj/item/clothing/under/rank/centcom/portauthority/pcat
	name = "\improper P-CAT manager uniform"
	desc = "A suit worn by Pallas Cargo and Transport's site managers and representatives."
	icon_state = "official"

/obj/item/clothing/under/rank/centcom/portauthority/commander
	name = "\improper Port Authority commander uniform"
	desc = "A suit worn by the Port Authority's absolute best. The belt buckle is gold!"
	icon_state = "portauth"

/obj/item/clothing/under/rank/centcom/portauthority/commander/skirt
	name = "\improper Port Authority commander uniform"
	desc = "A suit and pencil skirt worn by the Port Authority's absolute best. The belt buckle is gold!"
	icon_state = "portauth_skirt"

/obj/item/clothing/under/rank/centcom/portauthority/turtleneck
	name = "\improper Port Authority turtleneck"
	desc = "A suave green turtleneck that makes you look fabulously important."
	icon_state = "officer"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/centcom/portauthority/turtleneck/skirt
	name = "\improper Port Authority turtleneck"
	desc = "A suave green turtleneck and pencil skirt that make you look fabulously important."
	icon_state = "officer_skirt"

/obj/item/clothing/under/rank/engineering/pressuresuit
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
	equip_sound = 'sound/items/equip/glove_equip.ogg'
	can_adjust = FALSE
	resistance_flags = FIRE_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
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

/obj/item/clothing/under/syndicate/combat/eva
	name = "exoatmospheric combat uniform"
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "exo_combat"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	has_sensor = HAS_SENSORS

/obj/item/clothing/under/syndicate/combat/shocktrooper
	name = "shocktrooper combat uniform"
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "shocktrooper_combat"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/clothing/under/plasmaman/rev2
	name = "modern plasma envirosuit"
	desc = "A modern variant of plasma envirosuit designed to be less obtrusive when wearing both formal clothing \
		and work equipment. The extinguisher cartridge system (and notable weight) remain identical to older models."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "rev2_envirosuit"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/clothing/under/plasmaman/rev2/pcat
	name = "\improper P-CAT plasma envirosuit"
	desc = "An updated plasma envirosuit for usage by Pallas Cargo and Transport's site managers... and anyone else \
		representing them that might need one."
	icon_state = "official_envirosuit"

/obj/item/clothing/under/plasmaman/rev2/portauth
	name = "\improper Port Authority plasma envirosuit"
	desc = "An updated plasma envirosuit worn by the Port Authority's finest commanders. When you're this important, \
		you can never have enough <i>gold!</i>"
	icon_state = "portauth_envirosuit"

/// Shoes - mostly just pressure boots & envirosuit boots

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

/obj/item/clothing/shoes/jackboots/rev2
	name = "modern envirosuit boots"
	desc = "Despite being called boots, these look about as short as shoes; though they work perfectly for sealing \
		around the edges of a plasma envirosuit."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "rev2_enviroboots"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	body_parts_covered = FEET
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor_type = /datum/armor/color_plasmaman

/// Gloves - similarly, just pressure gloves and envirosuit gloves

/obj/item/clothing/gloves/combat/pressuregloves
	name = "pressure-sealed combat gloves"
	desc = "Dextrous combat gloves, both fireproof and electrically insulated. They feature a seal at the wrist \
		that connects to a pressure-resistant bodysuit."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "pressure_gloves"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	greyscale_colors = null
	resistance_flags = FIRE_PROOF

/obj/item/clothing/gloves/color/plasmaman/rev2
	name = "modern envirosuit gloves"
	desc = "Lightweight, dextrous gloves that are suitably pressure-sealed against (most) external atmoshperes."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "rev2_envirogloves"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	greyscale_colors = null

/// Helmets - armored headwear

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

// The work vest inherits the specular emissive type from its hazard vest parent, which magnifies light received
// This helmet, however, is meant to glow in the dark properly
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

/obj/item/clothing/head/helmet/alt/visorless
	name = "low-cut ballistic helmet"
	desc = "An up-armored low-cut helmet that more effectively covers the sides of the user's head than most contemporary \
		helmets. The standard-issue visor has been taken out to allow for easier operation of proprietary optical devices."
	icon_state = "helmet-novisor"

/obj/item/clothing/head/helmet/space/plasmaman/rev2
	name = "modern plasma envirosuit helmet"
	desc = "A modern variant of envirosuit helmet with a reflective visor and more accomodating internal head space, suitable \
		for people other than plasmoids to wear. It's still space-proof to boot!"
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "rev2_envirohelm"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/clothing/head/helmet/space/plasmaman/rev2/pcat
	name = "\improper P-CAT plasma envirosuit helmet"
	desc = "A modern variant of envirosuit helmet designed for individuals representing Pallas Cargo and Transport that might \
		require protection from an oxygen-rich environment."
	icon_state = "official_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/rev2/portauth
	name = "\improper Port Authority plasma envirosuit helmet"
	desc = "A modern variant of envirosuit helmet worn around by the Port Authority's most flammable commanders."
	icon_state = "portauth_envirohelm"

/// Hats - less-armored headwear. Includes stuff that might still have light armor, like formal caps

/obj/item/clothing/head/soft/portauth
	name = "\improper Port Authority cap"
	desc = "A nice green baseball cap representing the Port Authority."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "workhat"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	dog_fashion = null
	soft_type = "work"
	soft_suffix = "hat"

/obj/item/clothing/head/hats/centcom_cap/portauth
	name = "\improper Port Authority commander cap"
	desc = "Worn by the 4CA's finest."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "portauth_cap"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/clothing/head/hats/centcom_cap/pcat
	name = "\improper P-CAT site manager cap"
	desc = "Worn by Pallas Cargo and Transport's finest. Of course the suits have nice hats!"
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "official_cap"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/clothing/head/beret/centcom_formal/portauth
	name = "\improper Port Authority beret"
	desc = "Well, the badge isn't dull, so clearly whoever's wearing this must be vaguely important."
	armor_type = /datum/armor/hats_centcom_cap
	icon_state = "/obj/item/clothing/head/beret/centcom_formal/portauth"
	greyscale_colors = "#988d7f#e6b917"

/obj/item/clothing/head/beret/centcom_formal/pcat
	name = "\improper P-CAT site manager beret"
	desc = "Is it silver, or platinum? Perhaps it's up to taste."
	armor_type = /datum/armor/hats_centcom_cap
	icon_state = "/obj/item/clothing/head/beret/centcom_formal/pcat"
	greyscale_colors = "#988d7f#d4d7dF"

/// Vests - armored torsowear

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
	desc = "A modified Type III ballistic vest with improved protection and a number of aftermarket upgrades to ensure it protects \
		every bit of the wearer's body, save for their head, hands, and feet. Though useful and remarkably effective at allowing \
		a wearer to shrug off small-arms fire, systems like these are ludicrously heavy, and far worse at protecting against \
		laser or energy-based threats."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "heavy_battle_armor"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	w_class = WEIGHT_CLASS_HUGE
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	strip_delay = 12 SECONDS
	slowdown = 2
	armor_type = /datum/armor/armor_heavy

/obj/item/clothing/suit/armor/heavy_ballistic/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/adjust_fishing_difficulty, 5)
	init_rustle_component()

/obj/item/clothing/suit/armor/heavy_ballistic/proc/init_rustle_component()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/// Jackets & other light suit-slot clothes. May still have armor, like with formal coats & trenchcoats

/obj/item/clothing/suit/hazardvest/portauth
	name = "\improper Port Authority work vest"
	desc = "A high-visibility vest designed to help crew identify members of the Port Authority."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "workvest"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'

/obj/item/clothing/suit/armor/portauth
	name = "\improper Port Authority officer coat"
	desc = "A utilitarian coat given to Port Authority commanders. Stylish, but not excessive."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "portauth_officer"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	inhand_icon_state = "centcom"
	body_parts_covered = CHEST|GROIN|ARMS
	armor_type = /datum/armor/armor_centcom_formal

/obj/item/clothing/suit/armor/portauth/pcat
	name = "\improper P-CAT site manager coat"
	desc = "A utilitarian coat given to Pallas Cargo and Transport site managers. Suits and ties are <i>so</i> last-gen."
	icon_state = "official_officer"

/obj/item/clothing/suit/armor/portauth/formal
	name = "\improper Port Authority formal coat"
	desc = "A stylish coat given to Port Authority commanders. Quite gaudy... the government really spends money on this stuff?"
	icon_state = "portauth_formal"

/obj/item/clothing/suit/armor/portauth/formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/// Backpacks - or rather, THE backpack

/obj/item/storage/backpack/rucksack
	name = "rucksack"
	desc = "A larger variety of backpack with a carefully-weighted set of straps, so as to not disturb the wearer's movement \
		in spite of its remarkable size."
	icon = 'modular_doppler/modular_response_teams/icons/icon.dmi'
	icon_state = "rucksack"
	worn_icon = 'modular_doppler/modular_response_teams/icons/onmob.dmi'
	/// Duffel-type slightly extra back storage, without the cost of having to care about the zipper
	storage_type = /datum/storage/duffel

/// Radio headsets; most of which are standard frontier headset reskins cause they look dope

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
	name = "\improper PA-RC radio headset"
	desc = "A bulky headset designed to survive the most unruly of conditions. Though not as heavy as a standard frontier \
		radio headset, it's still significantly larger than the usual earpieces. These Port Authority Response Corps variants \
		feature active audio balancing to help mitigate the impact of incredibly loud noises, while also keeping the wearer \
		verbally audible in low-pressure environments."

/obj/item/radio/headset/headset_frontier_colonist/ert/voidcorps
	name = "\improper Void Corps radio headset"
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
	keyslot = /obj/item/encryptionkey/syndicate
	keyslot2 = null

/obj/item/radio/headset/headset_frontier_colonist/ert/shocktrooper/Initialize(mapload)
	. = ..()
	make_syndie()

// we override the names of centcom headsets just because I don't want /all/ doppler ERT headsets being frontier
/obj/item/radio/headset/headset_cent
	name = "\improper high command headset"
	desc = "A headset used by a good number of corporate and government representatives. Green is very in-fashion!"

/obj/item/radio/headset/headset_cent/alt
	name = "\improper high command bowman headset"
	desc = "A headset especially for emergency response personnel. Protects ears from flashbangs."

/// Misc one-offs like the tool pouch

/obj/item/clothing/glasses/thermal/shocktrooper
	name = "\improper T91 thermal goggles"
	desc = "High-spec thermal goggles for usage in any conditions. Warranty void if exposed to electicity."
	icon_state = "heat"

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
