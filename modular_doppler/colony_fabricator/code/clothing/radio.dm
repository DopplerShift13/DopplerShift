/obj/item/radio/headset/headset_frontier_colonist
	name = "frontier radio headset"
	desc = "A bulky headset that should hopefully survive exposure to the elements better than station headsets might. \
		Has a built-in antenna allowing the headset to work independently of a communications network."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "radio"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "radio"
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn_teshari.dmi'
	)
	alternate_worn_layer = FACEMASK_LAYER + 0.5
	subspace_transmission = FALSE

/obj/item/radio/headset/headset_frontier_colonist/mining
	name = "mining wide-band headset"
	desc = "A bulky headset that can transmit regardless of local comms conditions. It's not very comfortable."
	keyslot = /obj/item/encryptionkey/headset_mining
	resistance_flags = FIRE_PROOF

/obj/item/radio/headset/headset_frontier_colonist/mining/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/callouts, ITEM_SLOT_EARS, examine_text = span_info("Use ctrl-click to enable or disable callouts."))

/obj/item/radio/headset/headset_frontier_colonist/mining/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_EARS)
		ADD_TRAIT(user, TRAIT_SPEECH_BOOSTER, CLOTHING_TRAIT)

/obj/item/radio/headset/headset_frontier_colonist/mining/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SPEECH_BOOSTER, CLOTHING_TRAIT)
