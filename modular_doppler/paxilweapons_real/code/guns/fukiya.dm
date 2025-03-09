// Over-under 8mm marsian super rifle

/obj/item/gun/ballistic/marsian_super_rifle
	name = "\improper Fukiya double-barrel rifle"
	desc = "A double-barrel over-under rifle of considerable length that fires the powerful 8mm Marsian cartridge."
	icon = 'modular_doppler/paxilweapons_real/icons/rifle_48.dmi'
	icon_state = "fukiya"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "fukiya"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "fukiya"
	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_doppler/paxilweapons_real/sound/osako/chokyu.wav'
	load_sound = 'modular_doppler/paxilweapons_real/sound/ramu/ramu_load.wav'
	can_suppress = FALSE
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_heavygun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_heavygun.wav'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force = 15
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/c8marsian
	can_be_sawn_off = FALSE
	semi_auto = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	can_be_sawn_off = FALSE
	internal_magazine = TRUE
	casing_ejector = FALSE
	cartridge_wording = "shell"
	tac_reloads = FALSE
	weapon_weight = WEAPON_HEAVY
	pb_knockback = 2
	recoil = 2

/obj/item/gun/ballistic/marsian_super_rifle/add_bayonet_point()
	return

/obj/item/gun/ballistic/marsian_super_rifle/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/marsian_super_rifle/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/marsian_super_rifle/examine_more(mob/user)
	. = ..()
	. += "The Fukiya is an over-under sporting rifle that saw popular use on both Mars and Jupiter. \
		This is due to the weapon's ability to hurt both heavily modded targets in the case of Mars, \
		or heavily armored targets in the case of Jupiter."
	return .

/obj/item/gun/ballistic/marsian_super_rifle/starts_empty
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/c8marsian/starts_empty
