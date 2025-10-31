GLOBAL_LIST_EMPTY(species_clothing_fallback_cache)

/**
 * Modularly get the species' fallback greyscale config.
 * Only used if you use generate_custom_worn_icon_fallback()
 * Arguments:
 * * item_slot: The slot we're updating. One of OFFSET_HEAD, etc.
 * * item: The item being rendered.
 */
/datum/species/proc/get_custom_worn_config_fallback(item_slot, obj/item/item)
	if (isnull(item)) return
	var/list/list_to_use = item.autogen_clothing_config
	if(istype(item, /obj/item/clothing/under) && !(item.body_parts_covered & LEGS) && !isnull(item.autogen_clothing_config_skirt))
		list_to_use = item.autogen_clothing_config_skirt

	if (isnull(list_to_use))
		return null

	return list_to_use[id]

/datum/species/proc/use_custom_worn_icon_cached()
	LAZYINITLIST(GLOB.species_clothing_fallback_cache[name])

/**
 * Read from freely usable cache of generated icons for your species.
 * Arguments:
 * * file_to_use: icon you're substituting
 * * state_to_use: icon state you're substituting
 * * meta: string containing other info.
 */
/datum/species/proc/get_custom_worn_icon_cached(file_to_use, state_to_use, meta)
	return GLOB.species_clothing_fallback_cache[name]["[file_to_use]-[state_to_use]-[meta]"]

/**
 * Write to a freely usable cache of generated icons for your species.
 * Arguments:
 * * file_to_use: icon you're substituting
 * * state_to_use: icon state you're substituting
 * * meta: string containing other info.
 * * cached_value: Cached value
 */
/datum/species/proc/set_custom_worn_icon_cached(file_to_use, state_to_use, meta, cached_value)
	GLOB.species_clothing_fallback_cache[name]["[file_to_use]-[state_to_use]-[meta]"] = cached_value

/**
 * Generate a fallback worn icon, if the species supports it. You must call it in an override of generate_custom_worn_icon()
 */
/datum/species/proc/generate_custom_worn_icon_fallback(item_slot, obj/item/item, mob/living/carbon/human/human_owner)
	var/icon/human_icon = item.worn_icon || item.icon
	var/human_icon_state = item.worn_icon_state || item.icon_state

	// First, let's just check if we've already made this.
	use_custom_worn_icon_cached()
	var/icon/cached_icon = get_custom_worn_icon_cached(human_icon, human_icon_state, item.greyscale_colors || "x")
	if(cached_icon)
		if(!(human_icon_state in icon_states(cached_icon)))
			cached_icon.Insert(cached_icon, icon_state = human_icon_state) // include the expected icon_state
		return cached_icon

	// Get GAGs config
	var/fallback_config = get_custom_worn_config_fallback(item_slot, item)
	if(!fallback_config)
		return null

	// The GAGs config needs this many colors.
	var/expected_num_colors = SSgreyscale.configurations["[fallback_config]"].expected_colors
	// The colors string.
	var/fallback_greyscale_colors

	// If this outfit is already GAGs, use the existing colors.
	if(item.greyscale_colors)
		// Just use the colors already given to us, but re-align to expected colors.
		var/list/colors = SSgreyscale.ParseColorString(item.greyscale_colors)
		var/default_color = (length(colors) >= 1) ? colors[1] : COLOR_DARK
		var/list/final_list = list()
		for(var/i in 1 to expected_num_colors)
			final_list += (i < length(colors)) ? colors[i] : default_color
		fallback_greyscale_colors = final_list.Join("")
	else
		// OK, we have to actually guess the colors.
		var/icon/final_human_icon = icon(human_icon, human_icon_state)
		var/list/color_list = list()

		for(var/i in 1 to expected_num_colors)
			if(isnull(item.species_clothing_color_coords) || \
			length(item.species_clothing_color_coords) < i)
				color_list += COLOR_DARK
				continue
			var/coord = item.species_clothing_color_coords[i]
			color_list += final_human_icon.GetPixel(coord[1], coord[2]) || COLOR_DARK

		fallback_greyscale_colors = color_list.Join("")

	// Finally, render with GAGs
	var/icon/final_icon = icon(SSgreyscale.GetColoredIconByType(get_custom_worn_config_fallback(item_slot, item), fallback_greyscale_colors))
	// Duplicate to the specific icon_state and set.
	final_icon.Insert(final_icon, icon_state = human_icon_state) // include the expected icon_state
	// Cache the clean copy.
	set_custom_worn_icon_cached(human_icon, human_icon_state, item.greyscale_colors || "x", final_icon)

	return final_icon
