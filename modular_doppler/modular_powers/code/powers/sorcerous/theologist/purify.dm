/*
	Does 3 things;
	- When targeting objects, it dispels it; and if it has a holy equivelant, it turns it into that equivelant.
	- When targeting creatures, it dispels them.
	- It will also remove all poisons contained in the item if it can hold reagents.
	If it fails to do any of these 3 succesfully, it refunds the piety.
*/

/datum/power/theologist/purify
	name = "Purify"
	desc = "Cleanses impurity from objects and creatures in melee range. The chosen target is immediately dispelled and purified of all poisons. \
	If the target is an object with a holy equivelant, it turns it into that (e.g water into holy water). Has varying piety costs, but usually defaults to 5."
	security_record_text = "Subject can end magical effects on a target, nullify poisons and transmute objects into their holy variants with a touch."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/theologist/purify
	value = 5

	required_powers = list(/datum/power/theologist_root/shared)

/datum/action/cooldown/power/theologist/purify
	name = "Purify"
	desc = "Cleanses impurity from objects and creatures in melee range. The chosen target is immediately dispelled and purified of all poisons. \
	If the target is an object with a holy equivelant, it turns it into that (e.g water into holy water). Has varying piety costs, but usually defaults to 5."
	button_icon = 'icons/obj/mining_zones/artefacts.dmi'
	button_icon_state = "purified_soulstone"
	cooldown_time = 60

	target_range = 1
	click_to_activate = TRUE
	/// Accumulated piety cost for this use.
	var/pending_piety_cost = 0

/datum/action/cooldown/power/theologist/purify/InterceptClickOn(mob/living/clicker, params, atom/target)
	. = ..()
	// Makes it so we always override the base click. Don't want to use the item you are trying to purify.
	return TRUE

