/obj/item/gun/ballistic/revolver/c38/detective
	name = "\improper Javiro detective special"
	desc = "A modern revolver that comes in a wide variety of variations depending on the owner's taste. \
		There are rumors you can turn your gun into a quick way to blow your hand off with a wrench and \
		little will to live."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "det"
	base_icon_state = "det"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/rev6mm
	initial_caliber = CALIBER_6MMGIBRALTAR
	initial_fire_sound = 'modular_doppler/modular_weapons/sounds/pistol_heavy.ogg'

/obj/item/gun/ballistic/revolver/c38/detective/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/javiro)

/datum/atom_skin/javiro
	abstract_type = /datum/atom_skin/javiro

/datum/atom_skin/javiro/classic
	preview_name = "Classic"
	new_icon_state = "det"

/datum/atom_skin/javiro/modern
	preview_name = "Modern"
	new_icon_state = "det_modern"

/datum/atom_skin/javiro/steel
	preview_name = "Polished"
	new_icon_state = "det_steel"

/datum/atom_skin/javiro/modern_steel
	preview_name = "Polished Modern"
	new_icon_state = "det_modern_steel"

/datum/atom_skin/javiro/signal
	preview_name = "Signal"
	new_icon_state = "det_signal"

/datum/atom_skin/javiro/gold
	preview_name = "Gold"
	new_icon_state = "det_gold"

/obj/item/ammo_box/magazine/internal/cylinder/rev6mm
	name = "detective revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c6ng
	caliber = CALIBER_6MMGIBRALTAR
	max_ammo = 6
