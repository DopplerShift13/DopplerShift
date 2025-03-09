// SolFed shotgun (this was gonna be in a proprietary shotgun shell type outside of 12ga at some point, wild right?)

/obj/item/gun/ballistic/shotgun/riot/sol
	name = "\improper Renoster Shotgun"
	desc = "A twelve gauge shotgun with a six shell capacity underneath. \
		Made for and used by SolFed's various military branches."
	icon = 'modular_doppler/paxilweapons_real/icons/shotgun_48.dmi'
	icon_state = "renoster"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "renoster"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "renoster"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/shot/riot/sol
	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_doppler/paxilweapons_real/sound/doesnt_miss/shotgun_heavy.ogg'
	rack_sound = 'modular_doppler/paxilweapons_real/sound/doesnt_miss/shotgun_rack.ogg'
	suppressed_sound = 'modular_doppler/paxilweapons_real/sound/doesnt_miss/suppressed_heavy.ogg'
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	can_suppress = TRUE
	suppressor_x_offset = 9
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	can_be_sawn_off = FALSE
	recoil = 0.5
	/// Is the stock extended or nah
	var/stock_extended = TRUE

/obj/item/gun/ballistic/shotgun/riot/sol/Initialize(mapload)
	. = ..()
	extend_stock()

/obj/item/gun/ballistic/shotgun/riot/sol/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_CARWO)

/obj/item/gun/ballistic/shotgun/riot/sol/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>Alt-Click</b> to fiddle with the stock.")
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/shotgun/riot/sol/click_alt(mob/user)
	stock_extended = !stock_extended
	balloon_alert(user, "stock [stock_extended ? "extended" : "retracted"]")
	if(stock_extended)
		extend_stock()
	else
		retract_stock()
	playsound(src, 'sound/items/ampoule_snap.ogg', 60, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/shotgun/riot/sol/proc/extend_stock()
	spread = initial(spread)
	recoil = initial(recoil)
	w_class = initial(w_class)
	cut_overlays()
	update_appearance()
	var/image/stock_overlay = image(icon = icon, icon_state = "[icon_state]_stock")
	add_overlay(stock_overlay)

/obj/item/gun/ballistic/shotgun/riot/sol/proc/retract_stock()
	spread = 10
	recoil = 3
	w_class = WEIGHT_CLASS_NORMAL
	cut_overlays()
	update_appearance()
	var/image/stock_overlay = image(icon = icon, icon_state = "[icon_state]_stock_flat")
	add_overlay(stock_overlay)

/obj/item/gun/ballistic/shotgun/riot/sol/examine_more(mob/user)
	. = ..()
	. += "The Renoster was designed at its core as a police shotgun. \
		As consequence, it holds all the qualities a police force would want \
		in one. Large shell capacity, sturdy frame, while holding enough \
		capacity for modification to satiate even the most overfunded of \
		peacekeeper forces. Inevitably, the weapon made its way into civilian \
		markets alongside its sale to several military branches that also \
		saw value in having a heavy shotgun."
	return .

// Shotgun but EVIL!

/obj/item/gun/ballistic/shotgun/riot/sol/evil
	desc = "A twleve guage shotgun with an eight shell capacity underneath. This one is painted in a tacticool black."
	icon_state = "renoster_evil"
	worn_icon_state = "renoster_evil"
	inhand_icon_state = "renoster_evil"
