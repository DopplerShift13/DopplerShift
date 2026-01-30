/datum/emojipedia_addition
	New()
		. = ..()
		var/list/extra = icon_states(icon('modular_doppler/modular_emoji/emoji.dmi'))
		/datum/computer_file/program/emojipedia::emoji_list |= extra

var/global/datum/emojipedia_addition/_emojipedia_addition = new
