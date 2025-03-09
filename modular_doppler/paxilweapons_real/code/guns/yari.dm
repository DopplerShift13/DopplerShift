// Suppressed rifles firing 12mm sub-sonics, funny

/obj/item/gun/ballistic/automatic/suppressed_rifle
	name = "\improper Yari suppressed rifle"
	desc = "A special rifle firing 12mm Chinmoku out of an integrally suppressed barrel. Uses Chinmoku magazines."
	icon = 'modular_doppler/paxilweapons_real/icons/rifle_48.dmi'
	icon_state = "yari"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "yari"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "yari"
	SET_BASE_PIXEL(-8, 0)
	special_mags = TRUE
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/c12chinmoku
	spawn_magazine_type = /obj/item/ammo_box/magazine/c12chinmoku/standard
	load_sound = 'modular_doppler/paxilweapons_real/sound/yari/yari_magin.wav'
	rack_sound = 'modular_doppler/paxilweapons_real/sound/yari/yari_rack.wav'
	fire_sound = 'modular_doppler/paxilweapons_real/sound/yari/yari.wav'
	suppressed_sound = 'modular_doppler/paxilweapons_real/sound/yari/yari.wav'
	can_suppress = TRUE
	can_unsuppress = FALSE
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	burst_size = 1
	fire_delay = 0.3 SECONDS
	actions_types = list()
	spread = 7.5
	recoil = 0.25

/obj/item/gun/ballistic/automatic/suppressed_rifle/Initialize(mapload)
	. = ..()
	var/obj/item/suppressor/new_suppressor = new(src)
	install_suppressor(new_suppressor)
	give_autofire()

/obj/item/gun/ballistic/automatic/suppressed_rifle/add_bayonet_point()
	return

/// Separate proc for handling auto fire just because one of these subtypes isn't otomatica
/obj/item/gun/ballistic/automatic/suppressed_rifle/proc/give_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/suppressed_rifle/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/suppressed_rifle/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/suppressed_rifle/examine_more(mob/user)
	. = ..()
	. += "The Yari rifles were made for special forces units that needed the power of the standard Solfed \
		rifle selection, but needed a little more nuance to their operations. These weapons sport a barrel \
		with a suppressor built in, as well as a tacticool black paint scheme to be terrible in every environment. \
		Rather than firing the baseline .40 sol long cartridges, a modified variant was created to be both \
		sub-sonic and more powerful at extremely short ranges where these operations would be taking place."
	return .

/obj/item/gun/ballistic/automatic/suppressed_rifle/starts_empty
	spawnwithmagazine = FALSE
