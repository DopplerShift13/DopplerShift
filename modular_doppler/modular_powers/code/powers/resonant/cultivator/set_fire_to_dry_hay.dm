/datum/power/cultivator/set_fire_to_dry_hay
	name = "Set Fire to Dry Hay"
	desc = "You can set fire onto anything you touch. This works similary to a ligher in terms of functionality. \
	While in Alignment, you can right click shoot a flameblast that ignite everything in the area where it lands. \
	Using the alignment version consumes Energy. No cooldown."
	security_record_text = "Subject can set fire to any object in melee range. While in a heightened state, they can shoot motes of flame to ignite anything hit as well."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	required_powers = list(/datum/power/cultivator_root/flame_soul)
	action_path = /datum/action/cooldown/power/cultivator/set_fire_to_dry_hay

// Mouse click handlers
/// No mouse click
#define FIRE_CLICK_NONE 0
/// Left mouse click
#define FIRE_CLICK_LEFT 1
/// Right mouse click
#define FIRE_CLICK_RIGHT 2

/datum/action/cooldown/power/cultivator/set_fire_to_dry_hay
	name = "Set Fire to Dry Hay"
	desc = "You can set fire onto anything you touch. This works similary to a lighter in terms of functionality. \
	While in Alignment, you can right click to shoot a flameblast that ignite everything in the area where it lands. \
	Using the alignment version consumes Energy. No cooldown."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "fireball"

	click_to_activate = TRUE
	unset_after_click = FALSE
	click_cd_override = 5 // matches cooldown between shots

	/// Cooldown for right click projectile, in deciseconds.
	var/projectile_delay = 5
	/// World-time for when the next projectile is ready
	var/next_projectile_time = 0

	/// cost for flameblast projectile
	var/flameblast_cost = 20
	/// Icon for flameblast projectile
	var/flameblast_icon = null
	/// Icon state for flamebast projectile
	var/flameblast_icon_state = "fireball"
	/// Icon scale for the flameblast projectile
	var/flameblast_scale = 0.7

	/// Flamebast's light range
	var/flameblast_light_range = 3
	/// Flameblast's light power
	var/flameblast_light_power = 1
	/// Flameblast's light color
	var/flameblast_light_color = "#e99a3f"

	/// Flameblast projectile's on-hit damage
	var/flameblast_damage = 10
	/// Flaemblast projectile's firestacks on hit
	var/flameblast_firestacks = 0.1
	/// The sound of flameblast impacting
	var/flameblast_impact_sound = 'sound/effects/fire_puff.ogg'
	/// Cached alignment action for gating right click effects.
	var/datum/action/cooldown/power/cultivator/alignment/flame_soul/flame_soul_alignment
	/// Which mouse click is used in use_action
	var/fire_click_type = FIRE_CLICK_NONE

// We use both left and right mouse button.
/datum/action/cooldown/power/cultivator/set_fire_to_dry_hay/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		fire_click_type = FIRE_CLICK_RIGHT
	else
		fire_click_type = FIRE_CLICK_LEFT
	. = ..()
	if(!.)
		fire_click_type = FIRE_CLICK_NONE
	return TRUE // Always consume the click to avoid normal click interactions.

