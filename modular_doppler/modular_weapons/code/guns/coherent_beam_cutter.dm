// the Handheld Coherent Beam Cutter is a laser weapon that shoots a constant beam that can easily cut right through walls, doors, and most other structures

// this is the amount of charge used per heat unit when welding with the cutter
#define BEAM_CUTTER_CHARGE_WELD (0.050 * STANDARD_CELL_CHARGE)

/obj/item/gun/energy/coherent_beam_cutter
	name = "\improper Handheld Coherent Beam Cutter"
	desc = "A compact, stockless energy weapon with a peculiar set of rotating coils surrounding the barrel and\
		a completely separate handguard to keep your palms away from any moving parts. Cutters like these are used \
		in many industrial applications like shipbreaking, but work just as well as weapons or breaching tools."
	icon = 'modular_doppler/modular_weapons/icons/obj/guns32x.dmi'
	icon_state = "handheld_cbc"
	worn_icon = 'modular_doppler/modular_weapons/icons/mob/worn/guns.dmi'
	worn_icon_state = "handheld_cbc"
	lefthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_weapons/icons/mob/inhands/gun_righthand.dmi'
	inhand_icon_state = "handheld_cbc"
	ammo_type = list(/obj/item/ammo_casing/energy/coherent_energy_beam)
	cell_type = /obj/item/stock_parts/power_store/cell/high
	charge_sections = 3
	ammo_x_offset = 2
	shaded_charge = FALSE
	display_empty =  TRUE
	weapon_weight = WEAPON_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	heat = 3800
	/// You can weld with one of these, and it's really good at it, but if you slip and fire it you're going to hurt someone or something very badly
	tool_behaviour = TOOL_WELDER
	toolspeed = 0.5

/obj/item/gun/energy/coherent_beam_cutter/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, autofire_shot_delay =  100 MILLISECONDS, firing_sound_loop = /datum/looping_sound/coherent_beam_cutter)

/obj/item/gun/energy/coherent_beam_cutter/tool_use_check(mob/living/user, amount, heat_required)
	if(QDELETED(cell))
		balloon_alert(user, "no cell inserted!")
		return FALSE
	// A cutter weld charge costs are 50 charge from the cutter's 5000
	// We take away 50 charge for every unit of heat required, with equal base heat to a normal welding tool
	if(amount ? cell.charge < BEAM_CUTTER_CHARGE_WELD * amount : cell.charge < BEAM_CUTTER_CHARGE_WELD)
		balloon_alert(user, "not enough charge!")
		return FALSE
	if(heat < heat_required)
		to_chat(user, span_warning("[src] is not hot enough to complete this task!"))
		return FALSE

	return TRUE

/obj/item/gun/energy/coherent_beam_cutter/use(used)
	return (!QDELETED(cell) && cell.use(used ? used * BEAM_CUTTER_CHARGE_WELD : BEAM_CUTTER_CHARGE_WELD))

/obj/item/gun/energy/coherent_beam_cutter/use_tool(atom/target, mob/living/user, delay, amount=1, volume=0, datum/callback/extra_checks)
	if(amount)
		var/mutable_appearance/sparks = mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE)
		target.add_overlay(sparks)
		LAZYADD(update_overlays_on_z, sparks)
		. = ..()
		LAZYREMOVE(update_overlays_on_z, sparks)
		target.cut_overlay(sparks)
	else
		. = ..(amount=1)

/obj/item/gun/energy/coherent_beam_cutter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!status && interacting_with.is_refillable())
		reagents.trans_to(interacting_with, reagents.total_volume, transferred_by = user)
		to_chat(user, span_notice("You empty [src]'s fuel tank into [interacting_with]."))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	if(!ishuman(interacting_with))
		return NONE
	if(user.combat_mode)
		return NONE

#undef BEAM_CUTTER_CHARGE_WELD
