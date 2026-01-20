
/obj/item/organ/stomach/charging
	abstract_type = /obj/item/organ/stomach/charging
	name = "abstract charging stomach"
	desc = "You have peered betwixt the veil and found... An abstract electronic device, \
	designed to allow a body to subsist off of electrical charge. Make an issue report."
	failing_desc = "seems to be broken."
	icon_state = "stomach-c-u"
	organ_traits = list(TRAIT_NOHUNGER) // We have our own hunger mechanic.
	organ_flags = ORGAN_ROBOTIC
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	disgust_metabolism = 2
	metabolism_efficiency = 0.07

	// Chance of permanent effects when EMP'd.
	var/emp_vulnerability = 40
	// but allow this to be overridden.
	var/can_use_borg_charger = TRUE

	/// The rate at which this stomach type discharges.
	var/discharge_rate = CHARGING_STOMACH_DISCHARGE_RATE
	/// The amount with which this stomach type discharges when EMP'd.
	var/emp_discharge = CHARGING_STOMACH_EMP_DISCHARGE
	/// The amount this stomach type recharges back up to on revival.
	var/revival_charge = CHARGING_STOMACH_REVIVAL_CHARGE
	/// The amount of charge below which this stomach type considers itself low on charge.
	var/low_charge_threshold = CHARGING_STOMACH_CHARGE_LOW

	/// Hud element to display our energy level.
	var/atom/movable/screen/android/energy/energy_tracker
	/// Internal cell we use for tracking our energy level.
	var/obj/item/stock_parts/power_store/internal_cell
	/// The typepath for our internal cell.
	var/internal_cell_type = /obj/item/stock_parts/power_store/cell/charging_stomach

/obj/item/organ/stomach/charging/Initialize(mapload)
	. = ..()
	internal_cell = new internal_cell_type(src)

/obj/item/organ/stomach/charging/Destroy()
	QDEL_NULL(internal_cell)
	return ..()

/obj/item/organ/stomach/charging/on_mob_insert(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	apply_energy_hud(organ_owner)
	RegisterSignal(organ_owner, COMSIG_LIVING_REVIVE, PROC_REF(on_revival))
	if(can_use_borg_charger)
		RegisterSignal(organ_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(on_borgcharger_charge))

/obj/item/organ/stomach/charging/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	remove_energy_hud(organ_owner)
	UnregisterSignal(organ_owner, list(COMSIG_LIVING_REVIVE, COMSIG_PROCESS_BORGCHARGER_OCCUPANT))
	organ_owner.remove_movespeed_modifier(/datum/movespeed_modifier/android_nocharge)

/obj/item/organ/stomach/charging/on_life(seconds_per_tick, times_fired)
	. = ..()
	adjust_charge(-discharge_rate * seconds_per_tick)

/obj/item/organ/stomach/charging/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	run_emp_effects(severity)

/// Adjust our charge, handle subsequent charge effects.
/obj/item/organ/stomach/charging/proc/adjust_charge(amount)
	internal_cell.change(amount)
	handle_charge_effects()

/// Handles applying the consequences of our current charge level.
/obj/item/organ/stomach/charging/proc/handle_charge_effects()
	update_energy_hud()
	if(internal_cell.charge() <= 0)
		owner.add_movespeed_modifier(/datum/movespeed_modifier/android_nocharge)
	else
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/android_nocharge)

/// Runs our consequences for being EMP'd.
/obj/item/organ/stomach/charging/proc/run_emp_effects(severity)
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) // So we cant just spam EMP to kill people.
		adjust_charge(-emp_discharge)
		var/atom/movable/sparks_source = owner ? owner : src
		do_sparks(3, FALSE, sparks_source)
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)
	if(prob(emp_vulnerability / severity))
		organ_flags |= ORGAN_EMP // Starts organ failure - gonna need replacing soon.

/// Handles refilling ourselves slightly when our host gets revived, as a grace period.
/obj/item/organ/stomach/charging/proc/on_revival(datum/source, full_heal_flags)
	SIGNAL_HANDLER
	var/charge_difference = revival_charge - internal_cell.charge()
	if(charge_difference <= 0)
		return
	adjust_charge(charge_difference)

/// Handles our charging when inside of a borg charger.
/obj/item/organ/stomach/charging/proc/on_borgcharger_charge(datum/source, datum/callback/charge_cell, seconds_per_tick)
	SIGNAL_HANDLER
	charge_cell.Invoke(internal_cell, seconds_per_tick)
	handle_charge_effects()

/// Update our energy hud, if needed.
/obj/item/organ/stomach/charging/proc/update_energy_hud()
	if(isnull(energy_tracker))
		if(!apply_energy_hud(owner))
			return
	energy_tracker.update_energy_hud(internal_cell.charge())

/// Apply our energy hud, if we haven't already applied one.
/obj/item/organ/stomach/charging/proc/apply_energy_hud(mob/living/carbon/organ_owner)
	if(energy_tracker)
		return FALSE
	if(isnull(organ_owner?.hud_used))
		return FALSE
	var/datum/hud/hud_used = organ_owner.hud_used
	energy_tracker = new(FALSE, hud_used, low_charge_threshold)
	hud_used.infodisplay += energy_tracker
	hud_used.show_hud(hud_used.hud_version)
	return TRUE

/// Remove our energy hud, if we currently have one applied.
/obj/item/organ/stomach/charging/proc/remove_energy_hud(mob/living/carbon/organ_owner)
	if(isnull(energy_tracker))
		return
	if(isnull(organ_owner?.hud_used))
		return
	organ_owner.hud_used.infodisplay -= energy_tracker
	QDEL_NULL(energy_tracker)

/// Get a string representing our current charge, for use in crew monitors or such.
/obj/item/organ/stomach/charging/proc/get_charge_string()
	var/current_charge = internal_cell.charge()
	if(current_charge > 0.01 MEGA JOULES)
		return "[round((current_charge/(1 MEGA JOULES)), 0.1)]MJ"
	if(current_charge > 0.01 KILO JOULES)
		return "[round((current_charge/(1 KILO JOULES)), 0.1)]kJ"
	return "[round(current_charge, 0.1)]J"

/// Internal cell used by the charging stomach type.
/obj/item/stock_parts/power_store/cell/charging_stomach
	name = "ahelp it"
	desc = "You shouldn't see this. Make an issue report."
	maxcharge = CHARGING_STOMACH_CHARGE_FULL
	charge = CHARGING_STOMACH_CHARGE_START
	icon_state = null
	charge_light_type = null
	connector_type = null
	custom_materials = null
	grind_results = null
	emp_damage_modifier = 0

/obj/item/stock_parts/power_store/cell/charging_stomach/examine(mob/user)
	. = ..()
	CRASH("[src.type] got examined by [user]")
