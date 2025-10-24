/datum/sprite_accessory
	///Unique key of an accessory. All tails should have "tail", ears "ears" etc.
	var/key = null
	///If an accessory is special, it wont get included in the normal accessory lists
	var/special = FALSE
	///Which color we default to on acquisition of the accessory (such as switching species, default color for character customization etc)
	///You can also put down a a HEX color, to be used instead as the default
	var/default_color
	/// Whether or not this sprite accessory has an additional overlay added to
	/// it as an "inner" part, which is pre-colored.
	var/has_inner = FALSE
	color_src = USE_ONE_COLOR
	///Which layers does this accessory affect
	var/relevant_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER, BODY_FRONT_UNDER_CLOTHES_LAYER, ABOVE_BODY_FRONT_HEAD_LAYER)
	///This is used to determine whether an accessory gets added to someone. This is important for accessories that are "None", which should have this set to false
	var/factual = TRUE
	///Use this as a type path to an organ that this sprite_accessory will be associated. Make sure the organ has 'mutantpart_info' set properly.
	var/obj/item/organ/organ_type
	/// Tells the mutant bodypart overlay responsible for us what layers this sprite accessory actually applies to, and what to call the icon_state
	var/list/color_layer_names = list()

/datum/sprite_accessory/New()
	if(!default_color)
		switch(color_src)
			if(USE_ONE_COLOR)
				default_color = DEFAULT_PRIMARY
			if(USE_MATRIXED_COLORS)
				default_color = DEFAULT_MATRIXED
			else
				default_color = "#FFFFFF"
	color_layer_names["1"] = MUTANT_ACCESSORY_NO_AFFIX // Makes sure single color accessories still work
	if(name == SPRITE_ACCESSORY_NONE)
		factual = FALSE
	if(color_src == USE_MATRIXED_COLORS && default_color != DEFAULT_MATRIXED)
		default_color = DEFAULT_MATRIXED
	if(color_src == USE_MATRIXED_COLORS)
		if(!SSaccessories.cached_mutant_icon_files[icon])
			SSaccessories.cached_mutant_icon_files[icon] = icon_states(new /icon(icon))
		for(var/layer in relevant_layers)
			var/layertext
			switch(layer)
				if(BODY_BEHIND_LAYER)
					layertext = "BEHIND"
				if(BODY_ADJ_LAYER)
					layertext = "ADJ"
				else
					layertext = "FRONT"
			if("m_[key]_[icon_state]_[layertext]_2" in SSaccessories.cached_mutant_icon_files[icon])
				color_layer_names["2"] = "2"
			if("m_[key]_[icon_state]_[layertext]_3" in SSaccessories.cached_mutant_icon_files[icon])
				color_layer_names["3"] = "3"
