
/datum/species/ethereal
	name = "Crystalline"
	preview_outfit = /datum/outfit/ethereal_preview

/datum/species/ethereal/get_species_description()
	return "A species of humanoid bipedals with a fleshy, translucent outer layer giving way to crystalline bones and organs. \
		Being nearly see-through, they are known to produce a very bright glow due to their innards- particularly, their luminescent electrolyte blood. \
		Generally, their color will stay with them their entire life. \
		Their flesh's appearance is roughly glassy, but poor in durability- squishier than a human. \
		Notably, they do not require food or water, instead absorbing electricity from their surroundings."

/datum/species/ethereal/get_species_lore()
	return list(
		"=== SEE WIKI ARTICLE: Ethereal ===",

		"Shortened Description:",

		"Known as Ethereals, these sprout from the highly scenic, highly beautiful death world of Where All Is Found – Otherwise known as ‘Allhome.’",

		"As a whole, they are known for their unusual piezoelectric anatomy, as well as being one of the only races in the Orion Spur to be nearly immortal. \
		Their homeworld, one of the most lethal planets ever discovered, was only recently contacted less than a century ago- \
		in the form of a crashed research outpost belonging to the NanoTrasen Corporation.",

		"Ethereals, to put it informally, are the ultimate unemployed friend at 2PM on a Thursday. \
		Most of them, at least those that are from Allhome itself, are to be less thought of as ‘an alien’ and more like ‘some kind of faelike creature.’ \
		Try being as unusual as you can be. \
		In terms of first contact, you're free to be an Ethereal from any end of opinions about them. \
		Many regard it as ‘generally the worst thing that’s happened,' and can be rather vengeful about it. \
		On the note, many Ethereals are either unused to danger such as willful murder, or have died possibly a dozen or more times due to environmental factors. \
		Allhome is fantastically lethal, after all.",
	)

/datum/species/ethereal/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.dna.features["ethcolor"] = GLOB.color_list_ethereal["Green"]
	refresh_light_color(human_for_preview)
	human_for_preview.set_hairstyle("Lila", update = TRUE)
	regenerate_organs(human_for_preview)
	human_for_preview.update_body(is_creating = TRUE)


/datum/outfit/ethereal_preview
	name = "Ethereal (Species Preview)"
	uniform = /obj/item/clothing/under/frontier_colonist
	head = /obj/item/clothing/head/soft/frontier_colonist
