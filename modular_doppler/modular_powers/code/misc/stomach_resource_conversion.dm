/*
	Handles satiety costs and deductions across different unique types of stomachs, translating the resource-cost to the same amount for that stomach percentually.
*/

/// Convers the satiety cost from base satiety into an equivelant amount (percentually) in its own custom mechanics.
/obj/item/organ/stomach/proc/get_satiety_cost(amount)
	return amount

/// Returns TRUE/FALSE depending on if a mob can afford the satiety cost.
/obj/item/organ/stomach/proc/can_afford_satiety_cost(amount)
	if(amount <= 0)
		return TRUE
	if(!iscarbon(owner))
		return FALSE

	var/mob/living/carbon/carbon_owner = owner
	return carbon_owner.nutrition > (NUTRITION_LEVEL_STARVING + get_satiety_cost(amount))

/// Adjusts satiety by the given amount.
/obj/item/organ/stomach/proc/adjust_satiety(amount)
	if(amount <= 0 || !iscarbon(owner))
		return

	var/mob/living/carbon/carbon_owner = owner
	carbon_owner.adjust_nutrition(-get_satiety_cost(amount))

/*
	Special stomach versions below.
*/

/obj/item/organ/stomach/charging/get_satiety_cost(amount)
	return scale_satiety_cost(amount, CHARGING_STOMACH_CHARGE_FULL - CHARGING_STOMACH_CHARGE_LOW)

/obj/item/organ/stomach/charging/can_afford_satiety_cost(amount)
	if(amount <= 0)
		return TRUE

	var/obj/item/stock_parts/power_store/charging_cell = get_cell()
	return charging_cell?.charge() > (CHARGING_STOMACH_CHARGE_LOW + get_satiety_cost(amount))

/obj/item/organ/stomach/charging/adjust_satiety(amount)
	if(amount <= 0)
		return

	adjust_charge(-get_satiety_cost(amount))

/obj/item/organ/stomach/ethereal/get_satiety_cost(amount)
	return scale_satiety_cost(amount, ETHEREAL_CHARGE_FULL - ETHEREAL_CHARGE_LOWPOWER)

/obj/item/organ/stomach/ethereal/can_afford_satiety_cost(amount)
	if(amount <= 0)
		return TRUE

	return cell?.charge() > (ETHEREAL_CHARGE_LOWPOWER + get_satiety_cost(amount))

/obj/item/organ/stomach/ethereal/adjust_satiety(amount)
	if(amount <= 0)
		return

	adjust_charge(-get_satiety_cost(amount))

/obj/item/organ/stomach/proc/scale_satiety_cost(amount, alternate_resource_capacity)
	var/base_nutrition_capacity = NUTRITION_LEVEL_FULL - NUTRITION_LEVEL_STARVING
	if(amount <= 0 || alternate_resource_capacity <= 0 || base_nutrition_capacity <= 0)
		return amount

	return amount / base_nutrition_capacity * alternate_resource_capacity
