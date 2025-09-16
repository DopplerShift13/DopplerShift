
/obj/item/borg/upgrade/threadripper
	name = "medical cyborg threadripper"
	desc = "An upgrade to the Medical model, installing an integrated \
		threadripper device. Parallel to its MODsuit counterpart, \
		this allows users to disassemble and re-sew all manners of \
		garments while still on the patient where needed."
	icon_state = "module_medical"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical, /obj/item/robot_model/syndicate_medical)
	model_flags = BORG_MODEL_MEDICAL

	items_to_add = list(/obj/item/borg_threadripper)


/// Allows medical borgs to 'rip' open worn items, temporarily allowing surgery and such through them.
/obj/item/borg_threadripper
	name = "threadripper"
	desc = "A device for rapidly disassembling and re-sewing garments \
	otherwise blocking medical intervention on patients."
	icon = 'icons/obj/clothing/modsuit/mod_modules.dmi'
	icon_state = "thread_ripper"
	item_flags = NOBLUDGEON

	/// An associated list of ripped clothing and the body part covering slots they covered before.
	var/list/ripped_clothing = list()

/obj/item/borg_threadripper/equipped(mob/user, slot, initial)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/borg_threadripper/dropped(mob/user, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	resew_all(user)

/obj/item/borg_threadripper/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!iscyborg(user))
		return ITEM_INTERACT_BLOCKING
	if(!user.Adjacent(interacting_with) || !iscarbon(interacting_with) || user == interacting_with)
		balloon_alert(user, "invalid target!")
		return ITEM_INTERACT_BLOCKING
	var/mob/living/carbon/carbon_target = interacting_with
	if(length(ripped_clothing))
		balloon_alert(user, "already ripped!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "ripping clothing...")
	playsound(src, 'sound/items/zip/zip.ogg', 25, TRUE, frequency = -1)
	if(!do_after(user, 1.5 SECONDS, target = carbon_target))
		balloon_alert(user, "interrupted!")
		return ITEM_INTERACT_BLOCKING

	var/target_zones = body_zone2cover_flags(user.zone_selected)
	for(var/obj/item/clothing as anything in carbon_target.get_equipped_items())
		if(isnull(clothing))
			continue
		var/shared_flags = target_zones & clothing.body_parts_covered
		if(shared_flags)
			ripped_clothing[clothing] = shared_flags
			clothing.body_parts_covered &= ~shared_flags

/obj/item/borg_threadripper/process(seconds_per_tick)
	if(!iscyborg(loc))
		return
	if(!length(ripped_clothing))
		return

	var/mob/living/silicon/robot/borg_user = loc
	var/zipped = FALSE
	for(var/obj/item/clothing as anything in ripped_clothing)
		if(QDELETED(clothing))
			ripped_clothing -= clothing
			continue
		var/mob/living/carbon/clothing_wearer = clothing.loc
		if(istype(clothing_wearer) && borg_user.Adjacent(clothing_wearer) && !clothing_wearer.is_holding(clothing))
			continue
		zipped = TRUE
		clothing.body_parts_covered |= ripped_clothing[clothing]
		ripped_clothing -= clothing
	if(zipped)
		playsound(src, 'sound/items/zip/zip.ogg', 25, TRUE)
		balloon_alert(borg_user, "clothing mended")

/obj/item/borg_threadripper/proc/resew_all(mob/living/user)
	if(!length(ripped_clothing))
		return
	for(var/obj/item/clothing as anything in ripped_clothing)
		if(QDELETED(clothing))
			ripped_clothing -= clothing
			continue
		clothing.body_parts_covered |= ripped_clothing[clothing]
	ripped_clothing = list()
	playsound(src, 'sound/items/zip/zip.ogg', 25, TRUE)
	if(user)
		balloon_alert(user, "clothing mended")


/datum/design/borg_upgrade_threadripper
	name = "Cyborg Threadripper"
	id = "borg_upgrade_threadripper"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/threadripper
	materials = list(
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 2.5,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	construction_time = 4 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MEDICAL
	)
