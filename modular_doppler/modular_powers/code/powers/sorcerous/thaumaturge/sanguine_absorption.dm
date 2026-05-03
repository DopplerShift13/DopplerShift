/*
	Heal someone using BLOOD.
*/
/datum/power/thaumaturge/sanguine_absorption
	name = "Sanguine Absorption"
	desc = "You draw nearby blood into the target. This draws up to 100u of blood from adjacent floor/wall splatters, containers and other mobs (in that order). It then transfers that blood to the target and converts it to universally accepted blood.\
	\nAny excess blood in the target creature beyond 100% is transformed into healing, at a 10u per 4 damage ratio. This can only heal organic bodyparts and does not heal any damage-types besides Brute or Burn. This also does not affect creatures with non-blood bloodtypes such as Ethereals or Slimepeople. \
	\nRequires Affinity 3. Additional affinity increases the healing ratio by 0.5 per point"
	security_record_text = "Subject can draw blood from varying sources (including humanoids) and transmute it into universal blood, potentially healing the target."
	value = 5

	action_path = /datum/action/cooldown/power/thaumaturge/sanguine_absorption
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/sanguine_absorption
	name = "Sanguine Absorption"
	desc = "You draw nearby blood into the target. This draws up to 100u of blood from adjacent floor/wall splatters, containers and other mobs (in that order). It then tranfers that blood to the target and converts it to universally accepted blood.\
	\nAny excess blood in the target creature beyond 100% is transformed into healing, at a 10u per 4 damage ratio. This can only heal organic bodyparts and does not heal any damage-types besides Brute or Burn. This also does not affect creatures with non-blood bloodtypes such as Ethereals or Slimepeople."
	button_icon = 'icons/effects/blood.dmi'
	button_icon_state = "bubblegumfoot"

	required_affinity = 3
	prep_cost = 5
	target_range = 4

	use_time = 3 SECONDS
	click_to_activate = TRUE

	/// Healing ratio per 1u
	var/healing_ratio = 0.4
	/// How much extra affinity adds to the ratio.
	var/affinity_healing_ratio_bonus = 0.05

	/// How much blood (in units) we try to gather.
	var/harvest_goal = 100

	/// The special effect on the target
	var/use_time_target_overlay = /obj/effect/temp_visual/sanguine_absorption
	/// Tracks whether the current cast was dispelled mid-channel.
	var/cast_interrupted_by_dispel = FALSE

/datum/action/cooldown/power/aberrant/cocoon/InterceptClickOn(mob/living/clicker, params, atom/target)
	..()
	// Always consume the click to avoid normal click interactions.
	return TRUE

