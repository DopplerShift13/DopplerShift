/datum/armor/gvardi_gear
	melee = 40
	bullet = 60
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

// head

/obj/item/clothing/head/helmet/rohe
	name = "rohe gvardi helmet"
	desc = "A large, blue painted helmet in the common style of the Crusoe's Rest Rohe Gvardi, otherwise known as the \
		system guard. No tricks, no frills, just a big dome made of the strongest metal that wouldn't break anyone's neck."
	icon = 'modular_doppler/clothing/icons/military_obj.dmi'
	icon_state = "rohe_helmet"
	worn_icon = 'modular_doppler/clothing/icons/military.dmi'
	worn_icon_state = "rohe_helmet"
	lefthand_file = 'modular_doppler/clothing/icons/inhands/generic_left.dmi'
	righthand_file = 'modular_doppler/clothing/icons/inhands/generic_right.dmi'
	inhand_icon_state = null
	supported_bodyshapes = null
	flags_cover = EARS_COVERED
	flags_inv = null
	armor_type = /datum/armor/gvardi_gear
	hair_mask = /datum/hair_mask/standard_hat_middle

/obj/item/clothing/head/helmet/rohe/evil
	name = "kaitiaki helmet"
	desc = "A large, blue painted helmet in the common style of the Crusoe's Rest Rohe Gvardi, except for the fact that \
		this one has been hastily spraypainted over in NG green and had a bright band wrapped around it. While the green \
		may be innocent, the band marks the helmet as belonging to the Kaitiaki of the People, a dangerous militant group \
		made up of former Gvardi members who want independence from the 4CA."
	icon_state = "kaiti_helmet"
	worn_icon_state = "kaiti_helmet"

// suit

/obj/item/clothing/suit/armor/rohe
	name = "rohe gvardi plate"
	desc = "A simple vest with inserted superalloy plates to protect your innards from becoming outards, made in the common \
		style of the Crusoe's Rest Rohe Gvardi. The armor itself, however, sees use with elements both noble and otherwise, often \
		seen on members of the Kaitiaki on their fight for independence."
	icon = 'modular_doppler/clothing/icons/military_obj.dmi'
	icon_state = "rohe_armor"
	worn_icon = 'modular_doppler/clothing/icons/military.dmi'
	worn_icon_state = "rohe_armor"
	lefthand_file = 'modular_doppler/clothing/icons/inhands/generic_left.dmi'
	righthand_file = 'modular_doppler/clothing/icons/inhands/generic_right.dmi'
	inhand_icon_state = null
	supported_bodyshapes = null
	body_parts_covered = CHEST|GROIN|ARMS|LEGS // its for bitrunner domains, take limb aiming to the real world
	armor_type = /datum/armor/gvardi_gear

// under

/obj/item/clothing/under/rohe
	name = "rohe gvardi uniform"
	desc = "The iconic uniform of the Crusoe's Rest Rohe Gvardi, a short sleeved bright blue bolero on top of some \
		high waist short legged flood pants. Perfect for the local environment, that is to say, perfect for NG and \
		not many other places. The good news is that most of the action happens there anyway."
	icon = 'modular_doppler/clothing/icons/military_obj.dmi'
	icon_state = "gvardi"
	worn_icon = 'modular_doppler/clothing/icons/military.dmi'
	worn_icon_state = "gvardi"
	lefthand_file = 'modular_doppler/clothing/icons/inhands/generic_left.dmi'
	righthand_file = 'modular_doppler/clothing/icons/inhands/generic_right.dmi'
	inhand_icon_state = null
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/clothing/icons/military.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/clothing/icons/military_digi.dmi',
	)
	body_parts_covered = CHEST|GROIN|LEGS
	can_adjust = FALSE
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/clothing_under

/obj/item/clothing/under/rohe/evil
	name = "kaitiaki uniform"
	desc = "The infamous uniform of the local Kaitiaki, if one could say they have a uniform at all. In truth, it is actually \
		the clothing of their biggest enemy painted over with some NG green spraypaint combined with a brightly colored band around the forearm."
	icon_state = "gvardi_evil"
	worn_icon_state = "gvardi_evil"

// belt

/obj/item/storage/belt/mining/military
	name = "gvardi rig"
	desc = "A hefty belt covered in all manner of military pouches."
	supported_bodyshapes = null
	storage_type = /datum/storage/military_belt
