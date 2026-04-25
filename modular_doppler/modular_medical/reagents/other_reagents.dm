/datum/reagent/consumable/sap
	name = "Sap"
	description = "Water saturated with glucose and other nutrients. Used by viridians in their vascular system."
	color = "#d6ba6cff"
	nutriment_factor = 1
	taste_description = "sweet and earthy"
	taste_mult = 1.3
	penetrates_skin = NONE
	ph = 7.4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/// Blood for holosynths
/datum/reagent/hologel
	name = "Hologel"
	description = "The miraculous aerogel Holosynths' use as a canvas for their bodies. It's variably dense, refracting, and responds to electromagnetic controllers."
	taste_description = "Air with a hint of copper"
	taste_mult = 0.5
	color = BLOOD_COLOR_HOLOGEL
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/chemical_reaction/hologel
	results = list(/datum/reagent/hologel = 2.5)
	required_reagents = list(/datum/reagent/oxygen = 4, /datum/reagent/silicon = 1)
	required_catalysts = list(/datum/reagent/medicine/nanite_slurry = 1)
	temp_exponent_factor = 4 // gets hotter as the reaction progresses
	thermic_constant = 600 // gets extremely hot in high quantities
	mix_message = "The mixture bubbles erratically."

/// Blood for androids, child of oil to preserve oil qualities but make it yellow.
/datum/reagent/oil/synth
    name = "Synth Oil"
    description = "The byproduct of synthetic lifeforms processing oil, giving it a yellow hue."
    color = BLOOD_COLOR_SYNTHETIC
