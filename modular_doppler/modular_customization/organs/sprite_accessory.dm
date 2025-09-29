/datum/sprite_accessory
	///Unique key of an accessory. All tails should have "tail", ears "ears" etc.
	var/key = null
	///If an accessory is special, it wont get included in the normal accessory lists
	var/special = FALSE
	var/list/recommended_species
	///Which color we default to on acquisition of the accessory (such as switching species, default color for character customization etc)
	///You can also put down a a HEX color, to be used instead as the default
	var/default_color
	///Set this to a name, then the accessory will be shown in preferences, if a species can have it. Most accessories have this
	///Notable things that have it set to FALSE are things that need special setup, such as genitals
	var/generic
	/// Whether or not this sprite accessory has an additional overlay added to
	/// it as an "inner" part, which is pre-colored.
	var/has_inner = FALSE
	/// For all the flags that you need to pass from a sprite_accessory to an organ, when it's linked to one.
	/// (i.e. passing through the fact that a snout should or shouldn't use a muzzled sprite for head worn items)
	var/flags_for_organ = NONE
	color_src = USE_ONE_COLOR
	///Which layers does this accessory affect
	var/relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER, BODY_FRONT_UNDER_CLOTHES_LAYER, ABOVE_BODY_FRONT_HEAD_LAYER)
	///This is used to determine whether an accessory gets added to someone. This is important for accessories that are "None", which should have this set to false
	var/factual = TRUE
	///Use this as a type path to an organ that this sprite_accessory will be associated. Make sure the organ has 'mutantpart_info' set properly.
	var/obj/item/organ/organ_type
	///Set this to true to make an accessory appear as color customizable in preferences despite advanced color settings being off, will also prevent the accessory from being reset
	var/always_color_customizable
	///Whether this feature is genetic, and thus modifiable by DNA consoles
	var/genetic = FALSE
	var/uses_emissives = FALSE
	var/color_layer_names

/datum/sprite_accessory/New()
	if(!default_color)
		switch(color_src)
			if(USE_ONE_COLOR)
				default_color = DEFAULT_PRIMARY
			if(USE_MATRIXED_COLORS)
				default_color = DEFAULT_MATRIXED
			else
				default_color = "#FFFFFF"
	if(name == SPRITE_ACCESSORY_NONE)
		factual = FALSE
	if(color_src == USE_MATRIXED_COLORS && default_color != DEFAULT_MATRIXED)
		default_color = DEFAULT_MATRIXED
	if(color_src == USE_MATRIXED_COLORS)
		color_layer_names = list()
		if (!SSaccessories.cached_mutant_icon_files[icon])
			SSaccessories.cached_mutant_icon_files[icon] = icon_states(new /icon(icon))
		for (var/layer in relevent_layers)
			var/layertext = layer == BODY_BEHIND_LAYER ? "BEHIND" : (layer == BODY_ADJ_LAYER ? "ADJ" : "FRONT")
			if ("m_[key]_[icon_state]_[layertext]" in SSaccessories.cached_mutant_icon_files[icon])
				color_layer_names["1"] = MUTANT_ACCESSORY_NO_AFFIX
			if ("m_[key]_[icon_state]_[layertext]_2" in SSaccessories.cached_mutant_icon_files[icon])
				color_layer_names["2"] = "2"
			if ("m_[key]_[icon_state]_[layertext]_3" in SSaccessories.cached_mutant_icon_files[icon])
				color_layer_names["3"] = "3"
