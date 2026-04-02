/datum/computer_file/program/emojipedia/New()
		. = ..()
		var/list/extra = icon_states(icon(MODULAR_EMOJI_SET))
		emoji_list |= extra
