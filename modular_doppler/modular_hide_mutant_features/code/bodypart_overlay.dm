// Head

/datum/bodypart_overlay/mutant/proc/can_draw_on_head(var/mob/living/carbon/human/wearer, key)
	if(!istype(wearer) || !wearer.head)
		return TRUE

	// Hide if wearing hat
	if(key in wearer.try_hide_mutant_parts)
		return FALSE

	return TRUE

/datum/bodypart_overlay/mutant/horns/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return can_draw_on_head(bodypart_owner.owner, feature_key)

/datum/bodypart_overlay/mutant/ears/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return can_draw_on_head(bodypart_owner.owner, feature_key)

/datum/bodypart_overlay/mutant/antennae/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return can_draw_on_head(bodypart_owner.owner, feature_key)

// Chest/Bottom

/datum/bodypart_overlay/mutant/proc/can_draw_on_chest(var/mob/living/carbon/human/wearer, key)
	if(!istype(wearer) || (!wearer.w_uniform && !wearer.wear_suit))
		return TRUE

	// Hide if wearing uniform
	if(key in wearer.try_hide_mutant_parts)
		return FALSE

	if(wearer.wear_suit)
		// Exception for MODs
		if(istype(wearer.wear_suit, /obj/item/clothing/suit/mod))
			return TRUE
	return TRUE

/datum/bodypart_overlay/mutant/wings/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return can_draw_on_chest(bodypart_owner.owner, feature_key)

/datum/bodypart_overlay/mutant/wings/moth/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return can_draw_on_chest(bodypart_owner.owner, "wings") // moth wings are weird so we'll have to do this

/datum/bodypart_overlay/mutant/tail/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return can_draw_on_chest(bodypart_owner.owner, feature_key_sprite) // so are tails

/datum/bodypart_overlay/mutant/spines/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return can_draw_on_chest(bodypart_owner.owner, feature_key)

// We won't want floating tail spines here
/datum/bodypart_overlay/mutant/tail_spines/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	var/mob/living/carbon/human/wearer = bodypart_owner.owner
	if(!wearer.w_uniform && !wearer.wear_suit)
		return ..()
	if("spines" in wearer.try_hide_mutant_parts)
		return FALSE
	if("tail" in wearer.try_hide_mutant_parts)
		return FALSE

	if(wearer.wear_suit)
		// Exception for MODs
		if(istype(wearer.wear_suit, /obj/item/clothing/suit/mod))
			return FALSE
	return TRUE
