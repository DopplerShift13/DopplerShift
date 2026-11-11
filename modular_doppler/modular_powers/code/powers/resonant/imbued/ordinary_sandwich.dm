/*
	Based on a sily convo between maints about being able to manifest a grilled cheese sandwich out of fridges.
	Tastiness scales with how ordinary the eater is. This leads to the paradox that the power owner will never fully be able to enjoy the sandwich themselves.
*/
/datum/power/imbued/ordinary_sandwich
	name = "Ordinary Grilled Cheese Sandwich Finder"
	desc = "Somehow, you always manage to find a grilled cheese sandwich left in the fridge.\
	\nFridges you open will always contain an ordinary grilled cheese sandwich. This sandwich's tastiness is determined by how ordinary a person is: the less points invested in powers, the more tasty it is. \
	Because of this, you will never be able to experience the full glory of this ordinary cheese sandwich yourself.\
	\nYou can only find an ordinary grilled cheese sandwich once every 3 minutes."
	security_record_text = "Subject seems to always find a grilled cheese sandwich in fridges, regardless of their previous contents."
	value = 1
	power_flags = POWER_HUMAN_ONLY
	required_powers = list(/datum/power/imbued_root/anomalous)

	menu_icon = 'icons/obj/food/burgerbread.dmi'
	menu_icon_state = "toastedsandwich"

	/// Limits how often the power can create a sandwich.
	COOLDOWN_DECLARE(sandwich_cooldown)

/// Creates an ordinary grilled cheese sandwich when opening a freezer.
/// Still don't like this override just for this power but it was better than the view() check
/obj/structure/closet/secure_closet/freezer/after_open(mob/living/user, force)
	. = ..()

	if(!user)
		return

	var/datum/power/imbued/ordinary_sandwich/sandwich_power = user.get_power(/datum/power/imbued/ordinary_sandwich)
	if(!sandwich_power || !COOLDOWN_FINISHED(sandwich_power, sandwich_cooldown))
		return

	new /obj/item/food/sandwich/cheese/grilled/ordinary(drop_location())
	COOLDOWN_START(sandwich_power, sandwich_cooldown, 3 MINUTES)

/// The special ordinary grilled cheese sandwich.
/obj/item/food/sandwich/cheese/grilled/ordinary
	name = "ordinary grilled cheese sandwich"
	/// The mobs which have already received the blandness warning from this sandwich.
	var/list/warned_eaters
	/// The mobs which have already received the exceptional-taste message from this sandwich.
	var/list/delighted_eaters

/// Registers handling for the sandwich being eaten.
/obj/item/food/sandwich/cheese/grilled/ordinary/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_FOOD_EATEN, PROC_REF(on_eaten))

/// Returns the food quality granted by the eater's total power-point investment.
/obj/item/food/sandwich/cheese/grilled/ordinary/proc/get_tastiness(mob/living/eater)
	var/power_points = 0
	for(var/datum/power/power_instance as anything in eater.powers)
		power_points += power_instance.value
	power_points = clamp(power_points, 0, MAXIMUM_POWER_POINTS)

	switch(power_points)
		if(0)
			return FOOD_QUALITY_TOP
		if(1 to 5)
			return FOOD_QUALITY_FANTASTIC
		if(6 to 10)
			return FOOD_QUALITY_GOOD
		if(11 to 19)
			return FOOD_QUALITY_NORMAL
		if(20 to INFINITY)
			return 0

/// Applies the sandwich's power-dependent mood effects and one-time taste messages.
/obj/item/food/sandwich/cheese/grilled/ordinary/proc/on_eaten(datum/source, mob/eater, mob/feeder, bitecount, bite_consumption)
	SIGNAL_HANDLER

	if(!isliving(eater))
		return

	var/mob/living/living_eater = eater
	var/tastiness = get_tastiness(living_eater)
	// The best of the best, for only the blandest.
	if(tastiness == FOOD_QUALITY_TOP)
		living_eater.add_mood_event("ordinary_sandwich_favorite", /datum/mood_event/favorite_food)
		if(!delighted_eaters || !(REF(living_eater) in delighted_eaters))
			to_chat(living_eater, span_notice("This is the best [name] I have ever had!"))
			LAZYADD(delighted_eaters, REF(living_eater))
	// Imagine being a munchkin
	else if(!tastiness)
		living_eater.add_mood_event("ordinary_sandwich_bland", /datum/mood_event/disgusting_food)
		if(!warned_eaters || !(REF(living_eater) in warned_eaters))
			to_chat(living_eater, span_warning("This is revoltingly bland and ordinary!"))
			LAZYADD(warned_eaters, REF(living_eater))

	RegisterSignal(living_eater, COMSIG_LIVING_GET_PERCEIVED_FOOD_QUALITY, PROC_REF(add_tastiness))

/// Adds this sandwich's quality to the tastiness calc.
/obj/item/food/sandwich/cheese/grilled/ordinary/proc/add_tastiness(mob/living/eater, datum/component/edible/edible, list/extra_quality)
	SIGNAL_HANDLER

	if(edible.parent != src)
		return

	extra_quality += get_tastiness(eater)
	UnregisterSignal(eater, COMSIG_LIVING_GET_PERCEIVED_FOOD_QUALITY)
