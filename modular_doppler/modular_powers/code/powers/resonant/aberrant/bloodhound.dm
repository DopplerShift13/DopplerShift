// Lets you sniff someone out based on their blood. Sorta similar toa pinpointer.
/datum/power/aberrant/bloodhound
	name = "Bloodhound"
	desc = "A whiff of someone's blood, and you're right on their tail. Select a source of blood and it will be your currently active scent. You can only have one active source of scent, and it only lasts for a few minutes.\
	\n Whilst you have someone's blood, you have an indicator of your quarry's direction. Does not work on scrying immune creatures."
	security_record_text = "Subject can track down a creature's direction using blood samples."
	value = 10

	required_powers = list(/datum/power/aberrant_root/beastial)
	action_path = /datum/action/cooldown/power/aberrant/bloodhound

/datum/action/cooldown/power/aberrant/bloodhound
	name = "Bloodhound"
	desc = "Track someone using a sample their blood. By targeting a source of blood, you acquire your quarry, allowing you to track their direction for a limited time."
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "cleave"
	click_to_activate = TRUE
	target_range = 1

	/// How much hunger does tracking someone take?
	var/hunger_cost = 20
	/// How long you can keep a mob's scent.
	var/scent_duration = 2 MINUTES

/datum/action/cooldown/power/aberrant/bloodhound/use_action(mob/living/user, atom/target)
	var/list/dna_samples = get_blood_dna_list_from_target(target)
	if(!length(dna_samples))
		user.balloon_alert(user, "You need blood to focus your scent.")
		return FALSE

	// If your list of dna samples has multiples then my man you gotta clean your samples. Chooses a random one.
	var/selected_dna = pick(dna_samples)
	var/mob/living/chosen_target = find_target_from_dna(selected_dna)
	if(!chosen_target)
		user.balloon_alert(user, "No scent to follow.")
		return FALSE

	if(!can_affect_bloodhound(chosen_target))
		user.balloon_alert(user, "No scent to follow.")
		return FALSE

	var/datum/status_effect/power/bloodhound_scent/applied = user.apply_status_effect(/datum/status_effect/power/bloodhound_scent, scent_duration, chosen_target)
	if(!applied)
		return FALSE

	user.emote("sniff")
	to_chat(user, span_notice("You catch someone's scent!"))
	user.adjust_nutrition(hunger_cost)
	return TRUE

/// Checks if the target can be affected by bloodhound tracking. Basically magic resistance + scrying immunity.
/datum/action/cooldown/power/aberrant/bloodhound/proc/can_affect_bloodhound(mob/living/target)
	if(target.can_block_resonance())
		return FALSE
	if(target.can_block_magic(MAGIC_RESISTANCE))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_ANTIRESONANCE_SCRYING))
		return FALSE
	return TRUE

/// Gets DNA from blood
/datum/action/cooldown/power/aberrant/bloodhound/proc/get_blood_dna_list_from_target(atom/target)
	if(isnull(target))
		return null

	var/list/dna_list = list()

	if(ismob(target))
		return dna_list

	// Gets dna from a blood decal.
	if(istype(target, /obj/effect/decal/cleanable/blood))
		var/obj/effect/decal/cleanable/blood/blood_decal = target
		if(blood_decal.dried || blood_decal.bloodiness <= 0) // we don't count dry blood. The trail has gone cold.
			return dna_list
		var/list/blood = GET_ATOM_BLOOD_DNA(target)
		for(var/dna in blood)
			dna_list += dna
		return dna_list

	// Gets dna from blood from reagent containers. Note: There's a bug with scraping blood not saving DNA; so if it acts weirds its likely that (as of 20/02/26)
	if(istype(target, /obj/item/reagent_containers))
		for(var/datum/reagent/present_reagent as anything in target.reagents?.reagent_list)
			if(!istype(present_reagent, /datum/reagent/blood))
				continue
			var/blood_dna = present_reagent.data?["blood_DNA"]
			if(isnull(blood_dna))
				continue
			if(islist(blood_dna))
				for(var/dna in blood_dna)
					dna_list += dna
			else
				dna_list += blood_dna

	// Any non-mob atom with forensics blood on it (e.g. clothes, tools)
	var/list/blood = GET_ATOM_BLOOD_DNA(target)
	if(length(blood))
		for(var/dna in blood)
			dna_list += dna

	return dna_list

/// Checks the blood for a dna match.
/datum/action/cooldown/power/aberrant/bloodhound/proc/find_target_from_dna(selected_dna)
	if(!selected_dna)
		return null

	for(var/mob/living/target in GLOB.mob_list)
		if(isobserver(target))
			continue
		var/list/blood_dna = target.get_blood_dna_list()
		if(blood_dna && blood_dna[selected_dna])
			return target
	return null

// Status effect meant for bloodhound
/datum/status_effect/power/bloodhound_scent
	id = "bloodhound_scent"
	status_type = STATUS_EFFECT_REPLACE
	show_duration = TRUE
	tick_interval = STATUS_EFFECT_AUTO_TICK
	alert_type = /atom/movable/screen/alert/status_effect/bloodhound_scent

	/// Weakref to the target mob
	var/datum/weakref/target_ref

/datum/status_effect/power/bloodhound_scent/on_creation(mob/living/new_owner, passed_duration, mob/living/target)
	if(isnum(passed_duration))
		duration = passed_duration
	else // we should always pass a duration so something went wrong. We fall back on this.
		duration = 1 MINUTES

	if(ismob(target))
		target_ref = WEAKREF(target)
	. = ..()
	update_direction_indicator()

// If we have no target we nuke the power.
/datum/status_effect/power/bloodhound_scent/on_apply()
	var/mob/living/target = target_ref?.resolve()
	if(!target)
		return FALSE
	return TRUE

/datum/status_effect/power/bloodhound_scent/tick(seconds_between_ticks)
	if(prob(1))
		owner.emote("sniff")
	update_direction_indicator()

/// Updates the direction indicator on the status effect (what we use to convey direction)
/datum/status_effect/power/bloodhound_scent/proc/update_direction_indicator()
	if(!owner || QDELETED(owner))
		qdel(src)
		return

	var/mob/living/target = target_ref?.resolve()
	if(!target || QDELETED(target))
		qdel(src)
		return

	var/turf/here = get_turf(owner)
	var/turf/there = get_turf(target)
	if(!here || !there || here.z != there.z)
		if(linked_alert)
			linked_alert.icon = 'icons/effects/landmarks_static.dmi'
			linked_alert.icon_state = "x"
			linked_alert.dir = SOUTH
		return

	var/dir_to_target = get_dir(here, there)
	if(!dir_to_target)
		return

	var/dir_text = uppertext(dir2text(dir_to_target))
	var/image/dir_image = GLOB.all_radial_directions[dir_text] // this is literally the best list of direction indicators I could find lmao
	if(!dir_image || !linked_alert)
		return

	linked_alert.icon = dir_image.icon
	linked_alert.icon_state = dir_image.icon_state
	linked_alert.dir = dir_image.dir

/atom/movable/screen/alert/status_effect/bloodhound_scent
	name = "Bloodhound"
	desc = "Your senses point the way to your quarry."
	icon = 'icons/testing/turf_analysis.dmi'
	icon_state = "red_arrow"
