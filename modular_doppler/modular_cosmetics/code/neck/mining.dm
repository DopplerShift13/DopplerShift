GLOBAL_VAR_INIT(liveleak_camera_net_number, 0)

/obj/item/broadcast_camera/mining
	name = "broadcast camera arm"
	desc = "A shoulder-mounted camera arm that broadcasts sight and sound to the station's entertainment network."
	desc_controls = "Right-click to change the broadcast name. Alt-click to toggle microphone."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/neck/mining.dmi'
	icon_state = "camcorder0"
	base_icon_state = "camcorder"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/neck/mining.dmi'
	inhand_icon_state = null
	force = 8
	throwforce = 12
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	slot_flags = NONE
	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_color = COLOR_LIGHT_ORANGE
	light_range = 4
	light_power = 1
	light_on = FALSE
	broadcast_name = "Mining Camera Stream"
	slot_flags = ITEM_SLOT_NECK
	active_microphone = FALSE // Defaults microphone to off

/obj/item/broadcast_camera/mining/Initialize(mapload)
	. = ..()
	var/random_camera_network = "mining_liveleak_[GLOB.liveleak_camera_net_number]"
	GLOB.liveleak_camera_net_number++
	camera_networks = list(random_camera_network)

/datum/orderable_item/mining/liveleak
	purchase_path = /obj/item/broadcast_camera/mining
	cost_per_order = 250
