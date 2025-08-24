
/*
*	A gun that shoots stingballs, intended to be a doppler-flavored replacement for the tgstation disabler
*/

#define LOW_PRESSURE 1
#define MID_PRESSURE 2
#define HIGH_PRESSURE 3
#define TANK_INSERTING 0
#define TANK_REMOVING 1

/obj/item/gun/ballistic/avispa_stingball_shooter
	name = "\improper Avispa stingball launcher"
	desc = "Oriented glass strand polymers in hivis yellow and blackened pneumatic tubing. The strange and uncomfortable stock \
	was designed for legalistic concerns over ergonomics. A label on the side admonishes the use of third party ammunition and \
	recommends against aiming for a target's eyes."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "avispa"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "avispa"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "avispa"
	fire_sound = 'sound/items/weapons/peashoot.ogg'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force = 10
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/avispa_stingball_shooter
	bolt_type = BOLT_TYPE_OPEN
	casing_ejector = FALSE
	show_bolt_icon = FALSE
	internal_magazine = TRUE
	tac_reloads = FALSE
	burst_size = 2
	var/obj/item/tank/internals/tank = null //works like the powerfist
	var/pressure_setting = LOW_PRESSURE
	var/gas_per_shot = 3

/obj/item/gun/ballistic/avispa_stingball_shooter/proc/pressure_setting_to_text(pressure_setting)
	switch(pressure_setting)
		if(LOW_PRESSURE)
			return "low"
		if(MID_PRESSURE)
			return "medium"
		if(HIGH_PRESSURE)
			return "high"
		else
			CRASH("Invalid pressure setting: [pressure_setting]!")

/obj/item/gun/ballistic/avispa_stingball_shooter/examine(mob/user)
	. = ..()
	if(!in_range(user, src))
		. += span_notice("You'll need to get closer to see any more.")
		return
	if(tank)
		. += span_notice("[icon2html(tank, user)] It has \a [tank] mounted onto it. It could be removed with <b>Alt-Click</b>.")

	. += span_notice("Use a <b>wrench</b> to change the valve strength. Current strength is at <b>[pressure_setting_to_text(pressure_setting)]</b> level.")

/obj/item/gun/ballistic/avispa_stingball_shooter/click_alt(mob/user) //we won't be using a silencer so we let people unscrew tanks with this one
	if(!tank)
		balloon_alert(user, "no tank present")
		return
	update_tank(tank, TANK_REMOVING, user)
	return TRUE

/obj/item/gun/ballistic/avispa_stingball_shooter/attackby(obj/item/item_to_insert, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(item_to_insert, /obj/item/tank/internals))
		return ..()
	if(tank)
		to_chat(user, span_notice("A tank is already present, remove it with <b>Alt-Click</b> first."))
		return
	var/obj/item/tank/internals/tank_to_insert = item_to_insert
	if(tank_to_insert.volume >= 7)	// emergency and double emergency tanks only
		to_chat(user, span_warning("\The [tank_to_insert] is too large for \the [src]."))
		return
	update_tank(item_to_insert, TANK_INSERTING, user)

/obj/item/gun/ballistic/avispa_stingball_shooter/proc/update_tank(obj/item/tank/internals/the_tank, removing = TANK_INSERTING, mob/living/carbon/human/user)
	if(removing)
		if(!tank)
			to_chat(user, span_notice("\The [src] currently has no tank attached to it."))
			return
		to_chat(user, span_notice("You detach \the [the_tank] from \the [src]."))
		tank.forceMove(get_turf(user))
		user.put_in_hands(tank)
		tank = null
		return

	if(tank)
		to_chat(user, span_warning("\The [src] already has a tank."))
		return
	if(!user.transferItemToLoc(the_tank, src))
		return
	to_chat(user, span_notice("You hook \the [the_tank] up to \the [src]."))
	tank = the_tank

/obj/item/gun/ballistic/avispa_stingball_shooter/fire_gun(atom/target, mob/living/user, flag, params)
	. = ..()
	if(!tank)
		to_chat(user, span_warning("\The [src] can't operate without a source of gas!"))
		return
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return

	var/datum/gas_mixture/gas_used = tank.remove_air(gas_per_shot * pressure_setting)
	if(!gas_used)
		to_chat(user, span_warning("\The [src]'s tank is empty!"))
		return

	if(!molar_cmp_equals(gas_used.total_moles(), gas_per_shot * pressure_setting))
		our_turf.assume_air(gas_used)
		to_chat(user, span_warning("\The [src]'s pneumatics fail, it needs more gas!"))
		playsound(src, dry_fire_sound, 30, TRUE)
		target.visible_message(span_danger("[user]'s launcher pneumatics fail!"))
		return

	our_turf.assume_air(gas_used)

/obj/item/ammo_box/magazine/internal/avispa_stingball_shooter
	name = "stingball hopper"
	ammo_type = /obj/item/ammo_casing/
	caliber = CALIBER_STINGBALL
	max_ammo = 38

#undef LOW_PRESSURE
#undef MID_PRESSURE
#undef HIGH_PRESSURE
#undef TANK_INSERTING
#undef TANK_REMOVING
