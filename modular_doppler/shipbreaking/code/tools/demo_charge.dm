GLOBAL_LIST_EMPTY(demolition_charges)

/obj/item/demo_charge_detonator
	name = "demolition vac-charge clacker"
	desc = "A big scary remote controller that makes a satisfying click when the lever on the side is pressed. \
		As a safety measure, the remote needs to be used multiple times in order to detonate any charges."
	icon = 'modular_doppler/shipbreaking/icons/tools.dmi'
	icon_state = "detonator"
	inhand_icon_state = "signaler"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/demo_charge_detonator/attack_self(mob/user)
	user.balloon_alert_to_viewers("clack")
	playsound(src, 'sound/items/pen_click.ogg', 40, TRUE)
	for(var/obj/item/grenade/c4/demo_charge/charge as anything in GLOB.demolition_charges)
		charge.clack()

/obj/item/grenade/c4/demo_charge
	name = "low-pyrotechnic shaped demolition vac-charge"
	desc = "A special demolition charge for the rapid deconstruction of salvaged ships. Uses a special process to make use of minimal explosive mass \
		vaporizing a precision formed strip of material, which then reflects off of the sturdy casing of the explosive to direct the full force into \
		whatever surface the charge is attached to. Involves minimal risk to any operators standing near the charge."
	icon = 'modular_doppler/shipbreaking/icons/tools.dmi'
	icon_state = "charge0"
	inhand_icon_state = "ninja-explosive"
	worn_icon_state = null
	lefthand_file = 'icons/mob/inhands/weapons/bombs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/bombs_righthand.dmi'
	directional = TRUE
	directional_arc = 90
	boom_sizes = list(0, 3, 5)
	full_damage_on_mobs = FALSE
	/// How many times the detonator has pulsed on this demo charge
	var/clacks = 0
	/// How many times the detonator needs to be pulsed to detonate the charge
	var/clacks_needed = 2

/obj/item/grenade/c4/demo_charge/Initialize(mapload)
	. = ..()
	if(prob(20))
		clacks_needed += rand(1, 3)

/// Decides on random effects to play when the detonator has been clicked but nothing happens yet
/obj/item/grenade/c4/demo_charge/proc/clack()
	clacks++
	if(prob(25))
		do_sparks(3, FALSE, target)
	if(clacks < clacks_needed)
		return
	if(obj_flags & EMAGGED)
		detonate()
		return
	if(istype(get_area(target), /area/shuttle/salvaged_shuttle))
		detonate()
		return

/obj/item/grenade/c4/demo_charge/Destroy()
	if(src in GLOB.demolition_charges)
		GLOB.demolition_charges -= src
	return ..()

/obj/item/grenade/c4/demo_charge/attack_self(mob/user)
	return

/obj/item/grenade/c4/demo_charge/plant_c4(atom/bomb_target, mob/living/user)
	if(!(obj_flags & EMAGGED))
		if(isliving(bomb_target))
			to_chat(user, span_warning("The demolition charge refuses to latch onto something living!"))
			return FALSE
		var/area/target_area = get_area(bomb_target)
		if(!istype(target_area, /area/shuttle/salvaged_shuttle))
			to_chat(user, span_warning("The charge refuses to latch onto anything other than inactive salvage shuttles!"))
			return FALSE
	if(bomb_target != user && HAS_TRAIT(user, TRAIT_PACIFISM) && isliving(bomb_target))
		to_chat(user, span_warning("You don't want to harm other living beings!"))
		return FALSE
	balloon_alert(user, "planting...")
	if(!do_after(user, 3 SECONDS, target = bomb_target))
		return FALSE
	if(!user.temporarilyRemoveItemFromInventory(src))
		return FALSE
	target = bomb_target
	active = TRUE

	if(obj_flags & EMAGGED)
		message_admins("[ADMIN_LOOKUPFLW(user)] planted a hacked demolition charge on [target.name] at [ADMIN_VERBOSEJMP(target)]")
		var/icon/target_icon = icon(bomb_target.icon, bomb_target.icon_state)
		target_icon.Blend(icon(icon, icon_state), ICON_OVERLAY)
		var/mutable_appearance/bomb_target_image = mutable_appearance(target_icon)
		notify_ghosts(
			"[user.real_name] has planted a hacked demolition charge on [target]!",
			source = bomb_target,
			header = "Explosive Planted",
			alert_overlay = bomb_target_image,
			notify_flags = NOTIFY_CATEGORY_NOFLASH,
		)
	user.log_message("planted [name] on [target.name].", LOG_ATTACK)

	moveToNullspace()
	if(isitem(bomb_target)) //your crappy throwing star can't fly so good with a giant brick of c4 on it.
		var/obj/item/thrown_weapon = bomb_target
		thrown_weapon.throw_speed = max(1, (thrown_weapon.throw_speed - 3))
		thrown_weapon.throw_range = max(1, (thrown_weapon.throw_range - 3))
		thrown_weapon.get_embed()?.embed_chance = 0
	else if(isliving(bomb_target))
		plastic_overlay.layer = FLOAT_LAYER
	target.add_overlay(plastic_overlay)
	to_chat(user, span_notice("You plant the charge, red light on the shell blinking ominously."))
	GLOB.demolition_charges += src
	return TRUE
