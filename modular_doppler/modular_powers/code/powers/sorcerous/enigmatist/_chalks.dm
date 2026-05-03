#define CAT_ENIGMATIST "Enigmatist"

/**
 * Base Enigmatist Chalk
 */

/* Though crass, I am commenting this out largely because this will get development later.

// TODO: make a basic enigmatist chalk item.
// TODO: using it sends a signal to the user and collects a list of powers there.
// Signal probably includes the type of chalk.

/obj/item/enigmatist_chalk
	name = "enigmatist chalk"
	desc = "An abstract chalk item. Looks tasty. Mmmm... \
	Wait it's abstract in the coding sense. Quick, report it!"
	icon = 'icons/obj/art/crayons.dmi'
	icon_state = "crayonwhite"
	worn_icon_state = "crayon"

	// stats parallel to crayons
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	attack_verb_continuous = list("attacks", "colours")
	attack_verb_simple = list("attack", "colour")
	grind_results = list()
	interaction_flags_atom = parent_type::interaction_flags_atom | INTERACT_ATOM_IGNORE_MOBILITY

	/// Bitflag of which types of enigmatist powers this can invoke.
	var/enigmatist_flags = NONE
	/// Our current integrity. When this reaches <0, we break.
	var/resonant_integrity = ENIGMATIST_CHALK_STANDARD_INTEGRITY
	/// Our maximum integrity.
	var/max_resonant_integrity = ENIGMATIST_CHALK_STANDARD_INTEGRITY
	/// The currently selected enigmatist power, if any.
	var/datum/weakref/current_selected_power_ref

/obj/item/enigmatist_chalk/Initialize(mapload)
	. = ..()
	register_context()
	register_item_context()

/obj/item/enigmatist_chalk/Destroy(force)
	current_selected_power_ref = null
	return ..()


/obj/item/enigmatist_chalk/examine(mob/user)
	. = ..()
	. += span_notice("It's at [EXAMINE_HINT("[integrity_percent()]%")] integrity.")

/obj/item/enigmatist_chalk/add_context(
	atom/source,
	list/context,
	obj/item/held_item,
	mob/user,
)
	var/datum/power/enigmatist_spell/current_selected_power = current_selected_power_ref?.resolve()
	if(isnull(current_selected_power))
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Select spell"
		return CONTEXTUAL_SCREENTIP_SET

	if(current_selected_power.power_holder == user)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Reset selection"
	else
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Select spell"
	current_selected_power.chalk_add_context(src, context, held_item, user)
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/enigmatist_chalk/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
	mob/living/user,
)
	var/datum/power/enigmatist_spell/current_selected_power = current_selected_power_ref?.resolve()
	if(isnull(current_selected_power))
		return NONE
	return current_selected_power.chalk_add_item_context(src, context, target, user)


/obj/item/enigmatist_chalk/attack_self(mob/user, modifiers)
	. = ..()
	var/datum/power/enigmatist_spell/current_selected_power = current_selected_power_ref?.resolve()
	if(isnull(current_selected_power))
		return
	return current_selected_power.chalk_attack_self(src, user, modifiers)

/obj/item/enigmatist_chalk/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/datum/power/enigmatist_spell/current_selected_power = current_selected_power_ref?.resolve()
	if(isnull(current_selected_power))
		return NONE
	return current_selected_power.chalk_interact_with_atom(src, interacting_with, user, modifiers)

/obj/item/enigmatist_chalk/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	var/datum/power/enigmatist_spell/current_selected_power = current_selected_power_ref?.resolve()
	if(isnull(current_selected_power))
		return NONE
	return current_selected_power.chalk_interact_with_atom_secondary(src, interacting_with, user, modifiers)


/obj/item/enigmatist_chalk/click_alt(mob/user)
	var/datum/power/enigmatist_spell/current_selected_power = current_selected_power_ref?.resolve()
	if(current_selected_power)
		current_selected_power_ref = null
		current_selected_power.chalk_reset_spell(user, src)
		// Act as if nothing happened only if our spell wasn't set by our previous user.
		if(current_selected_power.power_holder == user)
			balloon_alert(user, "selection reset")
			return CLICK_ACTION_SUCCESS

	var/list/spell_options = list()
	SEND_SIGNAL(user, COMSIG_ENIGMATIST_CHALK_SELECTION, enigmatist_flags, spell_options)
	if(!length(spell_options))
		balloon_alert(user, "you know nothing!")
		return CLICK_ACTION_BLOCKING

	var/list/radial_items = list()
	for(var/spell_name as anything in spell_options)
		var/datum/power/enigmatist_spell/spell_option = spell_options[spell_name]
		var/datum/radial_menu_choice/radial_option = new()
		radial_option.name = spell_option.get_option_name()
		radial_option.info = spell_option.get_option_desc()
		radial_option.image = image(icon = spell_option.option_icon, icon_state = spell_option.option_icon_state)
		radial_items[spell_option.name] = radial_option
	sort_list(radial_items)

	message_admins("click_alt PRE-RADIAL -<br>radial_items: [radial_items]<br>spell_options: [spell_options]")
	for(var/radial_name as anything in radial_items)
		message_admins("click_alt PRE-RADIAL-LOOP -<br>radial_name: [radial_name]<br>entry: [radial_items[radial_name]]")

	var/chosen_option = show_radial_menu(user, src, radial_items, custom_check = CALLBACK(src, PROC_REF(check_selection_menu), user), require_near = TRUE, tooltips = TRUE)
	message_admins("click_alt POST RADIAL -<br>chosen_option: [chosen_option]")
	if(isnull(chosen_option))
		return CLICK_ACTION_BLOCKING
	var/datum/power/enigmatist_spell/chosen_spell = spell_options[chosen_option]
	if(isnull(chosen_spell))
		return CLICK_ACTION_BLOCKING

	current_selected_power_ref = WEAKREF(chosen_spell)
	chosen_spell.chalk_selected_spell(user, src)
	balloon_alert(user, "spell selected")
	return CLICK_ACTION_SUCCESS

/// C
/obj/item/enigmatist_chalk/proc/check_selection_menu(mob/user)
	if(QDELETED(src))
		return FALSE
	if(!istype(user))
		return FALSE
	if(user.incapacitated)
		return FALSE
	return TRUE


/// Gets the percentage of its maximum our current integrity is at.
/obj/item/enigmatist_chalk/proc/integrity_percent()
	return PERCENT(resonant_integrity / max_resonant_integrity)

/// Try to use a given amount of integrity. If we don't have enough, don't and return FALSE.
/obj/item/enigmatist_chalk/proc/use_integrity(damage, user)
	if(damage > resonant_integrity)
		return FALSE
	resonant_integrity -= damage
	if(resonant_integrity <= 0)
		break_chalk(user)
	return TRUE

/// Breaks the chalk! Sends feedback if given a user.
/obj/item/enigmatist_chalk/proc/break_chalk(user)
	if(user)
		balloon_alert(user, "chalk shatters!")
	// TODO: replace with remnants if possible.
	// TODO: add sounds if possible.
	qdel(src)

/**
 * Practical Chalk Items
 */

