// What if the sindano fired CIN ammo?

/obj/item/gun/ballistic/automatic/seiba_smg
	name = "\improper Seiba submachine gun"
	desc = "A compact submachinegun firing .27-54 cartridges out of Miecz magazines."
	icon = 'modular_doppler/paxilweapons_real/icons/smg_48.dmi'
	icon_state = "seiba"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "seiba"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "seiba"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	slot_flags = ITEM_SLOT_BELT
	accepted_magazine_type = /obj/item/ammo_box/magazine/miecz
	load_sound = 'modular_doppler/paxilweapons_real/sound/seiba/seiba_magin.wav'
	rack_sound = 'modular_doppler/paxilweapons_real/sound/seiba/seiba_rack.wav'
	fire_sound = 'modular_doppler/paxilweapons_real/sound/seiba/seiba.wav'
	suppressed_sound = 'modular_doppler/paxilweapons_real/sound/seiba/seiba_silenced.wav'
	can_suppress = TRUE
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_lightgun.wav'
	suppressor_x_offset = 6
	burst_size = 3
	fire_delay = 0.18 SECONDS
	spread = 7.5
	recoil = 0.25
	/// Is the stock extended or nah
	var/stock_extended = TRUE

/obj/item/gun/ballistic/automatic/seiba_smg/Initialize(mapload)
	. = ..()
	extend_stock()

/obj/item/gun/ballistic/automatic/seiba_smg/add_bayonet_point()
	return

/obj/item/gun/ballistic/automatic/seiba_smg/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_CARWO)

/obj/item/gun/ballistic/automatic/seiba_smg/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")
	. += span_notice("You can <b>Alt-Click</b> to fiddle with the stock.")

/obj/item/gun/ballistic/automatic/seiba_smg/click_alt(mob/user)
	stock_extended = !stock_extended
	balloon_alert(user, "stock [stock_extended ? "extended" : "retracted"]")
	if(stock_extended)
		extend_stock()
	else
		retract_stock()
	playsound(src, 'sound/items/ampoule_snap.ogg', 60, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/automatic/seiba_smg/proc/extend_stock()
	spread = initial(spread)
	recoil = initial(recoil)
	w_class = initial(w_class)
	cut_overlays()
	update_appearance()
	var/image/stock_overlay = image(icon = icon, icon_state = "[icon_state]_stock")
	add_overlay(stock_overlay)

/obj/item/gun/ballistic/automatic/seiba_smg/proc/retract_stock()
	spread = 15
	recoil = 1.5
	w_class = WEIGHT_CLASS_NORMAL
	cut_overlays()
	update_appearance()
	var/image/stock_overlay = image(icon = icon, icon_state = "[icon_state]_stock_flat")
	add_overlay(stock_overlay)

/obj/item/gun/ballistic/automatic/seiba_smg/examine_more(mob/user)
	. = ..()
	. += "Another unusual competitor to a local sol design, the Seiba was made as an alternative to the venerable Sindano. \
		Much like it's .27-54 firing pistol counterpart, the Seiba uses Miecz magazines in the role of a submachinegun this time. \
		Similarly to the Sindano, it sports a three round burst fire, though it manages slightly faster firing speeds to the sindano \
		thanks to the specs of the .27-54 cartridge."
	return .

/obj/item/gun/ballistic/automatic/seiba_smg/starts_empty
	spawnwithmagazine = FALSE
