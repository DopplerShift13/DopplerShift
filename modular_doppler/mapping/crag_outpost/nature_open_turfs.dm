/turf/open/water/superketone
	name = "superketone pool"
	desc = "Superketone coolants, a staple of starship cooling loops and scorching planet heat dissipation. \
		Do not fall for the allure of its tasty looking appearance, superketone coolant is extremely caustic against \
		organic tissue and practically a superconductor."
	icon = 'icons/_smooth_doppler/turfs/open/superketone.dmi'
	icon_state = "superketone-255"
	base_icon_state = "superketone"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SUPERKETONE
	canSmoothWith = SMOOTH_GROUP_SUPERKETONE
	planetary_atmos = TRUE
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	gender = PLURAL
	baseturfs = /turf/open/water/superketone
	fishing_datum = null
	light_color = "#d2c545"
	light_range = 2
	light_power = 0.75
	light_on = TRUE

/turf/open/water/superketone/Entered(atom/movable/arrived, atom/old_loc)
	. = ..()
	if(!(flags_1 & INITIALIZED_1))
		return
	enter_pool(arrived)

/turf/open/water/superketone/on_atom_inited(datum/source, atom/movable/movable)
	enter_pool(movable)

/// Pours acid on anyone who enters the pool
/turf/open/water/superketone/proc/enter_pool(atom/movable/movable)
	movable.acid_act(20, 30)

/turf/open/water/superketone/GetTemperature()
	. = TCMB * 2

/turf/open/water/sulfur_spring
	name = "sulfurous spring"
	desc = "A boiling pool of sulfurous water. You get a really good feeling this isn't the kind you lounge around in."
	icon = 'icons/_smooth_doppler/turfs/open/spring.dmi'
	icon_state = "spring-255"
	base_icon_state = "spring"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SULFUR_SPRING
	canSmoothWith = SMOOTH_GROUP_SULFUR_SPRING_DEEP + SMOOTH_GROUP_SULFUR_SPRING
	planetary_atmos = TRUE
	gender = PLURAL
	baseturfs = /turf/open/water/sulfur_spring
	fishing_datum = /datum/fish_source/sulfur_spring
	/// If this spring is harmful or not
	var/harmful = TRUE
	/// What kind of particles does this turf use. Use normal steam particles for the indoors variant
	var/particles/particle_type = /particles/sulfur_spring_steam

/turf/open/water/sulfur_spring/Initialize(mapload)
	. = ..()
	var/obj/effect/abstract/shared_particle_holder/holder = add_shared_particles(particle_type, "[particle_type]_[GET_TURF_PLANE_OFFSET(src)]", pool_size = 4)
	holder.vis_flags &= ~VIS_INHERIT_PLANE
	holder.plane = MUTATE_PLANE(MASSIVE_OBJ_PLANE, src)

/turf/open/water/sulfur_spring/Destroy()
	remove_shared_particles("[particle_type]_[GET_TURF_PLANE_OFFSET(src)]")
	for(var/atom/movable/movable as anything in contents)
		exit_pool(movable)
	return ..()

/turf/open/water/sulfur_spring/Entered(atom/movable/arrived, atom/old_loc)
	. = ..()
	if(!(flags_1 & INITIALIZED_1))
		return
	enter_pool(arrived)

/turf/open/water/sulfur_spring/on_atom_inited(datum/source, atom/movable/movable)
	enter_pool(movable)

/// Handles applying dipping effects to movables or not
/turf/open/water/sulfur_spring/proc/enter_pool(atom/movable/movable)
	if(is_type_in_typecache(movable, GLOB.immerse_ignored_movable))
		return FALSE
	RegisterSignal(movable, SIGNAL_ADDTRAIT(TRAIT_IMMERSED), PROC_REF(dip_in))
	if(isliving(movable))
		RegisterSignal(movable, SIGNAL_REMOVETRAIT(TRAIT_IMMERSED), PROC_REF(dip_out))
	if(HAS_TRAIT(movable, TRAIT_IMMERSED))
		dip_in(movable)

