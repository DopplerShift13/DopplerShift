/// Summons copies of yourself to beat the snot out of you; or harrass others if you dare to run away. Unlike normal mirrages, these do hurt you. What hurts more is the social fuax pas of copies of yourself beating someoen else up.
/datum/psyker_event/catastrophic/mirage_gangup
	lingering = TRUE
	weight = PSYKER_EVENT_RARITY_RARE // this shouldn't be too common since this inconveniences others as well
	/// How many mirages to spawn
	var/spawn_count = 8
	/// Range around the psyker to spawn, in tiles
	var/spawn_range = 3
	/// Lifetime of each mirage
	var/mirage_lifetime = 20 SECONDS

/datum/psyker_event/catastrophic/mirage_gangup/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("Your Resonant powers send your mind spiraling; everyone is looking like you, and at you!"))
	psyker.cause_hallucination(/datum/hallucination/delusion/psyker_gangup, "psyker mirage gangup", duration = mirage_lifetime, psyker_owner = psyker)

	// Spawn a large semblence of illusions to heckle and harass us.
	for(var/iteration = 0; iteration < spawn_count; iteration++)
		addtimer(CALLBACK(src, PROC_REF(_spawn_gangup_mirage), psyker), iteration SECONDS)

	return TRUE

/// Creates a mirrage specific to gang-up, copies the parent mob and tells it to GO GET THE FUKKEN PSYKER
/datum/psyker_event/catastrophic/mirage_gangup/proc/_spawn_gangup_mirage(mob/living/carbon/human/psyker)
	if(!psyker || QDELETED(psyker))
		return

	var/turf/spawn_turf = pick_spawn_turf(psyker)
	if(!spawn_turf)
		return

	var/mob/living/basic/mirage_gangup/new_mirage = new(spawn_turf)
	new_mirage.Copy_Parent(psyker, mirage_lifetime)
	new_mirage.aggro_on(psyker)

/// Find an appropriate space to create our mirrages
/datum/psyker_event/catastrophic/mirage_gangup/proc/pick_spawn_turf(mob/living/psyker)
	var/list/valid_turfs = list()
	for(var/turf/turf_candidate in view(spawn_range, psyker))
		if(!isopenturf(turf_candidate))
			continue
		if(turf_candidate.is_blocked_turf(exclude_mobs = TRUE))
			continue
		valid_turfs += turf_candidate

	if(length(valid_turfs))
		return pick(valid_turfs)

	return get_turf(psyker)


/// Mirage mob used by the gangup event. These are tougher and hit harder. We don't subtype the basic mirage because it has so much overhead with taunting
/mob/living/basic/mirage_gangup
	name = "mirage"
	desc = "An illusory copy turned deadly."
	icon = 'icons/effects/effects.dmi'
	icon_state = "static"
	icon_living = "static"
	icon_dead = "null"
	mob_biotypes = NONE
	faction = list(FACTION_ILLUSION)
	basic_mob_flags = DEL_ON_DEATH
	death_message = "dissipates into thin air!"

	health = 50
	maxHealth = 50
	melee_damage_lower = 10
	melee_damage_upper = 10
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_sound = 'sound/items/weapons/punch1.ogg'
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile // WHAT DO YOU MEAN THERE'S NO STANDARD AI CONTROLLER?

	/// Weakref to what we're copying
	var/datum/weakref/parent_mob_ref
	/// ref for the alt appearance
	var/alt_appearance_key

/// Copies stats from the parent entity that summoned it, if any.
/mob/living/basic/mirage_gangup/proc/Copy_Parent(mob/living/original, life = 20 SECONDS)
	appearance = original.appearance
	name = original.name
	real_name = original.real_name
	gender = original.gender
	parent_mob_ref = WEAKREF(original)
	setDir(original.dir)
	transform = initial(transform)
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
	_setup_alt_appearance(original)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, death)), life)

/// Force this mirage to focus the psyker.
/mob/living/basic/mirage_gangup/proc/aggro_on(mob/living/target)
	if(!target || QDELETED(target) || !ai_controller)
		return
	if(ispath(ai_controller))
		ai_controller = new ai_controller(src)
	ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, target)
	ai_controller.set_ai_status(AI_STATUS_ON)
	ai_controller.SelectBehaviors(0.1)

