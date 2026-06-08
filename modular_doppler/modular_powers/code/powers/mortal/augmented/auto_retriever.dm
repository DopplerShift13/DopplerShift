/*
	Teleports you to medbay, once. Either on demand or when you soft-crit. Needs to be refurbished after & can be interupted.
*/
/datum/power/augmented/auto_retriever
	name = "Premium ANGL Auto Retriever"
	desc = "Some assets are far too wealthy to risk losing. Created by DeForest, this allows their premium customers to be rescued from the most grievous of circumstances; and recently came with a support API for other healthcare providers.\
	\n Once you reach critical condition or when manually activated, you begin a slow (and obvious) 10 second teleport towards your station's medbay lobby (regardless of Z-level).\
	Once it fires, a warning message is issued over the radio. The teleportation sets the quality to 0%, and can be interrupted by Epinephrine, Atropine or Stabilizing Agent in the bloodstream, EMP, or healing you above the critical threshold, after which it loses 25% quality and enters a several minute cooldown period.\
	\n Decreases in quality twice as fast. Lower quality decreases the speed of the teleport."
	security_record_text = "Subject has a ANGL Auto Retriever and will teleport to medbay if critically injured."
	security_threat = POWER_THREAT_MAJOR

	value = 6
	augment = /obj/item/organ/cyberimp/chest/auto_retriever

/obj/item/organ/cyberimp/chest/auto_retriever
	name = "ANGL Auto Retriever"
	desc = "Some assets are far too wealthy to risk losing. Created by DeForest, this allows their premium customers to be rescued from the most grievous of circumstances; and recently came with a support API for other healthcare providers.\
	\n Once you reach critical condition or when manually activated, you begin a slow (and obvious) 10 second teleport towards your station's medbay lobby (regardless of Z-level).\
	Once it fires, a warning message is issued over the radio. The teleportation sets the quality to 0%, and can be interrupted by Epinephrine, Atropine or Stabilizing Agent in the bloodstream, EMP, or healing you above the critical threshold, after which it loses 25% quality and enters a several minute cooldown period.\
	\n Decreases in quality twice as fast. Lower quality decreases the speed of the teleport."
	icon_state = "reviver_implant"
	slot = ORGAN_SLOT_HEART_AID

	actions_types = list(/datum/action/item_action/organ_action/premium/use)
	premium = TRUE
	/// On or off state.
	var/enabled = TRUE

	/// Are we in the process of teleporting
	var/teleporting = FALSE
	/// Reference ID for the timer proc.
	var/teleport_timer_id
	/// Time it takes to spool up the teleport.
	var/teleport_spool_time = 10 SECONDS
	/// The sound that plays while spooling up.
	var/teleport_charge_sound = 'sound/effects/magic/lightning_chargeup.ogg'

	// Frequencies are used to indicate that a teleporter is going faster or slower, since it both increases pace and pitch.
	/// The standard sound frequency used at 75%
	var/teleport_sound_base_frequency = 44000
	/// The lowest sound frequency used at the lowest tier
	var/teleport_sound_min_frequency = 32000
	/// The highest sound frequency used at the highest tier
	var/teleport_sound_max_frequency = 55000

	/// Cooldowns for TP
	var/tp_cooldown = 3 MINUTES
	/// Cooldown deceleration for TP
	COOLDOWN_DECLARE(teleport_cooldown)

	/// Cooldowns for EMP
	var/emp_cooldown = 30 SECONDS
	/// Cooldown decleration for EMP
	COOLDOWN_DECLARE(emp_reenable_cooldown)


	/// Internal radio used for relaying to medbay.
	var/obj/item/radio/internal_radio

	/// Ref for the sparking overlay.
	var/mutable_appearance/teleport_spark_overlay
	/// Icon of the sparks on TP
	var/teleport_spark_icon = 'icons/effects/effects.dmi'
	/// Icon state of the sparks on TP
	var/teleport_spark_state = "lightning"
	/// Layer of the sparks on TP
	var/teleport_spark_layer = ABOVE_MOB_LAYER

