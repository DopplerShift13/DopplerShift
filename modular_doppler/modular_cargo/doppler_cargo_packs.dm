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

/datum/supply_pack/imports/tajaran_sword
	name = "Imported Tajaran Duelist Sword"
	desc = "Fresh off the finest Coalition smithies. Possibly folded thousands of times. Great hand \
	protection. Vibrational enhancement features not included."
	contraband = TRUE
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
	/obj/item/storage/belt/tajaran_sheath
	)
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
	crate_name = "Finest Tajaran Imports"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/imports/motorcycle
	name = "Racing Motorcycle"
	desc = "A classic streetbike that's racetrack ready. Ride Smart! Where a helmet!"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/vehicle/ridden/motorcycle,
		/obj/item/clothing/suit/jacket/leather/biker,
		/obj/item/clothing/glasses/hud/ar/aviator,
	)
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
	crate_name = "Triumphant 900cc Streetbike"
	crate_type = /obj/structure/closet/crate/large
