
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
	/// Hud element to display our energy level.
	var/atom/movable/screen/android/energy/energy_tracker
	/// Internal cell we use for tracking our energy level.
	var/obj/item/stock_parts/power_store/internal_cell
	/// The typepath for our internal cell.
	var/internal_cell_type = /obj/item/stock_parts/power_store/cell/charging_stomach

	// TODO: register COMSIG_PROCESS_BORGCHARGER_OCCUPANT and charge on that
	// but allow this to be overridden.
	var/can_use_borg_charger = TRUE

/obj/item/organ/stomach/charging/Initialize(mapload)
	. = ..()
	internal_cell = new internal_cell_type(src)

/obj/item/organ/stomach/charging/Destroy()
	QDEL_NULL(internal_cell)
	return ..()

/obj/item/organ/stomach/charging/on_life(seconds_per_tick, times_fired)
	. = ..()
	adjust_charge(-CHARGING_STOMACH_DISCHARGE_RATE * seconds_per_tick)
	handle_charge(owner, seconds_per_tick, times_fired)

/obj/item/organ/stomach/charging/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	run_emp_effects(severity)

/// Runs our consequences for being EMP'd.
/obj/item/organ/stomach/charging/proc/run_emp_effects(severity)
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) // So we cant just spam EMP to kill people.
		// TODO: make lose charge and SPARK
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)
	if(prob(emp_vulnerability / severity))
		organ_flags |= ORGAN_EMP // Starts organ failure - gonna need replacing soon.


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
