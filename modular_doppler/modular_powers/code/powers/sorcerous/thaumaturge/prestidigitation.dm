// The classic cantrip that does neat things to make you feel magical, without needing to spend precious spell charges.
/datum/power/thaumaturge/prestidigtation
	name = "Prestidigtation"
	desc = "Perform a minor feat of magic. Right-click to select between modes, Left-click to execute.\
	\nAllows you to do various actions like summoning sparks, cleaning objects and flavor food.\
	\nRequires Affinity 1. Does not scale with Affinity and does not use charges."
	security_record_text = "Subject can perform minor magical tricks, such as creating sparks and flavoring food."
	value = 1

	action_path = /datum/action/cooldown/power/thaumaturge/prestidigtation
	required_powers = list(/datum/power/thaumaturge_root)

#define PRESTI_SUMMON_SPARKS "Summon Sparks"
#define PRESTI_CLEAN_OBJECTS "Clean Objects"
#define PRESTI_FLASH_MAGIC "Flash Magic"
#define PRESTI_FLAVOR_GOOD "Flavor Food (Good)"
#define PRESTI_FLAVOR_BAD "Flavor Food (Bad)"

/datum/action/cooldown/power/thaumaturge/prestidigtation
	name = "Prestidigtation"
	desc = "Perform a minor feat of magic on an object or location within touch range. Right-click to select between modes, Left-click to execute"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "spell_default"

	max_charges = 0 // does not interact with the charges system
	required_affinity = 1

	click_to_activate = TRUE
	target_range = 1
	aim_assist = FALSE // complex targeting

	/// Currently selected prestidigitation mode.
	var/selected_mode = PRESTI_SUMMON_SPARKS

/datum/action/cooldown/power/thaumaturge/prestidigtation/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/mods = params2list(params)
	if(LAZYACCESS(mods, RIGHT_CLICK))
		open_selection_menu(clicker)
		return TRUE

	return ..()

/// Routes for our various unique actions
/datum/action/cooldown/power/thaumaturge/prestidigtation/use_action(mob/living/user, atom/target)
	switch(selected_mode)
		if(PRESTI_SUMMON_SPARKS)
			return summon_sparks(user, target)
		if(PRESTI_CLEAN_OBJECTS)
			return clean_objects(user, target)
		if(PRESTI_FLASH_MAGIC)
			return flash_magic(user, target)
		if(PRESTI_FLAVOR_GOOD)
			return flavor_food_good(user, target)
		if(PRESTI_FLAVOR_BAD)
			return flavor_food_bad(user, target)
	return FALSE

/// Right click selection menu that lets you choose what you are doing with your presti.
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/open_selection_menu(mob/living/user)
	if(!check_selection_menu(user))
		return FALSE

	var/list/radial_items = get_radial_items()
	var/choice = show_radial_menu(
		user,
		user, // anchor for placement
		radial_items,
		custom_check = CALLBACK(src, PROC_REF(check_selection_menu), user, target),
		tooltips = TRUE
	)

	if(!choice)
		return FALSE

	selected_mode = choice
	user.balloon_alert(user, "[selected_mode]")
	return TRUE

/// Validation for the right click
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/check_selection_menu(mob/living/user, atom/target)
	if(QDELETED(src))
		return FALSE
	if(!istype(user))
		return FALSE
	if(!can_use(user, target))
		return FALSE
	return TRUE

/// Populates our list of 'actions' our prestidigation spell can take.
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/get_radial_items()
	var/static/list/radial_items
	if(radial_items)
		return radial_items

	radial_items = list()

	var/list/options = list(
		PRESTI_SUMMON_SPARKS = list("icon" = 'icons/effects/effects.dmi', "state" = "electricity3"),
		PRESTI_CLEAN_OBJECTS = list("icon" = 'icons/obj/watercloset.dmi', "state" = "soap"),
		PRESTI_FLASH_MAGIC = list("icon" = 'icons/mob/actions/actions_spells.dmi', "state" = "exit_possession"),
		PRESTI_FLAVOR_GOOD = list("icon" = 'icons/obj/drinks/mixed_drinks.dmi', "state" = "wizz_fizz"),
		PRESTI_FLAVOR_BAD = list("icon" = 'icons/obj/drinks/drinks.dmi', "state" = "acidspitglass")
	)

	for(var/option_name in options)
		var/list/entry = options[option_name]
		var/datum/radial_menu_choice/choice = new()
		choice.name = option_name
		choice.image = image(icon = entry["icon"], icon_state = entry["state"])
		radial_items[option_name] = choice

	return radial_items

