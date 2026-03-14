/*
	Gives TRAIT_REAGENT_SCANNER which is basically what science goggles do.
*/

/datum/power/expert/eye_for_ingredients
	name = "Eye for Ingredients"
	desc = "You've interacted with food, drinks and/or chemicals so often, you can see at a glance if something's off with it. You can see the precise reagent contents of all containers by simply examining it."
	security_record_text = "Subject has a keen eye for spotting substances inside food, drinks and chemicals."
	value = 3

/datum/power/expert/eye_for_ingredients/add()
	ADD_TRAIT(power_holder, TRAIT_REAGENT_SCANNER, src)

/datum/power/expert/eye_for_ingredients/remove()
	REMOVE_TRAIT(power_holder, TRAIT_REAGENT_SCANNER, src)
