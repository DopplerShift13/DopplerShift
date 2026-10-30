/// LONG HAVE WE WAITED, TILE-CLICK ACTIVATED.
/// Whenever u left, right or ctrl click on a tile in harm intent, the click checks if there's a mob standing on the tile, and instead tries to click on that guy
/mob/living/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tile_attacks)

/datum/element/tile_attacks

/datum/element/tile_attacks/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_LIVING_EARLY_UNARMED_ATTACK, PROC_REF(slappies))
	RegisterSignals(target, list(COMSIG_USER_ITEM_INTERACTION, COMSIG_USER_ITEM_INTERACTION_SECONDARY), PROC_REF(stabbies))
	RegisterSignal(target, COMSIG_MOB_CTRL_CLICKED, PROC_REF(grabbies))

/datum/element/tile_attacks/Detach(datum/source)
	UnregisterSignal(source, list(COMSIG_LIVING_EARLY_UNARMED_ATTACK, COMSIG_USER_ITEM_INTERACTION, COMSIG_USER_ITEM_INTERACTION_SECONDARY, COMSIG_MOB_CTRL_CLICKED))
	return ..()

/// for the unarmed portion. right clicks get passed along in modifiers so shoving works too
/datum/element/tile_attacks/proc/slappies(mob/living/source, atom/target, proximity_flag, list/modifiers)
	SIGNAL_HANDLER

	if(!proximity_flag)
		return NONE

	var/mob/living/villain = get_redirect_target(source, target, modifiers)
	if(isnull(villain))
		return NONE

	if(!HAS_TRAIT(source, TRAIT_HANDS_BLOCKED))
		source.changeNext_move(CLICK_CD_MELEE) /// ensure we do not skip clickCD
	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob, UnarmedAttack), villain, proximity_flag, modifiers)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/datum/element/tile_attacks/proc/stabbies(mob/living/source, atom/target, obj/item/tool, list/modifiers) 	/// no manually added cd because the item shouuuld do that
	SIGNAL_HANDLER

	var/mob/living/villain = get_redirect_target(source, target, modifiers)
	if(isnull(villain))
		return NONE

	INVOKE_ASYNC(tool, TYPE_PROC_REF(/obj/item, melee_attack_chain), source, villain, modifiers)
	return ITEM_INTERACT_SUCCESS

/// for grabs. ctrl clicks don't go to the attack chain so they need their own proc. no added cd needed
/datum/element/tile_attacks/proc/grabbies(mob/living/source, atom/target)
	SIGNAL_HANDLER

	if(!source.Adjacent(target))
		return NONE

	var/mob/living/villain = get_redirect_target(source, target)
	if(isnull(villain))
		return NONE

	INVOKE_ASYNC(source, TYPE_PROC_REF(/mob, CtrlClickOn), villain)
	return COMSIG_MOB_CANCEL_CLICKON

/// checks who this should be redirected to. whoever is on the highest layer is prioritized
/datum/element/tile_attacks/proc/get_redirect_target(mob/living/source, atom/target, list/modifiers)
	var/turf/clicked_turf = target
	if(istype(target, /obj/effect/decal/cleanable)) /// decals - bloodstains or oil spills or what have you - redirect to the turf and go from there
		clicked_turf = target.loc
	if(!isturf(clicked_turf))
		return null
	if(isnull(source.client))
		return null
	if(!source.combat_mode)
		return null

	var/mob/living/villain
	for(var/mob/living/candidate in clicked_turf)
		if(candidate == source)
			continue
		if(candidate.alpha < 40 || candidate.mouse_opacity == MOUSE_OPACITY_TRANSPARENT) ///this should stop ppl from clicking invisible ppl
			continue
		if(isnull(villain) || candidate.layer >= villain.layer)
			villain = candidate

	return villain
