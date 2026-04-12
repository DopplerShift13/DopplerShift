/datum/species/pod
	exotic_bloodtype = BLOOD_TYPE_SAP
	digitigrade_customization = DIGITIGRADE_OPTIONAL

	digi_leg_overrides = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/pod,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/pod,
	)

/datum/species/pod/get_species_description()
	return 	"Viridians are a species of sapient plants-- \
		the result of an encounter between carefree experimentation by the Ordoht and the modern technology involved in genetically modified crops. \
		Ordoht scientists, having no concept of ownership over intellectual property and no desire to keep their experiments from ‘spreading’, ended up later having their work reflected in the highly mutagenic nature of plants designed to grow in space."

/datum/species/pod/get_species_lore()
	return list(
		"Viridians are a wide-ranging species of sapient plants. Ranging from humanoid, to non-humanoid, the description of a Viridian is incredibly loose.",

		"They draw from pre-existing plant species, the term 'cultivars' used to categorize their variations. \
		Cultivars vary widely in features, culture, and personalities. Cultivars can evolve into a number of niches, depending on their environments.\
		Usually, cultivars on certain planets or in certain environments form communities to assist eachother.",

		"Viridians are highly sensitive to their environments, poor environments plagued by pollution, pests, or fungal infection, quickly weakening or killing Viridians.\
		This makes Viridians rather specific and demanding, environments like space stations and ships leaving them homesick, as the lack of natural light and atmospheric systems\
		are not natural.",

		"Within the 4CA and outside of it, Viridians are commonly found working in fields of agriculture, ecological protection, and botanical research.",

		"Despite the plant-like nature and peace other species may expect from Viridians, many oppose the ecological damage caused by terraforming and the expansion of other species,\
		be it trying to at least direct the efforts, or in more radical cases, do acts of ecoterrorism."
	)
