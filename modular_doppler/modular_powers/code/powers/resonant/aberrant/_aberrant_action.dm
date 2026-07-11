/datum/action/cooldown/power/aberrant
	name = "abstract aberrant power action - ahelp this"
	background_icon_state = "bg_aberrant"
	overlay_icon_state = "bg_aberrant_border"

	/// How much hunger cost the ability use has
	var/cost

// Block use while starving.
/datum/action/cooldown/power/aberrant/can_use(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	if(!can_pay_hunger_cost(user, cost))
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	return TRUE

// Action cost
/datum/action/cooldown/power/aberrant/on_action_success(mob/living/user, atom/target)
	. = ..()
	modify_hunger(cost, user)

// General handler that handles both hunger costs and alt resource costs.
/datum/action/cooldown/power/aberrant/proc/modify_hunger(amount, mob/living/user = owner)
	if(amount <= 0 || !iscarbon(user))
		return

	var/mob/living/carbon/carbon_user = user
	var/obj/item/organ/stomach/stomach = carbon_user.get_organ_slot(ORGAN_SLOT_STOMACH)

	/// Android stomachs
	if(istype(stomach, /obj/item/organ/stomach/charging))
		var/obj/item/organ/stomach/charging/charging_stomach = stomach
		charging_stomach.adjust_charge(-get_scaled_hunger_cost(amount, ABERRANT_ANDROID_HUNGER_COST_BASE))
		return

	/// Ethereal stomachs
	if(istype(stomach, /obj/item/organ/stomach/ethereal))
		var/obj/item/organ/stomach/ethereal/ethereal_stomach = stomach
		ethereal_stomach.adjust_charge(-get_scaled_hunger_cost(amount, ABERRANT_ETHEREAL_HUNGER_COST_BASE))
		return

	carbon_user.adjust_nutrition(-amount)

/// Returns TRUE when the user can afford an aberrant hunger cost with their current type of stomach
/datum/action/cooldown/power/aberrant/proc/can_pay_hunger_cost(mob/living/user, amount)
	if(amount <= 0)
		return TRUE
	if(!iscarbon(user))
		return FALSE

	var/mob/living/carbon/carbon_user = user
	var/obj/item/organ/stomach/stomach = carbon_user.get_organ_slot(ORGAN_SLOT_STOMACH)

	/// Android stomachs
	if(istype(stomach, /obj/item/organ/stomach/charging))
		var/obj/item/organ/stomach/charging/charging_stomach = stomach
		var/scaled_amount = get_scaled_hunger_cost(amount, ABERRANT_ANDROID_HUNGER_COST_BASE)
		var/obj/item/stock_parts/power_store/charging_cell = charging_stomach.get_cell()
		return charging_cell?.charge() > (CHARGING_STOMACH_CHARGE_LOW + scaled_amount)

	/// Ethereal stomachs
	if(istype(stomach, /obj/item/organ/stomach/ethereal))
		var/obj/item/organ/stomach/ethereal/ethereal_stomach = stomach
		var/scaled_amount = get_scaled_hunger_cost(amount, ABERRANT_ETHEREAL_HUNGER_COST_BASE)
		return ethereal_stomach.cell?.charge() > (ETHEREAL_CHARGE_LOWPOWER + scaled_amount)

	return carbon_user.nutrition > (NUTRITION_LEVEL_STARVING + amount)

/// Scales a standard aberrant hunger amount into an equivalent amount for an alternate hunger equivelants.
/datum/action/cooldown/power/aberrant/proc/get_scaled_hunger_cost(amount, special_cost_base)
	if(amount <= 0 || special_cost_base <= 0 || ABERRANT_HUNGER_COST_BASE <= 0) // NO HUNGRY LITTLE BOY, DON'T DIVIDE BY ZERO-
		return amount
	return amount / ABERRANT_HUNGER_COST_BASE * special_cost_base // divide by base cost = rough-percentage amount that we want to subtract in resources.
