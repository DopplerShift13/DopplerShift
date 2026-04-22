
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

///special doppie sticker pack, these will still appear in normal sticker packs anyway. parent type first.
/obj/item/storage/box/stickers/doppler
	abstract_type = /obj/item/storage/box/stickers/doppler
	icon = 'modular_doppler/modular_items/icons/stickers.dmi'
	///the parent item populates its illustration var from a static list, this var allows us to define a new list
	var/list/doppler_pack_labels = list(
		"dolphin",
	)
	/// The base type from which we pick subtypes to spawn.
	var/spawned_sticker_basetype = /obj/item/sticker/doppler

///the parent item populates its illustration var from the aforementioned static list, so we override it
/obj/item/storage/box/stickers/doppler/Initialize(mapload)
	if(isnull(illustration))
		illustration = pick(doppler_pack_labels)
		update_appearance()
	. = ..()

///makes our list of doppie stickers, overrides basically the same code from the parent /obj/item/storage/box/stickers
/obj/item/storage/box/stickers/doppler/generate_non_contraband_stickers_list()
	var/list/allowed_stickers = list()

	for(var/obj/item/sticker/sticker_type as anything in subtypesof(spawned_sticker_basetype))
		if(!sticker_type::exclude_from_random)
			allowed_stickers += sticker_type

	return allowed_stickers

/// PopulateContents() on the parent item uses a static list, meaning the first pack that's spawned into the round decides the sticker pool
/// for every other one. We override this with the same block and a non-static list.

/obj/item/storage/box/stickers/doppler/PopulateContents()
	var/list/non_contraband

	if(isnull(non_contraband))
		non_contraband = generate_non_contraband_stickers_list()

	for(var/i in 1 to rand(4, 8))
		var/type = pick(non_contraband)
		new type(src)

/obj/item/storage/box/stickers/doppler/local
	name = "local sector sticker pack"

///rhinestones! starting with a parent item for the same purpose as above
/obj/item/sticker/rhinestone
	abstract_type = /obj/item/sticker/rhinestone
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
/obj/item/storage/box/stickers/doppler/rhinestones
	name = "rhinestone pack"
	doppler_pack_labels = list(
		"rhinestone_pink",
		"rhinestone_purple",
		"rhinestone_red",
		"rhinestone_yellow",
		"rhinestone_blue",
		"rhinestone_green",
	)
	spawned_sticker_basetype = /obj/item/sticker/rhinestone
