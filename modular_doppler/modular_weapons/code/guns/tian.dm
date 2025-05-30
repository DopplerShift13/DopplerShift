/obj/item/gun/ballistic/marsian_super_rifle
	name = "\improper Tian-Diyu double-rifle"
	desc = "A double-barrel over-under rifle of considerable length that fires the powerful .585 naraka cartridge. \
		Earns it's namesake through the ability to send you to one of those two places after a single shot."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns48x.dmi'
	icon_state = "tian"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "tian"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "tian"
	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_doppler/modular_weapons/sounds/tian.wav'
	load_sound = 'modular_doppler/modular_weapons/sounds/ramu_load.wav'
	can_suppress = FALSE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force = 15 // bonk
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/c585naraka
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
	fire_delay = 0.3 SECONDS

/obj/item/gun/ballistic/marsian_super_rifle/add_bayonet_point()
	return

/obj/item/ammo_box/magazine/internal/c585naraka
	name = ".585 naraka over-under tubes"
	ammo_type = /obj/item/ammo_casing/c585naraka
	caliber = CALIBER_585NARAKA
	max_ammo = 2
	multiload = FALSE
