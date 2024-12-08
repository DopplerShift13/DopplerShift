/datum/techweb_node/emergency_fab_designs
	id = TECHWEB_NODE_EMERGENCY_FAB
	display_name = "Emergency Repair Lathe Designs"
	description = "All of the designs that work for the emergency repair lathe."
	design_ids = list(
		"breach_bag_doppla",
		"breach_helmet_doppla",
		"empty_yellow_tank_doppla",
		"door_seal_doppla",
		"damage_fab_plastic_wall_panel",
		"damage_fab_medbed",
		"damage_fab_crowbar",
		"damage_fab_flare",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 50000000000000) // God save you
	hidden = TRUE
	show_on_wiki = FALSE
	starting_node = TRUE

// Breach helmet

/datum/design/breach_helmet_doppla
	name = "Breach Helmet"
	id = "breach_helmet_doppla"
	build_type = DAMAGE_FAB
	build_path = /obj/item/storage/bag/breach_bag
	construction_time = 2 MINUTES
	materials = list()
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ATMOSPHERICS,
	)

// Entire filled breach bag

/datum/design/breach_bag_doppla
	name = "Damage Control Ensemble Bag"
	id = "breach_bag_doppla"
	build_type = DAMAGE_FAB
	build_path = /obj/item/storage/bag/breach_bag
	construction_time = 7 MINUTES
	materials = list()
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ATMOSPHERICS,
	)

// Entire filled breach bag

/datum/design/empty_yellow_tank_doppla
	name = "Empty Internals Tank"
	id = "empty_yellow_tank_doppla"
	build_type = DAMAGE_FAB
	build_path = /obj/item/tank/internals/oxygen/yellow/empty
	construction_time = 1 MINUTES
	materials = list()
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ATMOSPHERICS,
	)

// Door seals

/datum/design/door_seal_doppla
	name = "Door Seal"
	id = "door_seal_doppla"
	build_type = DAMAGE_FAB
	build_path = /obj/item/door_seal
	construction_time = 2 MINUTES
	materials = list()
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)

// Plastic wall panels are good for sealing holes in the wall

/datum/design/damage_fab_plastic_wall
	name = "Plastic Paneling"
	id = "damage_fab_plastic_wall_panel"
	build_type = DAMAGE_FAB
	materials = list()
	build_path = /obj/item/stack/sheet/plastic_wall_panel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	construction_time = 10 SECONDS

// Rollerbeds for saving people

/datum/design/damage_fab_rollerbed
	name = "Emergency Medical Bed"
	id = "damage_fab_medbed"
	build_type = DAMAGE_FAB
	materials = list()
	build_path = /obj/item/emergency_bed
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	construction_time = 1 MINUTES

// Bar with crows in it

/datum/design/damage_fab_rollerbed
	name = "Emergency Crowbar"
	id = "damage_fab_crowbar"
	build_type = DAMAGE_FAB
	materials = list()
	build_path = /obj/item/crowbar/red
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	construction_time = 1 MINUTES

// Flare

/datum/design/damage_fab_flare
	name = "Flare"
	id = "damage_fab_flare"
	build_type = DAMAGE_FAB
	materials = list()
	build_path = /obj/item/flashlight/flare
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING,
	)
	construction_time = 30 SECONDS
