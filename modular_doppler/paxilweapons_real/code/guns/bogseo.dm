// Evil .585 smg that blueshields used to spawn with that will throw your screen like hell but itll sure kill whoever threatens a head really good

/obj/item/gun/ballistic/automatic/xhihao_smg
	name = "\improper Bogseo Submachine Gun"
	desc = "A weapon that could hardly be called a 'sub' machinegun, firing the monstrous .585 cartridge. \
		It provides enough kick to bruise a shoulder pretty bad if used without protection."
	icon = 'modular_doppler/paxilweapons_real/icons/smg_32.dmi'
	icon_state = "bogseo"
	worn_icon = 'modular_doppler/paxilweapons_real/icons/onmob/guns_worn.dmi'
	worn_icon_state = "bogseo"
	lefthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_left.dmi'
	righthand_file = 'modular_doppler/paxilweapons_real/icons/onmob/guns_inhand_right.dmi'
	inhand_icon_state = "bogseo"
	special_mags = FALSE
	bolt_type = BOLT_TYPE_STANDARD
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT
	accepted_magazine_type = /obj/item/ammo_box/magazine/c585trappiste_pistol
	fire_sound = 'modular_doppler/paxilweapons_real/sound/bogseo/smg_heavy.ogg'
	can_suppress = TRUE
	suppressor_x_offset = 9
	burst_size = 1
	fire_delay = 0.15 SECONDS
	actions_types = list()
	projectile_wound_bonus = -20
	spread = 12.5
	recoil = 1.5
	pickup_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'
	drop_sound = 'modular_doppler/paxilweapons_real/sound/pickup_sounds/drop_mediumgun.wav'

/obj/item/gun/ballistic/automatic/xhihao_smg/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/xhihao_smg/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_XHIHAO)

/obj/item/gun/ballistic/automatic/xhihao_smg/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>examine closer</b> to learn a little more about this weapon.")

/obj/item/gun/ballistic/automatic/xhihao_smg/examine_more(mob/user)
	. = ..()
	. += "The Bogseo submachinegun is seen in highly different lights based on \
		who you ask. Ask a Jovian, and they'll go off all day about how they \
		love the thing so. A big weapon for shooting big targets, like the \
		fuel-stat raiders in their large suits of armor. Ask a space pirate, however \
		and you'll get a different story. That is thanks to many SolFed anti-piracy \
		units picking the Bogseo as their standard boarding weapon. What better \
		to ruin a brigand's day than a bullet large enough to turn them into \
		mist at full auto, after all?"
	return .

/obj/item/gun/ballistic/automatic/xhihao_smg/no_mag
	spawnwithmagazine = FALSE
