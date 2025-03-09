// Pistol but its evil and uses miecz magazines

/obj/item/gun/ballistic/automatic/pistol/weevil
	name = "\improper Zomushi pistol"
	desc = "A rare pistol firing the CIN .27-54 cartridge out of standard Miecz magazines."
	icon = 'modular_doppler/paxilweapons_real/icons/pistol_32.dmi'
	icon_state = "zomushi"
	rack_sound = 'modular_doppler/paxilweapons_real/sound/zomushi/zomushi_rack.wav'
	fire_sound = 'modular_doppler/paxilweapons_real/sound/zomushi/zomushi.wav'
	suppressed_sound = 'modular_doppler/paxilweapons_real/sound/zomushi/zomushi_silenced.wav'
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	w_class = WEIGHT_CLASS_NORMAL
	accepted_magazine_type = /obj/item/ammo_box/magazine/miecz
	suppressor_x_offset = 7
	suppressor_y_offset = 0
	fire_delay = 0.25 SECONDS
	recoil = 0.25

/obj/item/gun/ballistic/automatic/pistol/weevil/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/pistol/weevil/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/pistol/weevil/examine_more(mob/user)
	. = ..()
	. += "An unusual competitor to the widely popular Wespe pistols, \
		firing a CIN cartridge instead of any locally produced by Solfed. \
		Taking advantage of existing technology, it uses Miecz magazines in a functional, \
		though 'interesting' solution."
	return .

/obj/item/gun/ballistic/automatic/pistol/weevil/starts_empty
	spawnwithmagazine = FALSE
