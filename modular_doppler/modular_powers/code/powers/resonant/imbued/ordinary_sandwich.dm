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
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	required_powers = list(/datum/power/imbued_root/anomalous)

	menu_icon = 'icons/obj/food/burgerbread.dmi'
	menu_icon_state = "toastedsandwich"

	/// Freezers which are currently watched for being opened by the power holder.
	var/list/watched_freezers = list()
	/// Limits how often the power can create a sandwich.
	COOLDOWN_DECLARE(sandwich_cooldown)

/// Watches nearby freezers for successful opening. Yeah, this is the LAZIEST way to do it, but there's genuinely no way to signal into random locker openings that's any better and I am not adding a signaler JUST FOR THIS.
/datum/power/imbued/ordinary_sandwich/process(seconds_per_tick)
	var/list/visible_freezers = list()
	for(var/obj/structure/closet/secure_closet/freezer/freezer as anything in view(power_holder))
		visible_freezers += freezer
		if(freezer in watched_freezers)
			continue
		RegisterSignal(freezer, COMSIG_CLOSET_POST_OPEN, PROC_REF(on_freezer_opened))
		watched_freezers += freezer

	for(var/obj/structure/closet/secure_closet/freezer/freezer as anything in watched_freezers.Copy())
		if(freezer in visible_freezers)
			continue
		UnregisterSignal(freezer, COMSIG_CLOSET_POST_OPEN)
		watched_freezers -= freezer

/// Stops watching every freezer tracked by this power.
/datum/power/imbued/ordinary_sandwich/remove()
	for(var/obj/structure/closet/secure_closet/freezer/freezer as anything in watched_freezers)
		UnregisterSignal(freezer, COMSIG_CLOSET_POST_OPEN)
	watched_freezers.Cut()
	return ..()

/// Creates a sandwich after the power holder successfully opens a watched freezer.
/datum/power/imbued/ordinary_sandwich/proc/on_freezer_opened(obj/structure/closet/secure_closet/freezer/freezer, mob/living/user, force)
	SIGNAL_HANDLER

	if(user != power_holder || !COOLDOWN_FINISHED(src, sandwich_cooldown))
		return

	new /obj/item/food/sandwich/cheese/grilled/ordinary(freezer.drop_location())
	COOLDOWN_START(src, sandwich_cooldown, 3 MINUTES)

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
	addtimer(CALLBACK(src, PROC_REF(clear_tastiness_handler), living_eater), 0)

/// Adds this sandwich's quality to the tastiness calc.
/obj/item/food/sandwich/cheese/grilled/ordinary/proc/add_tastiness(mob/living/eater, datum/component/edible/edible, list/extra_quality)
	SIGNAL_HANDLER

	if(edible.parent != src)
		return

	UnregisterSignal(eater, COMSIG_LIVING_GET_PERCEIVED_FOOD_QUALITY)
	extra_quality += get_tastiness(eater)

/// Removes the tastiness handler after taking a bite.
/obj/item/food/sandwich/cheese/grilled/ordinary/proc/clear_tastiness_handler(mob/living/eater)
	UnregisterSignal(eater, COMSIG_LIVING_GET_PERCEIVED_FOOD_QUALITY)
