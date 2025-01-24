/datum/obj/item/disk/tech_disk/license_authenticator_disk
	name = "License Authenticator Disk"
	desc = "A humble disk containing the required licenses to unlock additional printing functionality on Port Authority lathes. Do not lose this."
	armor_type = /datum/armor/disk_nuclear
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

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