/obj/item/organ/cyberimp/chest/auto_retriever/Initialize(mapload)
	. = ..()
	if(premium_component)
		premium_component.refurb_parts = list(
			/obj/item/stack/sheet/iron = 1,
			/obj/item/stack/sheet/bluespace_crystal = 1,
			/obj/item/stack/cable_coil = 2,
			/obj/item/stock_parts/scanning_module/triphasic = 1)
		premium_component.decay_interval = AUGMENTED_DECAY_INTERVAL / 2 // decays twice as fast.

	// We give it a radio to be able to speak to the medbay frequency.
	internal_radio = new /obj/item/radio(src)
	internal_radio.keyslot = new /obj/item/encryptionkey/headset_med
	internal_radio.subspace_transmission = TRUE
	internal_radio.canhear_range = 0 // no free medbay radio 4u
	internal_radio.recalculateChannels()

/obj/item/organ/cyberimp/chest/auto_retriever/Destroy()
	if(teleport_timer_id)
		deltimer(teleport_timer_id)
		teleport_timer_id = null
	QDEL_NULL(internal_radio)
	return ..()

// Checks if we're in deep shit and need teleporting out.
/obj/item/organ/cyberimp/chest/auto_retriever/on_life(seconds_per_tick, times_fired)
	if(!owner || !enabled)
		return
	if(teleporting)
		if(should_cancel_teleport())
			cancel_teleport()
		return
	if(!premium_component?.can_function())
		return
	if(!COOLDOWN_FINISHED(src, teleport_cooldown))
		return
	if(owner.reagents?.has_reagent(/datum/reagent/medicine/epinephrine) || owner.reagents?.has_reagent(/datum/reagent/medicine/atropine))
		return
	if(owner.stat >= SOFT_CRIT && owner.stat != DEAD)
		start_teleport()

/// Starts spooling up and notifying literally everyone they are going to poof.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/start_teleport()
	if(!owner)
		return
	if(teleporting || !enabled)
		return
	if(!premium_component?.can_function())
		return
	if(!COOLDOWN_FINISHED(src, teleport_cooldown))
		return
	teleporting = TRUE
	// Modifies the tp by efficiency
	var/efficiency = premium_component?.get_efficiency() || 1
	var/spool_time = round(teleport_spool_time / max(efficiency, 0.01))
	var/teleport_seconds = round(spool_time / (1 SECONDS))
	var/message = "Patient health critical; commencing teleportation in [teleport_seconds] seconds. Stabilize patient to cancel."
	augment_speak(message)
	apply_teleport_effects(spool_time)
	var/sound_frequency = clamp(round(teleport_sound_base_frequency * efficiency), teleport_sound_min_frequency, teleport_sound_max_frequency)
	if(sound_frequency > teleport_sound_min_frequency && spool_time > 2 SECONDS)
		var/sound_ratio = spool_time / max(spool_time - 2 SECONDS, 1)
		sound_frequency = clamp(round(sound_frequency * sound_ratio), teleport_sound_min_frequency, teleport_sound_max_frequency)
	owner.playsound_local(owner, teleport_charge_sound, 75, TRUE, frequency = sound_frequency)
	teleport_timer_id = addtimer(CALLBACK(src, PROC_REF(finish_teleport)), spool_time, TIMER_STOPPABLE)

/// We go POOF, away.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/finish_teleport()
	if(!teleporting)
		return
	teleporting = FALSE
	if(teleport_timer_id)
		deltimer(teleport_timer_id)
		teleport_timer_id = null
	clear_teleport_effects()
	if(!owner || owner.stat < SOFT_CRIT || owner.stat == DEAD)
		return

	// We try to TP to the lobby first; if there's no lobby we teleport them to the medbay.
	var/turf/destination = pick_open_turf_from_area(/area/station/medical/medbay/lobby)
	if(!destination)
		destination = pick_open_turf_from_area(/area/station/medical/medbay, subtypes = TRUE)
	if(!destination)
		return

	var/teleport_success = do_teleport(owner, destination, channel = TELEPORT_CHANNEL_QUANTUM)
	if(!teleport_success)
		return

	augment_speak("Auto Retriever alert: [owner.real_name] has teleported to Medbay for emergency treatment.", RADIO_CHANNEL_MEDICAL)

	// Sets it to 0. Go and get it refurbished.
	if(premium_component)
		premium_component.adjust_quality(-premium_component.quality)

