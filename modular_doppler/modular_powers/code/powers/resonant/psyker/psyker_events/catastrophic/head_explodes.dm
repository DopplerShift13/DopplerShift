/*
 * Well, has anyone seen Scanners?
 * It's a movie that - seriously?
 * It's that famous scene where the dude's head explodes. That's you. You're dead.
*/
/datum/psyker_event/catastrophic/head_explodes
	weight = PSYKER_EVENT_RARITY_VERYRARE // it's instant fucking death
	lingering = TRUE
	/// Number of one-second warning ticks before the Psyker's head explodes.
	var/ringing_ticks = 10
	/// Delay from _ring_tick firing
	var/ring_tick_delay = 1.15 SECONDS
	/// Volume of the ring
	var/ring_volume = 3
	/// Volume that the ring increase by every ring
	var/ring_volume_increase = 4
	/// Random emote chance every tick before exploding
	var/random_emote_chance = 30
	/// Organ damage minimum damage per tick
	var/organ_damage_min = 1
	/// Organ damage maximum damage per tick
	var/organ_damage_max = 15
	/// Psyker whose screen is being tinted during the buildup.
	var/mob/living/carbon/human/colour_owner
	/// Client colour that becomes progressively redder during the buildup.
	var/datum/client_colour/psyker_head_explosion/screen_colour
	/// Distress emotes the Psyker can perform as the pressure builds.
	var/static/list/buildup_emotes = list("shiver", "twitch", "gasp", "scream", "grimace", "choke", "groan", "scowl", "screech", "whimper")

// Can't lose your head if you don't got head.
/datum/psyker_event/catastrophic/head_explodes/can_execute(mob/living/carbon/human/psyker)
	return !!psyker.get_bodypart(BODY_ZONE_HEAD)

/datum/psyker_event/catastrophic/head_explodes/execute(mob/living/carbon/human/psyker)
	to_chat(psyker, span_userdanger("A faint, high-pitched ringing starts somewhere inside your skull."))

	// applies screen effects
	colour_owner = psyker
	screen_colour = psyker.add_client_colour(/datum/client_colour/psyker_head_explosion, REF(src))

	// STARTS THE DEATH CYCLE
	_ring_tick(psyker, 0)
	return TRUE

/// Replays the short ringing sample at a steadily increasing, but deliberately restrained, volume.
/datum/psyker_event/catastrophic/head_explodes/proc/_ring_tick(mob/living/carbon/human/psyker, tick_count)
	if(QDELETED(psyker))
		qdel(src)
		return

	if(tick_count >= ringing_ticks)
		explode_head(psyker)
		return

	// damage the psyker organ every tick to show its failing.
	var/obj/item/organ/resonant/psyker/psyker_organ = psyker.get_organ_slot(ORGAN_SLOT_PSYKER)
	psyker_organ?.apply_organ_damage(rand(organ_damage_min, organ_damage_max))
	// damages the brain every tick to show it is getting ravaged.
	var/obj/item/organ/brain/psyker_brain = psyker.get_organ_slot(ORGAN_SLOT_BRAIN)
	psyker_brain?.apply_organ_damage(rand(organ_damage_min, organ_damage_max))

	var/colour_strength = tick_count / ringing_ticks
	// Keep the red channel intact while removing more green and blue each tick, making the screen progressively redder.
	screen_colour?.update_color(list(1, 0, 0, 0, 0, 1 - colour_strength, 0, 0, 0, 0, 1 - colour_strength, 0, 0, 0, 0, 1, 0, 0, 0, 0), -1)

	// Random distress emotes during the buildup, followed by a guaranteed audible scream on the final tick.
	if(tick_count == ringing_ticks - 1) // final tick version
		// WE WANT TO HEAR THEM SCREAM
		TIMER_COOLDOWN_END(psyker, /datum/emote/living/scream)
		TIMER_COOLDOWN_END(psyker, "general_emote_audio_cooldown")
		psyker.emote("scream", forced = TRUE)
	else if(prob(random_emote_chance))
		psyker.emote(pick(buildup_emotes))

	psyker.playsound_local(get_turf(psyker), 'sound/effects/screech.ogg', ring_volume + (tick_count * ring_volume_increase), FALSE, pressure_affected = FALSE)
	if(tick_count == 5)
		to_chat(psyker, span_userdanger("The ringing swells, drowning out every thought."))
	else if(tick_count == ringing_ticks - 1)
		to_chat(psyker, span_userdanger("The tone becomes unbearable."))

	addtimer(CALLBACK(src, PROC_REF(_ring_tick), psyker, tick_count + 1), ring_tick_delay)

