/datum/power/cultivator_root/flame_soul
	name = "Flame Soul Alignment"
	desc = "You gain your Dantian's aura by being able to see exposed fires (bonfires, plasma fires, etc.) or if you are on fire yourself. Activating it gives you a burning hot aura, causing your punches to do 10 extra burn damage.\
	Passively, your high temprature threshold is increased by 30C regardless of species. Activating the alignment makes you completely immune to fire (but does not extinguish them).\
	You gain armor III and laser VI across your whole body. Has diminishing effects with your worn armor."
	action_path = /datum/action/cooldown/power/cultivator/alignment/flame_soul

	value = 6

// Gives innate resistance to heat.
/datum/power/cultivator_root/flame_soul/post_add()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_heat_damage_limit += 30

/datum/power/cultivator_root/flame_soul/remove()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_heat_damage_limit -= 30

/datum/action/cooldown/power/cultivator/alignment/flame_soul
	name = "Flame Soul Alignment"
	desc = "Activates your Astral-Touched Alignment aura, granting you immunity to fire, increasing your defenses (if unarmored), and increasing your strength with unarmed attacks."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "sacredflame"

	alignment_outline_color = "#e99a3f"
	alignment_activation_sound = 'sound/effects/magic/fireball.ogg'
	alignment_overlay_state = "blessed"

	alignment_damage_type = BURN
	alignment_defense = /datum/armor/alignment_flamesoul_defense

// Adds pressure immunity & cold immunity.
/datum/action/cooldown/power/cultivator/alignment/flame_soul/enable_alignment(mob/living/carbon/user)
	. = ..()
	user.add_traits(list(TRAIT_RESISTHEAT, TRAIT_NOFIRE), src)

/datum/action/cooldown/power/cultivator/alignment/flame_soul/disable_alignment(mob/living/carbon/user)
	. = ..()
	user.remove_traits(list(TRAIT_RESISTHEAT, TRAIT_NOFIRE), src)


// special laser & fire proofed armor for flamesoul.
/datum/armor/alignment_flamesoul_defense
	acid = 30
	bio = 30
	melee = 30
	bullet = 30
	bomb = 30
	energy = 30
	laser = 60
	fire = 100
	melee = 30
	wound = 30

