/datum/storage/bandolier_belt/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/ammo_casing,
	))

/obj/item/storage/belt/bandolier/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_casing/shotgun/buckshot = 17,
	), src)
