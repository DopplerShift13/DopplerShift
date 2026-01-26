
/datum/power/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the creature over a prolonged period of time. \
	Grants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again. \
	This is mutually exclusive with the other 'A Burden...' powers."
	action_path = /datum/action/power/theologist/theologist_root/revered

	value = 5

/datum/action/power/theologist/theologist_root/revered
	name = "A Burden Revered"
	desc = "Nullifies pain and slowly heals the creature over a prolonged period of time. \
	Grants piety based on healing done, ends prematurely if the target reaches full health or if it is cast again."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "transformslime"
	target_range = 1
	target_type = /mob/living
	click_to_activate = TRUE
	target_self = FALSE

/datum/action/power/theologist/theologist_root/revered/use_action(mob/living/user, mob/living/target)
	to_chat(owner, span_boldnotice("Placeholder"))

	return TRUE

/datum/action/power/theologist/theologist_root/revered/on_activation(mob/living/user)
	to_chat(owner, span_notice("You ready yourself to relieve the burden of others!<br><B>Left-click</B> a creature next to you to target them!"))

/datum/action/power/theologist/theologist_root/revered/on_deactivation(mob/living/user)
	to_chat(owner, span_notice("You withdraw your power."))

///datum/power/theologist_root/revered/process()
