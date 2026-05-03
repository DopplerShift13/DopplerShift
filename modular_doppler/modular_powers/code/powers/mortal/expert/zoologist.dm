/*
	Make friends with just about any simple creature. Doesn't save your friends though.
*/
/datum/power/expert/zoologist
	name = "Zoologist"
	desc = "You are capable of befriending just about any creature, given the opportunity. You gain the 'Befriend Creature' ability; using it on a mob in melee range will befriend it and any of it's other nearby cousins. \
	This doesn't prevent them from turning hostile on other creatures. You can befriend just about any creature that can also be revived with a Lazurs Injector. There's no limit to how many creatures you can befriend."
	security_record_text = "Subject has an unusual ability to befriend any and all animals."
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

/datum/action/cooldown/power/expert/zoologist/use_action(mob/living/user, mob/living/target)
	// eligibility like Lazarus injector
	if(!target?.compare_sentience_type(SENTIENCE_ORGANIC))
		user.balloon_alert(user, "invalid creature!")
		return FALSE
	if (target.stat == DEAD)
		user.balloon_alert(user, "they're dead, they won't make for good friends like this!")
		return

	/// sets the range which is basically screen width
	var/range_tiles = world.view

	for(var/mob/living/friendshiptarget in view(range_tiles, target))
		// same typepath (exact) or subtype
		if(friendshiptarget.type == target.type || istype(friendshiptarget, target.type))
			var/image/heart = image('icons/effects/effects.dmi', loc = friendshiptarget, icon_state = "love_hearts", layer = ABOVE_MOB_LAYER)
			friendshiptarget.flick_overlay(heart, list(user.client), 25, ABOVE_MOB_LAYER)
			friendshiptarget.befriend(user)
	return TRUE

/obj/effect/temp_visual/tame_hearts
	name = "hearts"
	icon = 'icons/effects/effects.dmi'
	icon_state = "love_hearts"
	duration = 25
