/obj/item/organ/tongue/grey
	name = "grey tongue"
	desc = "An atrophied tongue found in Greys. It appears to have no real functionality for speaking- at best, tasting"
	liked_foodtypes = RAW | MEAT | SEAFOOD | BUGS | FRUIT
	disliked_foodtypes = GRAIN | CLOTH | GROSS
	organ_traits = list(TRAIT_MUTE)
	modifies_speech = TRUE

/obj/item/organ/tongue/grey/modify_speech(datum/source, list/speech_args)
