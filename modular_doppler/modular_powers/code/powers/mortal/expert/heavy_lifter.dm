/*
	Allows you to drag some heavy objects and people more efficiently. Also athletics boost.
*/

/datum/power/expert/heavy_lifter
	name = "Heavy Lifter"
	desc = "A strong back does a lot when it comes to carrying closets. You ignore the slowdown from dragging objects and having creatures grabbed and/or carried.	All other slowdowns such as stamina, items, damage, etc. still apply as normal.\
	\nYou also gain 500 Athletics experience, equivelant to Journeyman."
	security_record_text = "Subject possesses a high degree of strength and is capable of hauling objects without being slowed down."
	value = 5

	menu_icon = 'icons/obj/storage/crates.dmi'
	menu_icon_state = "crate" //32x48 sprite may get scrungled

/datum/power/expert/heavy_lifter/post_add()
	..()
	// Grab slowdowns all share the same movespeed id.
	power_holder.add_movespeed_mod_immunities(src, MOVESPEED_ID_MOB_GRAB_STATE)
	power_holder.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/bulky_drag)
	// Fireman carry slowdown.
	power_holder.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/human_carry)

	power_holder.mind?.adjust_experience(/datum/skill/athletics, SKILL_EXP_JOURNEYMAN)

/datum/power/expert/heavy_lifter/remove()
	power_holder.remove_movespeed_mod_immunities(src, MOVESPEED_ID_MOB_GRAB_STATE)
	power_holder.remove_movespeed_mod_immunities(src, (/datum/movespeed_modifier/bulky_drag))
	power_holder.remove_movespeed_mod_immunities(src, (/datum/movespeed_modifier/human_carry))
	power_holder.mind?.adjust_experience(/datum/skill/athletics, -SKILL_EXP_JOURNEYMAN)
