/** Lets us shapeshift into other mobs!
 * Health damage carries over; halved if transforming back manually.
 * Prones on exit
**/
/datum/power/aberrant/shapechange
	name = "Shapechange"
	desc = "You can adjust your body to turn into a specific type of animal (chosen in the power).\
	\n Activating the ability transforms you into the chosen animal. It does not have your name or any other identifying traits, but the number is always the same when you use it (and the security record for this power elaborates on what creature and numbers). \
	\n Using the ability makes you hungry, and cannot be used while you're starving.\
	\n If the creature dies or the effect ends, you are reverted to your normal form (prone on the ground), and all damage taken is transfered to your original form (halved if reverting back manually)."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	species_blacklist = list(/datum/species/android/holosynth) // there are SO MANY BUGS with holosynths I'd rather just NOT.

	required_powers = list(/datum/power/aberrant_root/beastial, /datum/power/aberrant_root/monstrous)
	required_allow_any = TRUE
	action_path = /datum/action/cooldown/power/aberrant/shapechange

/datum/power/aberrant/shapechange/get_security_record_text()
	var/datum/action/cooldown/power/aberrant/shapechange/shape_action = action_path
	if(!istype(shape_action))
		return ""

	// Resolve from the action itself so overrides (wolf/spider) are reflected in records.
	if(!ispath(shape_action.animal_form))
		shape_action.animal_form = shape_action.get_shapechange_type(power_holder?.client)

	var/animal_name = "animal" // if we don't get anything good
	if(ispath(shape_action.animal_form, /mob/living))
		var/mob/living/animal_type = shape_action.animal_form
		animal_name = initial(animal_type.name)

	if(!shape_action.shape_identifier)
		return ""
	return "Subject can shapechange into a [animal_name] with persistent identifier #[shape_action.shape_identifier]."

// Sets a persistent number identifier for the mob used in both sec records and the mob.
/datum/power/aberrant/shapechange/post_add()
	. = ..()
	var/datum/action/cooldown/power/aberrant/shapechange/shape_action = action_path
	if(!istype(shape_action))
		return
	if(!shape_action.shape_identifier)
		shape_action.shape_identifier = rand(1, 999)
	if(!ispath(shape_action.animal_form))
		shape_action.animal_form = shape_action.get_shapechange_type(power_holder?.client)

	power_holder?.refresh_security_power_records()

/datum/action/cooldown/power/aberrant/shapechange
	name = "Shapechange"
	desc = "Change into your chosen animal form!"
	button_icon = 'icons/mob/simple/pets.dmi'
	button_icon_state = "corgi"

	cooldown_time = 300

	// We're an animorph; this would lock us out if its true.
	human_only = FALSE
	/// Amount of time it takes to transform.
	use_time = 2 SECONDS
	/// Nutrition cost when changing into animal form.
	var/hunger_cost = 50
	/// Tracks if the current activation performed a shift (not a revert).
	var/just_shifted = FALSE
	/// Persistent identifier used for the shapeshifted form.
	var/shape_identifier = 0
	/// The chosen animal form.
	var/animal_form

// Register dispel listener on the owner
/datum/action/cooldown/power/aberrant/shapechange/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/datum/action/cooldown/power/aberrant/shapechange/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)

/// On dispel forces you out of the mob form.
/datum/action/cooldown/power/aberrant/shapechange/proc/on_dispel(mob/living/user, atom/dispeller)
	SIGNAL_HANDLER
	if(user?.has_status_effect(/datum/status_effect/shapechange_mob/aberrant))
		user.remove_status_effect(/datum/status_effect/shapechange_mob/aberrant)
		active = FALSE
		to_chat(user, span_userdanger("You have been forced out of your shapeshifted form!"))
		StartCooldown(300)
		return DISPEL_RESULT_DISPELLED
	return NONE

