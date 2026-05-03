/datum/component/thaumaturge_preparation
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// The mob we’re attached to is always `parent`.
	var/mob/living/attached_mob

	/// The 'mana' we have to allocate. This is basically the power value of the spell in the powers menu. Note that the spell's own mana cost need not be propertional to the value.
	var/mana = 0

	/// The mana that is currently being spend by spell preperation.
	var/mana_spend = 0

	/// Maximum amount of mana you can have.
	var/max_mana = THAUMATURGE_MAX_MANA

	/// List of spells available to the user.
	var/list/spell_list = list()

	/// Spells being prepared in the UI
	var/list/prepared_charges = list()

	/// Spells prepared post-preperation.
	var/list/applied_prepared_charges = list()

	/// If this is the first time preparing spells for the round.
	var/first_time_preperation = TRUE

	/// If they go to sleep, they'll recharge their actions. This is only set if it passes validation.
	var/recharge_when_sleep = FALSE

/datum/component/thaumaturge_preparation/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = parent

// We need to set these to interact with sleeping = gain charges
/datum/component/thaumaturge_preparation/RegisterWithParent()
	. = ..()
	RegisterSignal(attached_mob, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(on_sleep_set))

/datum/component/thaumaturge_preparation/UnregisterFromParent()
	UnregisterSignal(attached_mob, COMSIG_LIVING_STATUS_SLEEP)
	. = ..()

/// Gives the status effect responsible for charging spells when we go to sleep.
/datum/component/thaumaturge_preparation/proc/on_sleep_set(mob/living/source, amount)
	SIGNAL_HANDLER
	// Only trigger on entering sleep (not waking, shortening, or extending existing sleep).
	if(amount <= 0 || source.IsSleeping())
		return
	// Do we have queqed changes and is the flag that it passed validation on?
	if(applied_prepared_charges && recharge_when_sleep)
		//Do we have the focus on our person?
		if(locate(/obj/item/spell_focus) in attached_mob.get_all_contents())
			// apply the status effect which handles replenishment.
			attached_mob.apply_status_effect(/datum/status_effect/power/thaumaturgic_sleep, src)
			return
		to_chat(attached_mob, span_warning("You cannot recharge your spells without a Spell Focus on your person!"))


/// Validates mana and adds spells to the list.
/datum/component/thaumaturge_preparation/proc/build_spells()
	var/calculated_mana = 0
	spell_list = list()
	for(var/datum/power/power_instance as anything in attached_mob.powers)
		if(!power_instance)
			continue
		if(power_instance.path != POWER_PATH_THAUMATURGE)
			continue
		if(check_if_can_prepare(power_instance.action_path))
			spell_list.Add(power_instance)
		calculated_mana += power_instance.value
	mana = clamp(calculated_mana * THAUMATURGE_MANA_MULT, 0, max_mana)

/// Checks if we can prepare the spell in our spellbook and if so adds it to the spell list.
/datum/component/thaumaturge_preparation/proc/check_if_can_prepare(action_type)
	if(!istype(action_type, /datum/action/cooldown/power/thaumaturge))
		return FALSE
	var/datum/action/cooldown/power/thaumaturge/cast_type = action_type
	if(!cast_type.max_charges)
		return FALSE

	return TRUE

/// Find the spell in the current spell_list and read its prep_cost.
/datum/component/thaumaturge_preparation/proc/get_prep_cost_for_spell_ref(spell_ref)
	for(var/datum/power/power_instance as anything in spell_list)
		if("[power_instance.action_path.type]" == spell_ref)
			var/datum/action/cooldown/power/thaumaturge/action_instance = power_instance.action_path
			return max(0, action_instance?.prep_cost || 0)
	return 0


