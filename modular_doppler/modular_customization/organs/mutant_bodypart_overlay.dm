// Almost everything here was made by GoldenAlpharex at Nova, hooray to them for doing the work for me

/// The greatest amount of colors that can be in a matrixed bodypart_overlay.
#define MAX_MATRIXED_COLORS 3
/// Default value for alpha, making it fully opaque.
#define ALPHA_OPAQUE 255

/datum/bodypart_overlay/mutant
	/// Alpha value associated to the overlay, to be inherited from the parent limb.
	var/alpha = ALPHA_OPAQUE
	/// A simple list of indexes to color (as we don't want to color emissives, MOD overlays or inner ears)
	var/list/overlay_indexes_to_color
	/// A simple cache of what the last icon_states built were.
	/// It's really only there to help with debugging what's happening.
	var/list/last_built_icon_states

/datum/bodypart_overlay/mutant/get_overlay(layer, obj/item/bodypart/limb)
	layer = bitflag_to_layer(layer)
	var/list/images = get_images(layer, limb)
	color_images(images, layer, limb)
	return images

/// Get the images we need to draw on the person. Called from get_overlay() which is called from _bodyparts.dm.
/// `limb` can be null.
/// This is different from the base procs as it allows for multiple overlays to
/// be generated for one bodypart_overlay. Useful for matrixed color mutant bodyparts.
/datum/bodypart_overlay/mutant/proc/get_images(image_layer, obj/item/bodypart/limb)
	if(!sprite_datum)
		CRASH("Trying to call get_images() on [type] while it didn't have a sprite_datum. This shouldn't happen, report it as soon as possible.")
	var/returned_images = list()
	var/gender = (limb?.limb_gender == FEMALE) ? "f" : "m"
	overlay_indexes_to_color = list()
	var/index = 1
	var/mob/living/carbon/human/owner = limb?.owner
	last_built_icon_states = list()
	switch(sprite_datum.color_src)
		if(USE_MATRIXED_COLORS)
			var/list/color_layer_names = get_color_layer_names(build_icon_state(gender, image_layer))
			for(var/color_index in color_layer_names)
				var/mutable_appearance/color_layer_image = get_singular_image(build_icon_state(gender, image_layer, color_layer_names[color_index]), image_layer, owner)
				returned_images += color_layer_image
				overlay_indexes_to_color += index
				index++
		else
			var/mutable_appearance/image_to_return = get_singular_image(build_icon_state(gender, image_layer, MUTANT_ACCESSORY_NO_AFFIX), image_layer, owner)
			returned_images += image_to_return
			overlay_indexes_to_color += index
	return returned_images

/**
 * Returns the color_layer_names of the sprite_datum associated with our datum.
 * Mainly here so that it can be overriden elsewhere to have other effects.
 */
/datum/bodypart_overlay/mutant/proc/get_color_layer_names(icon_state_to_lookup)
	return sprite_datum.color_layer_names

/// Colors the given overlays list. Limb can be null.
/// This is different from the base procs as it allows for multiple overlays to be colored at once.
/// Useful for matrixed color mutant bodyparts.
/datum/bodypart_overlay/mutant/proc/color_images(list/image/overlays, layer, obj/item/bodypart/limb)
	if(!sprite_datum || !overlays)
		return
	if(limb?.is_husked)
		if(sprite_datum.color_src == USE_MATRIXED_COLORS) //Matrixed+husk needs special care, otherwise we get sparkle dogs
			draw_color = HUSK_COLOR_LIST
		else
			draw_color = limb.husk_color ? limb.husk_color : HUSK_COLOR_TONE
	var/i = 1 // Starts at 1 for color layers.
	alpha = limb?.alpha || ALPHA_OPAQUE
	for(var/index_to_color in overlay_indexes_to_color)
		if(index_to_color > length(overlays))
			break
		var/image/overlay = overlays[index_to_color]
		switch(sprite_datum.color_src)
			if(USE_ONE_COLOR)
				overlay.color = islist(draw_color) ? draw_color[i] : draw_color
				overlay.alpha = alpha
			if(USE_MATRIXED_COLORS)
				overlay.color = islist(draw_color) ? draw_color[i] : draw_color
				overlay.alpha = alpha
				i++
			else
				overlay.color = limb?.color
				overlay.alpha = alpha

/**
 * Helper to generate the icon_state for the bodypart_overlay we're trying to draw.
 *
 * Arguments:
 * * gender - The gender of the limb. Can be "f" or "m".
 * * image_layer - The layer on which the icon will be drawn.
 * * color_layer - The color_layer of this icon_state, if any. Should be either "primary", "secondary", "tertiary" or `null`.
 * Defaults to `null`.
 * * feature_key_suffix - A string that will be directly appended to the result
 * of `get_feature_key_for_overlay()`. Defaults to `null`.
 */
/datum/bodypart_overlay/mutant/proc/build_icon_state(gender, image_layer, color_layer = null, feature_key_suffix = null)
	var/list/icon_state_builder = list()
	icon_state_builder += sprite_datum.gender_specific ? gender : "m" //Male is default because sprite accessories are so ancient they predate the concept of not hardcoding gender
	icon_state_builder += get_feature_key_for_overlay() + feature_key_suffix
	icon_state_builder += get_base_icon_state()
	icon_state_builder += mutant_bodyparts_layertext(image_layer)
	if(color_layer != MUTANT_ACCESSORY_NO_AFFIX)
		icon_state_builder += color_layer
	var/built_icon_state = icon_state_builder.Join("_")
	LAZYADD(last_built_icon_states, built_icon_state)
	return built_icon_state

/**
 * Helper to generate one individual image for a multi-image overlay.
 * Very similar to get_image(), just a little simplified.
 *
 * Arguments:
 * * image_icon_state - The icon_state of the mutable_appearance we want to get.
 * * image_layer - The layer of the mutable_appearance we want to get.
 * * owner - The owner of the limb this is drawn on. Can be null.
 * * icon_override - The icon to use for the mutable_appearance, rather than
 * `sprite_datum.icon`. Default is `null`, and its value will be used if it's
 * anything else.
 */
/datum/bodypart_overlay/mutant/proc/get_singular_image(image_icon_state, image_layer, mob/living/carbon/human/owner, icon_override = null)
	// We get from icon_override if it is filled, and from sprite_datum.icon if not.
	var/mutable_appearance/appearance = mutable_appearance(icon_override || sprite_datum.icon, image_icon_state, layer = image_layer)
	if(sprite_datum.center)
		center_image(appearance, sprite_datum.dimension_x, sprite_datum.dimension_y)
	return appearance

/**
 * Helper to fetch the `feature_key` of the bodypart_overlay, so that it can be
 * overriden in the cases where `feature_key` is not what we want to use here.
 */
/datum/bodypart_overlay/mutant/proc/get_feature_key_for_overlay()
	return sprite_datum?.key || feature_key

#undef MAX_MATRIXED_COLORS
#undef ALPHA_OPAQUE
