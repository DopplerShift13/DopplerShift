/datum/obj/item/disk/tech_disk/license_authenticator_disk
	name = "License Authenticator Disk"
	desc = "A humble disk containing the required licenses to unlock additional printing functionality on Port Authority lathes. Do not lose this."
	armor_type = /datum/armor/disk_nuclear
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	/obj/item/disk/tech_disk/license_authenticator_disk/Initialize(mapload)
		. = ..()
		AddComponent(/datum/component/stationloving)
	/obj/item/disk/tech_disk/license_authenticator_disk/examine(mob/user)
	. = ..()
	if(isobserver(user) || HAS_STATUS_TRAIT(user, TRAIT_ROD_SUPLEX))
		, += span_warning("Imagine having to re-invent the wheel. Good thing we invented digital storage.")

/datum/techweb/shift_start
	id = "License Library"
	organization = "Port Authority"
	should_generate_points = FALSE
/datum/techweb/shift_start/New()
. = ..()
	for(var/i in SSresearch.techweb_nodes)
		var/datum/techweb_node/TN = SSresearch.techweb_nodes[i]
		research_node(TN, TRUE, TRUE, FALSE)
	for(var/i in SSresearch.point_types)
		research_points[i] = INFINITY
	hidden_nodes = list()