/datum/action/cooldown/power/cultivator/set_fire_to_dry_hay/use_action(mob/living/user, atom/target)
	// Sets the click type.
	if(fire_click_type == FIRE_CLICK_RIGHT) // shoots flameblasts instead of lighting cigs.
		return shoot_flameblast(user, target)
	if(!target)
		return FALSE
	// Lighter version only works in melee range.
	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	if(user_turf && target_turf && get_dist(user_turf, target_turf) > 1)
		owner.balloon_alert(user, "Out of range!")
		return FALSE
	var/obj/item/cultivator_virtual_lighter/lighter = new
	// Allow the lighter's cigarette lighting behavior on mobs.
	if(isliving(target))
		var/mob/living/target_mob = target
		lighter.attack(target_mob, user, list(), list())
		qdel(lighter)
		return TRUE
	// Allow lighting loose cigarettes directly.
	if(istype(target, /obj/item/cigarette))
		var/obj/item/cigarette/cig = target
		cig.attackby(lighter, user, list(), list())
		qdel(lighter)
		return TRUE

	// First run normal item-interaction handlers (candles use this path).
	var/item_interact_result = target.item_interaction(user, lighter, list())
	if(!(item_interact_result & ITEM_INTERACT_ANY_BLOCKER))
		// Fallback to attackby handlers (bonfires use this path).
		target.attackby(lighter, user, list(), list())
		// Finally, raw ignition for generic flammables.
		if((target.resistance_flags & FLAMMABLE) && !(target.resistance_flags & FIRE_PROOF))
			target.fire_act(lighter.get_temperature())
	qdel(lighter)
	playsound(user, 'sound/effects/fire_puff.ogg', 60, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	// Always return TRUE to keep the click ability active.
	return TRUE

/// Gets & caches flame soul alignment for gating the right click.
/datum/action/cooldown/power/cultivator/set_fire_to_dry_hay/proc/is_flame_soul_alignment_active(mob/living/user)
	if(!flame_soul_alignment)
		for(var/datum/action/cooldown/power/cultivator/alignment/flame_soul/alignment_action in user.actions)
			flame_soul_alignment = alignment_action
			break
	if(!flame_soul_alignment)
		return FALSE
	return flame_soul_alignment.active

/// Shoots a lil flameblast when we're in alignment.
/datum/action/cooldown/power/cultivator/set_fire_to_dry_hay/proc/shoot_flameblast(mob/living/user, atom/target)
	if(!is_flame_soul_alignment_active(user))
		user.balloon_alert(user, "alignment required!")
		return FALSE
	if(world.time < next_projectile_time)
		return FALSE
	next_projectile_time = world.time + projectile_delay
	fire_projectile(user, target, /obj/projectile/resonant/fire_to_dry_hay)
	playsound(user, 'sound/effects/fire_puff.ogg', 60, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	adjust_energy(-flameblast_cost)
	return TRUE

// Applies projectile customization here.
/datum/action/cooldown/power/cultivator/set_fire_to_dry_hay/ready_projectile(obj/projectile/projectile_instance, atom/target, mob/living/user)
	. = ..()
	if(!projectile_instance)
		return
	var/obj/projectile/flame_projectile = projectile_instance
	if(flameblast_icon)
		flame_projectile.icon = flameblast_icon
	if(flameblast_icon_state)
		flame_projectile.icon_state = flameblast_icon_state
	if(flameblast_scale)
		var/matrix/scale_matrix = matrix(flame_projectile.transform)
		scale_matrix.Scale(flameblast_scale, flameblast_scale)
		flame_projectile.transform = scale_matrix
	flame_projectile.damage = flameblast_damage
	flame_projectile.light_range = flameblast_light_range
	flame_projectile.light_power = flameblast_light_power
	flame_projectile.light_color = flameblast_light_color
	flame_projectile.light_on = TRUE
	flame_projectile.set_light(flame_projectile.light_range, flame_projectile.light_power, flame_projectile.light_color, l_on = TRUE)

// Because welder/lighter interactions check for get_temprature on the item we kind of have to make an abstract item do the work for us.
/obj/item/cultivator_virtual_lighter
	parent_type = /obj/item/lighter
	name = "\improper cultivator flame"
	desc = "A conjured spark of flame."
	fancy = TRUE
	heat_while_on = HIGH_TEMPERATURE_REQUIRED - 100

/obj/item/cultivator_virtual_lighter/Initialize(mapload)
	. = ..()
	lit = FALSE // so we have to make sure its unlit before we light it or it won't work. I love it here.
	set_lit(TRUE)

/obj/item/cultivator_virtual_lighter/get_fuel()
	return INFINITY

/obj/item/cultivator_virtual_lighter/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		return span_infoplain(span_rose("[user] touches the tip of [A] with [user.p_their()] finger and it ignites. Badass!"))
	return ""

// The fire projectile
/obj/projectile/resonant/fire_to_dry_hay
	name = "flameblast"
	icon_state = "fireball"
	damage = 10
	armour_penetration = 0 // doesnt do jack to fireproofing
	damage_type = BURN
	armor_flag = FIRE

/obj/projectile/resonant/fire_to_dry_hay/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	var/turf/impact_turf = get_turf(target)
	if(!impact_turf)
		return
	var/datum/action/cooldown/power/cultivator/set_fire_to_dry_hay/power = creating_power
	if(power?.flameblast_impact_sound)
		playsound(impact_turf, power.flameblast_impact_sound, 75, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	// Apply fire stacks to mobs; ignite objects on the turf.
	for(var/mob/living/burning_mob in impact_turf.contents)
		burning_mob.adjust_fire_stacks(power?.flameblast_firestacks || 0)
		burning_mob.ignite_mob()
	for(var/atom/movable/ignite_target in impact_turf.contents)
		if(ismob(ignite_target))
			continue
		if(ignite_target.resistance_flags & FIRE_PROOF)
			continue
		ignite_target.fire_act(500)

#undef FIRE_CLICK_NONE
#undef FIRE_CLICK_LEFT
#undef FIRE_CLICK_RIGHT
