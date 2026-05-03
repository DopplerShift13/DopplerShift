/* This largely served as the first example power of Theologist outside the roots.
Biggest takeaway is just use status effects if it's any form of lingering effect; and to borrow cool mechanics from other code.
Entropic Mending removes wounds (sometimes) and speeds up the target's metabolism, hunger and blood regen by 3x.
*/
/datum/power/theologist/entropic_mending
	name = "Entropic Mending"
	desc = "Entropy's a long road, a few steps further along it will do you more good than harm. Spend 5 Piety to touch another humanoid and attempt to restore it's lingering wounds. \
	Moderate wounds will be healed automatically; all other wounds have a random chance to depending on severity. \
	Invoking this power will cause temporary, lingering entropic effects on the target; such as increased metabolism, hunger and blood replenishment, at triple pace."
	security_record_text = "Subject can accelerate a target's bodily functions (e.g metabolism) to be thrice as fast, and mend lingering wounds."
	action_path = /datum/action/cooldown/power/theologist/entropic_mending
	value = 6

	required_powers = list(/datum/power/theologist_root/twisted)

/datum/action/cooldown/power/theologist/entropic_mending
	name = "Entropic Mending"
	desc = "Entropy's a long road, a few steps further along it will do one more good than harm. Spend 5 Piety to touch another humanoid and attempt to restore it's lingering wounds. \
	Moderate wounds will be healed automatically; all other wounds have a random chance to depending on severity. \
	Invoking this power will cause temporary, lingering entropic effects on the target; such as increased metabolism, hunger and blood replenishment, at triple pace."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "manip"
	cooldown_time = 150
	target_range = 1
	target_type = /mob/living/carbon/human
	click_to_activate = TRUE
	target_self = FALSE
	unset_after_click = TRUE
	cost = 5

	/// Current instance of the status effect
	var/datum/status_effect/power/entropic_mending/active_effect

/datum/action/cooldown/power/theologist/entropic_mending/use_action(mob/living/user, mob/living/target)
	to_chat(owner, span_boldnotice("You begin to mend [target.get_visible_name()]"))
	if(active_effect)
		qdel(active_effect)
	active_effect = target.apply_status_effect(/datum/status_effect/power/entropic_mending, src)
	active = TRUE
	return TRUE

/datum/action/cooldown/power/theologist/entropic_mending/set_click_ability(mob/on_who)
	. = ..()
	to_chat(owner, span_notice("You channel entropic energies into your hand!<br><B>Left-click</B> a creature next to you to target them!"))

/// Callback from the status effect that updates the active state
/datum/action/cooldown/power/theologist/entropic_mending/proc/effect_expired(amount)
	//Always reset this after use.
	active = FALSE
	return

// Status effect that Burden Revered applies
/datum/status_effect/power/entropic_mending
	id = "entropic_mending"
	duration = 3 MINUTES
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/entropic_mending

	/// The power responsible for this.
	var/datum/action/cooldown/power/theologist/entropic_mending/entropic_mending

	/// Because a lot of things here require static types.
	var/mob/living/carbon/human/victim

	/// How much we speed up blood regen with
	var/blood_regen_rate = 3
	/// How much we speed up metabolism with
	var/metabolic_boost = 3
	/// How much we speed up hunger gain with
	var/hunger_rate = 3
	//// Tracks if we've modified the physiology of the owner
	VAR_PRIVATE/physiology_modified = FALSE
	/// Tracks how many wounds were healed by this.
	var/wounds_treated = 0


/atom/movable/screen/alert/status_effect/entropic_mending
	name = "Entropic Mending"
	desc = "Your body's internal functions seem to be accelerated, for better or worse."
	icon_state = "arrow8" // Placeholder

