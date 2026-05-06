#define TESH_STOMACH_HEAVY_METAL_PURGE_RATE 0.2 // per second

/obj/item/organ/ears/teshari
	name = "teshari ears"
	desc = "A set of four long rabbit-like ears, a Teshari's main tool while hunting. Naturally extremely sensitive to loud sounds."
	damage_multiplier = 1.5
	actions_types = list(/datum/action/cooldown/teshari_hearing)
	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/teshari

/obj/item/organ/ears/teshari/on_mob_remove(mob/living/carbon/ear_owner)
	. = ..()
	REMOVE_TRAIT(ear_owner, TRAIT_GOOD_HEARING, ORGAN_TRAIT)

/datum/action/cooldown/teshari_hearing
	name = "Toggle Sensitive Hearing"
	desc = "Perk up your ears to listen for quiet sounds, useful for picking up whispering."
	button_icon = 'modular_doppler/modular_species/species_types/teshari/icons/abilities/actions.dmi'
	button_icon_state = "echolocation_off"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"

	cooldown_time = 1 SECONDS

/datum/action/cooldown/teshari_hearing/proc/update_button_state(new_state) //This makes it so that the button icon changes dynamically based on ears being up or not.
	button_icon_state = new_state
	owner.update_action_buttons()

/datum/action/cooldown/teshari_hearing/Remove(mob/living/remove_from)
	REMOVE_TRAIT(remove_from, TRAIT_GOOD_HEARING, ORGAN_TRAIT)
	remove_from.update_sight()
	return ..()

/datum/action/cooldown/teshari_hearing/Activate(atom/target)
	. = ..()

	var/mob/living/living_target = target
	if (!istype(living_target))
		return

	if(HAS_TRAIT(living_target, TRAIT_GOOD_HEARING))
		teshari_hearing_deactivate(living_target)
		return

	living_target.apply_status_effect(/datum/status_effect/teshari_hearing)
	living_target.visible_message(span_notice("[living_target], pricks up [living_target.p_their()] four ears, each twitching intently!"), span_notice("You perk up all four of your ears, hunting for even the quietest sounds."))
	update_button_state("echolocation_on")

	var/obj/item/organ/ears/ears = living_target.get_organ_slot(ORGAN_SLOT_EARS)
	if(ears)
		ears.damage_multiplier = 3

/datum/action/cooldown/teshari_hearing/proc/teshari_hearing_deactivate(mob/living/carbon/human/user) //Called when you activate it again after casting the ability-- turning them off, so to say.
	if(!HAS_TRAIT_FROM(user, TRAIT_GOOD_HEARING, ORGAN_TRAIT))
		return

	user.remove_status_effect(/datum/status_effect/teshari_hearing)
	user.visible_message(span_notice("[user] drops [user.p_their()] ears down a bit, no longer listening as closely."), span_notice("You drop your ears down, no longer paying close attention."))
	update_button_state("echolocation_off")

	var/obj/item/organ/ears/ears = user.get_organ_slot(ORGAN_SLOT_EARS)
	if(ears)
		ears.damage_multiplier = 1.5

/datum/status_effect/teshari_hearing
	id = "teshari_hearing"
	alert_type = null
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/teshari_hearing/on_apply()
	ADD_TRAIT(owner, TRAIT_GOOD_HEARING, ORGAN_TRAIT)
	return ..()

/datum/status_effect/teshari_hearing/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GOOD_HEARING, ORGAN_TRAIT)
	return ..()

/datum/status_effect/teshari_hearing/get_examine_text()
	return span_notice("[owner.p_They()] [owner.p_have()] [owner.p_their()] ears perked up, listening closely to whisper-quiet sounds.")

/datum/bodypart_overlay/mutant/ears/teshari
	feature_key = FEATURE_EARS_TESHARI

/obj/item/organ/tail/teshari
	name = "teshari tail"
	desc = "A long, sinuous tail typically found in teshari. Whoever lost it probably isn't very pleased."
	dna_block = null
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/teshari

/datum/bodypart_overlay/mutant/tail/teshari
	feature_key = FEATURE_TAIL_TESHARI

/obj/item/organ/stomach/teshari
	name = "teshari stomach"
	desc = "A scavenger bird's stomach, well-suited for digestion of carrion and purging of heavy metals. Ill-suited for most other tasks."
	organ_traits = list(TRAIT_STRONG_STOMACH)
	metabolism_efficiency = 0.04
	/// If a reagent in this list is in our stomach, we rapidly purge it.
	var/static/list/purgable_heavy_metals = list(/datum/reagent/mercury, /datum/reagent/lead)

/obj/item/organ/stomach/teshari/on_life(seconds_per_tick, times_fired)
	if (!(organ_flags & ORGAN_FAILING))
		for (var/datum/reagent/bit as anything in reagents?.reagent_list)
			if (bit.metabolization_rate <= 0)
				continue

			for (var/purgable_type as anything in purgable_heavy_metals)
				if (istype(bit, purgable_type))
					reagents.remove_reagent(bit.type, TESH_STOMACH_HEAVY_METAL_PURGE_RATE * seconds_per_tick)
					break

	return ..()

#undef TESH_STOMACH_HEAVY_METAL_PURGE_RATE
