/// Returns the actual hunger cost when adjusted for our usable range.
/obj/item/organ/stomach/proc/get_adjusted_hunger_cost(base_cost)
	return base_cost * get_usable_hunger_range()

/// Gets the reference range for how much this can reasonably be drained by hunger effects before being a problem.
/obj/item/organ/stomach/proc/get_usable_hunger_range()
	return ABERRANT_HUNGER_COST_BASE

/// Gets the minimum level above which we need to be to invoke any hunger cost.
/obj/item/organ/stomach/proc/get_hunger_range_minimum()
	return NUTRITION_LEVEL_STARVING

/// Gets the value we're subtracting hunger costs off.
/obj/item/organ/stomach/proc/get_hunger_target_value()
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/carbon_owner = owner
	return carbon_owner.nutrition

/// Returns whether the owner of this stomach can afford the given hunger cost.
// (remove comment) this is written as it is so we don't have to override this proc and its math every time
/obj/item/organ/stomach/proc/can_afford_hunger_cost(base_cost)
	if(base_cost <= 0)
		return TRUE

	var/target_value = get_hunger_target_value()
	var/minimum_value = get_hunger_range_minimum()
	var/adjusted_cost = get_adjusted_hunger_cost(base_cost)

	return target_value >= (minimum_value + adjusted_cost)

/// Spends the given hunger cost.
/obj/item/organ/stomach/proc/spend_hunger(base_cost)
	if(base_cost <= 0 || !iscarbon(owner))
		return

	var/mob/living/carbon/carbon_owner = owner
	carbon_owner.adjust_nutrition(-get_adjusted_hunger_cost(base_cost))


/*
	Special stomach versions below.
*/

/// Charging stomach
/obj/item/organ/stomach/charging/get_usable_hunger_range()
	return (CHARGING_STOMACH_CHARGE_FULL - CHARGING_STOMACH_CHARGE_LOW)

/obj/item/organ/stomach/charging/get_hunger_range_minimum()
	return CHARGING_STOMACH_CHARGE_LOW

/obj/item/organ/stomach/charging/spend_hunger(base_cost)
	if(base_cost <= 0)
		return
	adjust_charge(-get_adjusted_hunger_cost(base_cost))

/// Ethereal stomach
/obj/item/organ/stomach/ethereal/get_usable_hunger_range()
	return ( ETHEREAL_CHARGE_FULL - ETHEREAL_CHARGE_LOWPOWER)

/obj/item/organ/stomach/ethereal/get_hunger_range_minimum()
	return ETHEREAL_CHARGE_LOWPOWER

/obj/item/organ/stomach/ethereal/spend_hunger(base_cost)
	if(base_cost <= 0)
		return
	adjust_charge(-get_adjusted_hunger_cost(base_cost))
