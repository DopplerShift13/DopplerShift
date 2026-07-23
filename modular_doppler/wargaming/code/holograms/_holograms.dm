/obj/structure/wargame_hologram
	abstract_type = /obj/structure/wargame_hologram
	icon = 'modular_doppler/wargaming/icons/holograms.dmi'
	icon_state = null
	anchored = TRUE
	density = FALSE
	max_integrity = 30
	alpha = 180
	obj_flags = UNIQUE_RENAME
	do_not_override_chat_colors = TRUE
	/// What object created this projection? Can be null as a projector isn't required for this to exist
	var/obj/item/wargame_projector/projector
	/// If this hologram ignores pixel shifting when placed, instead using swarming
	var/swarming = FALSE
	/// The team datum responsible for managing this hologram, if any
	var/datum/weakref/team_reference
	/// Does this controllable thing require a mob interacting with it to be on its team
	var/requires_same_team = TRUE
	/// Is this hologram controllable in any way, false for things like dust clouds and asteroids
	var/controllable = FALSE
	/// This object's unit stats datum, to be created on init
	var/datum/wargame_unit_stats/unit_stats = /datum/wargame_unit_stats/generic

/obj/structure/wargame_hologram/Initialize(mapload, source_projector)
	. = ..()
	unit_stats = new unit_stats()
	unit_stats.set_hologram_name(src)
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.projections, src)
	if(swarming)
		AddComponent(/datum/component/swarming, max_x = 12, max_y = 12)
		layer = LOW_ITEM_LAYER
	register_context()

/obj/structure/wargame_hologram/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(istype(held_item, /obj/item/wargame_projector))
		context[SCREENTIP_CONTEXT_LMB] = "Delete hologram"
	else
		context[SCREENTIP_CONTEXT_LMB] = "Open actions menu"
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/wargame_hologram/examine(mob/user)
	. = ..()
	var/datum/wargaming_team/our_team = team_reference?.resolve()
	if(!isnull(our_team))
		. += span_notice("It belongs to the [our_team.team_name] team.")
	if(controllable)
		. += "This unit has [unit_stats.action_points] / [unit_stats.maximum_action_points] action points."
		. += "It costs this unit [unit_stats.movement_cost] action points to move."
	if(length(unit_stats.current_conditions))
		var/conditions_text = ""
		for(var/datum/wargame_condition/condition as anything in unit_stats.current_conditions)
			conditions_text += "[span_boldnotice("[condition.condition_name]")] - [condition.condition_desc] - [condition.condition_lifetime_left] turns until cleared.<br>"
		. += fieldset_block(span_bold("Conditions"), conditions_text, "boxed_message")
		if(length(unit_stats.current_conditions) > unit_stats.conditions_limit)
			. += span_warning("It looks like it's nearing its limit, if these conditions don't improve by next effects phase, the ship will be lost.")
	if(length(unit_stats.weaponry))
		var/weaponry_text = ""
		for(var/datum/wargame_weapon/weapon as anything in unit_stats.weaponry)
			weaponry_text += "[span_boldnotice("[weapon.weapon_name]")] - [weapon.weapon_description()][!isnull(weapon.maximum_ammo) ? " [weapon.maximum_ammo] shots left" : ""]<br>"
		. += fieldset_block(span_bold("Weaponry"), weaponry_text, "boxed_message")

/obj/structure/wargame_hologram/examine_more(mob/user)
	. = ..()
	var/examine_more_text = ""
	examine_more_text += "<b>Destruction</b> - Units with more conditions than their maximum conditions value will be \
		destroyed during the effects phase if these conditions are not repaired.<br>"
	examine_more_text += span_notice("This unit can sustain a maximum of <b>[unit_stats.conditions_limit]</b> conditions at once.<br>")
	examine_more_text += "<b>Repair</b> - Units with conditions will repair them by one turn during the effects phase. \
		Repairs take place before a ship is checked for destruction, meaning a ship that is over its conditions limit \
		but has a condition that will get repaired during that effects phase may not be destroyed.<br>"
	examine_more_text += "<b>Armor & Evasion</b> - Units have two values that determine if they will be hit by any given attack. \
		These values are armor class and evasion modifier. Armor class is a simple value that an attack must roll higher than in \
		order to hit. Certain weapons are weak against armor, and if the attack roll minus this weakness is lower than the unit's \
		armor class, then the attack will fail as well. Evasion provides a bonus to a unit's armor class against attacks that can \
		be evaded. Most attacks can be evaded with exception of beam weapon type attacks.<br>"
	examine_more_text += span_notice("This unit's armor class is <b>[unit_stats.armor_class]</b>, and it has an evasion modifier of <b>[unit_stats.evasion_modifier]</b>")
	. += fieldset_block(span_bold("Mechanics"), examine_more_text, "boxed_message")

/obj/structure/wargame_hologram/Destroy()
	if(projector)
		LAZYREMOVE(projector.projections, src)
		projector = null
	return ..()

/obj/structure/wargame_hologram/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, src)

/obj/structure/wargame_hologram/attack_hand(mob/living/user, list/modifiers)
	if(user.combat_mode || !controllable)
		return ..()
	hologram_controls(user)

/// Handles controlling the hologram when clicked on
/obj/structure/wargame_hologram/proc/hologram_controls(mob/living/user)
	SHOULD_CALL_PARENT(TRUE)
	if(!currently_our_turn())
		if(prob(1/1000))
			say("WAIT. YOUR. TURN!")
			playsound(src, 'sound/effects/seedling_chargeup.ogg', 50)
		else
			balloon_alert(user, "not our turn!")
		return
	if(requires_same_team && !verify_user_team(user))
		balloon_alert(user, "wrong team!")
		return
	unit_stats.basic_actions(user, src)

/// Checks with our projector's linked controller to see if it's our turn to move
/obj/structure/wargame_hologram/proc/currently_our_turn()
	var/obj/item/wargame_base_station/base_station = projector.linked_base_station?.resolve()
	if(isnull(base_station))
		return FALSE
	var/datum/wargaming_team/our_team = team_reference?.resolve()
	if(isnull(our_team))
		return FALSE
	if(base_station.turn_mode == WARGAME_TURN_MODE_SIMULTANEOUS)
		return TRUE
	if(base_station.team_turn != our_team)
		return FALSE
	return TRUE

/// Checks if the user is in the team datum's players list
/obj/structure/wargame_hologram/proc/verify_user_team(mob/living/user)
	var/datum/wargaming_team/owner_team = team_reference?.resolve()
	if(isnull(owner_team))
		return FALSE
	if(user in owner_team.team_players)
		return TRUE
	return FALSE

/obj/structure/wargame_hologram/controllable
	abstract_type = /obj/structure/wargame_hologram/controllable
	swarming = TRUE
	controllable = TRUE