// We do extra validation because we want to make sure containers aren't full and we aren't trying to put blood in a mob that can't hold it.
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/can_use(mob/living/user, atom/target)
	. = ..()
	if(istype(target, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = target
		if(!container.reagents || container.reagents.total_volume >= container.reagents.maximum_volume)
			user.balloon_alert(user, "container is full!")
			return FALSE
		return ..()

	if(!isliving(target))
		return FALSE

	var/mob/living/target_mob = target
	// ew, electricity/motor oil/plasma/whatever else aliens are composed of
	if(!is_valid_blood_target(target_mob))
		user.balloon_alert(user, "no blood to work with!")
		return FALSE
	if(target_mob.blood_volume <= BLOOD_VOLUME_NORMAL + 10 && !has_valid_blood_sources(get_turf(target_mob), target_mob))
		user.balloon_alert(user, "no blood nearby!")
		return FALSE

// Special cast effects; we want the blood orb to appear above the target..
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/do_use_time(mob/living/user, atom/target)
	cast_interrupted_by_dispel = FALSE
	if(user)
		RegisterSignal(user, COMSIG_ATOM_DISPEL, PROC_REF(on_cast_dispel))
	if(target)
		RegisterSignal(target, COMSIG_ATOM_DISPEL, PROC_REF(on_cast_dispel))
	var/target_use_overlay
	if(use_time_target_overlay)
		var/atom/overlay_obj = new use_time_target_overlay(null)
		target_use_overlay = new /mutable_appearance(overlay_obj)
		qdel(overlay_obj)
		target.add_overlay(target_use_overlay)
	// Spawns an indicator meant to show nearby targets that they are in the danger zone of having their blood donated to a blood drive.
	var/target_location = get_turf(target)
	for(var/atom/movable/source as anything in get_valid_blood_sources(target_location, null, null))
		new /obj/effect/temp_visual/sanguine_absorption_target(get_turf(source))

	target.visible_message(span_warning("[user] draws nearby blood into an orb above [target]!"))
	playsound(target, 'sound/effects/magic/enter_blood.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_ATOM_DISPEL)
	if(target)
		UnregisterSignal(target, COMSIG_ATOM_DISPEL)
	if(cast_interrupted_by_dispel)
		return FALSE
	if(target_use_overlay && !QDELETED(target))
		target.cut_overlay(target_use_overlay)

/datum/action/cooldown/power/thaumaturge/sanguine_absorption/use_action(mob/living/user, atom/target)
// Filling reagent containers with blood.
	if(istype(target, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = target
		if(!container.reagents)
			return FALSE

		// If between the cast time finishing and this happening the container is filled.
		var/remaining_capacity = container.reagents.maximum_volume - container.reagents.total_volume
		if(remaining_capacity <= 0)
			user.balloon_alert(user, "container is full!")
			return FALSE

		var/harvest_cap = min(harvest_goal, remaining_capacity) // harvest_goal capped by the spare space in teh cotnainer
		var/turf/center = get_turf(container)
		if(!center)
			return FALSE

		// Go get some blood.
		var/harvested = harvest_blood(center, harvest_cap, null, container)
		if(harvested <= 0) // you failed.
			user.balloon_alert(user, "no blood nearby!")
			return FALSE
		container.reagents.add_reagent(/datum/reagent/blood, harvested)

		user.visible_message(span_notice("Blood gathers into [target]."))
		playsound(target, 'sound/effects/splat.ogg', 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		return TRUE

// Filling mobs with blood.
	if(!isliving(target))
		return FALSE

	var/mob/living/target_mob = target
	var/turf/center = get_turf(target_mob)
	if(!center)
		return FALSE

	// Harvest loop: We try to gather as much as possible from nearby sources, one at a time, until we meet the quota.
	var/harvested = harvest_blood(center, harvest_goal, target_mob, null)

	// What a shitty blood drive.
	if(harvested <= 0 && target_mob.blood_volume <= BLOOD_VOLUME_NORMAL + 10) // we do +10 just to make sure we have something to work with
		user.balloon_alert(user, "no blood nearby!")
		return FALSE

	target_mob.blood_volume += harvested

	// We set the healing ratio and attempt to heal the target.
	var/ratio = healing_ratio + (isnum(affinity) ? max(affinity - required_affinity, 0) * affinity_healing_ratio_bonus : 0)
	if(ratio > 0)
		var/excess_blood = max(target_mob.blood_volume - BLOOD_VOLUME_NORMAL, 0)
		if(excess_blood > 0 && iscarbon(target_mob))
			var/mob/living/carbon/target_carbon = target_mob
			var/total_brute = 0
			var/total_burn = 0
			// Gets all the damage across various bodyparts.
			for(var/obj/item/bodypart/part as anything in target_carbon.bodyparts)
				if(!(part.bodytype & BODYTYPE_ORGANIC))
					continue
				total_brute += part.brute_dam
				total_burn += part.burn_dam
			var/total_damage = total_brute + total_burn

			// Based on the total damage, we heal based on the excess blood compared to the normal blood volume.
			if(total_damage > 0)
				var/heal_capacity = excess_blood * ratio // max we can heal
				var/heal_amount = min(heal_capacity, total_damage) // how much we will heal total
				var/heal_brute = total_damage ? (heal_amount * (total_brute / total_damage)) : 0 // we try to heal all brute damage first
				var/heal_burn = heal_amount - heal_brute // then we heal burn damage
				var/actual_healed = target_carbon.heal_overall_damage(brute = heal_brute, burn = heal_burn, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
				// update the blood in the target based on the healing used.
				if(actual_healed > 0)
					var/blood_used = min(excess_blood, actual_healed / ratio)
					target_carbon.blood_volume = max(target_carbon.blood_volume - blood_used, BLOOD_VOLUME_NORMAL)
					target_carbon.updatehealth()
	target.visible_message(span_notice("Blood flows into [target]'s body, reinvigorating them!"), span_notice("You feel energized as the blood mends your body!"))
	playsound(target, 'sound/effects/splat.ogg', 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE

/// Do you have BLOOD; as in the real deal.
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/is_valid_blood_target(mob/living/target_mob)
	if(!target_mob)
		return FALSE
	return target_mob.get_blood_reagent() == /datum/reagent/blood

/// Ends the cast if we are dispelled during it.
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/on_cast_dispel(datum/source, atom/dispeller)
	cast_interrupted_by_dispel = TRUE
	to_chat(owner, span_warning("Your [name] is dispelled!"))

/// Checks if there's any valid blood sources in the area.
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/get_valid_blood_sources(turf/center, mob/living/target_mob, obj/item/reagent_containers/ignore_container)
	if(!center)
		return list()

	var/list/sources = list()

	for(var/obj/effect/decal/cleanable/blood/blood_decal in range(1, center))
		if(blood_decal.dried || blood_decal.bloodiness <= 0)
			continue
		if(!(blood_decal.decal_reagent == /datum/reagent/blood || blood_decal.reagents?.has_reagent(/datum/reagent/blood)))
			continue
		sources += blood_decal

	for(var/obj/item/reagent_containers/container in range(1, center))
		if(ignore_container && container == ignore_container)
			continue
		if(!container.reagents)
			continue
		if(container.reagents.get_reagent_amount(/datum/reagent/blood) <= 0)
			continue
		sources += container

	for(var/mob/living/other in range(1, center))
		if(other == target_mob)
			continue
		if(other.get_blood_reagent() != /datum/reagent/blood)
			continue
		if(other.blood_volume <= 0)
			continue
		sources += other

	return sources

/// Checks if the mob actually contains proper useable blood
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/has_valid_blood_sources(turf/center, mob/living/target_mob, obj/item/reagent_containers/ignore_container)
	return length(get_valid_blood_sources(center, target_mob, ignore_container)) > 0

/// Attempts to do a blood drive on decals, containers and mobs in descending order.
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/harvest_blood(turf/center, amount_needed, mob/living/target_mob, obj/item/reagent_containers/ignore_container)
	if(amount_needed <= 0 || !center)
		return 0

	var/harvested = 0
	harvested += harvest_blood_from_decals(center, amount_needed - harvested)
	if(harvested < amount_needed)
		harvested += harvest_blood_from_containers(center, amount_needed - harvested, ignore_container)
	if(harvested < amount_needed)
		harvested += harvest_blood_from_mobs(center, amount_needed - harvested, target_mob)

	return harvested

/// Attempts to harvest decals.
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/harvest_blood_from_decals(turf/center, amount_needed)
	if(amount_needed <= 0 || !center)
		return 0

	var/harvested = 0
	for(var/obj/effect/decal/cleanable/blood/blood_decal in range(1, center))
		if(harvested >= amount_needed)
			break
		if(blood_decal.dried || blood_decal.bloodiness <= 0)
			continue
		if(!(blood_decal.decal_reagent == /datum/reagent/blood || blood_decal.reagents?.has_reagent(/datum/reagent/blood)))
			continue

		var/available_units = blood_decal.bloodiness * BLOOD_TO_UNITS_MULTIPLIER
		if(available_units <= 0)
			continue

		var/to_take = min(amount_needed - harvested, available_units)
		if(to_take >= available_units) // if we would take the max amount, we destroy hte decal in the process.
			if(blood_decal.reagents)
				blood_decal.reagents.remove_reagent(/datum/reagent/blood, to_take, include_subtypes = TRUE)
			qdel(blood_decal)
		else // otherwise, we take away the reagent.
			var/bloodiness_to_remove = to_take / BLOOD_TO_UNITS_MULTIPLIER
			blood_decal.adjust_bloodiness(-bloodiness_to_remove)
			if(blood_decal.reagents)
				blood_decal.reagents.remove_reagent(/datum/reagent/blood, to_take, include_subtypes = TRUE)
		harvested += to_take

	return harvested

/// Attempts to harvest containers
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/harvest_blood_from_containers(turf/center, amount_needed, obj/item/reagent_containers/ignore_container)
	if(amount_needed <= 0 || !center)
		return 0

	var/harvested = 0
	for(var/obj/item/reagent_containers/container in range(1, center))
		if(harvested >= amount_needed)
			break
		if(ignore_container && container == ignore_container)
			continue
		if(!isturf(container.loc) || !container.reagents)
			continue
		var/available_units = container.reagents.get_reagent_amount(/datum/reagent/blood)
		if(available_units <= 0)
			continue
		var/to_take = min(amount_needed - harvested, available_units)
		container.reagents.remove_reagent(/datum/reagent/blood, to_take, include_subtypes = TRUE)
		harvested += to_take

	return harvested

/// Attempts to harvest mobs.
/datum/action/cooldown/power/thaumaturge/sanguine_absorption/proc/harvest_blood_from_mobs(turf/center, amount_needed, mob/living/target_mob)
	if(amount_needed <= 0 || !center)
		return 0

	var/harvested = 0
	for(var/mob/living/other in range(1, center))
		if(harvested >= amount_needed)
			break
		if(other == target_mob)
			continue
		if(other.can_block_resonance(1)) // Doesn't work if you're immune to resonance magic.
			continue
		if(other.get_blood_reagent() != /datum/reagent/blood)
			continue
		if(other.blood_volume <= 0)
			continue

		var/to_take = min(amount_needed - harvested, other.blood_volume)
		if(to_take <= 0)
			continue
		to_chat(other, span_userdanger("Blood is drawn from your body by [owner]!"))
		other.blood_volume = max(other.blood_volume - to_take, 0)
		harvested += to_take

	return harvested


// The visual effect of the cast
/obj/effect/temp_visual/sanguine_absorption
	name = "blood bubble"
	icon = 'icons/obj/weapons/guns/projectiles.dmi'
	icon_state = "mini_leaper"
	layer = ABOVE_MOB_LAYER
	duration = 3 SECONDS
	alpha = 200


/obj/effect/temp_visual/sanguine_absorption_target
	icon_state = "blessed"
	color = "#da2424"
	duration = 3 SECONDS
