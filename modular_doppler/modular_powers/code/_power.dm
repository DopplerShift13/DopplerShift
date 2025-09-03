
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

	/// The overarching archetype this belongs to.
	var/archetype
	/// The path this belongs to.
	var/path
	/// The priority this has.
	var/priority = NONE
	/// The powers this requires, if any.
	var/list/required_powers
	

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
	return

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

/// If a power is able to be selected for the mob's species
/datum/power/proc/is_species_appropriate(datum/species/mob_species)
	if(mob_trait in GLOB.species_prototypes[mob_species].inherent_traits)
		return FALSE
	return TRUE

/// Subtype power that has some bonus logic to spawn items for the player.
/datum/power/item_power
	/// Lazylist of strings describing where all the power items have been spawned.
	var/list/where_items_spawned
	/// If true, the backpack automatically opens on post_add(). Usually set to TRUE when an item is equipped inside the player's backpack.
	var/open_backpack = FALSE
	abstract_parent_type = /datum/power/item_power

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
/datum/power/item_power/proc/give_item_to_holder(obj/item/power_item, list/valid_slots, flavour_text = null, default_location = "at your feet", notify_player = FALSE)
	if(ispath(power_item))
		power_item = new power_item(get_turf(power_holder))

	var/mob/living/carbon/human/human_holder = power_holder

	var/where = human_holder.equip_in_one_of_slots(power_item, valid_slots, qdel_on_fail = FALSE, indirect_action = TRUE) || default_location

	if(where == LOCATION_BACKPACK)
		open_backpack = TRUE

	if(notify_player)
		LAZYADD(where_items_spawned, span_boldnotice("You have \a [power_item] [where]. [flavour_text]"))

/datum/power/item_power/post_add()
	if(open_backpack)
		var/mob/living/carbon/human/human_holder = power_holder
		// post_add() can be called via delayed callback. Check they still have a backpack equipped before trying to open it.
		if(human_holder.back)
			human_holder.back.atom_storage.show_contents(human_holder)

	for(var/chat_string in where_items_spawned)
		to_chat(power_holder, chat_string)

	where_items_spawned = null
