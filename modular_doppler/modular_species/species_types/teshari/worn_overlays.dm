/**
 * Setup the final version of accessory_overlay given custom species options.
 */
/obj/item/clothing/under/proc/modify_accessory_overlay()
	if(!ishuman(loc))
		return accessory_overlay

	var/mob/living/carbon/human/human_wearer = loc

	var/obj/item/bodypart/chest/my_chest = human_wearer.get_bodypart(BODY_ZONE_CHEST)

	if(isnull(attached_accessories))
		return accessory_overlay
	for(var/obj/item/clothing/accessory/iter_accessory as anything in attached_accessories)
		for(var/shape in iter_accessory.supported_bodyshapes)
			if(human_wearer.bodyshape & shape)
				var/potential_file = iter_accessory.bodyshape_icon_files["[shape]"]
				if (icon_exists(potential_file, icon_state))
					if (shape != BODYSHAPE_HUMANOID) // EVERYTHING has this
						return accessory_overlay // dont modify

	my_chest?.worn_accessory_offset?.apply_offset(accessory_overlay)

	return accessory_overlay
