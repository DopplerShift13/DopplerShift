/obj/item/mod/module/storage/civilian
	name = "MOD case civilian storage module"
	desc = "A small storage device fitted to civilian grade MOD control units, provided with \
		the efforts of Nakamura Engineering."
	complexity = 2
	storage_type = /datum/storage/mod_storage/civilian
	required_slots = list(ITEM_SLOT_BELT)
	removable = FALSE

/datum/storage/mod_storage/civilian
	max_specific_storage = WEIGHT_CLASS_SMALL

/obj/item/mod/module/status_readout
	required_slots = list(ITEM_SLOT_BACK|ITEM_SLOT_BELT)
