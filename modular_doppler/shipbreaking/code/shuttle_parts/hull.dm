/obj/structure/hull_plating
	abstract_type = /obj/structure/hull_plating
	icon = 'modular_doppler/shipbreaking/icons/turfs/walls_misc.dmi'
	density = TRUE
	anchored = FALSE
	/// How much damage we do when we fall on or crash into someone
	var/crush_damage = 40

/obj/structure/hull_plating/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/falling_hazard, damage = crush_damage, wound_bonus = 20, hardhat_safety = FALSE, crushes = TRUE, impact_sound = 'sound/effects/bang.ogg')

/obj/structure/hull_plating/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(isliving(hit_atom))
		workplace_accident(hit_atom)
	return ..()

/// Crushes someone like a vending machine if they are hit by the panel
/obj/structure/hull_plating/proc/workplace_accident(mob/living/osha_nonworker)
	var/turf/target_turf = get_turf(osha_nonworker)
	if(target_turf.is_blocked_turf(TRUE, src, list(src)))
		visible_message(span_danger("[src] nearly misses crushing [osha_nonworker], that was lucky!"))
	for(var/atom/atom_target in (target_turf.contents) + osha_nonworker)
		if(isarea(atom_target))
			continue
		if(SEND_SIGNAL(atom_target, COMSIG_PRE_TILT_AND_CRUSH, src) & COMPONENT_IMMUNE_TO_TILT_AND_CRUSH)
			continue
		var/crushed
		if(isliving(atom_target))
			crushed = TRUE
			var/mob/living/carbon/living_target = atom_target
			var/blocked = living_target.run_armor_check(attack_flag = MELEE)
			if(iscarbon(living_target))
				var/mob/living/carbon/carbon_target = living_target
				if(prob(30))
					// Will spread the damage and thus not break your bones, if you're lucky
					carbon_target.apply_damage(max(0, crush_damage), BRUTE, blocked = blocked, forced = TRUE, spread_damage = TRUE, attack_direction = get_dir(src, atom_target))
				else
					// Femur breaker if you're not lucky
					carbon_target.take_bodypart_damage(crush_damage, 0, check_armor = TRUE, wound_bonus = 5)
					carbon_target.take_bodypart_damage(crush_damage, 0, check_armor = TRUE, wound_bonus = 5)
				carbon_target.AddElement(/datum/element/squish, 80 SECONDS)
			else
				living_target.apply_damage(crush_damage, BRUTE, blocked = blocked, forced = TRUE, attack_direction = get_dir(src, atom_target))
			living_target.Paralyze(4 SECONDS)
			living_target.painful_scream()
			playsound(living_target, 'sound/effects/blob/blobattack.ogg', 40, TRUE)
			playsound(living_target, 'sound/effects/splat.ogg', 50, TRUE)
		else if(check_atom_crushable(atom_target))
			atom_target.take_damage(crush_damage, BRUTE, MELEE, FALSE, get_dir(src, atom_target))
			crushed = TRUE
		if(crushed)
			atom_target.visible_message(span_danger("[atom_target] is crushed by [src]!"), span_userdanger("You are crushed by [src]!"))
			SEND_SIGNAL(atom_target, COMSIG_POST_TILT_AND_CRUSH, src)
			playsound(src, 'sound/effects/bang.ogg', 40)
			visible_message(span_danger("[src] crashes into [atom_target]!"))
	Move(osha_nonworker, get_dir(src, osha_nonworker))

/obj/structure/hull_plating/nanocarbon
	name = "nanocarbon panels"
	desc = "A large section of nanocarbon hull that has been cut free, and has considerable mass."
	icon_state = "nanocarbon-2"
	custom_materials = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT * 3,
	)
	crush_damage = 50

/obj/structure/hull_plating/nanocarbon/floor
	name = "nanocarbon panel"
	desc = "A section of nanocarbon hull that has been cut free, and has considerable mass."
	icon_state = "nanocarbon-1"
	custom_materials = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT * 1,
	)

/obj/structure/hull_plating/aluminum
	name = "aluminum panels"
	desc = "A large section of aluminum hull that has been cut free, and has considerable mass."
	icon_state = "aluminum-2"
	custom_materials = list(
		/datum/material/aluminum = SHEET_MATERIAL_AMOUNT * 2,
	)

