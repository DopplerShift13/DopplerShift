/datum/sprite_accessory/ears_more/bunny
	icon = 'modular_doppler/modular_customization/accessories/icons/non_species_specific/leporid/leporid_ears.dmi'

/datum/sprite_accessory/ears_more/bunny/rabbit1
	name = "Rabbit (Classic)"
	icon_state = "rabbit1"

/datum/sprite_accessory/ears_more/bunny/bunny1
	name = "Lop"
	icon_state = "bunny1"

/datum/sprite_accessory/ears_more/bunny/bunny2
	name = "Lop (Sexy)"
	icon_state = "bunny2"

/datum/sprite_accessory/ears_more/bunny/big // big .dmi starts here
	icon = 'modular_doppler/modular_customization/accessories/icons/non_species_specific/leporid/leporid_ears_big.dmi'
	name = "Lop (Big)"
	icon_state = "rabbit_large"
	zooms_out_character_preview = FALSE //ok this is a little awkward
	// because these are the parent of the big subtype but also lop ears so niche case that doesn't need zooming. lol

/datum/sprite_accessory/ears_more/bunny/big/rabbit
	name = "Bunny (Tall)"
	icon_state = "bunny_large"
	zooms_out_character_preview = TRUE
