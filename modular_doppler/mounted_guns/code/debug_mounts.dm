/obj/item/gun/ballistic/automatic/wt550/debug_deployable
	name = "\improper Sindaryo PDW DEPLOYABLE"

/obj/item/gun/ballistic/automatic/wt550/debug_deployable/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deployable_turret, 5 SECONDS, /obj/vehicle/ridden/mounted_turret, 'sound/items/tools/ratchet.ogg')
