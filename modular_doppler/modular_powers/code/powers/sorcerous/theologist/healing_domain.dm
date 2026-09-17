/datum/power/theologist/healing_domain
	name = "Healer's Domain"
	desc = "There is an ambient power to Holy Water that you can wield. Your healing powers are increased by 25% while you or your target are stood on blessed ground.\
	\n(Blessed Ground are tiles splashed with holy water. Conditions are snap-shot on cast, so the requirements only have to be fulfilled when you use the healing action.)"
	mob_trait = TRAIT_SEE_BLESSED_TILES
	value = 3
	power_flags = POWER_HUMAN_ONLY | POWER_HEALING

	required_powers = list(/datum/power/theologist_root)
	required_allow_subtypes = TRUE

	menu_icon = 'icons/obj/drinks/bottles.dmi'
	menu_icon_state = "holyflask"

	/// How much of a multiplier healing domain gives. Base healing * (1 + healing_bonus).
	var/healing_bonus = 0.25

/datum/power/theologist/healing_domain/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS, PROC_REF(add_healing_modifier))

/datum/power/theologist/healing_domain/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_POWER_HEALING_MODIFIERS)

/// Adds Healing Domain's bonus if the caster or target is on blessed ground when the healing power snapshots its modifiers.
/datum/power/theologist/healing_domain/proc/add_healing_modifier(mob/living/source, atom/healing_target, list/additive_healing_modifiers, list/multiplicative_healing_modifiers)
	SIGNAL_HANDLER

	if(!istype(source))
		return NONE

	if(!is_on_blessed_ground(source) && !is_on_blessed_ground(healing_target))
		return NONE

	additive_healing_modifiers += healing_bonus
	return NONE

/// Returns whether the supplied atom is currently on a blessed tile.
/datum/power/theologist/healing_domain/proc/is_on_blessed_ground(atom/subject)
	var/turf/subject_turf = get_turf(subject)
	if(!subject_turf)
		return FALSE
	return !!locate(/obj/effect/blessing) in subject_turf
