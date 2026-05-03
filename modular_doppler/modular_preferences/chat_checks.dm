/proc/chat_name_color_prefs_check(mob/source, mob/hearer, specific_name)
	if(hearer.client?.prefs?.read_preference(/datum/preference/toggle/chat_name_coloring))
		return "<span style='color: [source.chat_color]'><b>[specific_name ? specific_name : source]</b></span>"
	else
		return "<b>[specific_name ? specific_name : source]</b>"
