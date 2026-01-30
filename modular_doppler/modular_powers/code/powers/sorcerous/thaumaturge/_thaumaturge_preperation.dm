/datum/component/thaumaturge_preparation
	dupe_mode = COMPONENT_DUPE_UNIQUE

	// The mob we’re attached to is always `parent`.
	var/mob/living/attached_mob

	// The 'mana' we have to allocate. This is basically 2x the power value in the powers menu. Note that the spell's own mana cost need not be propertional to the value.
	var/mana

	// The mana that is currently being spend by spell preperation.
	var/mana_spend

	// Maximum amount of mana you can have.
	var/max_mana = THAUMATURGE_MAX_MANA

	// List of spells available to the user.
	var/list/spell_list = list()

	// Spells being prepared in the UI
	var/list/prepared_charges = list()

	// Spells prepared post-preperation.
	var/list/applied_prepared_charges = list()


/datum/component/thaumaturge_preparation/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	attached_mob = parent

// Validates mana and adds spells to the list.
/datum/component/thaumaturge_preparation/proc/validate_spells()
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
	mana = clamp(calculated_mana, 0, max_mana)

// Checks if we can prepare the spell in our spellbook and if so adds it to the spell list.
/datum/component/thaumaturge_preparation/proc/check_if_can_prepare(action_type)
	if(!istype(action_type, /datum/action/cooldown/power/thaumaturge))
		return FALSE
	var/datum/action/cooldown/power/thaumaturge/cast_type = action_type
	if(!cast_type.max_charges)
		return FALSE

	return TRUE

// Find the spell in the current spell_list and read its prep_cost.
/datum/component/thaumaturge_preparation/proc/get_prep_cost_for_spell_ref(spell_ref)
	for(var/datum/power/power_instance as anything in spell_list)
		if("[power_instance.action_path]" == spell_ref)
			var/datum/action/cooldown/power/thaumaturge/action_instance = power_instance.action_path
			return max(0, action_instance?.prep_cost || 0)

	return 0


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
	// Pick an appropriate state; many UIs use always_state if only access control is server-side.
	return GLOB.always_state

/datum/component/thaumaturge_preparation/ui_data(mob/living/user)
	var/list/spells_payload = list()

	for(var/datum/power/power_instance as anything in spell_list)
		var/spell_ref = "[power_instance.action_path]"
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
		"mana_spend" = mana_spend,
		"mana_remaining" = mana_remaining,
		"spell_count" = length(spells_payload),
		"spells" = spells_payload,
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
			if("[power_instance.action_path]" != spell_ref)
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
		return TRUE

	return FALSE
