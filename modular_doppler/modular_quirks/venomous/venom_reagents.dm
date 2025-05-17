// TO MAKE: special medicine that you (RESPECTFULLY AQUIRE TIZIRIAN VENOM) to produce
/datum/reagent/toxin/tizirian
	name = "Tizirian Cytotoxin"
	description = "A toxic, though hardly fatal venom produced by some Tizirians. \
		Used historically to bring prey to toxic shock for hunting purposes."
	color = "#fff588" // rgb: 207, 54, 0
	taste_description = "coppery bitterness"
	metabolization_rate = REAGENTS_METABOLISM / 4 // Yeah this is a good plan
	taste_mult = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	toxpwr = 1.5
	liver_damage_multiplier = 0
	silent_toxin = TRUE
	health_required = -10 // Won't ever directly kill someone

/datum/reagent/toxin/tizirian/less
	name = "Tizirian Dendrotoxin"
	description = "A venom produced by some Tizirians that is hardly, if ever, fatal to the victim. \
		Instead it works to disrupt the victim's nervous system activity to incapacitate them."
	color = "#c5ff88" // rgb: 207, 54, 0
	toxpwr = 0
	health_required = -100
	metabolized_traits = list(TRAIT_ANALGESIA)

/datum/reagent/toxin/tizirian/less/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(current_cycle > 10)
		affected_mob.set_eye_blur_if_lower(6 SECONDS * REM * seconds_per_tick)
		affected_mob.adjust_confusion(1 SECONDS * REM * normalise_creation_purity() * seconds_per_tick)
	if(affected_mob.adjustStaminaLoss(2 * REM * seconds_per_tick, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH
