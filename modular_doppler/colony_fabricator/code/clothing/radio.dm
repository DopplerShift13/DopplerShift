/obj/item/radio/headset/headset_frontier_colonist
	name = "superband talker set"
	desc = "A bulky set of headphones and appropriately large microphone piece that are used in areas without developed \
		communications infrastructure. These are often seen directly wired into larger communications sets work on the back \
		or over the shoulder. Due to the construction of the ear cups and internal amplification, others standing next to \
		the wearer of these headsets may be able to hear their communications."
	icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing.dmi'
	icon_state = "radio"
	worn_icon = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi'
	worn_icon_state = "radio"
	inhand_icon_state = null
	supported_bodyshapes = list(BODYSHAPE_HUMANOID)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/colony_fabricator/icons/clothes/clothing_worn.dmi',
	)
	alternate_worn_layer = FACEMASK_LAYER + 0.5
	flags_cover = EARS_COVERED
	resistance_flags = FIRE_PROOF
	// Radio stuff
	subspace_transmission = FALSE
	subspace_switchable = FALSE
	canhear_range = 1

/obj/item/radio/headset/headset_frontier_colonist/mining
	keyslot = /obj/item/encryptionkey/headset_mining

/obj/item/radio/headset/headset_frontier_colonist/mining/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/callouts, ITEM_SLOT_EARS, examine_text = span_info("Use ctrl-click to enable or disable callouts."))

/obj/item/radio/headset/headset_frontier_colonist/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_EARS)
		ADD_TRAIT(user, TRAIT_SPEECH_BOOSTER, CLOTHING_TRAIT)

/obj/item/radio/headset/headset_frontier_colonist/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_SPEECH_BOOSTER, CLOTHING_TRAIT)
