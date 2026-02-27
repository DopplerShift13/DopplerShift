/datum/power/aberrant_root/beastial
	name = "Beastkindred"
	desc = "You have the traits of an animal; and with it, the apetite of one. In addition to your species normal preferences, you now like the following food based on your choice.\
	Herbivore: Vegetables & Fruit. \
	Carnivore: Raw, Gore, Meat & Bugs."
	value = 2

/datum/power/aberrant_root/beastial/add(client/client_source)
	var/obj/item/organ/tongue/tongue = power_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	var/liked_foodtypes = tongue.liked_foodtypes
	tongue.liked_foodtypes |= RAW | GORE
	tongue.disliked_foodtypes = NONE

/datum/power/aberrant_root/beastial/remove()
	var/obj/item/organ/tongue/tongue = power_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.liked_foodtypes = initial(tongue.liked_foodtypes)
	tongue.disliked_foodtypes = initial(tongue.disliked_foodtypes)
