/datum/power/cultivator_root/astral_touched
	name = "Astral Touched Alignment"
	desc = "You gain your Dantian's aura by being able to view space (or space adjacent things), proportional to distance. Activating it gives you a radiant, blue aura causing your punches to do 10 extra burn damage.\
	Passively, your cold temprature tolerance is increased by 30C; activating the alignment makes you immune to cold and pressure, allowing you to navigate space unharmed (though you still need to breathe).\
	You gain armor IV across your whole body. Has diminishing effects with your worn armor."
	action_path = /datum/action/cooldown/power/cultivator/alignment/astral_touched

	value = 6

// Gives innate resistance to cold.
/datum/power/cultivator_root/astral_touched/post_add()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_cold_damage_limit -= 30

/datum/power/cultivator_root/astral_touched/remove()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_cold_damage_limit += 30

/datum/action/cooldown/power/cultivator/alignment/astral_touched
	name = "Astral Touched Alignment"
	desc = "Activates your Astral Touched Alignment aura, granting you immune to cold and pressure, increasing your defenses (if unarmored), and increasing your strength with unarmed attacks."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "teleport"

	alignment_outline_color = "#66c5dd"
	alignment_activation_sound = 'sound/effects/magic/cosmic_energy.ogg'
	alignment_overlay_state = "shieldsparkles"

	alignment_damage_type = BURN

// Adds pressure immunity & cold immunity.
/datum/action/cooldown/power/cultivator/alignment/astral_touched/enable_alignment(mob/living/carbon/user)
	. = ..()
	user.add_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTCOLD), src)

/datum/action/cooldown/power/cultivator/alignment/astral_touched/disable_alignment(mob/living/carbon/user)
	. = ..()
	user.remove_traits(list(TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTCOLD), src)