/// Summons sparks as if you were spamming the RCD
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/summon_sparks(mob/living/user, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	do_sparks(5, FALSE, target_turf)
	return TRUE

/// Cleans everything on the target turf.
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/clean_objects(mob/living/user, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	target_turf.wash(CLEAN_WASH, TRUE)
	playsound(user, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	new /obj/effect/temp_visual/presti_clean(target_turf)
	to_chat(user, span_notice("You clean [target]!"))
	return TRUE

/// Calls flash_blue. You did a magic thing; as placebo as it gets.
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/flash_magic(mob/living/user, atom/target)
	flash_blue(target)
	playsound(user, 'sound/effects/magic/charge.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, span_notice("You make [target] feel magical! Wow!"))
	return TRUE

/// Flashes a target item blue briefly.
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/flash_blue(atom/target)
	if(!isatom(target))
		return
	var/filter_id = "presti_flash"
	target.add_filter(filter_id, 1, list(type = "outline", color = "#7266dd", size = 2, alpha = 255))
	target.transition_filter(filter_id, list("alpha" = 0), 2 SECONDS) // this actually looks smoother
	addtimer(CALLBACK(target, PROC_REF(remove_filter), filter_id), 2 SECONDS)

/// Adds a flavor component to food that makes it slightly better
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/flavor_food_good(mob/living/user, atom/target)
	if(!IS_EDIBLE(target))
		return FALSE
	if(!target.reagents)
		target.create_reagents(5, INJECTABLE)
	target.AddComponent(/datum/component/prestidigitation_flavor, TRUE)
	flash_blue(target) // temporary filter just to show people are tampering with food
	playsound(user, 'sound/effects/magic/charge.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	to_chat(user, span_notice("You make [target] taste better!"))
	return TRUE

/// Adds a flavor component to food that makes it notoriously worse (its easier to screw it up than to make it better)
/datum/action/cooldown/power/thaumaturge/prestidigtation/proc/flavor_food_bad(mob/living/user, atom/target)
	if(!IS_EDIBLE(target))
		return FALSE
	if(!target.reagents)
		target.create_reagents(5, INJECTABLE)
	target.AddComponent(/datum/component/prestidigitation_flavor, FALSE)
	flash_blue(target) // temporary filter just to show people are tampering with food
	playsound(user, 'sound/effects/magic/charge.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	to_chat(user, span_notice("You make [target] taste worse!"))
	return TRUE

#undef PRESTI_SUMMON_SPARKS
#undef PRESTI_CLEAN_OBJECTS
#undef PRESTI_FLASH_MAGIC
#undef PRESTI_FLAVOR_GOOD
#undef PRESTI_FLAVOR_BAD

/// Temp effect for the cleaning sparkles
/obj/effect/temp_visual/presti_clean
	icon_state = "shieldsparkles"
	duration = 1 SECONDS

/// Flavor component added by presti: tweaks quality and expires on eat.
/datum/component/prestidigitation_flavor
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// TRUE for good flavor, FALSE for bad.
	var/is_good = TRUE
	/// Quality bonus applied to the food.
	var/quality_bonus = 0

/datum/component/prestidigitation_flavor/Initialize(good_flavor = TRUE)
	if(!IS_EDIBLE(parent))
		return COMPONENT_INCOMPATIBLE
	is_good = good_flavor
	quality_bonus = is_good ? 1 : 0

/datum/component/prestidigitation_flavor/RegisterWithParent()
	RegisterSignal(parent, COMSIG_FOOD_EATEN, PROC_REF(on_food_eaten))
	if(quality_bonus)
		RegisterSignal(parent, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, PROC_REF(add_quality), TRUE)

/datum/component/prestidigitation_flavor/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_FOOD_EATEN)
	UnregisterSignal(parent, COMSIG_FOOD_GET_EXTRA_COMPLEXITY)

/// Adds quality to a flavor component
/datum/component/prestidigitation_flavor/proc/add_quality(datum/source, list/extra_complexity)
	SIGNAL_HANDLER
	extra_complexity[1] += quality_bonus

/// Signaler for bad mood to give the disgusting fod modlet.
/datum/component/prestidigitation_flavor/proc/on_food_eaten(datum/source, mob/eater, mob/feeder, bitecount, bite_consumption)
	SIGNAL_HANDLER
	if(!isliving(eater))
		return
	var/mob/living/living_eater = eater
	if(!is_good) // just give the disgusting food moodlet despite existing taste.
		living_eater.add_mood_event("presti_flavor_bad", /datum/mood_event/disgusting_food)
	qdel(src)
