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
	unique_reskin = list(
		"Classic" = "det",
		"Modern" = "det_modern",
		"Polished" = "det_steel",
		"Polished Modern" = "det_modern_steel",
		"Signal" = "det_signal", // erm uhh
		"Gold" = "det_gold",
	)

/obj/item/ammo_box/magazine/internal/cylinder/rev6mm
	name = "detective revolver cylinder"
	ammo_type = /obj/item/ammo_casing/c6ng
	caliber = CALIBER_6MMGIBRALTAR
	max_ammo = 6
