// HARDCORE PARKOUR
// Bounce off of walls to keep momentum.
/datum/power/expert/parkour
	name = "Parkourist"
	desc = "You can use the environment to keep your speed.\
	\nAt 80% momentum or greater, turning adjacent to a wall or an anchored, dense object prevents any momentum loss, allowing you to easily keep your speed in tight, twisting spaces; such as maintenance.\
	\nAt that threshold, you can also move across tables without climbing them.\
	\nYou also gain 500 Athletics experience, equivelant to Journeyman."
	security_record_text = "Subject is capable of parkour."
	security_threat = POWER_THREAT_MAJOR
	value = 4
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES

	menu_icon = 'modular_doppler/sprinting/icons/icons.dmi'
	menu_icon_state = "parkour"

	/// The momentum required to use Parkourist's movement benefits.
	var/minimum_momentum = 80
	/// Whether this power currently grants its table-crossing trait.
	var/table_running = FALSE
	/// The power holder's sprinting component.
	var/datum/component/sprinting/sprinting_component

/datum/power/expert/parkour/post_add() // skills don't always give xp when spawning unless its post_add()
	. = ..()
	RegisterSignal(power_holder, COMSIG_SPRINTING_TURNED, PROC_REF(prevent_turn_momentum_loss))
	sprinting_component = power_holder.GetComponent(/datum/component/sprinting)
	update_table_running()
	power_holder.mind?.adjust_experience(/datum/skill/athletics, SKILL_EXP_JOURNEYMAN)

/datum/power/expert/parkour/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_SPRINTING_TURNED)
	if(table_running)
		passtable_off(power_holder, REF(src))
	table_running = FALSE
	sprinting_component = null
	power_holder.mind?.adjust_experience(/datum/skill/athletics, -SKILL_EXP_JOURNEYMAN)

/// Prevents momentum loss from a turn when the sprinter is adjacent to a solid surface.
/datum/power/expert/parkour/proc/prevent_turn_momentum_loss(mob/living/carbon/human/sprinter, turn_angle, list/turn_loss_modifiers)
	SIGNAL_HANDLER
	if(!sprinting_component || sprinting_component.momentum < minimum_momentum)
		return

	for(var/turf/adjacent_turf in orange(1, sprinter))
		if(iswallturf(adjacent_turf))
			turn_loss_modifiers += -100
			return
		for(var/obj/adjacent_object in adjacent_turf)
			if(adjacent_object.anchored && adjacent_object.density)
				turn_loss_modifiers += -100
				return

/// Updates table crossing according to the power holder's current momentum.
/datum/power/expert/parkour/process(seconds_per_tick)
	update_table_running()

/// Grants or removes table running according to the power holder's current momentum.
/datum/power/expert/parkour/proc/update_table_running()
	var/should_run_tables = sprinting_component?.momentum >= minimum_momentum
	if(should_run_tables == table_running)
		return

	table_running = should_run_tables
	if(table_running)
		passtable_on(power_holder, REF(src))
	else
		passtable_off(power_holder, REF(src))
