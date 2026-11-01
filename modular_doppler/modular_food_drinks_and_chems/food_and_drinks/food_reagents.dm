/datum/reagent/consumable/sour_sugar
	name = "sour sugar"
	description = "A mixture of sugar and citric acid."
	color = COLOR_WHITE
	taste_mult = 1.5
	nutriment_factor = 2
	metabolization_rate = 5 * REAGENTS_METABOLISM
	taste_description = "sour sweetness"
	default_container = /obj/item/reagent_containers/cup/bottle

// burns ur tongue when u eat it
/datum/reagent/consumable/sour_sugar/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	var/need_mob_update
	if(SPT_PROB(50, seconds_per_tick))
		affected_mob.adjustOrganLoss(ORGAN_SLOT_TONGUE, 1, 50, affected_biotype)
		need_mob_update = TRUE
		to_chat(affected_mob, span_notice("Your tongue hurts."))
	if(need_mob_update)
		return UPDATE_MOB_HEALTH