// So given it is 'part of the effect', we actually handle the wound removal on here.
/datum/status_effect/power/entropic_mending/on_apply()
	victim = owner // Whilst I would like to set it on_creation, it doesn't always pass it along 4somerasinss.
	playsound(owner, 'sound/effects/magic/staff_healing.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	// Attemps to remove wounds
	for(var/datum/wound/wound in victim.all_wounds)
		switch(wound.severity)
			if(WOUND_SEVERITY_TRIVIAL, WOUND_SEVERITY_MODERATE)
				handle_wound_heal_success(entropic_mending.owner, victim, wound)
				wounds_treated++
			if(WOUND_SEVERITY_SEVERE)
				if(prob(60))
					handle_wound_heal_success(entropic_mending.owner, victim, wound)
					wounds_treated++
				else
					to_chat(entropic_mending.owner, span_warning("The restorative energies fail to treat the [wound.name]!"))
			if(WOUND_SEVERITY_CRITICAL)
				if(prob(30))
					handle_wound_heal_success(entropic_mending.owner, victim, wound)
					wounds_treated++
				else
					to_chat(entropic_mending.owner, span_warning("The restorative energies fail to treat the [wound.name]!"))
	// Feedback to user
	if(!LAZYLEN(victim.all_wounds)) // Not necessarily bad, you might use this for it's metabolize effect.
		to_chat(entropic_mending.owner, span_notice("[victim.get_visible_name()] has no wounds to treat!"))
	else if(wounds_treated <= 0)
		to_chat(entropic_mending.owner, span_warning("[entropic_mending.name] failed to heal any of [victim.get_visible_name()]'s wounds!"))
	else if(LAZYLEN(victim.all_wounds))
		to_chat(entropic_mending.owner, span_notice("[entropic_mending.name] managed to heal some of [victim.get_visible_name()]'s wounds!"))
	else
		to_chat(entropic_mending.owner, span_notice("[entropic_mending.name] managed to heal all of [victim.get_visible_name()]'s' wounds!"))

	// Makes our blood regenerate faster
	if(!physiology_modified)
		victim.physiology.blood_regen_mod *= blood_regen_rate
		physiology_modified = TRUE

	return TRUE

/// Just there to quickly handle wound-healing + return values.
/datum/status_effect/power/entropic_mending/proc/handle_wound_heal_success(caster, mob/living/victim, datum/wound/wound)
	new /obj/effect/temp_visual/heal(get_turf(victim), "#cf2525")
	wound.remove_wound()
	to_chat(entropic_mending.owner, span_notice("The restorative energies manage to treat the [wound.name]!"))
	to_chat(victim, span_notice("Your [wound.name] got healed!"))

// Sets the link with the original action
/datum/status_effect/power/entropic_mending/on_creation(mob/living/new_owner, datum/action/cooldown/power/theologist/entropic_mending/passed_power)
	entropic_mending = passed_power
	. = ..()

/datum/status_effect/power/entropic_mending/on_remove()
	// Removes the blood regen mult
	if(physiology_modified)
		victim.physiology.blood_regen_mod /= blood_regen_rate
		physiology_modified = FALSE
	expire()

// We're not spelling it out but basically all the vibes of age-based healing.
/datum/status_effect/power/entropic_mending/tick(seconds_between_ticks)
	//Code that the metabolic boost virus symptom would shamelessly steal from us, 16 years in the past.
	// Unlike metabolic boost we actually check if there's a liver
	var/obj/item/organ/liver/liver = victim.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver)
		// Not totally accurate with the liver damage but WHO WILL NOTICE THIS DISCRAPANCY?! IS IT YOU, MR./MS. CODEDIVER?! ARE YOU GOING TO TRIVIA THIS LIKE VIGGO'S TOE?!
		victim.reagents.metabolize(victim, (metabolic_boost - (liver.damage * 0.03)) * SSMOBS_DT, 0, can_overdose=TRUE)
	victim.overeatduration = max(victim.overeatduration - 4 SECONDS, 0)
	victim.adjust_nutrition(-hunger_rate * HUNGER_FACTOR) //Hunger depletes at 3x the normal speed

/// Communicates back to the power that the effect has ended.
/datum/status_effect/power/entropic_mending/proc/expire()
	// Report back BEFORE deletion starts
	if(entropic_mending)
		entropic_mending.effect_expired()
