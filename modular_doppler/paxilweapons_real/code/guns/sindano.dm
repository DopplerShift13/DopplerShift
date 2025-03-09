// Base Sol SMG

/obj/item/gun/ballistic/automatic/sol_smg
	name = "\improper Sindano Submachine Gun"
	desc = "A small submachine gun firing .35 Sol. Commonly seen in the hands of PMCs \
		and other unsavory corpos. Accepts any standard Sol pistol magazine."
	icon = 'modular_doppler/paxilweapons_real/icons/smg_32.dmi'
	icon_state = "sindano"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "sindano"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "sindano"
	special_mags = TRUE
	bolt_type = BOLT_TYPE_OPEN
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	slot_flags = ITEM_SLOT_BELT
	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	spawn_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol/stendo
	fire_sound = 'modular_doppler/paxilweapons_real/sound/sindano/smg_light.ogg'
	can_suppress = TRUE
	suppressor_x_offset = 7
	burst_size = 3
	fire_delay = 0.2 SECONDS
	spread = 7.5
	recoil = 0.25
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'

/obj/item/gun/ballistic/automatic/sol_smg/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_CARWO)

/obj/item/gun/ballistic/automatic/sol_smg/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/sol_smg/examine_more(mob/user)
	. = ..()
	. += "The Sindano submachinegun was originally produced for military contract. \
		These guns were seen in the hands of anyone from medics, ship techs, logistics officers, \
		and shuttle pilots often had several just to show off. Due to SolFed's quest to \
		extend the lifespans of their logistics officers and quartermasters, the weapon \
		uses the same standard pistol cartridge that most other miltiary weapons of \
		small caliber use. This results in interchangeable magazines between pistols \
		and submachineguns, neat!"
	return .

/obj/item/gun/ballistic/automatic/sol_smg/no_mag
	spawnwithmagazine = FALSE
