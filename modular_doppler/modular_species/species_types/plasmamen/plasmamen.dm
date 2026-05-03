
/datum/species/plasmaman
	name = "Phorid"
	preview_outfit = /datum/outfit/plasmaman_preview

/datum/species/plasmaman/get_species_description()
	return "A species of highly intelligent eukaryotic xenofungi, whose colonies together form sentient beings. \
		In 4CA space, they're usually attached to recycled sophont skeletons, \
		serving as a great calcium-rich substrate for structure and growth."

/datum/species/plasmaman/get_species_lore()
	return list(
		"=== SEE WIKI ARTICLE: Phorid ===",

		"=== TO BE IMPROVED ===",

		"Phorid, also known as Plasmamen, are a species of highly intelligent eukaryotic xenofungi-- \
		they are the result of millions of years of evolution, all contained to the furthest reaches of the known universe. ",

		"They were first discovered by a long distance probe sent out by the 3CA, \
		and have been an ally to the Celestial Alignment ever since, be it for better or for worse.",
	)


/datum/outfit/plasmaman_preview
	name = "Plasmaman (Species Preview)"
	uniform = /obj/item/clothing/under/plasmaman
	head = /obj/item/clothing/head/helmet/space/plasmaman
