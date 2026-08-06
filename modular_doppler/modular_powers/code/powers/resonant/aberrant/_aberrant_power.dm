/datum/power/aberrant
	name = "Aberrant Power"
	desc = "Oh my god how horrifying; an abstract parent type! Such an abomination. Not meant for your mortal eyes."

	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_ABERRANT
	priority = POWER_PRIORITY_BASIC
	abstract_parent_type = /datum/power/aberrant
	magic_flags = POWER_MAGIC_STANDARD

/// Spends aberrant hunger using the owner's stomach when present, falling back to nutrition otherwise.
/datum/power/aberrant/proc/spend_hunger(amount, mob/living/carbon/user = power_holder)
	if(amount <= 0 || !istype(user))
		return

	var/obj/item/organ/stomach/stomach = user.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(stomach)
		stomach.spend_hunger(amount)
		return

	user.adjust_nutrition(-(amount * ABERRANT_HUNGER_COST_BASE))

/// Returns whether the given user can afford an aberrant hunger cost.
/datum/power/aberrant/proc/can_afford_hunger(amount, mob/living/carbon/user = power_holder)
	if(amount <= 0)
		return TRUE
	if(!istype(user))
		return FALSE

	var/obj/item/organ/stomach/stomach = user.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(stomach)
		return stomach.can_afford_hunger_cost(amount)

	return user.nutrition >= (NUTRITION_LEVEL_STARVING + (amount * ABERRANT_HUNGER_COST_BASE))
