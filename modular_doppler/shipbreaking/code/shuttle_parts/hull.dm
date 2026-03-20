/obj/structure/hull_plating
	abstract_type = /obj/structure/hull_plating
	icon = 'modular_doppler/shipbreaking/icons/turfs/walls_misc.dmi'
	density = TRUE
	anchored = FALSE
	drag_slowdown = 1.5
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

/obj/structure/hull_plating/nanocarbon/ex_act(severity, target)
	. = ..()
	if(severity >= EXPLODE_HEAVY)
		nanocarbon_nuke()
	return TRUE

/// Makes shards of nanocarbon
/obj/structure/hull_plating/nanocarbon/proc/nanocarbon_nuke()
	var/random_shards = 2
	for(var/iteration in 1 to random_shards)
		var/obj/item/shard = new /obj/item/nanocarbon_shard(src)
		shard.pixel_x = rand(-6, 6)
		shard.pixel_y = rand(-6, 6)
		shard.color = color

/obj/structure/hull_plating/nanocarbon/floor
	name = "nanocarbon panel"
	desc = "A section of nanocarbon hull that has been cut free, and has considerable mass."
	icon_state = "nanocarbon-1"
	custom_materials = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT * 1,
	)

/obj/structure/hull_plating/gold_foil
	name = "roll of gold foil"
	desc = "An industrial scale roll of gold foil, presumably peeled off the nearest ship."
	icon_state = "gold_foil"
	custom_materials = list(
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 3,
	)

/obj/structure/hull_plating/silver_foil
	name = "roll of silver foil"
	desc = "An industrial scale roll of silver foil, presumably peeled off the nearest ship."
	icon_state = "silver_foil"
	custom_materials = list(
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
	)

/obj/structure/hull_plating/plastamic_sheets
	name = "plastimic panels"
	desc = "Panels of a complicated plastic compound used to clad the interiors of ships."
	icon_state = "plastic_1"
	base_icon_state = "plastic"
	custom_materials = list(
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1,
	)

/obj/structure/hull_plating/plastamic_sheets/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state]_[rand(1, 3)]"
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/hull_plating/armor_panels
	name = "armor panels"
	desc = "High grade armor panels used to protect the exteriors of ships from anything between asteroid impacts \
		to gunfire."
	icon_state = "armor_1"
	base_icon_state = "armor"
	custom_materials = list(
		/datum/material/alloy/plastitanium = SHEET_MATERIAL_AMOUNT * 3,
	)

/obj/structure/hull_plating/armor_panels/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state]_[rand(1, 3)]"
	update_appearance(UPDATE_ICON_STATE)

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
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS | SMOOTH_OBJ
	smoothing_groups = SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS
	custom_materials = list(
		/datum/material/nanocarbon = SHEET_MATERIAL_AMOUNT * 3,
	)
	rust_resistance = RUST_RESISTANCE_TITANIUM
	baseturfs = /turf/baseturf_bottom
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
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
	smoothing_groups = SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_TITANIUM_WALLS
	custom_materials = list(
		/datum/material/aluminum = SHEET_MATERIAL_AMOUNT * 2,
	)
	rust_resistance = RUST_RESISTANCE_TITANIUM
	baseturfs = /turf/open/floor/plating/nanocarbon

/turf/closed/wall/mineral/aluminum/break_wall()
	var/obj/new_plating = new /obj/structure/hull_plating/aluminum(src)
	new_plating.color = color
	if(girder_type)
		return new girder_type(src)

/turf/open/floor/plating/nanocarbon
	name = "nanocarbon hull"
	desc = "A durable nanocarbon-metal alloy hull used commonly in high endurance ships."
	icon = 'modular_doppler/shipbreaking/icons/turfs/floors.dmi'
	icon_state = "nanocarbon"
	base_icon_state = "nanocarbon"
	attachment_holes = FALSE
	upgradable = FALSE
	rust_resistance = RUST_RESISTANCE_TITANIUM
	/// What kind of plating we make when cut apart
	var/obj/cut_plating = /obj/structure/hull_plating/nanocarbon/floor

/turf/open/floor/plating/nanocarbon/Initialize(mapload)
	. = ..()
	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "Cut Hull",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/turf/open/floor/plating/nanocarbon/welder_act(mob/living/user, obj/item/tool)
	balloon_alert(user, "cutting...")
	if(!tool.use_tool(src, user, 4 SECONDS, amount = 1, volume=50))
		return ITEM_INTERACT_BLOCKING
	new cut_plating(get_turf(src))
	ScrapeAway()
	return ITEM_INTERACT_SUCCESS

/turf/open/floor/plating/aluminum
	name = "aluminum hull"
	desc = "Thin aluminum hull, commonly used to plate the cargo bays of ships."
	icon = 'modular_doppler/shipbreaking/icons/turfs/aluminum.dmi'
	icon_state = "aluminum-0"
	base_icon_state = "aluminum"
	attachment_holes = FALSE
	upgradable = FALSE
	rust_resistance = RUST_RESISTANCE_TITANIUM
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_CHASM
	canSmoothWith = SMOOTH_GROUP_TURF_CHASM
	/// What kind of plating we make when cut apart
	var/obj/cut_plating = /obj/structure/hull_plating/aluminum/floor

/turf/open/floor/plating/aluminum/Initialize(mapload)
	. = ..()
	var/static/list/tool_behaviors = list(
		TOOL_WELDER = list(
			SCREENTIP_CONTEXT_LMB = "Cut Plating",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/turf/open/floor/plating/aluminum/welder_act(mob/living/user, obj/item/tool)
	balloon_alert(user, "cutting...")
	if(!tool.use_tool(src, user, 4 SECONDS, amount = 1, volume=50))
		return ITEM_INTERACT_BLOCKING
	new cut_plating(get_turf(src))
	ScrapeAway()
	return ITEM_INTERACT_SUCCESS
