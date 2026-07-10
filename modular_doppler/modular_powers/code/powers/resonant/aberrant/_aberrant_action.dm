/datum/action/cooldown/power/aberrant
	name = "abstract aberrant power action - ahelp this"
	background_icon_state = "bg_aberrant"
	overlay_icon_state = "bg_aberrant_border"

	/// How much hunger cost the ability use has
	var/cost

// Block use while starving.
/datum/action/cooldown/power/aberrant/can_use(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	if(user.nutrition <= NUTRITION_LEVEL_STARVING)
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	return TRUE

// Action cost
/datum/action/cooldown/power/aberrant/on_action_success(mob/living/user, atom/target)
	. = ..()
	if(iscarbon(user)) // hunger is a tithe only able to be paid by carbons
		user.adjust_nutrition(-cost)