/// Set up the alternate appearance so the psyker and mental-immune viewers see through it. Also sneaks in the dispel signaler.
/mob/living/basic/mirage_gangup/proc/_setup_alt_appearance(mob/living/owner)
	if(alt_appearance_key)
		return
	alt_appearance_key = "mirage_gangup_static_[REF(src)]"
	var/image/appearance_image = image('icons/effects/effects.dmi', src, "static")
	appearance_image.dir = dir
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/mirage_gangup_static, alt_appearance_key, appearance_image, owner)
	RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_mirage_dir_change))
	RegisterSignal(src, COMSIG_ATOM_DISPEL, PROC_REF(on_mirage_dispel))

/mob/living/basic/mirage_gangup/Destroy()
	if(alt_appearance_key)
		remove_alt_appearance(alt_appearance_key)
		alt_appearance_key = null
		UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
	UnregisterSignal(src, COMSIG_ATOM_DISPEL)
	return ..()

/// Poofs the mob on dispel
/mob/living/basic/mirage_gangup/proc/on_mirage_dispel(datum/source, atom/dispeller)
	SIGNAL_HANDLER
	qdel(src)
	return DISPEL_RESULT_DISPELLED

/// Actually makes mirage sprites rotate.
/mob/living/basic/mirage_gangup/proc/on_mirage_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	var/image/appearance_image = hud_list?[alt_appearance_key]
	if(appearance_image)
		appearance_image.dir = new_dir

/// Alternate appearance for mirage gangup: static outline for mental-immune viewers to show that they are in fact hostile mobs.
/datum/atom_hud/alternate_appearance/basic/mirage_gangup_static
	var/datum/weakref/owner_ref

/datum/atom_hud/alternate_appearance/basic/mirage_gangup_static/New(key, image/appearance_image, mob/living/owner, options = AA_TARGET_SEE_APPEARANCE)
	owner_ref = WEAKREF(owner)
	if(appearance_image)
		appearance_image.override = TRUE
	. = ..(key, appearance_image, options)

/// Who is ALLOWED to see us for who we truly are?
/datum/atom_hud/alternate_appearance/basic/mirage_gangup_static/mobShouldSee(mob/viewer)
	if(!ismob(viewer) || !isliving(viewer))
		return FALSE
	var/mob/living/owner = owner_ref?.resolve()
	if(owner && viewer == owner)
		return FALSE
	return !can_affect_mental(viewer)

/// Validates if the target is affected by mental effects.
/datum/atom_hud/alternate_appearance/basic/mirage_gangup_static/proc/can_affect_mental(mob/living/target)
	if(!target)
		return FALSE
	if(target.can_block_magic(MAGIC_RESISTANCE_MIND, charge_cost = 0))
		return FALSE
	if(target.can_block_magic(MAGIC_RESISTANCE, charge_cost = 0))
		return FALSE
	if(target.can_block_resonance(0))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_DUMB))
		return FALSE
	return TRUE

/// Delusion: everyone looks like the psyker (for the psyker only).
/datum/hallucination/delusion/psyker_gangup
	random_hallucination_weight = 0
	affects_us = FALSE
	affects_others = TRUE
	delusion_name = "psyker"
	/// Who we're copying
	var/datum/weakref/psyker_ref

/datum/hallucination/delusion/psyker_gangup/New(mob/living/hallucinator, duration, mob/living/psyker_owner)
	if(psyker_owner)
		psyker_ref = WEAKREF(psyker_owner)
		delusion_name = psyker_owner.name
	return ..(hallucinator, duration)

// override just to pass along psyker_owner
/datum/hallucination/delusion/psyker_gangup/make_delusion_image(mob/over_who)
	var/image/funny_image = image(loc = over_who)
	var/mob/living/psyker_owner = psyker_ref?.resolve()
	if(psyker_owner)
		funny_image.appearance = psyker_owner.appearance
	else
		funny_image.appearance = over_who.appearance
	funny_image.name = delusion_name
	funny_image.override = TRUE
	SET_PLANE_EXPLICIT(funny_image, ABOVE_GAME_PLANE, over_who)
	return funny_image
