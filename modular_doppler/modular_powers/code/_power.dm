
// Every power should be coded around being applied on spawn.
/datum/power
	/// The name of the power
	var/name = "Test Power"
	/// The description of the power
	var/desc = "This is a test power."
	/// What the power is worth in preferences, zero = neutral / free
	var/value = 0
	/// Flags related to this power.
	var/power_flags = POWER_HUMAN_ONLY
	/// Reference to the mob currently tied to this power datum. Powers are not singletons.
	var/mob/living/power_holder
	/// if applicable, apply and remove this mob trait
	var/mob_trait
	/// Species that cannot pick this power. If species_blacklist_is_whitelist is TRUE, only these species can.
	var/list/species_blacklist
	/// If TRUE, species_blacklist becomes a whitelist.
	var/species_blacklist_is_whitelist = FALSE
	/// Amount of points this trait is worth towards the hardcore character mode.
	/// Minus points implies a positive power, positive means its hard.
	/// This is used to pick the powers assigned to a hardcore character.
	//// 0 means its not available to hardcore draws.
	var/hardcore_value = 0
	/// When making an abstract power (in OOP terms), don't forget to set this var to the type path for that abstract power.
	var/abstract_parent_type = /datum/power
	/// max stat below which this power can process (if it has POWER_PROCESSES) and above which it stops.
	/// If null, then it will process regardless of stat.
	var/maximum_process_stat = HARD_CRIT
	/// A list of additional signals to register with update_process()
	var/list/process_update_signals
	/// A list of traits that should stop this power from processing.
	/// Signals for adding and removing this trait will automatically be added to `process_update_signals`.
	var/list/no_process_traits
	/// Is it not available in the preference menu?
	var/available_in_prefs = TRUE

	/// The overarching archetype this belongs to.
	var/archetype
	/// The path this belongs to.
	var/path
	/// The priority this has.
	var/priority = NONE
	/// The powers this requires, if any.
	var/list/required_powers
	/// Allow subtypes to count for requirements.
	var/required_allow_subtypes
	/// Any one of the required powers satisfies the requirement list.
	var/required_allow_any
	/// The text in security records for this power.
	var/security_record_text
	/// Security threat classification used for records output.
	var/security_threat = POWER_THREAT_MINOR
	/// If FALSE, this specific power instance is hidden from security record power listings.
	var/include_in_security_records = TRUE

	/// The path, if applicable, to the action.
	var/datum/action/cooldown/power/action_path

	/// Where items were spawned for the power, if any.
	var/list/where_items_spawned
	/// If true, the backpack automatically opens on post_add(). Usually set to TRUE when an item is equipped inside the player's backpack.
	var/open_backpack = FALSE

/datum/power/New()
	. = ..()
	for(var/trait in no_process_traits)
		LAZYADD(process_update_signals, list(SIGNAL_ADDTRAIT(trait), SIGNAL_REMOVETRAIT(trait)))

/datum/power/Destroy()
	if(power_holder)
		remove_from_current_holder()
	return ..()

/// Called when power_holder is qdeleting. Simply qdels this datum and lets Destroy() handle the rest.
/datum/power/proc/on_holder_qdeleting(mob/living/source, force)
	SIGNAL_HANDLER
	qdel(src)

/**
 * Adds the power to a new power_holder.
 *
 * Performs logic to make sure new_holder is a valid holder of this power.
 * Returns FALSEy if there was some kind of error. Returns TRUE otherwise.
 * Arguments:
 * * new_holder - The mob to add this power to.
 * * power_transfer - If this is being added to the holder as part of a power transfer. Powers can use this to decide not to spawn new items or apply any other one-time effects.
 */
/datum/power/proc/add_to_holder(mob/living/new_holder, power_transfer = FALSE, client/client_source, unique = TRUE)
	if(!new_holder)
		CRASH("Power attempted to be added to null mob.")

	if((power_flags & POWER_HUMAN_ONLY) && !ishuman(new_holder))
		CRASH("Human only power attempted to be added to non-human mob.")

	if(new_holder.has_archetype_power(type))
		CRASH("Power attempted to be added to mob which already had this power.")

	if(power_holder)
		CRASH("Attempted to add power to a holder when it already has a holder.")

	power_holder = new_holder
	power_holder.powers += src
	// If we weren't passed a client source try to use a present one
	client_source ||= power_holder.client

	if(mob_trait)
		ADD_TRAIT(power_holder, mob_trait, POWER_TRAIT)

	add(client_source)

	if(power_flags & POWER_PROCESSES)
		if(!isnull(maximum_process_stat))
			RegisterSignal(power_holder, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_changed))
		if(process_update_signals)
			RegisterSignals(power_holder, process_update_signals, PROC_REF(update_process))
		if(should_process())
			START_PROCESSING(SSpowers, src)

	if(!power_transfer)
		if (unique)
			add_unique(client_source)

		if(power_holder.client)
			post_add()
		else
			RegisterSignal(power_holder, COMSIG_MOB_LOGIN, PROC_REF(on_power_holder_first_login))

	RegisterSignal(power_holder, COMSIG_QDELETING, PROC_REF(on_holder_qdeleting))

	return TRUE