/// Starts the process of applying spells. Verification & all
/datum/component/thaumaturge_preparation/proc/apply_preperation()
	if(!check_valid_preperation())
		recharge_when_sleep = FALSE
		return
	if(first_time_preperation)
		if(apply_spell_charges())
			first_time_preperation = FALSE
			recharge_when_sleep = TRUE
			to_chat(attached_mob, span_notice("Your spell preperation has been applied!"))
		else
			to_chat(attached_mob, span_warning("Something went wrong when applying spell charges; this shouldn't happen! Yell at a dev!"))
	else
		// For those curious how we trigger it, its the on_sleep_set() signaler at the top.
		recharge_when_sleep = TRUE
		to_chat(attached_mob, span_notice("Your changes have been saved! The next time you take the sleep action, the charges will be applied."))

/// Applies the prepared spell charges.
/datum/component/thaumaturge_preparation/proc/apply_spell_charges()
	if(!length(applied_prepared_charges))
		return FALSE

	for(var/datum/power/power in attached_mob.powers)
		// Thaumaturge powers only.
		if(power.path != POWER_PATH_THAUMATURGE)
			continue

		var/datum/action/cooldown/power/thaumaturge/action = power.action_path
		if(!action)
			continue

		var/charges = applied_prepared_charges["[action.type]"]
		if(isnull(charges))
			continue

		action.charges = clamp(charges, 0, action.max_charges)

		// Re-enable the power if it got charges, disable if it has 0 if it has max charges..
		if(action.charges)
			action.enable()
		else if(action.max_charges)
			action.disable()
		action.update_charges_overlay()
	return TRUE

/// Reverifies that all the things picked for preperation are indeed valid.
/datum/component/thaumaturge_preparation/proc/check_valid_preperation()
	var/total_mana_cost = 0
	build_spells()
	for(var/prepared_key in applied_prepared_charges)
		var/prepared_charges = applied_prepared_charges[prepared_key]

		// find matching action instance on the mob
		var/datum/action/cooldown/power/thaumaturge/matching_action = get_applied_charges_matching_power(attached_mob.powers, prepared_key)
		if(!matching_action)
			to_chat(attached_mob, span_warning("Prepared power '[prepared_key]' not found on you!"))
			return FALSE

		// Checks if the amount of charges are valid vs the max_charge
		if(matching_action.max_charges < prepared_charges)
			to_chat(attached_mob, span_warning("[matching_action]'s charges exceed the maximum!"))
			return FALSE
		total_mana_cost += (prepared_charges * matching_action.prep_cost)

	// Checks if the total mana cost of all the charges
	if(mana < total_mana_cost)
		to_chat(attached_mob, span_warning("You have spend more mana than you have!"))
		return FALSE
	return TRUE

/// Because TGUI gives it along as a string.
/datum/component/thaumaturge_preparation/proc/get_applied_charges_matching_power(list/powers_list, prepared_key)
	for(var/datum/power/power in powers_list)
		var/datum/action/cooldown/power/thaumaturge/action = power.action_path
		if(!action)
			continue

		// Becuase prepared key is a string we have to stringify action.type
		if("[action.type]" == prepared_key)
			return action

	return null


/* Below is responsible for all the TGUI stuff to do with spell preperation.
   Save yourself if you need to touch this.
*/
/datum/component/thaumaturge_preparation/ui_interact(mob/living/user, datum/tgui/ui)
	if(!user)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(ui)
		return

	// Draft starts from applied state
	prepared_charges = applied_prepared_charges.Copy()

	// Recalculate mana_spend from the draft
	mana_spend = 0
	for(var/spell_ref in prepared_charges)
		var/charges = prepared_charges[spell_ref]
		if(!isnum(charges) || charges <= 0)
			continue
		mana_spend += (charges * get_prep_cost_for_spell_ref(spell_ref))

	ui = new(user, src, "ThaumaturgeSpellPrep", "Spell Preparation")
	ui.open()


/datum/component/thaumaturge_preparation/ui_state(mob/user)
	return GLOB.always_state