/datum/action/cooldown/power/theologist/purify/use_action(mob/living/user, atom/target)
	if(!target)
		return FALSE
	pending_piety_cost = 0

	// Special construct purification channel.
	if(purify_construct(user, target))
		return TRUE
	var/success = FALSE

	// General dispel on target
	if(target.dispel(user))
		success = TRUE

	// Remove poison from a creature's bloodstream or an object's reagents.
	if(target.reagents)
		var/removed = target.reagents.remove_reagent(/datum/reagent/toxin, target.reagents.total_volume, include_subtypes = TRUE)
		if(removed > 0)
			success = TRUE

	// Holy-equivalent conversions.
	if(convert_objects(user, target))
		success = TRUE
	if(convert_reagents(user, target))
		success = TRUE

	if(success)
		pending_piety_cost = max(pending_piety_cost, THEOLOGIST_PIETY_MINOR)
		playsound(user, 'sound/effects/magic/magic_block_holy.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	else
		user.balloon_alert(user, "nothing to be purified!")
	return success

/// Adds and processes the variable cost of the interaction.
/datum/action/cooldown/power/theologist/purify/proc/try_add_cost(mob/living/user, cost)
	if(cost <= 0)
		return TRUE
	if(get_piety() < (pending_piety_cost + cost))
		user.balloon_alert(user, "needs [cost] piety!")
		return FALSE
	pending_piety_cost += cost
	return TRUE

/datum/action/cooldown/power/theologist/purify/on_action_success(mob/living/user, atom/target)
	. = ..()
	if(pending_piety_cost > 0)
		adjust_piety(-pending_piety_cost)
	pending_piety_cost = 0
	return

/// Deletes the old item and creates a new item in its place.
/datum/action/cooldown/power/theologist/purify/proc/replace_target(atom/target, typepath, mob/living/user)
	if(!target || !typepath)
		return null

	var/obj/old_obj = target
	var/mob/living/holder
	var/hand_index = 0
	if(istype(old_obj, /obj/item) && ismob(old_obj.loc))
		holder = old_obj.loc
		hand_index = holder.get_held_index_of_item(old_obj)

	var/obj/new_obj
	if(hand_index && holder)
		new_obj = new typepath(null)
		holder.put_in_hand(new_obj, hand_index, forced = TRUE)
	else
		new_obj = new typepath(old_obj.loc)

	qdel(old_obj)
	return new_obj

/// Copies the attributes of seeds to be passed along.
/datum/action/cooldown/power/theologist/purify/proc/copy_seed_stats(obj/item/seeds/from_seed, obj/item/seeds/to_seed)
	if(!from_seed || !to_seed)
		return
	to_seed.lifespan = from_seed.lifespan
	to_seed.endurance = from_seed.endurance
	to_seed.maturation = from_seed.maturation
	to_seed.production = from_seed.production
	to_seed.yield = from_seed.yield
	to_seed.potency = from_seed.potency
	to_seed.instability = from_seed.instability
	to_seed.weed_rate = from_seed.weed_rate
	to_seed.weed_chance = from_seed.weed_chance

/// Converts reagents in different types.
/datum/action/cooldown/power/theologist/purify/proc/convert_reagents(mob/living/user, atom/target)
	if(!target?.reagents)
		return FALSE

	var/converted = FALSE

	// (Unholy) Water -> Holy Water
	var/water_amt = target.reagents.get_reagent_amount(/datum/reagent/water, REAGENT_STRICT_TYPE)
	var/unholy_amt = target.reagents.get_reagent_amount(/datum/reagent/fuel/unholywater, REAGENT_STRICT_TYPE)
	var/holy_source_amt = water_amt + unholy_amt
	if(holy_source_amt > 0)
		if(try_add_cost(user, THEOLOGIST_PIETY_MODERATE))
			if(water_amt > 0)
				target.reagents.remove_reagent(/datum/reagent/water, water_amt)
			if(unholy_amt > 0)
				target.reagents.remove_reagent(/datum/reagent/fuel/unholywater, unholy_amt)
			target.reagents.add_reagent(/datum/reagent/water/holywater, holy_source_amt)
			to_chat(user, span_notice("The water in [target] gleams into holy water."))
			converted = TRUE

	// Blood -> Godsblood
	var/blood_amt = target.reagents.get_reagent_amount(/datum/reagent/blood, REAGENT_SUB_TYPE)
	if(blood_amt > 0)
		var/blood_cost = CEILING(blood_amt / 5, 5)
		if(try_add_cost(user, blood_cost))
			target.reagents.remove_reagent(/datum/reagent/blood, blood_amt, include_subtypes = TRUE)
			target.reagents.add_reagent(/datum/reagent/medicine/omnizine/godblood, blood_amt)
			to_chat(user, span_notice("The blood in [target] is sanctified into godsblood."))
			converted = TRUE

	return converted

/// Converts objects into other objects!
/datum/action/cooldown/power/theologist/purify/proc/convert_objects(mob/living/user, atom/target)
	// Melon -> Holy Melon
	if(istype(target, /obj/item/food/grown/watermelon) && !istype(target, /obj/item/food/grown/holymelon))
		if(!try_add_cost(user, THEOLOGIST_PIETY_MINOR))
			return FALSE
		var/obj/item/food/grown/watermelon/melon = target
		var/obj/item/seeds/old_seed = melon.get_plant_seed()
		var/obj/item/food/grown/holymelon/new_melon = replace_target(melon, /obj/item/food/grown/holymelon, user)
		if(new_melon && old_seed)
			var/obj/item/seeds/new_seed = new /obj/item/seeds/watermelon/holy(null)
			copy_seed_stats(old_seed, new_seed)
			new_melon.seed = new_seed
		to_chat(user, span_notice("Divine light transforms [melon] into a holymelon."))
		return TRUE

	// Soulstone -> Purified Soulstone
	if(istype(target, /obj/item/soulstone))
		var/obj/item/soulstone/stone = target
		if(stone.theme == THEME_HOLY)
			return FALSE
		if(!try_add_cost(user, THEOLOGIST_PIETY_MINOR))
			return FALSE
		stone.required_role = null
		stone.theme = THEME_HOLY
		stone.update_appearance()
		for(var/mob/shade_to_deconvert in stone.contents)
			stone.assign_master(shade_to_deconvert, user)
		UnregisterSignal(stone, COMSIG_BIBLE_SMACKED)
		to_chat(user, span_notice("You purify [stone], its glow becoming serene."))
		return TRUE

	// Any book -> Bible (free)
	if(istype(target, /obj/item/book) && !istype(target, /obj/item/book/bible))
		if(!try_add_cost(user, 0))
			return FALSE
		replace_target(target, /obj/item/book/bible, user)
		to_chat(user, span_notice("The pages reorder themselves into a bible."))
		return TRUE

	// Skateboard -> Holy Skateboard
	if(istype(target, /obj/item/melee/skateboard) && !istype(target, /obj/item/melee/skateboard/holyboard))
		if(!try_add_cost(user, THEOLOGIST_PIETY_MAJOR))
			return FALSE
		replace_target(target, /obj/item/melee/skateboard/holyboard, user)
		to_chat(user, span_notice("The board hums and becomes a holy skateboard."))
		return TRUE

	// Bow -> Divine Bow
	if(istype(target, /obj/item/gun/ballistic/bow) && !istype(target, /obj/item/gun/ballistic/bow/divine))
		if(!try_add_cost(user, THEOLOGIST_PIETY_MAJOR))
			return FALSE
		replace_target(target, /obj/item/gun/ballistic/bow/divine, user)
		to_chat(user, span_notice("The bow brightens, reshaping into a divine bow."))
		return TRUE

	// Arrow -> Holy Arrow
	if(istype(target, /obj/item/ammo_casing/arrow) && !istype(target, /obj/item/ammo_casing/arrow/holy))
		if(!try_add_cost(user, THEOLOGIST_PIETY_MINOR))
			return FALSE
		replace_target(target, /obj/item/ammo_casing/arrow/holy, user)
		to_chat(user, span_notice("The arrow brightens with holy light."))
		return TRUE

	return FALSE

/** Special interaction for hype moments and aura: Deacons (people converted by Chaplain Sects) and the Chaplain can deconvert constructs. It takes times and is interuptable.
 * If there is a mind inside the construct, it retains it and is de-antag'd.
 * If there isn't, it prompts a ghost to see if they want to be part of it.
**/
/datum/action/cooldown/power/theologist/purify/proc/purify_construct(mob/living/user, atom/target)
	if(!isconstruct(target))
		return FALSE

	var/mob/living/basic/construct/construct_target = target
	if(construct_target.theme == THEME_HOLY)
		return FALSE
	if(!are_we_a_holy_man(user))
		user.balloon_alert(user, "you need to be a holy figure to purify that!")
		return FALSE
	if(get_piety() < THEOLOGIST_PIETY_CRUSHING)
		user.balloon_alert(user, "needs [THEOLOGIST_PIETY_CRUSHING] piety!")
		return FALSE

	// Piety is spent regardless of success.
	adjust_piety(-THEOLOGIST_PIETY_CRUSHING)

	// End click targeting during the channel for clarity.
	unset_click_ability(user, refund_cooldown = TRUE)

	var/datum/beam/link = user.Beam(construct_target, icon_state = "kinesis", override_target_pixel_x = 0)
	construct_target.SetStun(15 SECONDS, ignore_canstun = TRUE)
	// normally you don't use userdanger for this but its a hype moment.
	playsound(user, 'sound/effects/magic/forcewall.ogg', 50, TRUE)
	user.visible_message(span_userdanger("[user] channels a beam of holy energy, attempting to purify any and all unholy qualities of [construct_target]!"))
	var/channel_success = do_after(user, 15 SECONDS, target = construct_target)
	construct_target.SetStun(0, ignore_canstun = TRUE)
	QDEL_NULL(link)

	if(!channel_success || QDELETED(construct_target))
		return TRUE

	var/typepath = get_purified_construct_type(construct_target)

	// Fallback for the constructs that dont have a purified version e.g proteons
	if(!typepath)
		convert_construct_in_place(construct_target, user)
		post_conversion(user, construct_target)
		return TRUE

	var/mob/living/basic/construct/new_construct = new typepath(construct_target.loc)
	if(construct_target.mind)
		construct_target.mind.remove_antag_datum(/datum/antagonist/cult)
		construct_target.mind.remove_antag_datum(/datum/antagonist/shade_minion)
		construct_target.mind.transfer_to(new_construct, force_key_move = TRUE)
	else
		enable_construct_ghost_control(new_construct)

	post_conversion(user, new_construct)
	qdel(construct_target)
	return TRUE

/// Applies post conversion fluff + curse.
/datum/action/cooldown/power/theologist/purify/proc/post_conversion(mob/living/user, mob/living/target)
	user.visible_message(span_notice("[user] purifies [target]!"))
	playsound(user, 'sound/effects/his_grace/his_grace_ascend.ogg', 50, TRUE)
	// Special feedback to the construct
	to_chat(target, span_blue("<b>The Geometer's presence in your mind fades, what was once your own freewill slips back into the forefront. You look down at your body; and while it is still the dark steel that adorns your body, you can move it of your own free will. Your freedom is returned; but still tethered forevermore to this body.</b>"))
	// Special feedback to the caster
	to_chat(user, span_blue("<b>As you have shown yourself to be pious, to take on the burdens of others; you now take on the greatest burden of another. Whoever the vile entity responsible may be, you take it away from this enslaved tool, and bury the energy responsible deep inside you. You have freed it; but this darkness seems to be eating away at you.</b>"))
	user.apply_status_effect(/datum/status_effect/debt_to_the_geometer, src)
	to_chat(user, span_cult_bold("<b>You have been cursed; your actions carry a price, and you shall be made to pay it.</b>"))

/// Are we a chaplain or deacon (chaplain sect convertee)?
/datum/action/cooldown/power/theologist/purify/proc/are_we_a_holy_man(mob/living/user)
	if(is_chaplain_job(user.mind?.assigned_role))
		return TRUE
	return user.mind?.holy_role == HOLY_ROLE_DEACON

/// Matches the purified construct type
/datum/action/cooldown/power/theologist/purify/proc/get_purified_construct_type(mob/living/basic/construct/target)
	if(istype(target, /mob/living/basic/construct/artificer))
		return /mob/living/basic/construct/artificer/angelic
	if(istype(target, /mob/living/basic/construct/wraith))
		return /mob/living/basic/construct/wraith/angelic
	if(istype(target, /mob/living/basic/construct/juggernaut))
		return /mob/living/basic/construct/juggernaut/angelic
	return null

/// Adds the ghost control component, allowing someone to play a purified construct.
/datum/action/cooldown/power/theologist/purify/proc/enable_construct_ghost_control(mob/living/basic/construct/target)
	target.AddComponent(\
		/datum/component/ghost_direct_control,\
		poll_candidates = TRUE,\
		poll_question = "Do you want to play as a Theologist's purified construct?",\
		role_name = "purified construct",\
		poll_ignore_key = POLL_IGNORE_CONSTRUCT,\
		assumed_control_message = "You are a purified construct, freed from the Geometer's influence. Your will is now your own.",\
	)

/// In the event that its a construct without a purified equivelant e.g protean, we do this instead.
/datum/action/cooldown/power/theologist/purify/proc/convert_construct_in_place(mob/living/basic/construct/target, mob/living/user)
	var/old_theme = target.theme
	target.theme = THEME_HOLY
	target.faction = list(FACTION_HOLY)
	ADD_TRAIT(target, TRAIT_ANGELIC, INNATE_TRAIT)
	// Neutralize hostile AI (e.g., lavaland proteons).
	if(target.ai_controller)
		target.ai_controller = null
	var/datum/component/ai_retaliate_advanced/retaliate = target.GetComponent(/datum/component/ai_retaliate_advanced)
	if(retaliate)
		qdel(retaliate)
	if(target.icon_state)
		target.cut_overlay("glow_[target.icon_state]_[old_theme]")
		target.add_overlay("glow_[target.icon_state]_[target.theme]")
	target.update_appearance()
	target.mind?.remove_antag_datum(/datum/antagonist/cult)
	target.mind?.remove_antag_datum(/datum/antagonist/shade_minion)
	if(!target.mind)
		enable_construct_ghost_control(target)
	user.visible_message(span_notice("[user] purifies [target]!"))
	return

// Purifying constructs invokes you a curse. You have to pay the bloodtithe; all of your blood. Payed in installments.
/datum/status_effect/debt_to_the_geometer
	id = "debt_to_the_geometer"
	alert_type = /atom/movable/screen/alert/status_effect/debt_to_the_geometer
	/// Total blood required to pay off the debt.
	var/debt_goal = 600
	/// Blood paid so far.
	var/debt_paid = 0
	/// Blood lost per second while the effect is active.
	var/bleed_per_second = 5
	// The curse is starting to tithe blood.
	var/curse_has_started = FALSE

/datum/status_effect/debt_to_the_geometer/on_apply()
	. = ..()
	if(!.)
		return FALSE
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))
	return TRUE