/obj/structure/hull_plating/aluminum/floor
	name = "aluminum panel"
	desc = "A section of aluminum hull that has been cut free, and has considerable mass."
	icon_state = "aluminum-1"
	custom_materials = list(
		/datum/material/aluminum = SHEET_MATERIAL_AMOUNT,
	)

/turf/closed/wall/mineral/nanocarbon
	name = "nanocarbon hull"
	desc = "A durable nanocarbon-metal alloy hull used commonly in high endurance ships."
	icon = 'modular_doppler/shipbreaking/icons/turfs/nanocarbon_wall.dmi'
	icon_state = "nanocarbon_wall-0"
	base_icon_state = "nanocarbon_wall"
	explosive_resistance = 3
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD
	sheet_type = /obj/item/stack/sheet/nanocarbon
	hardness = 20
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS
	custom_materials = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT * 3,
	)
	rust_resistance = RUST_RESISTANCE_TITANIUM
	/// How many shards of nanocarbon the wall will make when exploded, maximum
	var/number_of_shards = 6

/turf/closed/wall/mineral/nanocarbon/break_wall()
	var/obj/new_plating = new /obj/structure/hull_plating/nanocarbon(src)
	new_plating.color = color
	if(girder_type)
		return new girder_type(src)

/turf/closed/wall/mineral/nanocarbon/devastate_wall()
	var/random_shards = rand(2, number_of_shards)
	for(var/iteration in 1 to random_shards)
		var/obj/item/shard = new /obj/item/nanocarbon_shard(src)
		shard.pixel_x = rand(-6, 6)
		shard.pixel_y = rand(-6, 6)
		shard.color = color
	if(girder_type)
		return new girder_type(src)

/turf/closed/wall/mineral/nanocarbon/nodiagonal
	icon = MAP_SWITCH('modular_doppler/shipbreaking/icons/turfs/nanocarbon_wall.dmi', 'modular_doppler/shipbreaking/icons/turfs/walls_misc.dmi')
	icon_state = MAP_SWITCH("nanocarbon_wall-0", "nanocarbon_nd")
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/wall/mineral/nanocarbon/black
	color = COLOR_DARK

/turf/closed/wall/mineral/nanocarbon/nodiagonal/black
	color = COLOR_DARK

/turf/closed/wall/mineral/nanocarbon/standard
	color = COLOR_SILVER

/turf/closed/wall/mineral/nanocarbon/nodiagonal/standard
	color = COLOR_SILVER

/turf/closed/wall/mineral/nanocarbon/red
	color = COLOR_BUBBLEGUM_RED

/turf/closed/wall/mineral/nanocarbon/nodiagonal/red
	color = COLOR_BUBBLEGUM_RED

/turf/closed/wall/mineral/nanocarbon/green
	color = COLOR_IRISH_GREEN

/turf/closed/wall/mineral/nanocarbon/nodiagonal/green
	color = COLOR_IRISH_GREEN

/turf/closed/wall/mineral/nanocarbon/blue
	color = COLOR_COMMAND_BLUE

/turf/closed/wall/mineral/nanocarbon/nodiagonal/blue
	color = COLOR_COMMAND_BLUE

/turf/closed/wall/mineral/nanocarbon/yellow
	color = COLOR_GOLD

/turf/closed/wall/mineral/nanocarbon/nodiagonal/yellow
	color = COLOR_GOLD

/turf/closed/wall/mineral/aluminum
	name = "aluminum wall"
	desc = "A thin aluminum wall, commonly used to plate the interior of ships."
	icon = 'modular_doppler/shipbreaking/icons/turfs/aluminum_wall.dmi'
	icon_state = "aluminum_wall-0"
	base_icon_state = "aluminum_wall"
	sheet_type = /obj/item/stack/sheet/aluminum
	hardness = 50
	explosive_resistance = 0
	smoothing_groups = SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_TITANIUM_WALLS
	custom_materials = list(
		/datum/material/aluminum = SHEET_MATERIAL_AMOUNT * 2,
	)
	rust_resistance = RUST_RESISTANCE_TITANIUM

/turf/closed/wall/mineral/aluminum/break_wall()
	var/obj/new_plating = new /obj/structure/hull_plating/aluminum(src)
	new_plating.color = color
	if(girder_type)
		return new girder_type(src)