/datum/component/thaumaturge_preparation/ui_data(mob/living/user)
	var/list/spells_payload = list()

	for(var/datum/power/power_instance as anything in spell_list)
		var/spell_ref = "[power_instance.action_path.type]"
		var/current_charges = prepared_charges[spell_ref]
		if(isnull(current_charges))
			current_charges = 0

		var/datum/action/cooldown/power/thaumaturge/action_instance = power_instance.action_path

		var/prep_cost = action_instance?.prep_cost
		if(isnull(prep_cost))
			prep_cost = 1

		spells_payload += list(list(
			"key" = spell_ref,
			"name" = action_instance?.name || "Unknown Spell",
			"charges" = current_charges,
			"max_charges" = action_instance?.max_charges || 0,
			"prep_cost" = prep_cost,
			"icon" = action_instance?.button_icon,
			"icon_state" = action_instance?.button_icon_state,
		))

	var/mana_remaining = max(mana - mana_spend, 0)

	return list(
		"mana_total" = mana,
		"mana_max" = max_mana,
		"mana_spend" = mana_spend,
		"mana_remaining" = mana_remaining,
		"spell_count" = length(spells_payload),
		"spells" = spells_payload,
		"first_time_preperation" = first_time_preperation,
	)




/datum/component/thaumaturge_preparation/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	if(action == "inc" || action == "dec")
		var/spell_ref = params["ref"]
		if(!spell_ref)
			return TRUE

		// Validate spell exists (prevents spoofing)
		var/found = FALSE
		var/max_charges_local = 0

		for(var/datum/power/power_instance as anything in spell_list)
			if("[power_instance.action_path.type]" != spell_ref)
				continue

			var/datum/action/cooldown/power/thaumaturge/action_instance = power_instance.action_path
			max_charges_local = action_instance?.max_charges || 0
			found = TRUE
			break

		if(!found || max_charges_local <= 0)
			return TRUE

		var/current_charges = prepared_charges[spell_ref]
		if(isnull(current_charges))
			current_charges = 0

		var/prep_cost = get_prep_cost_for_spell_ref(spell_ref)

		if(action == "inc")
			if(current_charges >= max_charges_local)
				return TRUE

			if(mana_spend + prep_cost > mana)
				return TRUE

			current_charges++
			mana_spend += prep_cost

		else
			if(current_charges <= 0)
				return TRUE

			current_charges--
			mana_spend = max(mana_spend - prep_cost, 0)

		prepared_charges[spell_ref] = current_charges
		return TRUE

	if(action == "apply")
		applied_prepared_charges = prepared_charges.Copy()
		apply_preperation()
		return TRUE

	return FALSE

// Status effect used for validating sleep
/datum/status_effect/power/thaumaturgic_sleep
	id = "thaumaturgic_sleep"
	duration = THAUMATURGE_SLEEP_TIME // required amount of sleepytime
	tick_interval = 1 SECONDS
	show_duration = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/thaumaturgic_sleep

	/// Has the sleep ended early?
	var/ends_early = FALSE
	/// Reference to the preperation component.
	var/datum/component/thaumaturge_preparation/prep_component

/datum/status_effect/power/thaumaturgic_sleep/on_creation(mob/living/new_owner, datum/component/thaumaturge_preparation/thaum_component)
	prep_component = thaum_component
	return ..()

// Ticks every second, checks for focus and if we are asleep
/datum/status_effect/power/thaumaturgic_sleep/tick(seconds_between_ticks)
	var/has_focus = locate(/obj/item/spell_focus) in owner.get_all_contents()

	if(!owner.IsSleeping() || !has_focus)
		ends_early = TRUE
		qdel(src)

/datum/status_effect/power/thaumaturgic_sleep/on_remove()
	// YOU GET NOTHING, YOU LOSE.
	if(ends_early || QDELETED(owner))
		return
	if(!prep_component)
		return
	prep_component.apply_spell_charges()
	to_chat(owner, span_notice("Your mind focuses on your spells, and through your dreams, you feel your Thaumaturge powers recharge!"))

/atom/movable/screen/alert/status_effect/thaumaturgic_sleep
	name = "Thaumaturgic Sleep"
	desc = "You are manifesting your thaumaturgic power through your dreams; if you are asleep with your spell focus when this effect expires, you will recharge your spells. Waking up early yields nothing!"
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "ice_1"
