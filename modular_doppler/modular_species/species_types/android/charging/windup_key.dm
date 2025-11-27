
/obj/item/organ/stomach/charging/windup_key
	name = "windup key charging apparatus"
	desc = "" // TODO
	emp_vulnerability = 0 // We're a windup key.
	internal_cell_type = /obj/item/stock_parts/power_store/cell/charging_stomach/windup_key

/obj/item/organ/stomach/charging/windup_key/emp_act(severity)
	return // We're a windup key.

/obj/item/organ/stomach/charging/windup_key/on_mob_insert(mob/living/carbon/stomach_owner)
	. = ..()
	RegisterSignal(stomach_owner, COMSIG_CARBON_PRE_MISC_HELP, PROC_REF(on_pre_misc_help))

/obj/item/organ/stomach/charging/windup_key/on_mob_remove(mob/living/carbon/stomach_owner)
	. = ..()
	UnregisterSignal(stomach_owner, COMSIG_CARBON_PRE_MISC_HELP)

/obj/item/organ/stomach/charging/windup_key/proc/on_pre_misc_help(datum/source, mob/living/carbon/helper)
	SIGNAL_HANDLER
	// TODO: if behind person, invoke wind_up async and return COMPONENT_BLOCK_MISC_HELP, otherwise return NONE
	return COMPONENT_BLOCK_MISC_HELP

/obj/item/organ/stomach/charging/windup_key/proc/wind_up()
	return // TODO: ACTUALLY CHARGE HERE; make bad touch apply cause it's funny


/obj/item/stock_parts/power_store/cell/charging_stomach/windup_key
	maxcharge = WINDUP_KEY_CHARGE_FULL
	charge = WINDUP_KEY_CHARGE_START
