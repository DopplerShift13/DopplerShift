// Slight RPG resprite

/obj/item/gun/ballistic/rocketlauncher
	icon = 'modular_doppler/paxilweapons_real/icons/special_48.dmi'
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'

/obj/item/ammo_casing/rocket
	icon = 'modular_doppler/paxilweapons_real/icons/casings.dmi'
	icon_state = "rocket"

/obj/item/ammo_casing/rocket/heap
	icon_state = "super_rocket"

/obj/item/ammo_casing/rocket/weak
	icon_state = "low_rocket"

// Variants of stuff 4 lethal

/obj/item/gun/ballistic/rocketlauncher/unrestricted/filtre_anti_mech
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rocketlauncher/super_rocket

/obj/item/storage/toolbox/guncase/doppla/filtre_rocket_launcher
	weapon_to_spawn = /obj/item/gun/ballistic/rocketlauncher/unrestricted/filtre_weak_rocket
	extra_to_spawn = /obj/item/ammo_casing/rocket/weak

/obj/item/gun/ballistic/rocketlauncher/unrestricted/filtre_weak_rocket
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/rocketlauncher/super_rocket

/obj/item/ammo_box/magazine/internal/rocketlauncher/super_rocket
	ammo_type = /obj/item/ammo_casing/rocket/heap

/obj/item/ammo_box/magazine/internal/rocketlauncher/weak_rocket
	ammo_type = /obj/item/ammo_casing/rocket/weak
