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
	if(!can_pay_hunger_cost(user, cost))
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	return TRUE

// Action cost
/datum/action/cooldown/power/aberrant/on_action_success(mob/living/user, atom/target)
	. = ..()
	modify_hunger(cost, user)

/// Quick handler that modifies the mob's hunger
/datum/action/cooldown/power/aberrant/proc/modify_hunger(amount, mob/living/user = owner)
	if(amount <= 0 || !iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user
	var/obj/item/organ/stomach/stomach = carbon_user.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(stomach)
		stomach.adjust_satiety(amount)
		return

	carbon_user.adjust_nutrition(-amount)

/// Returns TRUE when the user can afford the cost with their current type of stomach
/datum/action/cooldown/power/aberrant/proc/can_pay_hunger_cost(mob/living/user, amount)
	if(amount <= 0)
		return TRUE
	if(!iscarbon(user))
		return FALSE

	var/mob/living/carbon/carbon_user = user
	var/obj/item/organ/stomach/stomach = carbon_user.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(stomach)
		return stomach.can_afford_satiety_cost(amount)

	return carbon_user.nutrition > (NUTRITION_LEVEL_STARVING + amount)
