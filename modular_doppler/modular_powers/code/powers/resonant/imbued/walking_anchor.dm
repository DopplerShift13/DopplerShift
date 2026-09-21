// Takes all of your points (1+9+10), however you silence everyone adjacent to you. Because this crater's peoples moods and is unpleasent to look at, expect to be hated.
// if you want to see the silence effect, see: modular_doppler\modular_powers\code\security\reality_anchor.dm

/datum/power/imbued/walking_anchor
	name = "Ontologically Immutable"
	desc = "While others are unmoved by resonance, you actively repel it. Everyone adjacent to you is silenced as if being next to a portable reality anchor, \
	anyone with resonant or sorcerous powers will feel horrible and will probably want to stay as far away from you as possible. It's lonely."
	security_record_text = "Subject generates an area of localised reality enforcement."
	security_threat = POWER_THREAT_MAJOR
	value = 10
	power_flags = POWER_PROCESSES
	required_powers = list(/datum/power/imbued/counter_resonance)

	menu_icon = 'icons/effects/effects.dmi'
	menu_icon_state = "shield-grey"

	// range of the silence, if we ever wanted to change it
	var/silence_range = 1

/datum/power/imbued/walking_anchor/process(seconds_per_tick)
	var/mob/living/carbon/mob = power_holder
	for(var/atom/movable/target in range(silence_range, mob))
		if(isliving(target))
			var/mob/living/living_target = target
			// Being immune to resonance or a heretic prevents the application of the silence effect. We also grant the power holder immunity so they don't buzz blue constantly.
			if(!living_target.can_block_resonance() && !living_target.mind?.has_antag_datum(/datum/antagonist/heretic) && !living_target == mob)
				living_target.apply_status_effect(/datum/status_effect/power/reality_anchor_silenced/walking_anchor)
			living_target.dispel(src, DISPEL_CASCADE_CARRIED)
		else if(isobj(target))
			target.dispel(src)

/datum/status_effect/power/reality_anchor_silenced/walking_anchor
	alert_type = /atom/movable/screen/alert/status_effect/reality_anchor_silenced/walking_anchor
	show_duration = FALSE
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/reality_anchor_silenced/walking_anchor
	desc = "Resonant powers are being surpressed by someone nearby..."
