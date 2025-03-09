/obj/item/gun/ballistic/rifle/osako
	name = "\improper Osako Bolt Rifle"
	desc = "A common weapon just about anywhere there's a need for the average person to own a rifle. \
		Sturdy enough for the frontier, and cheap enough for the average poor settler to own. \
		Fires the equally common .310 strilka round."
	icon = 'modular_doppler/paxilweapons_real/icons/rifle_48.dmi'
	icon_state = "osako"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "osako"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "osako"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_doppler/paxilweapons_real/sound/osako/chokyu.wav'
	rack_sound = 'modular_doppler/paxilweapons_real/sound/osako/chokyu_boltout.wav'
	bolt_drop_sound = 'modular_doppler/paxilweapons_real/sound/osako/chokyu_boltin.wav'
	recoil = 1
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction
	internal_magazine = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	can_suppress = FALSE
	can_unsuppress = FALSE

/obj/item/gun/ballistic/rifle/osako/add_bayonet_point()
	return

/obj/item/gun/ballistic/rifle/osako/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/rifle/osako/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/rifle/osako/examine_more(mob/user)
	. = ..()
	. += "The Osako originates from the earliest days of Marsian colonization. As humanity began to get settled on \
		the red planet, the distance from Earth in those days created a lack of law enforcement and thus a rise in crime. \
		Frontier colonies would be raided by other startups less successful, and the common settler had little to defend \
		themselves with. This led to the creation of the Osako rifle, a weapon that could be produced using the limited \
		mars-made resources available in the non-specialised machines present. The design is reliable and effective, and \
		the ammunition can be produced with relatively common resources, making it a favorite pick even to this day."
	return .

/obj/item/gun/ballistic/rifle/osako/scoped
	desc = "A common weapon just about anywhere there's a need for the average person to own a rifle. \
		Sturdy enough for the frontier, and cheap enough for the average poor settler to own. \
		Fires the equally common .310 strilka round. This one has a scope on it."
	icon_state = "osako_scoped"

/obj/item/gun/ballistic/rifle/osako/scoped/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)
