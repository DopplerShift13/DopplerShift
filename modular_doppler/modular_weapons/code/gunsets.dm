/*
*	GUNSET BOXES
*/

/obj/item/storage/toolbox/guncase/modular
	desc = "A thick gun case with foam inserts laid out to fit a weapon, magazines, and gear securely."

	icon = 'modular_doppler/modular_weapons/icons/obj/gunsets.dmi'
	icon_state = "guncase"

	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/cases.dmi'
	worn_icon_state = "darkcase"

	slot_flags = ITEM_SLOT_BACK

	material_flags = NONE

	/// Is the case visually opened or not
	var/opened = FALSE

/obj/item/storage/toolbox/guncase/modular/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 14 // Technically means you could fit multiple large guns in here but it's a case you cant backpack anyways so what it do
	atom_storage.max_slots = 6 // We store some extra items in these so lets make a little extra room

/obj/item/storage/toolbox/guncase/modular/update_icon()
	. = ..()
	if(opened)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)

/obj/item/storage/toolbox/guncase/modular/click_alt(mob/user)
	opened = !opened
	update_icon()
	return CLICK_ACTION_SUCCESS

/obj/item/storage/toolbox/guncase/modular/attack_self(mob/user)
	. = ..()
	opened = !opened
	update_icon()

// Empty guncase

/obj/item/storage/toolbox/guncase/modular/empty

/obj/item/storage/toolbox/guncase/modular/empty/PopulateContents()
	return

// Small case for pistols and whatnot

/obj/item/storage/toolbox/guncase/modular/pistol
	name = "small gun case"

	icon_state = "guncase_s"

	slot_flags = NONE

	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/toolbox/guncase/modular/pistol/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL

// Empty pistol case

/obj/item/storage/toolbox/guncase/modular/pistol/empty

/obj/item/storage/toolbox/guncase/modular/pistol/empty/PopulateContents()
	return

// Base yellow carwo case

/obj/item/storage/toolbox/guncase/modular/carwo_large_case
	desc = "A thick yellow gun case with foam inserts laid out to fit a weapon, magazines, and gear securely."

	icon = 'modular_doppler/modular_weapons/icons/obj/gunsets.dmi'
	icon_state = "case_carwo"

	worn_icon_state = "yellowcase"

	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/cases_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/cases_righthand.dmi'
	inhand_icon_state = "yellowcase"

// Empty version of the case

/obj/item/storage/toolbox/guncase/modular/carwo_large_case/empty

/obj/item/storage/toolbox/guncase/modular/carwo_large_case/empty/PopulateContents()
	return

// A version with a weak gun and some security gear +  empties

/obj/item/storage/toolbox/guncase/modular/sportsco_large_case
	desc = "A Sportsco branded gun case with fitted inserts."
	icon_state = "sportsco"

/obj/item/storage/toolbox/guncase/modular/sportsco_small_case
	desc = "A Sportsco branded pistol-sized case with fitted inserts."
	icon_state = "sportsco_s"

/obj/item/storage/toolbox/guncase/modular/sportsco_large_case/security_gunnery_package/PopulateContents()
	new /obj/item/gun/ballistic/avispa_stingball_shooter(src)
	new /obj/item/storage/belt/security/webbing/full(src)
	new /obj/item/book/granter/tactical_gun_tosser(src)

// The support package

/obj/item/storage/toolbox/guncase/modular/sportsco_large_case/security_support_package/PopulateContents()
	new /obj/item/shield/escarabajo(src)	// dont think about how it fits
	new /obj/item/gun/ballistic/alacran(src)
	new /obj/item/storage/box/alacran_dart(src)
	new /obj/item/storage/belt/security/webbing/full(src)
