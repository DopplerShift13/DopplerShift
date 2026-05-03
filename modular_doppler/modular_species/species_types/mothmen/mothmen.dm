/datum/species/moth
	name = "Lepidopteran"
	preview_outfit = /datum/outfit/moth_preview
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
	)
	exotic_bloodtype = BLOOD_TYPE_INSECTOID

/datum/species/moth/get_species_description()
	return "An insectoid species with hairy exoskeletal bodies strongly adapted to a lifetime of space travel. \
		They're easily identified by their highly sensitive compound eyes, weak wings only useful in microgravity, \
		and their faces' dexterous palps and proboscis."

/datum/species/moth/get_species_lore()
	return list(
		"=== SEE WIKI ARTICLE: Veniri ===",

		"Shortened Description:",

		"Veniri are space-faring nomads, traversing the world in a massive fleet comprised of some of the largest ships in Known Space, \
		most of them meticulously cobbled-together from what they can recycle or otherwise make use of.",

		"An intensely collectivist culture within their Grand Nomad Fleet, the Veniri are intensely focused on shared resources and effort-- \
		preferring to think of things in terms of ‘we’ rather than ‘I.’",
	)


/datum/outfit/moth_preview
	name = "Moth (Species Preview)"
	head = /obj/item/clothing/head/costume/garland/poppy
	suit = /obj/item/clothing/suit/hooded/wintercoat/hydro
	uniform = /obj/item/clothing/under/rank/civilian/hydroponics/skirt

/datum/species/moth/prepare_human_for_preview(mob/living/carbon/human/moth_for_preview)
	moth_for_preview.dna.features[FEATURE_MUTANT_COLOR] = "#74828b"
	moth_for_preview.dna.wing_type = "Moth Wings"
	moth_for_preview.dna.features["moth_wings"] = "Royal"
	moth_for_preview.dna.features["moth_antennae"] = "Royal"
	moth_for_preview.dna.features["moth_markings"] = "Royal"
	moth_for_preview.set_haircolor("#CCECFF", update = FALSE)
	moth_for_preview.set_hairstyle("Cotton (Alt)", update = TRUE)
	regenerate_organs(moth_for_preview)
	moth_for_preview.update_body(is_creating = TRUE)
