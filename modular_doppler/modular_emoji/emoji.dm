#define MODULAR_EMOJI_SET 'modular_doppler/modular_emoji/emoji.dmi'

/datum/asset/spritesheet_batched/chat/create_spritesheets()
	. = ..()
	insert_all_icons("emoji", MODULAR_EMOJI_SET)

/datum/asset/spritesheet_batched/emojipedia/create_spritesheets()
	. = ..()
	insert_all_icons("", MODULAR_EMOJI_SET)

/datum/computer_file/program/emojipedia/New()
		. = ..()
		var/list/extra = icon_states(icon(MODULAR_EMOJI_SET))
		emoji_list |= extra
