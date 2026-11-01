
// Paired with non-modular edits to:
// - `code/datums/storage/subtypes/holsters.dm`, detective holster storage

// Spawn ammo stacks used for replacement detective revolver.
/obj/item/storage/belt/holster/detective/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/ammo_stack/c6ng/full = 2,
		/obj/item/gun/ballistic/revolver/c38/detective = 1,
	), src)
