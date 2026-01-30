/datum/asset/spritesheet_batched/chat/create_spritesheets()
	. = ..()
	insert_all_icons("emoji", 'modular_doppler/modular_emoji/emoji.dmi')

/datum/asset/spritesheet_batched/emojipedia/create_spritesheets()
	. = ..()
	insert_all_icons("", 'modular_doppler/modular_emoji/emoji.dmi')
