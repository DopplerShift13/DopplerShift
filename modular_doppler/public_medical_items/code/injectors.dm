// Pen basetype where the icon is gotten from
/obj/item/reagent_containers/hypospray/medipen/doppler
	name = "non-functional autoinjector"
	desc = "A medical autoinjector, though this one seems to be both empty and non-functional."
	icon = 'modular_doppler/public_medical_items/icons/injectors.dmi'
	icon_state = "sensory"
	volume = 20
	list_reagents = list()
	custom_price = PAYCHECK_COMMAND
	/// If this pen has a timer for injecting others with, just for safety with some of the drugs in these
	var/inject_others_time = 1.5 SECONDS

/obj/item/reagent_containers/hypospray/medipen/doppler/Initialize(mapload)
	. = ..()
	amount_per_transfer_from_this = volume

/obj/item/reagent_containers/hypospray/medipen/doppler/inject(mob/living/affected_mob, mob/user)
	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] is empty!"))
		return FALSE
	if(!iscarbon(affected_mob))
		return FALSE
	//Always log attemped injects for admins
	var/list/injected = list()
	for(var/datum/reagent/injected_reagent in reagents.reagent_list)
		injected += injected_reagent.name
	var/contained = english_list(injected)
	log_combat(user, affected_mob, "attempted to inject", src, "([contained])")
	if((affected_mob != user) && inject_others_time)
		affected_mob.visible_message(span_danger("[user] is trying to inject [affected_mob]!"), \
				span_userdanger("[user] is trying to inject something into you!"))
		if(!do_after(user, CHEM_INTERACT_DELAY(inject_others_time, user), affected_mob))
			return FALSE
	if(!reagents.total_volume)
		return FALSE
	if(!(ignore_flags || affected_mob.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE)))
		return FALSE
	to_chat(affected_mob, span_warning("You feel a tiny prick!"))
	to_chat(user, span_notice("You inject [affected_mob] with [src]."))
	if(!stealthy)
		playsound(affected_mob, 'sound/items/hypospray.ogg', 50, TRUE)
	var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
	if(affected_mob.reagents)
		var/trans = 0
		if(!infinite)
			trans = reagents.trans_to(affected_mob, amount_per_transfer_from_this, transferred_by = user, methods = INJECT)
		else
			reagents.expose(affected_mob, INJECT, fraction)
			trans = reagents.trans_to(affected_mob, amount_per_transfer_from_this, copy_only = TRUE)
		to_chat(user, span_notice("[trans] unit\s injected. [reagents.total_volume] unit\s remaining in [src]."))
		log_combat(user, affected_mob, "injected", src, "([contained])")
	return TRUE

// Filled subtypes start

/obj/item/reagent_containers/hypospray/medipen/doppler/sensory
	name = "sensory health airhypo"
	desc = "A single-use air needle filled with (practically) pure inacusiate and oculine for quick repairs to hearing and vision."
	base_icon_state = "sensory"
	icon_state = "sensory"
	list_reagents = list(
		/datum/reagent/medicine/inacusiate = 7,
		/datum/reagent/medicine/oculine = 7,
		/datum/reagent/impurity/inacusiate = 3,
		/datum/reagent/inverse/oculine = 3,
	)

/obj/item/reagent_containers/hypospray/medipen/doppler/adrenaline
	name = "adrenaline airhypo"
	desc = "A single-use adrenaline air needle, to combat toxic shock caused by mixing other chemicals such as T-WITCH and DemonEye."
	base_icon_state = "adrenaline"
	icon_state = "adrenaline"
	list_reagents = list(
		/datum/reagent/medicine/synaptizine = 5,
		/datum/reagent/medicine/inaprovaline = 5,
		/datum/reagent/determination = 10,
	)

/obj/item/reagent_containers/hypospray/medipen/doppler/regen
	name = "regenerative stimulant airhypo"
	desc = "A single-use air needle loaded with a mild anesthetic and all purpose restorative."
	base_icon_state = "regen"
	icon_state = "regen"
	list_reagents = list(
		/datum/reagent/medicine/lidocaine = 5,
		/datum/reagent/medicine/omnizine = 15,
		/datum/reagent/medicine/epinephrine = 5,
	)
	volume = 25

/obj/item/reagent_containers/hypospray/medipen/doppler/antidote
	name = "general antidote airhypo"
	desc = "A single-use air needle loaded with a general purpose poison antidote. Should not be relied on solely \
		for poison treatment. See a medical professional after use."
	base_icon_state = "antidote"
	icon_state = "antidote"
	list_reagents = list(
		/datum/reagent/medicine/c2/multiver = 10,
		/datum/reagent/medicine/potass_iodide = 10,
		/datum/reagent/toxin/lipolicide = 5,
	)
	volume = 25

/obj/item/reagent_containers/hypospray/medipen/doppler/emergency
	name = "emergency airhypo"
	desc = "A single-use air needle loaded with a mix of atropine, epinephrine, and coagulants for stabilizing critical patients."
	base_icon_state = "emergency"
	icon_state = "emergency"
	list_reagents = list(
		/datum/reagent/medicine/epinephrine = 10,
		/datum/reagent/medicine/coagulant = 5,
		/datum/reagent/medicine/atropine = 5,
	)

/obj/item/reagent_containers/hypospray/medipen/doppler/twitch
	name = "T-WITCH vial"
	desc = "An almost cartoonish looking glass injector filled with a horribly corrosive green liquid that slowly swirls around. \
		A heavily regulated substance called T-WITCH that is claimed to make the users of it 'see faster'."
	base_icon_state = "twitch"
	icon_state = "twitch"
	list_reagents = list(
		/datum/reagent/drug/twitch = 10,
		/datum/reagent/drug/maint/tar = 5,
		/datum/reagent/medicine/silibinin = 5,
		/datum/reagent/toxin/leadacetate = 5,
	)
	volume = 25

// Stuff for robots (to be remade sometime)

// Medpen for robots that fixes toxin damage and purges synth chems but slows them down for a bit
/obj/item/reagent_containers/hypospray/medipen/doppler/robot_system_cleaner
	name = "synthetic cleaner autoinjector"
	desc = "An autoinjector loaded with system cleaner for purging synthetics of reagents."
	base_icon_state = "robor"
	icon_state = "robor"
	list_reagents = list(
		/datum/reagent/medicine/system_cleaner = 15,
		/datum/reagent/dinitrogen_plasmide = 5,
	)

// Medpen for robots that fixes brain damage but slows them down for a bit
/obj/item/reagent_containers/hypospray/medipen/doppler/robot_liquid_solder
	name = "synthetic smart-solder autoinjector"
	desc = "An autoinjector loaded with liquid solder to repair synthetic processor core damage."
	base_icon_state = "robor_brain"
	icon_state = "robor_brain"
	list_reagents = list(
		/datum/reagent/medicine/liquid_solder = 15,
		/datum/reagent/dinitrogen_plasmide = 5,
	)
