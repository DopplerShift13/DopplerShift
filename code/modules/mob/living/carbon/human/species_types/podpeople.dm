/datum/species/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "\improper Podperson"
	plural_form = "Podpeople"
	id = SPECIES_PODPERSON
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_PLANT_SAFE,
	)
	mutant_organs = list(
		/obj/item/organ/pod_hair = "None",
	)
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_PLANT
	inherent_factions = list(FACTION_PLANTS, FACTION_VINES)

	heatmod = 1.5
	payday_modifier = 1.0
	meat = /obj/item/food/meat/slab/human/mutant/plant
	exotic_bloodtype = BLOOD_TYPE_H2O
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/plant

	mutantappendix = /obj/item/organ/appendix/pod
	mutantbrain = /obj/item/organ/brain/pod
	mutantears = /obj/item/organ/ears/pod
	mutanteyes = /obj/item/organ/eyes/pod
	mutantheart = /obj/item/organ/heart/pod
	mutantliver = /obj/item/organ/liver/pod
	mutantlungs = /obj/item/organ/lungs/pod
	mutantstomach = /obj/item/organ/stomach/pod
	mutanttongue = /obj/item/organ/tongue/pod

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/pod,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/pod,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/pod,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/pod,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/pod,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/pod,
	)

/datum/species/pod/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features[FEATURE_MUTANT_COLOR] = "#886600"
	human.dna.features[FEATURE_POD_HAIR] = "Rose"
	human.update_body(is_creating = TRUE)

/datum/species/pod/get_physical_attributes()
	return "Viridians are in many ways the inverse of shadows, healing in light and starving with the dark. \
		Their bodies are like tinder and easy to char."

/datum/species/pod/get_species_description()
	return 	"Viridians are a species of sapient plants-- \
		the result of an encounter between carefree experimentation by the Ordoht and the modern technology involved in genetically modified crops. \
		Ordoht scientists, having no concept of ownership over intellectual property and no desire to keep their experiments from ‘spreading,’ ended up later having their work reflected in the highly mutagenic nature of plants designed to grow in space.",

/datum/species/pod/get_species_lore()
	return list(
		"Viridians are a wide-ranging species of sapient plants. Ranging from humanoid, to non-humanoid, the description of a Viridian is incredibly loose.",

		"They draw from pre-existing plant species, the term 'cultivars' used to categorize their variations. \
		Cultivars vary widely in features, culture, and personalities. Cultivars can evolve into a number of niches, depending on their environments.\
		Usually, cultivars on certain planets or in certain environments form communities to assist eachother.",

		"Viridians are highly sensitive to their environments, poor environments plagued by pollution, pests, or fungal infection, quickly weakening or killing Viridians.\
		This makes Viridians rather specific and demanding, environments like space stations and ships leaving them homesick, as the lack of natural light and atmospheric systems\
		are not natural."

		"Within the 4CA and outside of it, Viridians are commonly found working in fields of agriculture, ecological protection, and botanical research."

		"Despite the plant-like nature and peace other species may expect from Viridians, many oppose the ecological damage caused by terraforming and the expansion of other species,\
		be it trying to at least direct the efforts, or in more radical cases, do acts of ecoterrorism."
	)

/datum/species/pod/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "lightbulb",
		SPECIES_PERK_NAME = "Photosynthetic",
		SPECIES_PERK_DESC = "As long as you are conscious, and within a well-lit area, you will slowly heal brute, burn, toxin and oxygen damage and gain nutrition - and never get fat! \
		However, if you are LOW on nutrition, you will progressively take brute damage until you die or enter the light once more."
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "biohazard",
		SPECIES_PERK_NAME = "Weedkiller Susceptability",
		SPECIES_PERK_DESC = "Being a floral life form, you are susceptable to anti-florals and will take extra toxin damage from it!"
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "briefcase-medical",
		SPECIES_PERK_NAME = "Semi-Complex Biology",
		SPECIES_PERK_DESC = "Your biology is extremely complex, making ordinary health scanners unable to scan you. Make sure the doctor treating you either has a \
		plant analyzer or a advanced health scanner!"
	))

	return to_add
