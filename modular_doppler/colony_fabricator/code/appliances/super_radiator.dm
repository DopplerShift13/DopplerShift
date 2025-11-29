/obj/structure/tizirian_radiator
	name = "Portable Heat Radiator"
	desc = "A portable device that, once activated, will bathe the nearby area in a glowing heat \
		usually only comfortable for it's Tizirian creators."
	density = TRUE

/obj/structure/tizirian_radiator/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/powerful_heat_radiator)