/// Handles washing the movable and adding a status effect plus mood event to living mobs.
/turf/open/water/sulfur_spring/proc/dip_in(atom/movable/movable)
	SIGNAL_HANDLER
	movable.wash(CLEAN_RAD | CLEAN_WASH)
	if(!isliving(movable))
		return
	var/mob/living/living = movable
	if(!harmful && living.has_status_effect(/datum/status_effect/washing_regen/hot_spring))
		return
	else if(harmful && living.has_status_effect(/datum/status_effect/sulfur_burning))
		return
	var/status_effect_to_apply = harmful ? /datum/status_effect/sulfur_burning : /datum/status_effect/washing_regen/hot_spring
	living.apply_status_effect(status_effect_to_apply)
	if(harmful)
		living.add_mood_event("burning_spring", /datum/mood_event/burning_spring)
	else if(!HAS_TRAIT(living, TRAIT_WATER_HATER) || HAS_TRAIT(living, TRAIT_WATER_ADAPTATION))
		living.add_mood_event("hot_spring", /datum/mood_event/hot_spring)
	else
		living.add_mood_event("hot_spring", /datum/mood_event/hot_spring_hater)

/turf/open/water/sulfur_spring/Exited(atom/movable/gone, atom/new_loc)
	. = ..()
	exit_pool(gone)

/// Unregisters signals for immersion and handles exiting effects
/turf/open/water/sulfur_spring/proc/exit_pool(atom/movable/movable)
	UnregisterSignal(movable, list(SIGNAL_ADDTRAIT(TRAIT_IMMERSED), SIGNAL_REMOVETRAIT(TRAIT_IMMERSED)))
	if(!isliving(movable))
		return
	var/mob/living/living = movable
	var/turf/open/water/sulfur_spring/spring = living.loc
	if((spring?.harmful == src.harmful) && !istype(spring))
		return
	if((!living.has_status_effect(/datum/status_effect/washing_regen/hot_spring) && !living.has_status_effect(/datum/status_effect/sulfur_burning)) || istype(living.loc, /turf/open/water/sulfur_spring))
		return
	dip_out(living)

/// Handles removing the status effect from mobs.
/turf/open/water/sulfur_spring/proc/dip_out(mob/living/living)
	SIGNAL_HANDLER
	if(harmful)
		living.remove_status_effect(/datum/status_effect/sulfur_burning)
	else
		living.remove_status_effect(/datum/status_effect/washing_regen/hot_spring)
	if(harmful)
		living.add_mood_event("burning_spring", /datum/mood_event/burning_spring_left)
	else if(!HAS_TRAIT(living, TRAIT_WATER_HATER) || HAS_TRAIT(living, TRAIT_WATER_ADAPTATION))
		living.add_mood_event("hot_spring", /datum/mood_event/hot_spring_left)
	else
		living.add_mood_event("hot_spring", /datum/mood_event/hot_spring_hater_left)

/turf/open/water/sulfur_spring/lavaland
	planetary_atmos = TRUE
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	baseturfs = /turf/open/water/sulfur_spring

/turf/open/water/sulfur_spring/deep
	name = "deep sulfurous spring"
	icon = 'icons/_smooth_doppler/turfs/open/spring_deep.dmi'
	icon_state = "spring_deep-255"
	base_icon_state = "spring_deep"
	is_swimming_tile = TRUE
	immerse_overlay = "immerse_deep"
	smoothing_groups = SMOOTH_GROUP_SULFUR_SPRING_DEEP
	canSmoothWith = SMOOTH_GROUP_SULFUR_SPRING_DEEP
	baseturfs = /turf/open/water/sulfur_spring/deep

/turf/open/water/sulfur_spring/deep/lavaland
	planetary_atmos = TRUE
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	baseturfs = /turf/open/water/sulfur_spring/deep/lavaland

// Safe hotspring

