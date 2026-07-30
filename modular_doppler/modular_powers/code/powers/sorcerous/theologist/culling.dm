/// Grants Piety based on watching unholy mobs die.
/datum/power/theologist/culling
	name = "Cull the Unholy"
	desc = "You are invested in a holy mission; to cleanse evil wherever it may take root. Defeating unholy mobs (most mining mobs, undead and cultist constructs) will grant you 1 Piety, capped to 20. \
	\nElite Mining mobs grant 10 piety, whilst Sentient Elites and Megafauna grants you 25 Piety. Both of these are uncapped.\
	\nYou do not need to participate in the kill: as long as you witness their death and are in their proximity, you will gain the Piety."
	security_record_text = "Subject fuels their powers by slaying creatures of unholy disposition."
	value = 2
	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

	/// Reference to the owner's piety component
	var/datum/component/theologist_piety/piety_component
	/// Mobs that should never grant piety on death either for being weak or otherwise.
	var/static/list/mob_blacklist = typecacheof(list(
		/mob/living/basic/mining/legion_brood,
	))

/datum/power/theologist/culling/add(client/client_source)
	..()
	get_piety_component()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_death))

/datum/power/theologist/culling/remove()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)

/// Attempts to acquire the piety component
/datum/power/theologist/culling/proc/get_piety_component()
	piety_component = power_holder.GetComponent(/datum/component/theologist_piety)
	if(!piety_component)
		return FALSE
	return TRUE

/// Whenever a mob dies, we go through this listener.
/datum/power/theologist/culling/proc/on_death(datum/source, mob/living/died, gibbed)
	if(!piety_component && !get_piety_component())
		return
	if((died.z != power_holder.z) || !(died in view(power_holder))) // We need to see it.
		return
	if(is_type_in_typecache(died, mob_blacklist)) // not worth piety
		return

	// Attempts to give piety if the mob is on the unholy mob list
	if(is_type_in_typecache(died, GLOB.unholy_mobs))
		if(ismegafauna(died) || (istype(died, /mob/living/simple_animal/hostile/asteroid/elite) && died.mind)) // Sentient elites and megafauna grant 25
			piety_component.adjust_piety(THEOLOGIST_PIETY_MAJOR)
			to_chat(power_holder, span_boldnotice("Slaying a mighty foe has granted you a great amount of piety!"))
		else if(istype(died, /mob/living/simple_animal/hostile/asteroid/elite)) // If the mob is an elite grant 10
			piety_component.adjust_piety(THEOLOGIST_PIETY_MODERATE)
			to_chat(power_holder, span_boldnotice("Slaying a strong foe has granted you a large amount of piety!"))
		else if(piety_component.piety <= 20) // grants 1 if not at piety cap
			piety_component.adjust_piety(THEOLOGIST_PIETY_TRIVIAL * 2)
		else
			return
		// Sound effect to confirm you got piety
		playsound(power_holder, 'sound/effects/magic/charge.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)

