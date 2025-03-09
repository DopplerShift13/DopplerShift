// .585 super revolver

/obj/item/gun/ballistic/revolver/takbok
	name = "\improper Takbok Revolver"
	desc = "A hefty revolver with an equally large cylinder capable of holding five .585 Trappiste rounds."
	icon = 'modular_doppler/paxilweapons_real/icons/pistol_32.dmi'
	icon_state = "takbok"
	fire_sound = 'modular_doppler/paxilweapons_real/sound/revolver/revolver_heavy.ogg'
	suppressed_sound = 'modular_doppler/paxilweapons_real/sound/doesnt_miss/suppressed_heavy.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/c585trappiste
	suppressor_x_offset = 4
	can_suppress = TRUE
	fire_delay = 1 SECONDS
	recoil = 2
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'

/obj/item/gun/ballistic/revolver/takbok/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_TRAPPISTE)

/obj/item/gun/ballistic/revolver/takbok/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/revolver/takbok/examine_more(mob/user)
	. = ..()
	. += "The Takbok is a unique design for Trappiste for the sole reason that it \
		was made at first to be a one-off. Founder of partner company Carwo Defense, \
		Darmaan Khaali Carwo herself, requested a sporting revolver from Trappiste. \
		What was delivered wasn't a target revolver, it was a target crusher. The \
		weapon became popular as Carwo crushed many shooting competitions using \
		the Takbok, with the design going on several production runs up until \
		2511 when the popularity of the gun fell off. Due to the number of revolvers \
		made, they are still easy enough to find if you look despite production \
		having already ceased many years ago."
	return .
