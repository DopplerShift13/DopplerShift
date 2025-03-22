/turf/open/misc/rimworld_dirt/super
	name = "rich dirt"
	desc = "Extra tasty dirt, for plants, that is."
	gender = PLURAL
	icon = 'icons/vintagestation/floor/nature/super_dirt.dmi'
	icon_state = "super_dirt-255"
	base_icon_state = "super_dirt"
	tiled_dirt = FALSE
	transform = TRANSLATE_MATRIX(-16,-16)
	luminosity = 1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_SLOPPLER_SUPER_DIRT
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_SLOPPLER_SUPER_DIRT
	layer = MID_TURF_LAYER + 0.01
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/misc/rimworld_dirt/super
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	slowdown = 0.3

/turf/open/misc/rimworld_dirt
	name = "dirt"
	desc = "It's dirt. What else did you expect to see here?"
	gender = PLURAL
	icon = 'icons/vintagestation/floor/nature/dirt.dmi'
	icon_state = "dirt-255"
	base_icon_state = "dirt"
	tiled_dirt = FALSE
	transform = TRANSLATE_MATRIX(-16,-16)
	luminosity = 1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_SLOPPLER_DIRT
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_SLOPPLER_DIRT + SMOOTH_GROUP_SLOPPLER_SUPER_DIRT
	layer = MID_TURF_LAYER
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/misc/rimworld_dirt
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/misc/rimworld_mud
	name = "mud"
	desc = "Typically, this means water is near."
	gender = PLURAL
	icon = 'icons/vintagestation/floor/nature/mud.dmi'
	icon_state = "mud-255"
	base_icon_state = "mud"
	tiled_dirt = FALSE
	transform = TRANSLATE_MATRIX(-16,-16)
	luminosity = 1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_SLOPPLER_MUD
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_SLOPPLER_MUD + SMOOTH_GROUP_SLOPPLER_DIRT + SMOOTH_GROUP_SLOPPLER_SUPER_DIRT
	layer = MID_TURF_LAYER - 0.02
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/misc/rimworld_mud
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	slowdown = 0.6

/turf/open/misc/rimworld_stone
	name = "rough stone"
	desc = "Try not to trip, now."
	gender = PLURAL
	icon = 'icons/vintagestation/floor/nature/stone.dmi'
	icon_state = "stone-255"
	base_icon_state = "stone"
	tiled_dirt = FALSE
	transform = TRANSLATE_MATRIX(-16,-16)
	luminosity = 1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_WILD_STONE_FLOOR
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_WILD_STONE_FLOOR + SMOOTH_GROUP_SLOPPLER_DIRT + SMOOTH_GROUP_SLOPPLER_SUPER_DIRT
	layer = MID_TURF_LAYER - 0.01
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/misc/rimworld_stone
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/misc/rimworld_stone/examine(mob/user)
	. = ..()
	. += span_notice("This can be smoothed with an empty hand with <b>Right-Click</b>.")

/turf/open/misc/rimworld_stone/attack_hand_secondary(mob/user, list/modifiers)
	playsound(src, SFX_STONE_DROP, 75, TRUE)
	if(!do_After(user, 3 SECONDS), target = src)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	playsound(src, SFX_STONE_DROP, 75, TRUE)
	ChangeTurf(/turf/open/rimworld_constructed/smooth)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
