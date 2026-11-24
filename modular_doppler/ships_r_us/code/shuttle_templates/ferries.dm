/datum/map_template/shuttle/personal_buyable/ferries
	personal_shuttle_type = PERSONAL_SHIP_TYPE_FERRY
	port_id = "ferry"

// Little people mover

/datum/map_template/shuttle/personal_buyable/ferries/people_mover
	name = "CAS Hafila"
	description = "A small shuttle made for transporting things and people short distances, usually \
		between stations. Many stations that lack an automated ferry and cargo shuttle use something like \
		this one, so it's certain to not disappoint."
	credit_cost = CARGO_CRATE_VALUE * 8
	suffix = "hafila"
	width = 15
	height = 9
	personal_shuttle_size = PERSONAL_SHIP_MEDIUM

/area/shuttle/personally_bought/people_mover
	name = "CAS Hafila"

// Personal ship with some commodities

/datum/map_template/shuttle/personal_buyable/ferries/house_boat
	name = "CAS Manzil"
	description = "A small shuttle made to be someone's home in the stars, if that home in the stars \
		was smaller than your typical stay at Moruga Apartments. Comes with coffee machine, which makes \
		the extra credits you paid for this one worth it."
	credit_cost = CARGO_CRATE_VALUE * 10
	suffix = "manzil"
	width = 15
	height = 9
	personal_shuttle_size = PERSONAL_SHIP_MEDIUM

/area/shuttle/personally_bought/house_boat
	name = "CAS Manzil"

// Basically, a private jet

/datum/map_template/shuttle/personal_buyable/ferries/private_liner
	name = "CAS Khasun"
	description = "A small shuttle for important person, and a few other not so important people. \
		Comes with a small hold at the front in order to carry things like expensive band equipment, \
		science exhibits, stolen artefacts, and other cargo you can't trust a moving company with."
	credit_cost = CARGO_CRATE_VALUE * 12
	suffix = "khasun"
	width = 23
	height = 10
	personal_shuttle_size = PERSONAL_SHIP_MEDIUM

/area/shuttle/personally_bought/private_liner
	name = "CAS Khasun"

/datum/map_template/shuttle/personal_buyable/ferries/luxury_courier
	name = "TRS Majestic"
	description = "A comfortably quaint shuttle for a literal prince. \
		An Post-Shattering design made by Parigari paws, luxury over everything else. \
		Servants not included."
	credit_cost = CARGO_CRATE_VALUE * 24
	suffix = "tajaran"
	width = 23
	height = 11
	personal_shuttle_size = PERSONAL_SHIP_MEDIUM

/area/shuttle/personally_bought/luxury_courier
	name = "TRS Majestic"
	ambient_buzz = 'modular_doppler/ships_r_us/sound/amb_ship_luxury.ogg'
	// Some audiomixing I did since the default buzz does NOT fit this ship. Copyright free room noise from soundfx. Copyright free and human-made background music from Ethereal 88.
