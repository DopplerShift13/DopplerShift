/* The number one killer of people using A Burden Shared is oxyloss, so this addresses that.
*/
/datum/power/theologist/shared_breath_of_life
	name = "Breath of Life"
	desc = "You share your breath with the target. Using your A Burden Shared onto a target instantly heals all forms of suffocation damage, and the target is able to breathe in environments they normally cannot, \
	as long as you are not currently suffocating. This does not protect from toxic or otherwise dangerous gasses."
	security_record_text = "Subject's healing powers can function as a respiratory aid"
	value = 2
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	required_powers = list(/datum/power/theologist_root/shared)

	/// The base A Burden Shared action this upgrade enhances.
	var/datum/action/cooldown/power/theologist/theologist_root/shared/shared_action
	/// The current A Burden Shared target. Kept generic because Shared can target non-carbons.
	var/mob/living/shared_target

/datum/power/theologist/shared_breath_of_life/post_add()
	. = ..()
	var/datum/power/theologist_root/shared/shared_power = power_holder?.get_power(/datum/power/theologist_root/shared)
	shared_action = shared_power?.action_path
	RegisterSignal(power_holder, COMSIG_POWER_ACTION_SUCCESS, PROC_REF(on_power_action_success))

/datum/power/theologist/shared_breath_of_life/remove()
	STOP_PROCESSING(SSpowers, src)
	UnregisterSignal(power_holder, COMSIG_POWER_ACTION_SUCCESS)
	set_shared_target(null)
	return ..()

/// Updates the tracked Shared target and removes respiratory protection from the previous target.
/datum/power/theologist/shared_breath_of_life/proc/set_shared_target(mob/living/new_target)
	if(shared_target == new_target)
		return
	shared_target?.remove_traits(list(TRAIT_NO_BREATHLESS_DAMAGE), REF(src))
	shared_target = new_target

/// Heals all suffocation damage when A Burden Shared successfully starts.
/datum/power/theologist/shared_breath_of_life/proc/on_power_action_success(mob/living/signal_source, datum/action/cooldown/power/used_power, atom/target)
	SIGNAL_HANDLER
	if(used_power != shared_action || !isliving(target))
		return

	// Oxy heal + Piety gain
	set_shared_target(target)
	var/oxyloss = shared_target.getOxyLoss()
	shared_target.adjustOxyLoss(-oxyloss)
	var/datum/component/theologist_piety/piety_component = power_holder.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return FALSE
	if(shared_target.ckey) // don't get piety from healing nobides
		piety_component.adjust_piety(floor(oxyloss * THEOLOGIST_PIETY_HEALING_COEFFICIENT))
		to_chat(power_holder, span_notice("Restoring [shared_target]'s breath has gained you piety!"))

	if(iscarbon(shared_target))
		START_PROCESSING(SSpowers, src)

/// Refreshes respiratory protection for the active A Burden Shared target.
/datum/power/theologist/shared_breath_of_life/process(seconds_per_tick)
	// Stop processing if our power is off or we don't have a target
	if(!shared_action?.active)
		set_shared_target(null)
		STOP_PROCESSING(SSpowers, src)
		return

	set_shared_target(shared_action.current_target)
	if(!iscarbon(shared_target) || !iscarbon(power_holder))
		shared_target?.remove_traits(list(TRAIT_NO_BREATHLESS_DAMAGE), REF(src))
		STOP_PROCESSING(SSpowers, src)
		return

	// The caster's breathing determines whether their target receives protection.
	var/mob/living/carbon/caster = power_holder
	var/mob/living/carbon/carbon_target = shared_target
	if(caster.failed_last_breath)
		carbon_target.remove_traits(list(TRAIT_NO_BREATHLESS_DAMAGE), REF(src))
	else
		carbon_target.add_traits(list(TRAIT_NO_BREATHLESS_DAMAGE), REF(src))