/turf/open/water/sulfur_spring/safe
	name = "tamed hotspring"
	desc = "The domesticated version of your typical crag hotspring. Highly likely to not kill you when entered."
	planetary_atmos = FALSE
	baseturfs = /turf/baseturf_bottom
	particle_type = /particles/hotspring_steam
	harmful = FALSE

/turf/open/water/sulfur_spring/safe/deep
	name = "deep tamed hotspring"
	icon = 'icons/_smooth_doppler/turfs/open/spring_deep.dmi'
	icon_state = "spring_deep-255"
	base_icon_state = "spring_deep"
	is_swimming_tile = TRUE
	immerse_overlay = "immerse_deep"
	smoothing_groups = SMOOTH_GROUP_SULFUR_SPRING_DEEP
	canSmoothWith = SMOOTH_GROUP_SULFUR_SPRING_DEEP
	baseturfs = /turf/open/water/sulfur_spring/deep

/turf/open/misc/bacteria
	name = "bacterial mat"
	desc = "A brightly-colored bacterial mat that often forms near wild hotsprings. \
		These help to claim more lives on crag than any other thing on the floor ever could, \
		trapping unwitting explorers and crag jumpers in boiling springs with their slippery surface."
	icon = 'icons/_smooth_doppler/turfs/open/bacteria.dmi'
	icon_state = "bacteria-255"
	base_icon_state = "bacteria"
	transform = TRANSLATE_MATRIX(-16, -16)
	layer = LOW_FLOOR_LAYER + 0.25
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_BACTERIAL_MAT
	canSmoothWith = SMOOTH_GROUP_BACTERIAL_MAT + SMOOTH_GROUP_CLOSED_TURFS
	gender = PLURAL
	baseturfs = /turf/baseturf_bottom
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	footstep = FOOTSTEP_MEAT
	barefootstep = FOOTSTEP_MEAT
	clawfootstep = FOOTSTEP_MEAT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	rust_resistance = RUST_RESISTANCE_ORGANIC

/turf/open/misc/crag_gravel
	name = "eclogitic turf"
	desc = "Eclogitic rock commonly found in Crag's calderas and craters, as well as under the surface beneath the layers of \
		volcanic rocks and pyroclastic debris."
	icon = 'icons/_smooth_doppler/turfs/open/eclogitic.dmi'
	icon_state = "eclogitic-255"
	base_icon_state = "eclogitic"
	transform = TRANSLATE_MATRIX(-16, -16)
	layer = LOW_FLOOR_LAYER
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CRAG_GRAVEL
	canSmoothWith = SMOOTH_GROUP_CRAG_GRAVEL + SMOOTH_GROUP_CRAG_SAND + SMOOTH_GROUP_BACTERIAL_MAT + SMOOTH_GROUP_CLOSED_TURFS
	gender = PLURAL
	baseturfs = /turf/baseturf_bottom
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	rust_resistance = RUST_RESISTANCE_REINFORCED

/turf/open/misc/crag_sand
	name = "eclogitic sand"
	desc = "Fine-grained sand made up of wind blasted eclogitic rock commonly found around Crag's calderas and craters. \
		Can be dug up and turned into a form of concrete at an ore redemption machine, or through other more manual methods."
	icon = 'icons/_smooth_doppler/turfs/open/eclogitic_sand.dmi'
	icon_state = "eclogitic_sand-255"
	base_icon_state = "eclogitic_sand"
	transform = TRANSLATE_MATRIX(-16, -16)
	layer = LOW_FLOOR_LAYER + 0.1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CRAG_SAND
	canSmoothWith = SMOOTH_GROUP_CRAG_SAND + SMOOTH_GROUP_BACTERIAL_MAT + SMOOTH_GROUP_CLOSED_TURFS
	gender = PLURAL
	baseturfs = /turf/open/misc/crag_gravel
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	rust_resistance = RUST_RESISTANCE_REINFORCED

/turf/open/misc/crag_sand/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/diggable, /obj/item/stack/ore/crag_sand, 2)
