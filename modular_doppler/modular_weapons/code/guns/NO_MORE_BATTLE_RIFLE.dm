/obj/item/gun/ballistic/automatic/battle_rifle/Initialize(mapload)
	. = ..()
	var/obj/new_rifle = new /obj/item/gun/ballistic/automatic/marcielle(get_turf(src))
	new_rifle.pixel_y = pixel_y
	return INITIALIZE_HINT_QDEL

// This is where I send tech designs to super hell
/datum/techweb_node/techweb_eternal_super_damnation
	id = "techweb_eternal_super_damnation"
	display_name = "RND Super Hell"
	description = "I didn't know the research server had a trash bin function!"
	design_ids = list(
		"c38_true_strike_mag",
		"c38_hotshot_mag",
		"c38_trac_mag",
		"c38_true_strike",
		"c38_hotshot",
		"c38_trac",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 50000000000000) // God save you
	hidden = TRUE
	show_on_wiki = FALSE
	starting_node = FALSE
