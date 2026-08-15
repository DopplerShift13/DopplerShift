/obj/machinery/door/poddoor/bitrunning_player_barrier
	name = "unsubtle loading barrier"
	desc = "An ominous fog that can barely be seen through, likely displayed due to the following area still loading. Maybe wait a little bit?"
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "pyroclastic"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/bitrunning_player_barrier/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/machinery/door/poddoor/bitrunning_player_barrier/screwdriver_act(mob/living/user, obj/item/tool)
	return

/obj/machinery/door/poddoor/bitrunning_player_barrier/crowbar_act(mob/living/user, obj/item/tool)
	return

/obj/machinery/door/poddoor/bitrunning_player_barrier/welder_act(mob/living/user, obj/item/tool)
	return

/obj/machinery/door/poddoor/bitrunning_player_barrier/open(mob/living/user, obj/item/tool)
	qdel(src)
