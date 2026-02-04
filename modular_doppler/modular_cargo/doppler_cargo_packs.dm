/datum/supply_pack/security/shortsword
	name = "Shortsword Crate"
	desc = "Two security sheathes, with two security shortswords each. Very good at causing suspects to bleed out."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/storage/belt/secsword/deathmatch = 2) //4 swords total
	crate_name = "shortsword crate"

/datum/supply_pack/organic/lavalandsamples
	name = "Thermophytic Seeds Crate"
	desc = "A box of plant and mushroom samples that thrive in extreme heat and volcanic soil. Great for \
	harvesting cytology-related chemicals and making a mushroom stirfry, not-so-great for planting in an icy tundra."
	cost = CARGO_CRATE_VALUE * 9 //the price of failing to snoop around the mining base hard enough
	access_view = ACCESS_HYDROPONICS
	contains = list(
		/obj/item/seeds/lavaland/polypore,
		/obj/item/seeds/lavaland/porcini,
		/obj/item/seeds/lavaland/inocybe,
		/obj/item/seeds/lavaland/ember,
		/obj/item/seeds/lavaland/seraka,
		/obj/item/seeds/lavaland/fireblossom,
		/obj/item/seeds/lavaland/cactus,
	)
	crate_name = "thermophytic seeds crate"
	crate_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/service/lubedrum
	name = "Drum of Lube"
	desc = "Contains a fifty-five gallon drum filled with industrial space-grade lubricant. Cherry flavor."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/structure/reagent_dispensers/lubedrum)
	crate_name = "lube drum crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/hugelubedrum
	name = "Drum of Lube of Unusual Size"
	desc = "Contains a two hundred seventy-five gallon drum filled with industrial space-grade lubricant. Cherry flavor. Handle with care."
	cost = CARGO_CRATE_VALUE * 30 // while only five times the volume of a standard drum, it should cost way more for comedy factor
	contains = list(/obj/structure/reagent_dispensers/lubedrum/large)
	crate_name = "xxxxl lube drum crate"
