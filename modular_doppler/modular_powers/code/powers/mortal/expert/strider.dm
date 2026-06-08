/*
	No item slowdowns. Basically always having your stuff coated in slime speed pots.
*/

/datum/power/expert/strider
	name = "Strider"
	desc = "Your strength is herculean. You ignore all slowdowns from held & worn items. \
	You also start out at Master proficiency athletics."
	security_record_text = "Subject has an incredibly strong physique and carry heavy equipment without issue."
	value = 6
	required_powers = list(/datum/power/expert/heavy_lifter)

	/// how much xp we start with on average. Since the prerequisite skill gives journeyman, we subtract that.
	var/starting_xp_base = SKILL_EXP_MASTER - SKILL_EXP_JOURNEYMAN

/datum/power/expert/strider/post_add()
	..()
	power_holder.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/equipment_speedmod)
	power_holder.mind?.adjust_experience(/datum/skill/athletics, starting_xp_base)

/datum/power/expert/strider/remove()
	power_holder.remove_movespeed_mod_immunities(src, (/datum/movespeed_modifier/equipment_speedmod))
	power_holder.mind?.adjust_experience(/datum/skill/athletics, -starting_xp_base)

