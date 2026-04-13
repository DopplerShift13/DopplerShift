	#define BRAIN_TUMOR_DAMAGE_COEFF 0.066

	//The Original TG value would be 0.2
	// A doppler round lasts about triple that of a TG round.

/datum/quirk/item_quirk/brainproblems/add_unique(client/client_source)
	if(isandroid(quirk_holder))
		give_item_to_holder(
			/obj/item/storage/pill_bottle/liquid_solder/braintumor,
			list(
				LOCATION_LPOCKET,
				LOCATION_RPOCKET,
				LOCATION_BACKPACK,
				LOCATION_HANDS,
			),
			flavour_text = "These will keep you alive until you can secure a supply of medication. Don't rely on them too much!",
			notify_player = TRUE,
		)
	else
		give_item_to_holder(
			/obj/item/storage/pill_bottle/mannitol/braintumor,
			list(
				LOCATION_LPOCKET,
				LOCATION_RPOCKET,
				LOCATION_BACKPACK,
				LOCATION_HANDS,
			),
			flavour_text = "These will keep you alive until you can secure a supply of medication. Don't rely on them too much!",
			notify_player = TRUE,
		)

/datum/quirk/item_quirk/brainproblems/process(seconds_per_tick)
	quirk_holder.adjustOrganLoss(ORGAN_SLOT_BRAIN, BRAIN_TUMOR_DAMAGE_COEFF * seconds_per_tick)

#undef BRAIN_TUMOR_DAMAGE_COEFF
