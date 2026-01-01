// head

/obj/item/clothing/head/lizard_hat
	name = "tan peak-cover"
	desc = "A Tizirian favorite in military headwear. A bill to keep the sun away and side flaps to cover the \
		sides of your head. All this, while still looking fancy through a neatly folded top cover. This one is \
		in the recognizable tan of the empire's obligate service members."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "peak_levy"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "peak_levy"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null
	supported_bodyshapes = null
	hair_mask = /datum/hair_mask/standard_hat_middle

/obj/item/clothing/head/lizard_hat/white
	name = "white peak-cover"
	desc = "A Tizirian favorite in military headwear. A bill to keep the sun away and side flaps to cover the \
		sides of your head. All this, while still looking fancy through a neatly folded top cover. This one \
		is in the stark white of the empire's career service members."
	icon_state = "peak_reg"
	worn_icon_state = "peak_reg"

// eye hud

/obj/item/clothing/glasses/lizard_hud
	name = "solid infohud"
	desc = "A solid screen made to sit in front of the eye for the quick presentation of information. \
		Programmable (by professionals mainly) to fit a wide variety of roles."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "hud"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "hud"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null
	flags_cover = GLASSESCOVERSEYES

/obj/item/clothing/glasses/lizard_hud/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/glasses_stats_thief)

/obj/item/clothing/glasses/lizard_hud/change_glass_color(new_color_type)
	if(glass_colour_type)
		RemoveElement(/datum/element/wearable_client_colour, glass_colour_type, ITEM_SLOT_EYES, forced = forced_glass_color, comsig_toggle = COMSIG_CLICK_CTRL)
	glass_colour_type = new_color_type
	if(glass_colour_type)
		AddElement(/datum/element/wearable_client_colour, glass_colour_type, ITEM_SLOT_EYES, forced = forced_glass_color, comsig_toggle = COMSIG_CLICK_CTRL)

// ear tag

/obj/item/clothing/accessory/ear_tag
	name = "ear tag"
	desc = "A an old Tizirian ear tag, or at least a replica of one. These are a relic of a long gone era \
		where obligate soldiers of the empire (previously lovingly called levies) would have a tag such as this \
		attached for identification after battles."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "tag"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "tag"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null
	alternate_worn_layer = HANDCUFF_LAYER // above hats for visibility
	attachment_slot = NONE
	/// What message is displayed when our dogtags / its clothes / its wearer is examined
	var/display = null

/obj/item/clothing/accessory/ear_tag/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/pinnable_accessory, silent = TRUE, pinning_time = 5 SECONDS)

/obj/item/clothing/accessory/ear_tag/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		return NONE
	if(istype(held_item, /obj/item/pen))
		context[SCREENTIP_CONTEXT_LMB] = "Write on tag"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/accessory/ear_tag/examine(mob/user)
	. = ..()
	. += span_notice("You could write your own words on the tag with a pen.")
	if(display)
		. += "It has \"[display]\" written on it."
	else
		. += "There is nothing written on it."

/obj/item/clothing/accessory/ear_tag/item_interaction(mob/living/user, obj/item/weapon, list/modifiers)
	if(!istype(weapon, /obj/item/pen))
		return NONE
	var/new_display = tgui_input_text(user, "What should the tag say?", "Writing on tag", html_decode(display), MAX_DESC_LEN)
	if(QDELETED(user) || QDELETED(src) || !user.can_perform_action(src) || !(weapon in user.held_items))
		return ITEM_INTERACT_BLOCKING
	if(!new_display)
		return ITEM_INTERACT_BLOCKING
	if(new_display == "")
		display = null
		return ITEM_INTERACT_SUCCESS
	display = new_display
	return ITEM_INTERACT_SUCCESS

// Examining the clothes will display the examine message of the tag
/obj/item/clothing/accessory/ear_tag/attach(obj/item/clothing/under/attach_to, mob/living/attacher)
	. = ..()
	if(!.)
		return
	RegisterSignal(attach_to, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/obj/item/clothing/accessory/ear_tag/detach(obj/item/clothing/under/detach_from)
	. = ..()
	UnregisterSignal(detach_from, COMSIG_ATOM_EXAMINE)

// Double examining the person wearing the clothes will display the examine message of the tag
/obj/item/clothing/accessory/ear_tag/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/obj/item/clothing/accessory/ear_tag/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE)

