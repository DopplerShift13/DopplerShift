/datum/element/dusts_on_leaving_area
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	var/list/area_types = list()

/datum/element/dusts_on_leaving_area/Attach(datum/attached_mob, types)
	. = ..()

	if(!ismob(attached_mob))
		return ELEMENT_INCOMPATIBLE

	area_types = types
	RegisterSignal(attached_mob, COMSIG_ENTER_AREA, PROC_REF(check_dust))

/datum/element/dusts_on_leaving_area/Detach(mob/attached_mob)
	. = ..()
	UnregisterSignal(attached_mob, COMSIG_ENTER_AREA)

/datum/element/dusts_on_leaving_area/proc/check_dust(datum/source, area/current_area)
	SIGNAL_HANDLER

	var/mob/living/living_source = source
	if(!istype(living_source) || (current_area.type in area_types))
		return

	living_source.investigate_log("was dusted due to leaving their valid areas.", INVESTIGATE_DEATHS)
	living_source.dust(just_ash = TRUE, force = TRUE)
