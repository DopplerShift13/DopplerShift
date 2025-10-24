/obj/item/organ/appendix/pod
	name = "viridian vestigial organ"
	desc = "Doesn't seem to have a purpose."
	foodtype_flags = PODPERSON_ORGAN_FOODTYPES
	color = COLOR_LIME

/obj/item/organ/appendix/pod/Initialize(mapload)
	. = ..()
	// this could be anything... anything. still useless though
	name = pick("viridian endoplasmic reticulum", "viridian golgi apparatus", "viridian plastid", "viridian vesicle")
