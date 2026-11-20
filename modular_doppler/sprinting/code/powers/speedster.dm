// Your specialty is about going fast, instead of cardio.
/datum/power/expert/speedster
	name = "Speedster"
	desc = "You are specialized in covering as much ground as possible in as little time needed, rather than a prolonged sprint.\
	\nYour Athletics level also affects your top speed while sprinting. However, you lose energy (and subsequently stamina) while sprinting 30% faster.\
	\nYou also gain 500 Athletics experience, equivelant to Journeyman."
	security_record_text = "Subject reaches extreme top speeds when performing a sprint."
	security_threat = POWER_THREAT_MAJOR
	value = 6

	menu_icon = 'modular_doppler/sprinting/icons/icons.dmi'
	menu_icon_state = "speedster"

	/// The percentage increase to sprint energy drain.
	var/energy_drain_penalty = 30
	/// The full-momentum speed bonus granted for each Athletics level above None.
	var/speed_bonus_per_athletics_level = 0.05
	/// The power holder's sprinting component.
	var/datum/component/sprinting/sprinting_component

/datum/power/expert/speedster/post_add() // skills don't always give xp when spawning unless its post_add()
	. = ..()
	RegisterSignal(power_holder, COMSIG_SPRINTING_ENERGY_DRAIN, PROC_REF(increase_sprint_energy_drain))
	RegisterSignal(power_holder, COMSIG_SPRINTING_SPEED_BONUS, PROC_REF(add_athletics_speed_bonus))
	sprinting_component = power_holder.GetComponent(/datum/component/sprinting)
	sprinting_component?.update_momentum_slowdown()
	power_holder.mind?.adjust_experience(/datum/skill/athletics, SKILL_EXP_JOURNEYMAN)

/datum/power/expert/speedster/remove()
	. = ..()
	UnregisterSignal(power_holder, list(COMSIG_SPRINTING_ENERGY_DRAIN, COMSIG_SPRINTING_SPEED_BONUS))
	sprinting_component?.update_momentum_slowdown()
	sprinting_component = null
	power_holder.mind?.adjust_experience(/datum/skill/athletics, -SKILL_EXP_JOURNEYMAN)

/// Adds the Speedster energy drain penalty to sprinting movement.
/datum/power/expert/speedster/proc/increase_sprint_energy_drain(mob/living/carbon/human/sprinter, energy_drain, list/energy_drain_modifiers)
	SIGNAL_HANDLER
	energy_drain_modifiers += energy_drain_penalty

/// Adds an Athletics-scaled bonus to the speed granted at full momentum.
/datum/power/expert/speedster/proc/add_athletics_speed_bonus(mob/living/carbon/human/sprinter, list/speed_bonus_modifiers)
	SIGNAL_HANDLER
	var/athletics_level = sprinter.mind?.get_skill_level(/datum/skill/athletics) || SKILL_LEVEL_NONE
	speed_bonus_modifiers += max(athletics_level - SKILL_LEVEL_NONE, 0) * speed_bonus_per_athletics_level
