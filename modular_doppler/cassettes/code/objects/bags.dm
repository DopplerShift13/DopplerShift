/obj/item/storage/bag/books/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_total_storage = 21
	atom_storage.max_slots = 7
	atom_storage.set_holdable(list(
		/obj/item/book,
		/obj/item/spellbook,
		/obj/item/poster,
		/obj/item/cassette_tape,
	))
