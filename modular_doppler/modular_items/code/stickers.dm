
///a parent doppler sticker item so we can populate a doppie sticker pack easily
/obj/item/sticker/doppler
	abstract_type = /obj/item/sticker/doppler
	icon = 'modular_doppler/modular_items/icons/stickers.dmi'

/obj/item/sticker/doppler/dolphin
	name = "dolphin sticker"
	icon_state = "dolphin"

/obj/item/sticker/doppler/horse
	name = "horse sticker"
	icon_state = "horse"

/obj/item/sticker/doppler/pride
	name = "pride flag sticker"
	icon_state = "pride"

/obj/item/sticker/doppler/trans_pride
	name = "trans pride flag sticker"
	icon_state = "trans_pride"

/obj/item/sticker/doppler/marsian
	name = "marsian flag sticker"
	icon_state = "marsian"

/obj/item/sticker/doppler/tizira
	name = "tiziran flag sticker"
	icon_state = "tizira"

/obj/item/sticker/doppler/fourca
	name = "4CA sticker"
	icon_state = "4ca"

///special doppie sticker pack, these will still appear in normal sticker packs anyway
/obj/item/storage/box/stickers/local
	name = "local sector sticker pack"
	icon = 'modular_doppler/modular_items/icons/stickers.dmi'
	///necessary intervention, see below
	var/list/doppler_pack_labels = list(
		"dolphin",
	)

///the parent item populates its illustrate var from a static list, so we override it
/obj/item/storage/box/stickers/local/Initialize(mapload)
	if(isnull(illustration))
		illustration = pick(doppler_pack_labels)
		update_appearance()
	. = ..()

///makes our list of doppie stickers, overrides basically the same code from the parent /obj/item/storage/box/stickers
/obj/item/storage/box/stickers/local/generate_non_contraband_stickers_list()
	var/list/allowed_stickers = list()

	for(var/obj/item/sticker/sticker_type as anything in subtypesof(/obj/item/sticker/doppler))
		if(!sticker_type::exclude_from_random)
			allowed_stickers += sticker_type

	return allowed_stickers

///rhinestones! starting with a parent item for the same purpose as above
/obj/item/sticker/rhinestone
	icon = 'modular_doppler/modular_items/icons/stickers.dmi'

/obj/item/sticker/rhinestone/pink
	name = "pink rhinestone"
	icon_state = "rhinestone_pink"

/obj/item/sticker/rhinestone/purple
	name = "purple rhinestone"
	icon_state = "rhinestone_purple"

/obj/item/sticker/rhinestone/red
	name = "red rhinestone"
	icon_state = "rhinestone_red"

/obj/item/sticker/rhinestone/yellow
	name = "yellow rhinestone"
	icon_state = "rhinestone_yellow"

/obj/item/sticker/rhinestone/blue
	name = "blue rhinestone"
	icon_state = "rhinestone_blue"

/obj/item/sticker/rhinestone/green
	name = "green rhinestone"
	icon_state = "rhinestone_green"

///special boxes for the rhinestones
/obj/item/storage/box/stickers/local/rhinestones
	name = "rhinestone pack"
	doppler_pack_labels = list(
		"rhinestone_pink",
		"rhinestone_purple",
		"rhinestone_red",
		"rhinestone_yellow",
		"rhinestone_blue",
		"rhinestone_green",
	)

///makes a list of rhinestones as above
/obj/item/storage/box/stickers/local/rhinestones/generate_non_contraband_stickers_list()
	var/list/allowed_stickers = list()

	for(var/obj/item/sticker/sticker_type as anything in subtypesof(/obj/item/sticker/rhinestone))
		if(!sticker_type::exclude_from_random)
			allowed_stickers += sticker_type

	return allowed_stickers
