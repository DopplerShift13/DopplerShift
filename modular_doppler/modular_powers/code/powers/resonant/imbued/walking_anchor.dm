// Takes most of your points, however you silence everyone adjacent to you. Because this crater's peoples moods and is unpleasent to look at, expect to be hated.
// a lot of this is borrowed from portable anchors. see: modular_doppler\modular_powers\code\security\reality_anchor.dm

/datum/power/imbued/walking_anchor
	name = "Ontologically Immutable"
	desc = "While others are unmoved by resonance, you actively repel it. People adjacent to you are silenced as if next to a reality anchor. \
	This includes dispelling objects, lowering moods and generally being extremely unpleasent. Highly advanced magics can still break through \
	and magic users can see the pulses. It's lonely like this."
	security_threat = POWER_THREAT_MAJOR
	value = 7 // anti-resonance already costs a lot. this gives some small change for expert powers
	power_flags = POWER_PROCESSES
	required_powers = list(/datum/power/imbued/counter_resonance)

	menu_icon = 'icons/effects/effects.dmi'
	menu_icon_state = "shield-grey"

	/// Pulse interval, twice as fast than a portable anchor
	var/pulse_interval = 3 SECONDS
	/// Time until the next pulse
	var/next_pulse_time = 0
	/// range of the silence, if we ever wanted to change it
	var/pulse_range = 1

/datum/power/imbued/walking_anchor/process(seconds_per_tick)
	if(world.time < next_pulse_time)
		return
	pulse()
	next_pulse_time = world.time + pulse_interval

/datum/power/imbued/walking_anchor/proc/pulse()
	var/mob/living/carbon/mob = power_holder
	var/turf/center = get_turf(power_holder)
	new/obj/effect/temp_visual/circle_wave/reality_anchor/walking_anchor(center)
	for(var/atom/movable/target in range(pulse_range, mob))
		if(isliving(target))
			var/mob/living/living_target = target
			// Being immune to resonance or a heretic prevents the application of the silence effect. We also grant the power holder immunity so they don't buzz blue constantly.
			if(living_target != mob && !living_target.can_block_resonance() && !living_target.mind?.has_antag_datum(/datum/antagonist/heretic))
				living_target.apply_status_effect(/datum/status_effect/power/reality_anchor_silenced/walking_anchor)
			living_target.dispel(power_holder, DISPEL_CASCADE_CARRIED)
		else if(isobj(target))
			target.dispel(power_holder)

// status effect subtypes
/datum/status_effect/power/reality_anchor_silenced/walking_anchor
	alert_type = /atom/movable/screen/alert/status_effect/reality_anchor_silenced/walking_anchor
	show_duration = TRUE
	duration = 4 SECONDS

/atom/movable/screen/alert/status_effect/reality_anchor_silenced/walking_anchor
	desc = "Resonant powers are being surpressed by somebody nearby..."

//visuals for the pulse. we hide these from the power holder so they dont have to see it all round, and from non-magic users to add some funny confusion
/obj/effect/temp_visual/circle_wave/reality_anchor/walking_anchor
	max_alpha = 10
	amount_to_scale = 1

/obj/effect/temp_visual/circle_wave/reality_anchor/walking_anchor/Initialize()
	. = ..()
	var/image/effect_image = image(icon = icon, loc = src, icon_state = null)
	effect_image.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/walking_anchor, "walking_anchor", effect_image)

/datum/atom_hud/alternate_appearance/basic/walking_anchor/mobShouldSee(mob/living/viewer)
	if(!isliving(viewer))
		return FALSE
	return (!viewer.has_magical_power_in_archetype(POWER_ARCHETYPE_SORCEROUS)) & (!viewer.has_magical_power_in_archetype(POWER_ARCHETYPE_RESONANT)) & (!viewer.mind?.has_antag_datum(/datum/antagonist/heretic))