/// Destroys the head and its organs, except for the brain, which is hurled clear by the blast.
/datum/psyker_event/catastrophic/head_explodes/proc/explode_head(mob/living/carbon/human/psyker)
	var/obj/item/bodypart/head/exploding_head = psyker.get_bodypart(BODY_ZONE_HEAD)
	var/turf/explosion_turf = get_turf(psyker)
	if(!exploding_head || !explosion_turf)
		qdel(src)
		return

	psyker.visible_message(
		span_bolddanger("[psyker]'s head explodes in a shower of gore!"),
		span_userdanger("The ringing peaks - and then your head bursts apart!"),
	)
	playsound(explosion_turf, 'sound/machines/clockcult/ark_deathrattle.ogg', 55, TRUE) // worlds best sound still unused
	new /obj/effect/gibspawner/generic(explosion_turf, psyker)

	// Does all the bloody stuff such as splattering everything nearby in brain-blood.
	if(psyker.can_bleed())
		psyker.blood_volume = max(psyker.blood_volume * 0.8, 0)
		for(var/splatter_direction in GLOB.alldirs) // splatters and gibs
			psyker.create_splatter(splatter_direction)
		for(var/turf/bloodied_turf as anything in RANGE_TURFS(1, explosion_turf)) // blood splats on turfs
			psyker.add_splatter_floor(bloodied_turf)
		for(var/mob/living/splattered_mob in range(1, explosion_turf)) // deliberately drenches people in the blast radius with blood
			if(splattered_mob == psyker)
				continue
			splattered_mob.visible_message(
				span_danger("[splattered_mob] is drenched in [psyker]'s blood!"),
				span_userdanger("You are drenched in [psyker]'s blood!"),
			)
			// Coat their exposed clothing as well, wherever the source blood type allows it.
			splattered_mob.add_mob_blood(psyker)

	// Ejects the brain from the head and moves it onto the center turf.
	var/obj/item/organ/brain/ejected_brain = psyker.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(ejected_brain)
		ejected_brain.Remove(psyker)
		ejected_brain.forceMove(explosion_turf)

	// Now we remove the head and practically anything inside it. Since we already emergency ejected the brain, it should be safe.
	exploding_head.drop_limb(dismembered = TRUE)
	for(var/obj/item/organ/head_organ in exploding_head)
		qdel(head_organ)
	qdel(exploding_head)
	psyker.death()
	psyker.investigate_log("has been killed by a catastrophic Psyker stress event causing [psyker.p_their()] head to explode.", INVESTIGATE_DEATHS)

	// YEETS THE BRAIN
	if(ejected_brain && !QDELETED(ejected_brain))
		ejected_brain.throw_at(	get_edge_target_turf(explosion_turf, pick(GLOB.alldirs)), range = rand(2, 4), speed = 5, thrower = psyker)

	// ok were done
	qdel(src)

/datum/psyker_event/catastrophic/head_explodes/Destroy()
	if(!QDELETED(colour_owner))
		colour_owner.remove_client_colour(REF(src))
	colour_owner = null
	screen_colour = null
	return ..()

/datum/client_colour/psyker_head_explosion
	priority = CLIENT_COLOR_IMPORTANT_PRIORITY
	color = COLOR_MATRIX_IDENTITY

// Adds the backlash option as a smite for admin
/datum/smite/psyker_breakdown/head_explodes
	name = "Psyker Event: Head Explodes"
	event_type = /datum/psyker_event/catastrophic/head_explodes
