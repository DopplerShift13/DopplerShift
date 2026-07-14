/*
	Allows you to drag some heavy objects and people more efficiently. Also athletics boost.
*/

/datum/power/expert/heavy_lifter
	name = "Heavy Lifter"
	desc = "A strong back does a lot when it comes to carrying closets. You ignore the slowdown from dragging objects and having creatures grabbed and/or carried. You also start off as a Journeyman in the Athletics skill. \
	All other slowdowns such as stamina, items, damage, etc. still apply as normal."
	security_record_text = "Subject possesses a high degree of strength and is capable of hauling objects without being slowed down."
	value = 5
	/// how much xp we start with on average.
	var/starting_xp_base = SKILL_EXP_JOURNEYMAN
	/// tracks how much was given for removal later.
	var/xp_given = 0

/datum/power/expert/heavy_lifter/post_add()
	..()
	// Grab slowdowns all share the same movespeed id.
	power_holder.add_movespeed_mod_immunities(src, MOVESPEED_ID_MOB_GRAB_STATE)
	power_holder.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/bulky_drag)
	// Fireman carry slowdown.
	power_holder.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/human_carry)

	/// We give a degree of randomness to the amount of xp given.
	var/xp_mult = rand(100, 150) / 100
	xp_given = starting_xp_base * xp_mult
	power_holder.mind?.adjust_experience(/datum/skill/athletics, xp_given)

/datum/power/expert/heavy_lifter/remove()
	power_holder.remove_movespeed_mod_immunities(src, MOVESPEED_ID_MOB_GRAB_STATE)
	power_holder.remove_movespeed_mod_immunities(src, (/datum/movespeed_modifier/bulky_drag))
	power_holder.remove_movespeed_mod_immunities(src, (/datum/movespeed_modifier/human_carry))
	power_holder.mind?.adjust_experience(/datum/skill/athletics, -xp_given)
