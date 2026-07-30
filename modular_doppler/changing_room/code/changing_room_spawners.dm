/obj/effect/mob_spawn/ghost_role/human/changing_room
	name = "Changing Room Sleeper"
	prompt_name = "a changing room dreamer"
	infinite_use = TRUE
	deletes_on_zero_uses_left = FALSE
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	density = FALSE
	//spawner_job_path = /datum/job/changing_room
	outfit = /datum/outfit/changing_room
	you_are_text = "You are in the changing room dreamscape."
	flavour_text = "Try on some outfits and see how you look!"
	allow_loadout = TRUE
	allow_prefs = TRUE

/obj/effect/mob_spawn/ghost_role/human/changing_room/special(mob/living/spawned_human, mob/mob_possessor, apply_prefs)
	. = ..()
	if(!spawned_human.client)
		return

	spawned_human.AddElement(/datum/element/dusts_on_catatonia)
	var/area/current_area = get_area(src)
	spawned_human.AddElement(/datum/element/dusts_on_leaving_area, list(current_area.type) + GLOB.changing_room_areas)

	spawned_human.RegisterSignal(spawned_human, COMSIG_MOVABLE_USING_RADIO, TYPE_PROC_REF(/mob/living, on_using_radio))
	spawned_human.add_traits(list(TRAIT_SIXTHSENSE, TRAIT_FREE_GHOST, TRAIT_NOBREATH), TRAIT_GHOSTROLE)

	to_chat(spawned_human,span_warning("<b>Ghosting is free!</b>"))


/mob/living/proc/on_using_radio(atom/movable/talking_movable)
	SIGNAL_HANDLER

	var/area/target_area = get_area(talking_movable)
	if(target_area.type in GLOB.changing_room_areas)
		return COMPONENT_CANNOT_USE_RADIO


/datum/outfit/changing_room
	name = "Changing Room"
	uniform = /obj/item/clothing/under/chameleon
	shoes = /obj/item/clothing/shoes/chameleon
	back = /obj/item/storage/backpack/chameleon
	backpack_contents = list(/obj/item/storage/box/syndie_kit/chameleon/changing_room = 1)


/datum/outfit/changing_room/pre_equip(mob/living/carbon/human/visitor, visuals_only = FALSE)
	..()
	if (isplasmaman(visitor))
		backpack_contents += list(/obj/item/tank/internals/plasmaman/belt/full = 2)


/*
 * CHANGING ROOM COSTUMING KIT
*/
/obj/item/storage/box/syndie_kit/chameleon/changing_room
	name = "changing room costuming kit"
	desc = "A box containing various outfits and accessories for use in the changing room."
	icon_state = "box"
	illustration = "writing"
	storage_type = /datum/storage/changing_room


/datum/storage/changing_room
	max_specific_storage = WEIGHT_CLASS_HUGE
	max_slots = 14
	max_total_storage = 50 // To actually acommodate the stuff being added.


// The cham gear that you don't already spawn with.
// Doesn't contain a PDA, for isolation reasons.
/obj/item/storage/box/syndie_kit/chameleon/changing_room/PopulateContents()
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/clothing/neck/chameleon(src)
	new /obj/item/storage/belt/chameleon(src)

