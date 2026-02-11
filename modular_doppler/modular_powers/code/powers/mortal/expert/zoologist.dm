/*
	Make friends with just about any simple creature. Doesn't save your friends though.
*/
/datum/power/expert/zoologist
	name = "Zoologist"
	desc = "You are capable of befriending just about any creature, given the opportunity. You gain the 'Befriend Creature' ability; using it on a mob in melee range will befriend it and any of it's other nearby cousins. \
	This doesn't prevent them from turning hostile on other creatures. You can befriend just about any creature that can also be revived with a Lazurs Injector. There's no limit to how many creatures you can befriend."
	value = 4

	action_path = /datum/action/cooldown/power/expert/zoologist

/datum/action/cooldown/power/expert/zoologist
	name = "Befriend Creature"
	desc = "Befriends a mob in melee range, as well as any of it's other nearby cousins. This doesn't prevent them from turning hostile on other creatures. \
	You can befriend just about any creature that can also be revived with a Lazurs Injector. There's no limit to how many creatures you can befriend."
	button_icon = 'icons/mob/simple/pets.dmi'
	button_icon_state = "cat_sit"

	target_type = /mob/living
	target_range = 1
	click_to_activate = TRUE
	cooldown_time = 5

	// Do we have the taming upgrade? If so we use different behavior.
	var/taming = FALSE
	// How many creatures may we tame?
	var/taming_cap = 0
	// Track current tamed mobs for cap enforcement.
	var/list/tamed_mobs = list()

/datum/action/cooldown/power/expert/zoologist/proc/get_tamed_count()
	var/count = 0
	for(var/amount = length(tamed_mobs), amount >= 1, amount--)
		var/mob/living/tamed = tamed_mobs[amount]
		if(QDELETED(tamed))
			tamed_mobs.Cut(amount, amount + 1)
			continue
		count++
	return count


/datum/action/cooldown/power/expert/zoologist/use_action(mob/living/user, mob/living/target)
	// eligibility like Lazarus injector
	if(!target?.compare_sentience_type(SENTIENCE_ORGANIC))
		user.balloon_alert(user, "invalid creature!")
		return FALSE
	if (target.stat == DEAD)
		user.balloon_alert(user, "they're dead, they won't make for good friends like this!")
		return

	// If taming; tame the creature and give it pet commands. Otherwise, use base power and make everyone friends.
	if(taming)
		var/datum/component/zoologist_tamed/tame_component = target.GetComponent(/datum/component/zoologist_tamed)
		if(tame_component)
			tamed_mobs -= target
			qdel(target.GetComponent(/datum/component/obeys_commands))
			if(tame_component.original_faction)
				target.faction = tame_component.original_faction.Copy()
			qdel(tame_component)
			target.befriend(user)
			return TRUE

		if(taming_cap && get_tamed_count() >= taming_cap)
			user.balloon_alert(user, "too many tamed!")
			return FALSE

		var/list/pet_commands = set_pet_commands(user, target)
		if(length(pet_commands))
			if(!target.AddComponent(/datum/component/obeys_commands, pet_commands)) // this runtimes if it has no ai controller.
				user.balloon_alert(user, "no higher brain function!")
				return FALSE

		target.ai_controller?.set_blackboard_key(BB_PET_TARGETING_STRATEGY, /datum/targeting_strategy/basic/not_friends) // tells it that anyone you target is free game regardless of faction.
		target.AddComponent(/datum/component/zoologist_tamed, target.faction?.Copy())
		tamed_mobs += target
		qdel(target.GetComponent(/datum/component/tameable)) // No shared tames.
		target.befriend(user)
		target.faction = user.faction.Copy()
		//shows hearts to all
		var/image/heart = image('icons/effects/effects.dmi', loc = target, icon_state = "love_hearts", layer = ABOVE_MOB_LAYER)
		flick_overlay_global(heart, GLOB.clients, 25)
		return TRUE
	else
		// sets the range which is basically screen width
		var/range_tiles = world.view

		for(var/mob/living/friendshiptarget in view(range_tiles, target))
			// same typepath (exact) or subtype
			if(friendshiptarget.type == target.type || istype(friendshiptarget, target.type))
				var/image/heart = image('icons/effects/effects.dmi', loc = friendshiptarget, icon_state = "love_hearts", layer = ABOVE_MOB_LAYER)
				friendshiptarget.flick_overlay(heart, list(user.client), 25, ABOVE_MOB_LAYER)
				friendshiptarget.befriend(user)
		return TRUE

// Here for future proofing, but I'd love to make it so that you can use special abilities of some mobs. But that'd be a lotta work.
/datum/action/cooldown/power/expert/zoologist/proc/set_pet_commands(mob/living/user, mob/living/target)
	var/list/commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/protect_owner,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/good_boy,
	)
	return commands

/obj/effect/temp_visual/tame_hearts
	name = "hearts"
	icon = 'icons/effects/effects.dmi'
	icon_state = "love_hearts"
	duration = 25

/datum/component/zoologist_tamed
	/// Original faction list before taming (copied)
	var/list/original_faction

/datum/component/zoologist_tamed/Initialize(list/original_faction)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.original_faction = original_faction