/// Adds the examine message to the clothes and mob.
/obj/item/clothing/accessory/ear_tag/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(ismob(source))
		examine_list += "A tag is clipped to [source.p_their()] ear [display ? ": [display]" : "but nothing is on it."]"
	else
		examine_list += "A tag is clipped to [source] [display ? ": [display]" : "but nothing is on it."]"

// neck capes

/obj/item/clothing/neck/lizard_cape
	name = "hand's cape"
	desc = "A brilliant white shoulder cape to denote the wearer is serving as a hand of the empire, meaning \
		they are probably in charge of something you should be listening to right now."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "cape_hand"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "cape_hand"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null

/obj/item/clothing/neck/lizard_cape/med
	name = "scaler's cape"
	desc = "A deeply purple dyed shoulder cape to denote the wearer is a scaler, Tiziria's own medical corps, \
		and only sometimes not shot at on the battlefield."
	icon_state = "cape_med"
	worn_icon_state = "cape_med"

/obj/item/clothing/neck/lizard_cape/spec
	name = "claw's cape"
	desc = "An orange shoulder cape that denotes the user is a claw of the empire, otherwise known as a specialist \
		of some sort. Typically a sapper, or a radio carrier, but the cape applies to all except medics and leaders."
	icon_state = "cape"
	worn_icon_state = "cape"

// halftops

/obj/item/clothing/suit/lizard_halftop
	name = "tan halftop"
	desc = "The most popular clothing for the upper half of the Tizirians, enough to keep your scales from dulling \
		in the harsh summer sun, but open enough to not overheat in the same situation. This one is tan for the \
		empire's obligate service members."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "halftop_levy"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "halftop_levy"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null
	supported_bodyshapes = null

/obj/item/clothing/suit/lizard_halftop/white
	name = "white halftop"
	desc = "The most popular clothing for the upper half of the Tizirians, enough to keep your scales from dulling \
		in the harsh summer sun, but open enough to not overheat in the same situation. This one is white for the \
		empire's career service members."
	icon_state = "halftop_reg"
	worn_icon_state = "halftop_reg"

/obj/item/clothing/suit/lizard_halftop/black
	name = "black halftop"
	desc = "The most popular clothing for the upper half of the Tizirians, enough to keep your scales from dulling \
		in the harsh summer sun, but open enough to not overheat in the same situation. This one is black, typically \
		a taboo color for anything other than your armor and your legwear, due to black's capacity for absorbing the sun."
	icon_state = "halftop_black"
	worn_icon_state = "halftop_black"

// kilts

/obj/item/clothing/under/lizard_kilt
	name = "\improper Tizirian tan war kilt"
	desc = "The third best maintained item a Tizirian owns, next to their blades and armor. A relatively simple \
		looking kilt with a red banner hanging from it's front. Each banner holds a different long string of \
		Khaishhs written on to it, often with little meaning and just to \"look cool\" for the cameras. \
		This one is tan for the empire's obligate service members."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "kilt_levy"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "kilt_levy"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null
	body_parts_covered = GROIN|LEGS
	can_adjust = FALSE
	female_sprite_flags = NO_FEMALE_UNIFORM
	supported_bodyshapes = null
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/lizard_kilt/white
	name = "\improper Tizirian white war kilt"
	desc = "The third best maintained item a Tizirian owns, next to their blades and armor. A relatively simple \
		looking kilt with a red banner hanging from it's front. Each banner holds a different long string of \
		Khaishhs written on to it, often with little meaning and just to \" look cool \" for the cameras. \
		This one is white for the empire's career service members."
	icon_state = "kilt_reg"
	worn_icon_state = "kilt_reg"

// masks

/obj/item/clothing/mask/snout_balaclava
	name = "snout balaclava"
	desc = "A special balaclava, first popularized by the Tizirians and then stolen by everyone else, that \
		comfortably fits the average snout that any creature may have. Has generous eye holes for the wide variety of \
		numbers of eyes that many species have. May prove for an awkward fit on anyone without a snout."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "snoutacava"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	inhand_icon_state = "balaclava"
	resistance_flags = FIRE_PROOF
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT|MASKINTERNALS
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	alternate_worn_layer = LOW_FACEMASK_LAYER
	w_class = WEIGHT_CLASS_SMALL
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_SNOUTED)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi',
		BODYSHAPE_SNOUTED_T = 'modular_doppler/species_clothes/icons/tiziria/gear_worn_dig.dmi',
	)
