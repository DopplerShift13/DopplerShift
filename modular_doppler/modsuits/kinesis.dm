
/obj/item/mod/module/anomaly_locked/kinesis/weak
	name = "MOD magnalock module"
	desc = "A modular plug-in to the forearm, an experimental unit used for handling cargo and heavy objects. \
		This piece of technology allows the user to generate precise magnetic fields, \
		letting them move objects at a limited range. \
		Oddly enough, it doesn't seem to work on living creatures."
	grab_range = 3
	coreless = TRUE
	prebuilt = TRUE

/obj/item/mod/module/anomaly_locked/kinesis/weak/launch(atom/movable/launched_object)
	return // Does nothing

/datum/design/module/mod_kinesis/weak
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT,
	)
	name = "Magnalock Module"
	id = "mod_kinesis_weak"
	build_path = /obj/item/mod/module/anomaly_locked/kinesis/weak

/datum/techweb_node/mod_engi/New()
	design_ids |= list(
		"mod_kinesis_weak",
	)
	return ..()
