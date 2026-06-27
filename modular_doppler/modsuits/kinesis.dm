
/obj/item/mod/module/anomaly_locked/kinesis/weak
	name = "MOD magnalock module"
	desc = "A modular plug-in to the forearm, an experimental unit used for handling cargo and heavy objects. \
		This piece of technology allows the user to generate precise magnetic fields, \
		letting them move objects at a limited range. \
		Oddly enough, it doesn't seem to work on living creatures."
	coreless = TRUE
	prebuilt = TRUE

/obj/item/mod/module/anomaly_locked/kinesis/weak/launch(atom/movable/launched_object)
	playsound(launched_object, 'sound/effects/magic/repulse.ogg', 100, TRUE)
	RegisterSignal(launched_object, COMSIG_MOVABLE_IMPACT, PROC_REF(launch_impact))
	var/turf/target_turf = get_turf_in_angle(get_angle(mod.wearer, launched_object), get_turf(src), 10)
	launched_object.throw_at(target_turf, range = grab_range / 2, speed = 1, thrower = mod.wearer, spin = isitem(launched_object))

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
