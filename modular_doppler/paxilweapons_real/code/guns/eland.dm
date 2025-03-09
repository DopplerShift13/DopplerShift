// .35 Sol mini revolver

/obj/item/gun/ballistic/revolver/sol
	name = "\improper Eland Revolver"
	desc = "A small revolver with a comically short barrel and cylinder space for eight .35 Sol Short rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/pistol_32.dmi'
	icon_state = "eland"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/c35sol
	suppressor_x_offset = -1
	w_class = WEIGHT_CLASS_SMALL
	can_suppress = TRUE
	recoil = 0.25
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'

/obj/item/gun/ballistic/revolver/sol/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_TRAPPISTE)

/obj/item/gun/ballistic/revolver/sol/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/revolver/sol/examine_more(mob/user)
	. = ..()
	. += "The Eland is one of the few Trappiste weapons not made for military contract. \
		Instead, the Eland started life as a police weapon, offered as a gun to finally \
		outmatch all others in the cheap police weapons market. Unfortunately, this \
		coincided with nearly every SolFed police force realising they are actually \
		comically overfunded. With military weapons bought for police forces taking \
		over the market, the Eland instead found home in the civilian personal defense \
		market. That is likely the reason you are looking at this one now."
	return .