/obj/item/enigmatist_chalk/resonant
	name = "resonant chalk"
	desc = "A stark-white stick of chalk. \
	Its texture shifts as you turn it."
	icon_state = "crayonwhite"
	enigmatist_flags = ENIGMATIST_RESONANT

/obj/item/enigmatist_chalk/unsealed
	name = "unsealed chalk"
	desc = "A stick of chalk with an odd purple hue. \
	It doesn't obscure what's behind it."
	icon_state = "crayonpurple"
	enigmatist_flags = ENIGMATIST_UNSEALED

/obj/item/enigmatist_chalk/illuminated
	name = "illuminated chalk"
	desc = "A stick of chalk with an odd yellow hue. \
	It seems well-lit regardless of lighting."
	icon_state = "crayonyellow"
	enigmatist_flags = ENIGMATIST_ILLUMINATED

/obj/item/enigmatist_chalk/divided
	name = "divided chalk"
	desc = "A stick of chalk with an odd blue hue. \
	Its edges look sharp no matter the angle."
	icon_state = "crayonblue"
	enigmatist_flags = ENIGMATIST_DIVIDED

/**
 * Resonant Chalk
 */

/datum/crafting_recipe/resonant_chalk
	name = "Resonant Chalk"
	result = /obj/item/enigmatist_chalk/resonant
	reqs = list(
		/obj/item/stack/sheet/mineral/plasma = 1,
		/obj/item/toy/crayon = 1,
	)
	blacklist = list(
		/obj/item/toy/crayon/spraycan,
	)
	time = 5 SECONDS
	category = CAT_ENIGMATIST
	crafting_flags = CRAFT_MUST_BE_LEARNED

#undef CAT_ENIGMATIST
*/