// Special checks because changing mobs like this is apparently quite janky.
/datum/action/cooldown/power/aberrant/shapechange/can_use(mob/living/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	if(user.IsStun() || user.IsKnockdown())
		owner.balloon_alert(user, "stunned!")
		return FALSE
	// Can't shift while being held as an item (e.g. undersized in-hand).
	if(istype(user.loc, /obj/item/mob_holder))
		owner.balloon_alert(user, "can't while held!")
		return FALSE
	// Can't shift while ventcrawling; it breaks transfer into the new mob.
	if(user.movement_type & VENTCRAWLING)
		owner.balloon_alert(user, "can't while ventcrawling!")
		return FALSE
	// We shouldn't have any active powers because it will make this power 10x more glitchy. This checks against it.
	var/datum/action/cooldown/power/blocking_power = get_blocking_active_power(user)
	if(blocking_power)
		owner.balloon_alert(user, "active: [blocking_power.name]")
		return FALSE
	// Can't shapeshift while starving unless it is to turn back.
	if(!user.has_status_effect(/datum/status_effect/shapechange_mob/aberrant) && user.nutrition <= NUTRITION_LEVEL_STARVING)
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	return TRUE

/datum/action/cooldown/power/aberrant/shapechange/use_action(mob/living/user, atom/target)
	var/datum/status_effect/shapechange_mob/aberrant/shapechange = user.has_status_effect(/datum/status_effect/shapechange_mob/aberrant)
	if(shapechange) // we don't check for active since that doesn't carry over.
		shapechange.manual_revert = TRUE
		user.remove_status_effect(/datum/status_effect/shapechange_mob/aberrant)
		active = FALSE
		return TRUE

	just_shifted = FALSE
	if(!animal_form)
		animal_form = get_shapechange_type(user?.client)
	// Makes the icon look like your form after use.
	if(ispath(animal_form))
		var/atom/shape_path = animal_form
		button_icon = initial(shape_path.icon)
		button_icon_state = initial(shape_path.icon_state)
		build_all_button_icons(UPDATE_BUTTON_ICON)
	var/mob/living/new_shape = create_shapechange_mob(user)
	if(!new_shape)
		return FALSE

	user.buckled?.unbuckle_mob(user, force = TRUE)
	var/datum/status_effect/shapechange_mob/aberrant/applied = new_shape.apply_status_effect(/datum/status_effect/shapechange_mob/aberrant, user, src)
	if(!applied)
		to_chat(user, span_warning("Unable to shapechange!"))
		qdel(new_shape)
		return FALSE
	just_shifted = TRUE
	active = TRUE
	return TRUE

// Override do_use_time for a custom effect.
/datum/action/cooldown/power/aberrant/shapechange/do_use_time(mob/living/user, atom/target)
	// Skip the wind-up if we're reverting.
	if(user.has_status_effect(/datum/status_effect/shapechange_mob/aberrant))
		return TRUE
	if(use_time <= 0)
		return TRUE
	if(DOING_INTERACTION_WITH_TARGET(user, user))
		return FALSE

	var/old_transform = user.transform
	var/animate_step = use_time / 6
	playsound(user, 'sound/effects/wounds/crack1.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	animate(user, transform = matrix() * 1.1, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 0.9, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 1.2, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 0.8, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 1.3, time = animate_step, easing = SINE_EASING)
	animate(transform = matrix() * 0.1, time = animate_step, easing = SINE_EASING)

	user.balloon_alert(user, "transforming...")
	if(!do_after(user, delay = use_time, target = user))
		animate(user, transform = matrix(), time = 0, easing = SINE_EASING)
		user.transform = old_transform
		return FALSE
	// Restore the original transform after the animation sequence completes.
	animate(user, transform = old_transform, time = 0, easing = SINE_EASING)
	user.transform = old_transform
	user.visible_message(span_warning("[user]'s body rearranges itself with a horrible crunching sound!"))
	playsound(user, 'sound/effects/magic/demon_consume.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	return TRUE

// Subtract hunger on succesful use
/datum/action/cooldown/power/aberrant/shapechange/on_action_success(mob/living/user, atom/target)
	. = ..()
	if(just_shifted)
		user.adjust_nutrition(-hunger_cost)
	just_shifted = FALSE

/// Creates the relevant mob for shapeshift.
/datum/action/cooldown/power/aberrant/shapechange/proc/create_shapechange_mob(mob/living/user)
	var/shape_type = animal_form
	if(!ispath(shape_type))
		return null
	var/mob/living/new_shape = new shape_type(user.loc)
	// Ensure the new form inherits the caster's languages while keeping its existing ones.
	new_shape.get_language_holder().copy_languages(user.get_language_holder())
	apply_shape_identifier(new_shape)
	return new_shape

/// Creates the persistent random number for the shapechanger.
/datum/action/cooldown/power/aberrant/shapechange/proc/apply_shape_identifier(mob/living/shape)
	if(!shape)
		return
	if(!shape_identifier)
		shape_identifier = rand(1, 999)
	shape.identifier = shape_identifier
	shape.name = initial(shape.name)
	shape.set_name()

/// Gets the chosen mob from preferend choices.
/datum/action/cooldown/power/aberrant/shapechange/proc/get_shapechange_type(client/client_source)
	var/choice = client_source?.prefs?.read_preference(/datum/preference/choiced/shapechange_form)
	// defaults to parrot incase something is wrong so we don't runtime everything.
	if(isnull(choice))
		choice = "Parrot"
	var/shape_type = GLOB.shapechange_form_types[choice]
	if(ispath(shape_type))
		return shape_type
	return GLOB.shapechange_form_types["Parrot"]

/// Returns the first active power action that should block shapechanging.
/datum/action/cooldown/power/aberrant/shapechange/proc/get_blocking_active_power(mob/living/user)
	if(!user || !user.powers)
		return null
	for(var/datum/power/power as anything in user.powers)
		var/datum/action/cooldown/power/power_action = power.action_path
		if(!istype(power_action))
			continue
		if(power_action == src)
			continue
		if(power_action.active)
			return power_action
	return null

//Shapechange status effect for aberrant power. We make our own to prevent gibbed RR.
/datum/status_effect/shapechange_mob/aberrant
	id = "shapechange_aberrant"
	/// The power action that caused the change
	var/datum/weakref/source_weakref
	/// Cached transform of the caster so we can restore non-default scaling (e.g. undersized/oversized).
	var/matrix/caster_transform
	/// Whether the shifted body was gibbed when it died
	var/last_gibbed = FALSE
	/// Whether the revert was manually triggered.
	var/manual_revert = FALSE

/datum/status_effect/shapechange_mob/aberrant/on_creation(mob/living/new_owner, mob/living/caster, datum/action/cooldown/power/aberrant/shapechange/source_action)
	if(!istype(source_action))
		stack_trace("Mob shapechange \"aberrant\" status effect applied without a source action.")
		qdel(src)
		return

	source_weakref = WEAKREF(source_action)
	return ..()

/datum/status_effect/shapechange_mob/aberrant/on_apply()
	var/datum/action/cooldown/power/aberrant/shapechange/source_action = source_weakref.resolve()
	if(!QDELETED(source_action) && source_action.owner == caster_mob)
		source_action.Grant(owner)
	if(caster_mob)
		caster_transform = matrix(caster_mob.transform)
	return ..()

/datum/status_effect/shapechange_mob/aberrant/restore_caster(kill_caster_after)
	var/datum/action/cooldown/power/aberrant/shapechange/source_action = source_weakref.resolve()
	if(!QDELETED(source_action) && source_action.owner == owner)
		source_action.Grant(caster_mob)

	if(owner?.contents)
		// Prevent round removal and consuming stuff when losing shapechange
		for(var/atom/movable/thing as anything in owner.contents)
			if(thing == caster_mob || HAS_TRAIT(thing, TRAIT_NOT_BARFABLE))
				continue
			thing.forceMove(get_turf(owner))

	return ..()

/datum/status_effect/shapechange_mob/aberrant/on_shape_death(datum/source, gibbed)
	last_gibbed = gibbed
	manual_revert = FALSE
	if(QDELETED(owner))
		return
	restore_caster()
	return

/datum/status_effect/shapechange_mob/aberrant/after_unchange()
	. = ..()
	if(QDELETED(caster_mob) || QDELETED(owner))
		return

	// Ensure any transform scaling from the shift animation is cleared.
	caster_mob.transform = caster_transform ? caster_transform : matrix()

	// Transfer damage from the shifted body back to the caster.
	var/damage_mult = manual_revert ? 0.5 : 1
	var/brute = owner.getBruteLoss() * damage_mult
	var/burn = owner.getFireLoss() * damage_mult
	var/tox = owner.getToxLoss() * damage_mult
	var/oxy = owner.getOxyLoss() * damage_mult
	if(brute)
		caster_mob.apply_damage(brute, BRUTE, forced = TRUE)
	if(burn)
		caster_mob.apply_damage(burn, BURN, forced = TRUE)
	if(tox)
		caster_mob.apply_damage(tox, TOX, forced = TRUE)
	if(oxy)
		caster_mob.apply_damage(oxy, OXY, forced = TRUE)

	caster_mob.Knockdown(6 SECONDS, ignore_canstun = TRUE)

	// If we died by being gibbed, we instead apply a lot of damage and lob off a limb.
	if(last_gibbed)
		if(iscarbon(caster_mob))
			var/mob/living/carbon/carbon_caster = caster_mob
			var/zone = carbon_caster.get_random_valid_zone(even_weights = TRUE)
			var/obj/item/bodypart/part = carbon_caster.get_bodypart(zone)
			carbon_caster.apply_damage(150, BRUTE, part ? part : zone, forced = TRUE)
			// MY LEG
			if(part && part.body_zone != BODY_ZONE_HEAD && part.body_zone != BODY_ZONE_CHEST)
				if(part.can_dismember() && !(part.bodypart_flags & BODYPART_UNREMOVABLE))
					part.dismember()
		else
			caster_mob.apply_damage(150, BRUTE, forced = TRUE)
		last_gibbed = FALSE
	manual_revert = FALSE

// Preference choice for Shapechange form selection.
/datum/preference/choiced/shapechange_form
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "shapechange_form"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/shapechange_form/create_default_value()
	return "Parrot"

/datum/preference/choiced/shapechange_form/init_possible_values()
	var/list/values = list()
	for(var/choice in GLOB.shapechange_form_types)
		values += choice
	return values

/datum/preference/choiced/shapechange_form/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/choiced/shapechange_form/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/shapechange
	associated_typepath = /datum/power/aberrant/shapechange
	customization_options = list(/datum/preference/choiced/shapechange_form)
