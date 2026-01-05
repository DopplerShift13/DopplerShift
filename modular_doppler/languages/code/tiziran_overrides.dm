/obj/structure/sign/poster/contraband/babel_device
	desc = "A poster advertising Linguafacile's new Babel Device model. 'Calibrated for excellent performance on all Human languages, as well as most common variants of Khaishhs and Mothic!'"

/obj/item/food/lizard_fries
	desc = "One of the many human foods to make its way to the lizards was french fries, which are called poms-franzisks in Khaishhs. When topped with barbecued meat and sauce, they make a hearty meal."

/obj/structure/statue/dragonman
	desc = "Statue of a Tiziran humanoid warrior. Its glittering eyes seem to follow you around the room."

/datum/holiday/draconic_day
	name = "Khaishhs Language Day"

/datum/holiday/draconic_day/greet()
	return "On this day, Tizirans celebrates their language with literature and other cultural works."

/datum/holiday/draconic_day/getStationPrefix()
	return pick("Tiziran", "Literature", "Reading")
