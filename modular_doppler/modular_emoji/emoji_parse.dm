/proc/emoji_parse_modular(text)
	if(!text || !CONFIG_GET(flag/emojis))
		return text

	var/static/list/emojis = icon_states(icon(MODULAR_EMOJI_SET))
	var/parsed = ""
	var/pos = 1
	var/search

	while(TRUE)
		search = findtext(text, ":", pos)
		parsed += copytext(text, pos, search)
		if(!search)
			break

		pos = search
		search = findtext(text, ":", pos + 1)
		if(!search)
			break

		var/emoji = LOWER_TEXT(copytext(text, pos + 1, search))
		if(emoji in emojis)
			var/datum/asset/spritesheet_batched/sheet = get_asset_datum(/datum/asset/spritesheet_batched/chat)
			var/tag = sheet.icon_tag("[emoji]")
			if(tag)
				parsed += tag
				pos = search + 1
				continue

		parsed += copytext(text, pos, search)
		pos = search

	return parsed