/// Cancel if stabilized, epinephrine applied, or EMP'd.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/should_cancel_teleport()
	if(!owner)
		return FALSE
	if(owner.stat < SOFT_CRIT)
		return TRUE
	if(owner.reagents?.has_reagent(/datum/reagent/medicine/epinephrine) || owner.reagents?.has_reagent(/datum/reagent/medicine/atropine) || owner.reagents?.has_reagent(/datum/reagent/stabilizing_agent))
		return TRUE
	return FALSE

/// Stops a teleport that is in progress.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/cancel_teleport()
	if(!teleporting)
		return
	teleporting = FALSE
	if(teleport_timer_id)
		deltimer(teleport_timer_id)
		teleport_timer_id = null
	clear_teleport_effects()
	augment_speak("Teleportation cancelled; entering cooldown.")
	COOLDOWN_START(src, teleport_cooldown, tp_cooldown)
	if(premium_component)
		premium_component.adjust_quality(-AUGMENTED_PREMIUM_QUALITY_MODERATE)

/// When we get EMP'd.
/obj/item/organ/cyberimp/chest/auto_retriever/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(premium_component)
		premium_component.adjust_quality(-AUGMENTED_PREMIUM_QUALITY_MINOR)
	enabled = FALSE
	COOLDOWN_START(src, emp_reenable_cooldown, emp_cooldown)
	premium_component?.update_quality_actions()
	to_chat(owner, span_warning("Your [name] becomes disabled!"))
	cancel_teleport()

/// Makes the augment speak, either locally or through the radio.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/augment_speak(message, channel)
	if(!message)
		return
	var/list/message_mods = list(SAY_MOD_VERB = "states")
	if(channel)
		if(internal_radio)
			internal_radio.talk_into(src, message, channel, message_mods = message_mods)
		return
	say(message, forced = "auto retriever", message_mods = message_mods)

// Toggle the auto-retriever on/off (gate for activation).
/obj/item/organ/cyberimp/chest/auto_retriever/use_action()
	if(!owner)
		return FALSE
	if(!enabled && !COOLDOWN_FINISHED(src, emp_reenable_cooldown))
		to_chat(owner, span_warning("Your [name] is temporarily disabled from EMP interference."))
		return FALSE
	enabled = !enabled
	if(enabled)
		to_chat(owner, span_notice("Your [name] is toggled on; it will now activate when you reach critical condition."))
	else
		to_chat(owner, span_notice("Your [name] is toggled off."))
	return enabled

/obj/item/organ/cyberimp/chest/auto_retriever/is_action_active()
	return enabled

/// Apply the sparking visual effect + jitter.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/apply_teleport_effects(spool_time)
	if(!owner)
		return
	owner.set_jitter_if_lower(spool_time)
	if(!teleport_spark_overlay)
		teleport_spark_overlay = mutable_appearance(teleport_spark_icon, teleport_spark_state, teleport_spark_layer)
	teleport_spark_overlay.appearance_flags |= KEEP_APART
	owner.add_overlay(teleport_spark_overlay)

/// Removes the active sparking overlay on the mob.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/clear_teleport_effects()
	if(!owner || !teleport_spark_overlay)
		return
	owner.cut_overlay(teleport_spark_overlay)

/// Finds an open space to teleport to.
/obj/item/organ/cyberimp/chest/auto_retriever/proc/pick_open_turf_from_area(area_type, subtypes = FALSE)
	var/list/turfs = get_area_turfs(area_type, subtypes = subtypes)
	if(!LAZYLEN(turfs))
		return null
	var/list/open_turfs = list()
	for(var/turf/turf_candidate as anything in turfs)
		if(!turf_candidate.density)
			open_turfs += turf_candidate
	if(!LAZYLEN(open_turfs))
		return null
	return pick(open_turfs)