/datum/status_effect/debt_to_the_geometer/tick(seconds_between_ticks)
	if(!owner)
		return

	// We give a bit of an unpredictable buffer before we start bleeding the person. A bit of space to have them RP.
	if(!curse_has_started)
		if(prob(0.5))
			curse_has_started = TRUE
			to_chat(owner, span_cult_bold("Blood is starting to ooze from every part of your body!"))
		else
			return

	// You pissed off the Geometer herself. If Nar'Sie exists, ensure we are her current target.
	if(GLOB.cult_narsie)
		var/turf/owner_turf = get_turf(owner)
		if(owner_turf && owner_turf.z == GLOB.cult_narsie.z)
			var/datum/component/singularity/singularity_component = GLOB.cult_narsie.singularity?.resolve()
			if(singularity_component && singularity_component.target != owner)
				GLOB.cult_narsie.acquire(owner)

	// Visual feedback.
	spawn_blood_splatter()

	// Periodic blood loss and tracking.
	if(istype(owner, /mob/living/carbon))
		var/mob/living/carbon/carbon_owner = owner
		// Because ticks & blood are fucky we do before and after for cost mapping
		var/before = carbon_owner.blood_volume
		carbon_owner.bleed(bleed_per_second * seconds_between_ticks)
		var/removed = max(before - carbon_owner.blood_volume, 0)
		debt_paid += removed

	if(debt_paid >= debt_goal)
		qdel(src)
		return