/// Removes the power from the current power_holder.
/datum/power/proc/remove_from_current_holder(power_transfer = FALSE)
	if(!power_holder)
		CRASH("Attempted to remove power from the current holder when it has no current holder.")

	UnregisterSignal(power_holder, list(COMSIG_MOB_STATCHANGE, COMSIG_MOB_LOGIN, COMSIG_QDELETING))
	if(process_update_signals)
		UnregisterSignal(power_holder, process_update_signals)

	power_holder.powers -= src

	if(mob_trait && !QDELETED(power_holder))
		REMOVE_TRAIT(power_holder, mob_trait, POWER_TRAIT)

	if(power_flags & POWER_PROCESSES)
		STOP_PROCESSING(SSpowers, src)

	remove()

	if(!QDELETED(power_holder))
		power_holder.refresh_security_power_records()

	power_holder = null

/**
 * On client connection set power preferences.
 *
 * Run post_add to set the client preferences for the power.
 * Clear the attached signal for login.
 * Used when the power has been gained and no client is attached to the mob.
 */
/datum/power/proc/on_power_holder_first_login(mob/living/source)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_MOB_LOGIN)
	post_add()

/// Any effect that should be applied every single time the power is added to any mob, even when transferred.
/datum/power/proc/add(client/client_source)
	return

/// Returns the text this power should contribute to security records.
/datum/power/proc/get_security_record_text()
	return security_record_text

/// Any effects from the proc that should not be done multiple times if the power is transferred between mobs.
/// Put stuff like spawning items in here.
/datum/power/proc/add_unique(client/client_source)
	return

/// Removal of any reversible effects added by the power.
/datum/power/proc/remove()
	return

/// Any special effects or chat messages which should be applied.
/// This proc is guaranteed to run if the mob has a client when the power is added.
/// Otherwise, it runs once on the next COMSIG_MOB_LOGIN.
/datum/power/proc/post_add()
	SHOULD_CALL_PARENT(TRUE)
	// Grants appropriate actions in the UI
	if(action_path)
		var/new_action_path = grant_action(action_path)
		action_path = new_action_path
	// If we give items to the player and open_backpack is true, have it open on round start.
	if(open_backpack)
		var/mob/living/carbon/human/human_holder = power_holder
		// post_add() can be called via delayed callback. Check they still have a backpack equipped before trying to open it.
		if(human_holder.back)
			human_holder.back.atom_storage.show_contents(human_holder)
	// Informs the players of any spawned items.
	for(var/chat_string in where_items_spawned)
		to_chat(power_holder, chat_string)

	where_items_spawned = null
	power_holder?.refresh_security_power_records() // ensures that post_add features are included in the records.
	return

/// Adds activateable power buttons.
/datum/power/proc/grant_action(datum/action/cooldown/power/power_path)
	if(!ispath(power_path) || !power_holder)
		return FALSE

	var/datum/action/cooldown/power/new_action = new power_path(src)
	// TODO: Browse this and see how much of this we can move to the action subtypes.
	new_action.origin_power = src
	new_action.Grant(power_holder)

	return new_action

/// Constructs [GLOB.all_power_constant_data] by iterating through a typecache of pregen data, ignoring abstract types, and instantiating the rest.
/proc/generate_power_constant_data()
	RETURN_TYPE(/list/datum/power_constant_data)

	var/list/datum/power_constant_data/all_constant_data = list()

	for (var/datum/power_constant_data/iterated_path as anything in typecacheof(path = /datum/power_constant_data, ignore_root_path = TRUE))
		if (initial(iterated_path.abstract_type) == iterated_path)
			continue

		if (!isnull(all_constant_data[initial(iterated_path.associated_typepath)]))
			stack_trace("pre-existing pregen data for [initial(iterated_path.associated_typepath)] when [iterated_path] was being considered: [all_constant_data[initial(iterated_path.associated_typepath)]]. \
				this is definitely a bug, and is probably because one of the two pregen data have the wrong power typepath defined. [iterated_path] will not be instantiated")
			continue

		var/datum/power_constant_data/pregen_data = new iterated_path
		all_constant_data[pregen_data.associated_typepath] = pregen_data

	return all_constant_data

