// A revolver, but it can hold shotgun shells
// Woe, buckshot be upon ye

/obj/item/gun/ballistic/revolver/shotgun_revolver
	name = "\improper Bóbr 12 GA revolver"
	desc = "An outdated sidearm rarely seen in use by some members of the CIN. A revolver type design with a four shell cylinder. That's right, shell, this one shoots twelve guage."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev12ga
	recoil = SAWN_OFF_RECOIL
	weapon_weight = WEAPON_MEDIUM
	icon = 'modular_doppler/paxilweapons_real/icons/pistol_32.dmi'
	icon_state = "bobr"
	fire_sound = 'modular_doppler/paxilweapons_real/sound/revolver/revolver_heavy.ogg'
	spread = SAWN_OFF_ACC_PENALTY
	recoil = 0.5
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'

/obj/item/gun/ballistic/revolver/shotgun_revolver/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SZOT)

/obj/item/gun/ballistic/revolver/shotgun_revolver/examine_more(mob/user)
	. = ..()
	. += "The 'Bóbr' started development as a limited run sporting weapon before \
		the military took interest. The market quickly changed from sport shooting \
		targets, to sport shooting SolFed strike teams once the conflict broke out. \
		This pattern is different from the original civilian version, with a military \
		standard pistol grip and weather resistant finish. While the 'Bóbr' was not \
		a weapon standard issued to every CIN soldier, it was available for relatively \
		cheap, and thus became rather popular among the ranks."
	return .