/// Creates a blood splatter of varying sizes.
/datum/status_effect/debt_to_the_geometer/proc/spawn_blood_splatter()
	var/turf/bleed_turf = get_turf(owner)
	if(!bleed_turf)
		return
	var/amt
	// random blood splatters
	switch(rand(1, 100))
		if(1 to 80)
			amt = rand(1, 8)
		if(81 to 95)
			amt = rand(9, 15)
		else
			amt = rand(16, 25)
	owner.add_splatter_floor(bleed_turf, amt)

/datum/status_effect/debt_to_the_geometer/on_remove()
	if(owner)
		to_chat(owner, span_cult_bold("The Geometer's notice is no longer upon you."))
	return ..()

/// When the owner dies, spray them out like a juicebox.
/datum/status_effect/debt_to_the_geometer/proc/on_owner_death(datum/source, gibbed)
	SIGNAL_HANDLER
	if(!owner)
		return
	if(istype(owner, /mob/living/carbon))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.blood_volume = 0

	var/turf/center = get_turf(owner)
	if(center)
		for(var/turf/T in range(1, center))
			owner.add_splatter_floor(T, FALSE)
	owner.visible_message(span_boldwarning("[owner]'s body bursts open, showering blood everywhere!"))
	playsound(owner, 'sound/effects/wounds/splatter.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	qdel(src)

/atom/movable/screen/alert/status_effect/debt_to_the_geometer
	name = "Debt to the Geometer"
	desc = "The Geometer demands you pay the blood price for your actions."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "soulstone2" // Placeholder
	alerttooltipstyle = "cult"