GLOBAL_LIST_INIT_TYPED(all_power_constant_data, /datum/power_constant_data, generate_power_constant_data())

/// A singleton datum representing constant data and procs used by powers.
/datum/power_constant_data
	abstract_type = /datum/power_constant_data

	/// The typepath of the power we will be associated with in the global list.
	var/datum/power/associated_typepath

	/// A lazylist of preference datum typepaths. Any character pref put in here will be rendered in the powers page under a dropdown.
	var/list/datum/preference/customization_options

/datum/power_constant_data/New()
	. = ..()

	ASSERT(abstract_type != type && !isnull(associated_typepath), "associated_typepath null - please set it! occurred on: [src.type]")

/// Returns a list of savefile_keys derived from the preference typepaths in [customization_options]. Used in powers middleware to supply the preferences to render.
/datum/power_constant_data/proc/get_customization_data()
	RETURN_TYPE(/list)

	var/list/customization_data = list()

	for (var/datum/preference/pref_type as anything in customization_options)
		var/datum/preference/pref_instance = GLOB.preference_entries[pref_type]
		if (isnull(pref_instance))
			stack_trace("get_customization_data was called before instantiation of [pref_type]!")
			continue // just in case its a fluke and its only this one that's not instantiated, we'll check the other pref entries

		customization_data += pref_instance.savefile_key

	return customization_data

/// Is this power customizable? If true, a button will appear within the power's description box in the powers page, and upon clicking it,
/// will open a customization menu for the power.
/datum/power_constant_data/proc/is_customizable()
	return LAZYLEN(customization_options) > 0

/datum/power_constant_data/Destroy(force)
	var/error_message = "[src], a singleton power constant data instance, was destroyed! This should not happen!"
	if (force)
		error_message += " NOTE: This Destroy() was called with force == TRUE. This instance will be deleted and replaced with a new one."
	stack_trace(error_message)

	if (!force)
		return QDEL_HINT_LETMELIVE

	. = ..()

	GLOB.all_power_constant_data[associated_typepath] = new src.type //recover

/// Returns if the power holder should process currently or not.
/datum/power/proc/should_process()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_BE_PURE(TRUE)
	if(QDELETED(power_holder))
		return FALSE
	if(!(power_flags & POWER_PROCESSES))
		return FALSE
	if(!isnull(maximum_process_stat) && power_holder.stat >= maximum_process_stat)
		return FALSE
	for(var/trait in no_process_traits)
		if(HAS_TRAIT(power_holder, trait))
			return FALSE
	return TRUE

/// Checks to see if the power should be processing, and starts/stops it.
/datum/power/proc/update_process()
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	if(should_process())
		START_PROCESSING(SSpowers, src)
	else
		STOP_PROCESSING(SSpowers, src)

/// Updates processing status whenever the mob's stat changes.
/datum/power/proc/on_stat_changed(mob/living/source, new_stat)
	SIGNAL_HANDLER
	update_process()


/**
 * Handles inserting an item in any of the valid slots provided, then allows for post_add notification.
 *
 * If no valid slot is available for an item, the item is left at the mob's feet.
 * Arguments:
 * * power_item - The item to give to the power holder. If the item is a path, the item will be spawned in first on the player's turf.
 * * valid_slots - List of LOCATION_X that is fed into [/mob/living/carbon/proc/equip_in_one_of_slots].
 * * flavour_text - Optional flavour text to append to the where_items_spawned string after the item's location.
 * * default_location - If the item isn't possible to equip in a valid slot, this is a description of where the item was spawned.
 * * notify_player - If TRUE, adds strings to where_items_spawned list to be output to the player in [/datum/power/item_power/post_add()]
 */
/datum/power/proc/give_item_to_holder(obj/item/power_item, list/valid_slots, flavour_text = null, default_location = "at your feet", notify_player = FALSE)
	if(ispath(power_item))
		power_item = new power_item(get_turf(power_holder))

	var/mob/living/carbon/human/human_holder = power_holder

	var/where = human_holder.equip_in_one_of_slots(power_item, valid_slots, qdel_on_fail = FALSE, indirect_action = TRUE) || default_location

	if(where == LOCATION_BACKPACK)
		open_backpack = TRUE

	if(notify_player)
		LAZYADD(where_items_spawned, span_boldnotice("You have \a [power_item] [where]. [flavour_text]"))
