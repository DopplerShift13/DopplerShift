/obj/item/inhaler/disposable
	name = "broken disposable inhaler"
	desc = "A small device capable of administering short bursts of aerosolized chemicals. Cannot be \
		refilled and must be either disposed of or recycled after use."
	icon = 'modular_doppler/public_medical_items/icons/inhaler.dmi'
	icon_state = "generic"
	canister_underlay_y_offset = 0

/obj/item/inhaler/disposable/handle_deconstruct(disassembled)
	QDEL_NULL(canister)
	return ..()

/obj/item/inhaler/disposable/try_remove_canister(mob/living/user, modifiers)
	return FALSE

/obj/item/inhaler/disposable/try_insert_canister(obj/item/reagent_containers/inhaler_canister/new_canister, mob/living/user, params)
	return FALSE

/obj/item/inhaler/disposable/update_canister_underlay()
	return

/obj/item/reagent_containers/inhaler_canister/disposable
	name = "disposable inhaler canister"
	desc = "A small canister filled with aerosolized reagents for use in an equally disposable inhaler."
	icon = 'modular_doppler/public_medical_items/icons/inhaler.dmi'
	icon_state = "canister"
	initial_reagent_flags = SEALED_CONTAINER | NO_SPLASH
	puff_sound = 'modular_doppler/public_medical_items/sound/inhaler_puff.ogg'
	self_administer_delay = 0.5 SECONDS
	amount_per_transfer_from_this = 0 // Change from zero if you want to manually set puff size, otherwise it will be the entire canister

/obj/item/reagent_containers/inhaler_canister/disposable/Initialize(mapload, vol)
	. = ..()
	if(amount_per_transfer_from_this == 0)
		amount_per_transfer_from_this = volume

// The actual canisters

/obj/item/reagent_containers/inhaler_canister/disposable/aslanane
	name = "aslanane canister"
	icon_state = "aslanane_canister"
	list_reagents = list(/datum/reagent/medicine/aslanane = 20)
	amount_per_transfer_from_this = 5
	volume = 20

/obj/item/inhaler/disposable/aslanane
	name = "disposable anesthetic inhaler"
	desc = "Four doses of synthetic aslanane condensed into a handy disposable inhaler format."
	icon_state = "aslanane"
	initial_casister_path = /obj/item/reagent_containers/inhaler_canister/disposable/aslanane

/obj/item/reagent_containers/inhaler_canister/disposable/asthma
	name = "albuterol canister"
	icon_state = "albuterol_canister"
	list_reagents = list(/datum/reagent/medicine/albuterol = 10)
	amount_per_transfer_from_this = 5
	volume = 10

/obj/item/inhaler/disposable/asthma
	name = "disposable albuterol inhaler"
	desc = "A two-puff inhaler of albuterol made primarily for asthmatics that forgot their normal one at home, or are in desperate \
		need of a replacement that can't wait."
	icon_state = "albuterol"
	initial_casister_path = /obj/item/reagent_containers/inhaler_canister/disposable/asthma

/obj/item/reagent_containers/inhaler_canister/disposable/demoneye
	name = "demoneye canister"
	icon_state = "demoneye_canister"
	list_reagents = list(
		/datum/reagent/drug/demoneye = 10,
		/datum/reagent/drug/maint/sludge = 10,
	)
	volume = 20

/obj/item/inhaler/disposable/demoneye
	name = "single-use DemonEye inhaler"
	desc = "A single puff of DemonEye to ruin everyone's day, including yours."
	icon_state = "demoneye"
	initial_casister_path = /obj/item/reagent_containers/inhaler_canister/disposable/demoneye

/obj/item/reagent_containers/inhaler_canister/disposable/protozene
	name = "protozene canister"
	icon_state = "protozene_canister"
	list_reagents = list(
		/datum/reagent/medicine/omnizine/protozine = 20,
		/datum/reagent/drug/kronkaine = 5,
	)
	volume = 25

/obj/item/inhaler/disposable/protozene
	name = "single-use protozene inhaler"
	desc = "A single puff of protozene and other stimulants. Made for recovery from heavy augmentation operations, but \
		you're just going to use it to get high, aren't you?"
	icon_state = "protozene"
	initial_casister_path = /obj/item/reagent_containers/inhaler_canister/disposable/protozene

/obj/item/reagent_containers/inhaler_canister/disposable/soberup
	name = "sober-up canister"
	icon_state = "soberup_canister"
	list_reagents = list(
		/datum/reagent/medicine/antihol = 10,
		/datum/reagent/medicine/higadrite = 5,
		/datum/reagent/medicine/silibinin = 5,
	)
	volume = 20

/obj/item/inhaler/disposable/soberup
	name = "single-use sober-up inhaler"
	desc = "A single puff of every alcoholic's worst nightmare, and martian's best friend. Quickly reverses the effects of intoxication due to alcohol."
	icon_state = "soberup"
	initial_casister_path = /obj/item/reagent_containers/inhaler_canister/disposable/soberup
