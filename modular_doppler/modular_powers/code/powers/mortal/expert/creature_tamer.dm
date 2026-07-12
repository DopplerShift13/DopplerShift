/datum/power/expert/creature_tamer
	name = "Creature Tamer"
	desc = "You're always met with success when taming creatures. Grants you the 'Tame Creature' ability, allowing you to automatically tame any normally tameable creatures. Now you too can have your very own space carp pet."
	security_record_text = "Subject has an affinity for taming creatures."
	value = 2
	required_powers = list(/datum/power/expert/zoologist)
	action_path = /datum/action/cooldown/power/expert/creature_tamer

/datum/action/cooldown/power/expert/creature_tamer
	name = "Tame Creature"
	desc = "Tame a creature that is already tameable, granting all the bonuses that you would've gained from taming it normally."
	button_icon = 'icons/obj/clothing/neck.dmi'
	button_icon_state = "petcollar"

	target_type = /mob/living
	target_range = 1
	click_to_activate = TRUE
	cooldown_time = 5

/datum/action/cooldown/power/expert/creature_tamer/use_action(mob/living/user, mob/living/target)
	if(target.stat == DEAD)
		user.balloon_alert(user, "they're dead, they won't make for good friends like this!")
		return FALSE

	var/datum/component/tameable/tameable_component = target.GetComponent(/datum/component/tameable)
	if(!tameable_component)
		user.balloon_alert(user, "can't be tamed!")
		return FALSE

	// We actually unfriend them to prevent an ai issue.
	target.unfriend(user)
	SEND_SIGNAL(target, COMSIG_SIMPLEMOB_SENTIENCEPOTION, user) // This basically tells it to instantly succeed at being tamed.

	//shows hearts to all
	var/image/heart = image('icons/effects/effects.dmi', loc = target, icon_state = "love_hearts", layer = ABOVE_MOB_LAYER)
	flick_overlay_global(heart, GLOB.clients, 25)
	return TRUE
