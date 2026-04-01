/// Special job specific robes that give affinity.

// Viszard; affinity 4 body, no bonus perks besides not being flammable.
/obj/item/clothing/suit/wizrobe/viszard
	name = "vizard robe"
	desc = "Most people would think this is a high-vis raincoat, but those fools are WRONG. These are the proud garments of a thaumaturge. They look the same? Well, one is worn in rainy weather, and the other is the highly regarded robes of the great thaumaturges that can untangle the 'M6 Spaghetti Junction' with the flick of a wrist. "
	icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	worn_icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	icon_state = "hivizmob"
	inhand_icon_state = "hivizobj"
	armor_type = /datum/armor/none
	cold_protection = CHEST|GROIN|ARMS|HANDS|LEGS
	heat_protection = CHEST|GROIN|ARMS|HANDS|LEGS
	fishing_modifier = -6 // high vishing
	affinity = 3
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes_digi.dmi')

// Viszard; affinity 3 head, no bonus perks besides not being flammable.
/obj/item/clothing/head/wizard/viszard
	name = "viszard hat"
	desc = "An incredibly obvious wizard hat; as if the pointiness wasn't obvious enough. Despite being granted to the Engineering department, it does not pass as a helmet for workplace safety standards, so please beware falling objects. However, it is fireproof."
	icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	worn_icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	icon_state = "hivizhat"
	inhand_icon_state = "hivizhatobj"
	armor_type = /datum/armor/none
	fishing_modifier = -5 // high vishing
	affinity = 3

// Secrobe; affinity 3 armor. Has the stats of a secjacket and covers the legs, and also has affinity, but also has a slight amount of slowdown.
/obj/item/clothing/suit/wizrobe/secwiz
	name = "security thaumaturge robe"
	desc = "The garments of a security-contracted Thaumaturge. The robes have been reinforced and provide a high amount of protection across a large degree of the body, at the cost of being bulkier to move in. The proportion of armor to robe has been fine-tuned for the most optimal results; it seems that armored wizards aren't particularly popular in the worldly zeitgeist, reducing the impact of armor on robes."
	icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	worn_icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	icon_state = "secrobemob"
	inhand_icon_state = "secrobesobj"
	armor_type = /datum/armor/armor_secjacket
	cold_protection = CHEST|GROIN|ARMS|HANDS|LEGS
	heat_protection = CHEST|GROIN|ARMS|HANDS|LEGS
	resistance_flags = FLAMMABLE
	affinity = 3
	slowdown = 0.2
	fishing_modifier = -3
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes_digi.dmi')

// Secrobe; affinity 3 head, no bonus perks besides not being flammable.
/obj/item/clothing/head/wizard/secwiz
	name = "security thaumaturge hat"
	desc = "A wizard's hat, painted in the colors of the security department. Jokingly referred to as the Magic Police, Thaumaturges experience an unique skillset that is very useful to have as a Security Officer. Given their requirements to dress \
	for their powers, security has commissioned these special hats."
	icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	worn_icon = 'modular_doppler/modular_powers/icons/items/thaumaturge_robes.dmi'
	icon_state = "sechat"
	inhand_icon_state = "sechatobj"
	armor_type = /datum/armor/none
	fishing_modifier = -2
	resistance_flags = FLAMMABLE
	affinity = 3

