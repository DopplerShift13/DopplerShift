/obj/item/gun/ballistic/automatic/sol_rifle
	name = "\improper Carwo-Cawil Blaster"
	desc = "A precision Donk(tm) blaster for long range Donk(tm)ing."
	icon = 'modular_doppler/its_donk_or_dont/icons/rifle_48.dmi'
	icon_state = "cawil"
	worn_icon = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_worn.dmi'
	worn_icon_state = "cawil"
	lefthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/its_donk_or_dont/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "cawil"
	SET_BASE_PIXEL(-8, 0)
	special_mags = TRUE
	bolt_type = BOLT_TYPE_LOCKING
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/c40sol_rifle
	spawn_magazine_type = /obj/item/ammo_box/magazine/c40sol_rifle/standard
	fire_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot0.wav'
	suppressed_sound = 'modular_doppler/its_donk_or_dont/sound/sound_nailgun_shot2.wav'
	can_suppress = TRUE
	suppressor_x_offset = 0
	burst_size = 1
	fire_delay = 0.45 SECONDS
	actions_types = list()
	spread = 7.5
	pickup_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_heavygun.wav'
	drop_sound = 'modular_doppler/its_donk_or_dont/sound/pickup_sounds/drop_heavygun.wav'

/obj/item/gun/ballistic/automatic/sol_rifle/Initialize(mapload)
	. = ..()
	give_autofire()

/// Separate proc for handling auto fire just because one of these subtypes isn't otomatica
/obj/item/gun/ballistic/automatic/sol_rifle/proc/give_autofire()
	return

/obj/item/gun/ballistic/automatic/sol_rifle/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_DONK)

/obj/item/gun/ballistic/automatic/sol_rifle/no_mag
	spawnwithmagazine = FALSE

// Evil version of the rifle (nothing different it's just black)

/obj/item/gun/ballistic/automatic/sol_rifle/evil
	desc = "A precision Donk(tm) blaster for long range Donk(tm)ing. LARPers have painted this one black."
	icon_state = "cawil_evil"
	worn_icon_state = "cawil_evil"
	inhand_icon_state = "cawil_evil"
	/// Is the stock extended or nah
	var/stock_extended = TRUE

/obj/item/gun/ballistic/automatic/sol_rifle/evil/Initialize(mapload)
	. = ..()
	extend_stock()

/obj/item/gun/ballistic/automatic/sol_rifle/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>Alt-Click</b> to fiddle with the stock.")

/obj/item/gun/ballistic/automatic/sol_rifle/evil/click_alt(mob/user)
	stock_extended = !stock_extended
	balloon_alert(user, "stock [stock_extended ? "extended" : "retracted"]")
	if(stock_extended)
		extend_stock()
	else
		retract_stock()
	playsound(src, 'sound/items/ampoule_snap.ogg', 60, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/automatic/sol_rifle/evil/proc/extend_stock()
	spread = initial(spread)
	recoil = initial(recoil)
	w_class = initial(w_class)
	cut_overlays()
	update_appearance()
	var/image/stock_overlay = image(icon = icon, icon_state = "[icon_state]_stock")
	add_overlay(stock_overlay)

/obj/item/gun/ballistic/automatic/sol_rifle/evil/proc/retract_stock()
	spread = 15
	w_class = WEIGHT_CLASS_NORMAL
	cut_overlays()
	update_appearance()
	var/image/stock_overlay = image(icon = icon, icon_state = "[icon_state]_stock_flat")
	add_overlay(stock_overlay)

/obj/item/gun/ballistic/automatic/sol_rifle/evil/no_mag
	spawnwithmagazine = FALSE
