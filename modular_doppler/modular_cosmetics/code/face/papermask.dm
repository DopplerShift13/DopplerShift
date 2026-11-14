/datum/action/item_action/adjust/papermask
	name = "Adjust paper mask"
	desc = "RMB: Adjust mask."

/datum/action/item_action/adjust/papermask/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/clothing/mask/paper/paper_mask = target
	if(trigger_flags & TRIGGER_SECONDARY_ACTION)
		paper_mask.adjust_mask(usr)

/obj/item/clothing/mask/paper
	name = "paper mask"
	desc = "It's true. Once you wear a mask for so long, you forget about who you are. Wonder if that happens with shitty paper ones."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/face/papermask.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/face/papermask.dmi'
	icon_state = "mask_paper"
	clothing_flags = MASKINTERNALS
	flags_inv = HIDEFACIALHAIR | HIDESNOUT
	interaction_flags_click = NEED_DEXTERITY
	w_class = WEIGHT_CLASS_SMALL
	supported_bodyshapes = null
	bodyshape_icon_files = null
	actions_types = list(/datum/action/item_action/adjust/papermask)
	/// Whether or not the mask is currently being layered over (or under!) hair. FALSE/null means the mask is layered over the hair (this is how it starts off).
	var/wear_hair_over
	/// Whether or not the strap is currently hidden or visible
	var/strap_hidden

/obj/item/clothing/mask/paper/Initialize(mapload)
	. = ..()
	if(wear_hair_over)
		alternate_worn_layer = BACK_LAYER

/obj/item/clothing/mask/paper/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!strap_hidden)
		. += mutable_appearance(icon_file, "mask_paper_strap")

/obj/item/clothing/mask/paper/click_alt_secondary(mob/user)
	adjust_mask(user)

/obj/item/clothing/mask/paper/item_ctrl_click(mob/user)
	adjust_strap(user)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/mask/paper/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_RMB] = "Adjust Mask"
	context[SCREENTIP_CONTEXT_CTRL_LMB] = "Hide/Show Strap"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/mask/paper/proc/adjust_mask(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!user.incapacitated)
		var/is_worn = user.wear_mask == src
		wear_hair_over = !wear_hair_over
		if(wear_hair_over)
			alternate_worn_layer = BACK_LAYER
			to_chat(user, "You [is_worn ? "" : "will "]sweep your hair over the mask.")
		else
			alternate_worn_layer = initial(alternate_worn_layer)
			to_chat(user, "You [is_worn ? "" : "will "]sweep your hair under the mask.")

		user.update_worn_mask()

/obj/item/clothing/mask/paper/proc/adjust_strap(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!user.incapacitated)
		var/is_worn = user.wear_mask == src
		strap_hidden = !strap_hidden
		to_chat(user, "You [is_worn ? "" : "will "][strap_hidden ? "hide" : "show"] the mask strap.")

		user.update_worn_mask()

// Because alternate_worn_layer can potentially get reset on unequipping the mask (ex: for 'Top' snouts), let's make sure we don't lose it our settings
/obj/item/clothing/mask/paper/dropped(mob/living/carbon/human/user)
	var/prev_alternate_worn_layer = alternate_worn_layer
	. = ..()
	alternate_worn_layer = prev_alternate_worn_layer

/obj/item/clothing/mask/paper/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/doppler/papermask, TRUE)

/datum/atom_skin/doppler/papermask
	abstract_type = /datum/atom_skin/doppler/papermask

/datum/atom_skin/doppler/papermask/blank
	preview_name = "Blank"
	new_icon_state = "mask_paper"

/datum/atom_skin/doppler/papermask/neutral
	preview_name = "Neutral"
	new_icon_state = "mask_neutral"

/datum/atom_skin/doppler/papermask/eye
	preview_name = "Eye"
	new_icon_state = "mask_eye"

/datum/atom_skin/doppler/papermask/sleeping
	preview_name = "Sleep"
	new_icon_state = "mask_sleep"

/datum/atom_skin/doppler/papermask/heart
	preview_name = "Heart"
	new_icon_state = "mask_heart"

/datum/atom_skin/doppler/papermask/cre
	preview_name = "Core"
	new_icon_state = "mask_core"

/datum/atom_skin/doppler/papermask/plus
	preview_name = "Plus"
	new_icon_state = "mask_plus"

/datum/atom_skin/doppler/papermask/square
	preview_name = "Square"
	new_icon_state = "mask_square"

/datum/atom_skin/doppler/papermask/bullseye
	preview_name = "Bullseye"
	new_icon_state = "mask_bullseye"

/datum/atom_skin/doppler/papermask/vertical
	preview_name = "Vertical"
	new_icon_state = "mask_vertical"

/datum/atom_skin/doppler/papermask/horizontal
	preview_name = "Horizontal"
	new_icon_state = "mask_horizontal"

/datum/atom_skin/doppler/papermask/x
	preview_name = "X"
	new_icon_state = "mask_x"

/datum/atom_skin/doppler/papermask/bug
	preview_name = "Bug"
	new_icon_state = "mask_bug"

/datum/atom_skin/doppler/papermask/double
	preview_name = "Double"
	new_icon_state = "mask_double"

/datum/atom_skin/doppler/papermask/mark
	preview_name = "Mark"
	new_icon_state = "mask_mark"

/datum/atom_skin/doppler/papermask/line
	preview_name = "Line"
	new_icon_state = "mask_line"

/datum/atom_skin/doppler/papermask/minus
	preview_name = "Minus"
	new_icon_state = "mask_minus"

/datum/atom_skin/doppler/papermask/four
	preview_name = "Four"
	new_icon_state = "mask_four"

/datum/atom_skin/doppler/papermask/diamond
	preview_name = "Diamond"
	new_icon_state = "mask_diamond"

/datum/atom_skin/doppler/papermask/cat
	preview_name = "Cat"
	new_icon_state = "mask_cat"

/datum/atom_skin/doppler/papermask/big_eye
	preview_name = "Big Eye"
	new_icon_state = "mask_bigeye"

/datum/atom_skin/doppler/papermask/good
	preview_name = "Good"
	new_icon_state = "mask_good"

/datum/atom_skin/doppler/papermask/bad
	preview_name = "Bad"
	new_icon_state = "mask_bad"

/datum/atom_skin/doppler/papermask/happy
	preview_name = "Happy"
	new_icon_state = "mask_happy"

/datum/atom_skin/doppler/papermask/sad
	preview_name = "Sad"
	new_icon_state = "mask_sad"

/datum/crafting_recipe/paper_mask
	name = "Paper Mask"
	result = /obj/item/clothing/mask/paper
	time = 30
	tool_behaviors = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/paper = 5)
	category = CAT_CLOTHING
