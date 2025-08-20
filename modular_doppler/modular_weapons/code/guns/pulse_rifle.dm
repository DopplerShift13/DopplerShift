// Karim Electrics pulse rifle, YIPPIE ALIENS YIPPIE!!

/obj/item/gun/ballistic/automatic/karim
	name = "\improper Karim Pulse Rifle"
	desc = "A compact rifle with high magazine capacity and fire-rate. A novel design that replaces many common firearm \
		components with electrified alternatives, allowing a much smaller size for the firepower it provides. \
		This gives the weapon it's distinctive firing sound."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "karim"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "karim"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "karim"
	special_mags = FALSE
	bolt_type = BOLT_TYPE_LOCKING
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT|ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/karim
	can_suppress = FALSE
	burst_size = 1
	fire_delay = 0.15 SECONDS
	actions_types = list()
	spread = 5
	recoil = 0.1
	pin = /obj/item/firing_pin/explorer
	/// List of the possible firing sounds
	var/list/firing_sound_list = list(
		'sound/items/weapons/gun/smartgun/smartgun_shoot_1.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_2.ogg',
		'sound/items/weapons/gun/smartgun/smartgun_shoot_3.ogg',
	)

/obj/item/gun/ballistic/automatic/karim/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/karim/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/karim/fire_sounds()
	var/picked_fire_sound = pick(firing_sound_list)
	playsound(src, picked_fire_sound, fire_sound_volume, vary_fire_sound)

/obj/item/gun/ballistic/automatic/karim/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/karim/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/karim/unrestricted/no_mag
	spawnwithmagazine = FALSE

/obj/item/storage/toolbox/guncase/modular/pulse_rifle
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/karim/no_mag
	extra_to_spawn = /obj/item/ammo_box/magazine/karim

/datum/orderable_item/accelerator/pulse_rifle
	purchase_path = /obj/item/gun/ballistic/automatic/karim/no_mag
	cost_per_order = 750

/datum/orderable_item/accelerator/pulse_ammo
	purchase_path = /obj/item/ammo_box/magazine/karim
	cost_per_order = 25
