
/*
 * Express-only groceries console for the cantina.
 */
/obj/machinery/computer/order_console/cook/cantina
	name = "Express Produce Console"
	desc = "An interface for ordering fresh produce and other. Costs a bit to get things out here, \
	but it keeps the regulars from complaining and the bartenders from complaining more."
	forced_express = TRUE
	express_cost_multiplier = 1 // We can only order express.
	blackbox_key = "cantina_chef"


/*
 * Artificial Sweeteners.
 * (Poisons for the bartender.)
 */

/obj/item/reagent_containers/cup/bottle/cantina_tetrodotoxin
	name = "tetrodotoxin bottle"
	desc = "A small bottle. Contains tetrodotoxin."
	list_reagents = list(/datum/reagent/toxin/tetrodotoxin = 30)

/obj/item/reagent_containers/cup/bottle/cantina_zombiepowder
	name = "zombie powder bottle"
	desc = "A small bottle. Contains zombie powder."
	list_reagents = list(/datum/reagent/toxin/zombiepowder = 30)

/obj/item/reagent_containers/cup/bottle/cantina_mutetoxin
	name = "mute toxin bottle"
	desc = "A small bottle. Contains mute toxin."
	list_reagents = list(/datum/reagent/toxin/mutetoxin = 30)

/obj/item/reagent_containers/cup/bottle/cantina_itching_powder
	name = "itching powder bottle"
	desc = "A small bottle. Contains itching powder."
	list_reagents = list(/datum/reagent/toxin/itching_powder = 30)

/obj/item/storage/box/cantina_sweeteners
	name = "box of artificial sweeteners"
	desc = "A bartender's secret to keeping the rowdiest customers at bay."
	icon_state = "syndiebox"
	illustration = "beaker"

/obj/item/storage/box/cantina_sweeteners/PopulateContents()
	new /obj/item/reagent_containers/cup/bottle/cantina_mutetoxin(src)
	new /obj/item/reagent_containers/cup/bottle/cantina_itching_powder(src)
	new /obj/item/reagent_containers/cup/bottle/leadacetate(src)
	new /obj/item/reagent_containers/cup/bottle/cyanide(src)
	new /obj/item/reagent_containers/cup/bottle/cantina_tetrodotoxin(src)
	new /obj/item/reagent_containers/cup/bottle/cantina_zombiepowder(src)
	new /obj/item/storage/pill_bottle/painkiller(src)


/*
 * Fridges for the cantina freezer, and objects to spawn in them.
 */

/// Egg box containing chocolate eggs instead.
/obj/item/storage/fancy/egg_box/cantina_chocolate
	spawn_type = /obj/item/food/chocolateegg

/// Pre-dead cantina chicken (for revival by the bartender).
/mob/living/basic/chicken/cantina
	name = "The Unregistered Dragon"

/mob/living/basic/chicken/cantina/Initialize(mapload)
	. = ..()
	death(FALSE)

/// 'Fresh Eggs' fridge. Joke, get the resources from express console.
/obj/structure/closet/secure_closet/freezer/cantina_eggs
	name = "egg fridge"
	desc = "There's a note on the fridge... It mentions something about having difficulty finding \
	'fresh eggs' and 'chocolate', and a lazarus pen in the bartender's closet. Wonder what that's all about."
	req_access = null

/obj/structure/closet/secure_closet/freezer/cantina_eggs/PopulateContents()
	..()
	new /obj/item/storage/fancy/egg_box/cantina_chocolate(src)
	new /obj/item/storage/fancy/egg_box/cantina_chocolate(src)
	new /mob/living/basic/chicken/cantina(src)

/// Meat fridge that additionally contains monkey cubes.
/obj/structure/closet/secure_closet/freezer/cantina_meat
	name = "meat fridge"
	desc = "There's a note on the fridge... It mentions something about using 'denser' storage \
	to make up for the egg fridge, and needing to 'apply water'. Wonder what that's all about."
	req_access = null

/obj/structure/closet/secure_closet/freezer/cantina_meat/PopulateContents()
	..()
	for(var/i in 1 to 4)
		new /obj/item/food/meat/slab/monkey(src)
	new /obj/item/storage/box/monkeycubes(src)


/*
 * Cantina Fax Machine.
 * Can be made visible to the network, but isn't by default.
 */

/obj/machinery/fax/cantina
	name = "Unregistered Fax Machine"
	desc = "Bluespace technologies on the application of evil bureaucracy. \
	This one has been customized to block its network-visibility as needed."
	obj_flags = parent_type::obj_flags | EMAGGED
	visible_to_network = FALSE

/obj/machinery/fax/cantina/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_LMB] = "[visible_to_network ? "H" : "Unh"]ide from network"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/fax/cantina/click_alt(mob/living/user)
	visible_to_network = !visible_to_network
	balloon_alert(user, (visible_to_network ? "fax unhidden" : "fax hidden"))
	return CLICK_ACTION_SUCCESS


/*
 * Cantina Encryption Key. edit key: CANTINA_COMMS
 * Traitor comms only, doesn't block radio, doesn't show station comms.
 */

/obj/item/encryptionkey/syndicate/cantina_headset
	name = "undisclosed encryption key"
	desc = "An encryption key for a radio headset, allowing use of the Curfew and Sundown's network. \
	To avoid any long-term interference, the actual key changes on the regular."
	channels = list(RADIO_CHANNEL_SYNDICATE = 1)
	special_channels = RADIO_SPECIAL_CANTINA_HEADSET

/obj/item/radio/headset/can_receive(input_frequency, list/levels)
	. = ..()
	if(input_frequency != FREQ_SYNDICATE)
		return
	if(special_channels & RADIO_SPECIAL_CANTINA_HEADSET)
		return TRUE


/*
 * Cantina Intercom
 * Allows for listening in on station comms from the cantina.
 */

/obj/item/encryptionkey/syndicate/cantina_intercom
	channels = list(RADIO_CHANNEL_SYNDICATE = 0, RADIO_CHANNEL_COMMAND = 0, RADIO_CHANNEL_SECURITY = 0, RADIO_CHANNEL_ENGINEERING = 0, RADIO_CHANNEL_SCIENCE = 0, RADIO_CHANNEL_MEDICAL = 0, RADIO_CHANNEL_SUPPLY = 0, RADIO_CHANNEL_SERVICE = 0)

/obj/item/radio/intercom/cantina
	name = "listening ear intercom"
	desc = "The Curfew and Sundown's special free-frequency intercom, \
	allowing you to snoop in on practically any local frequency. \
	To maintain customer privacy, however, it is functionally incapable of sending anything."
	icon_state = "intercom_command"
	icon_off = "intercom_command-p"
	freerange = TRUE
	subspace_transmission = TRUE
	keyslot = /obj/item/encryptionkey/syndicate/cantina_intercom

/obj/item/radio/intercom/cantina/Initialize(mapload, ndir, building)
	. = ..()
	recalculateChannels()
	set_broadcasting(FALSE)
	set_listening(FALSE)

/obj/item/radio/intercom/cantina/talk_into_impl(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	return // Can't talked through. Use the holopad, or go to the station!

#define FREQ_LISTENING (1<<0) // Local define in the nonmodular radio file, so, we redo it here.

/obj/item/radio/intercom/cantina/can_receive(input_frequency, list/levels)
	if (input_frequency == frequency)
		return TRUE
	for(var/ch_name in channels)
		if(channels[ch_name] & FREQ_LISTENING)
			if(GLOB.radiochannels[ch_name] == text2num(input_frequency))
				return TRUE
	return FALSE

#undef FREQ_LISTENING

MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/cantina, 27)
