/turf/closed/mineral/crag_caldera
	name = "eclogitic rock"
	desc = "A solid wall of eclogitic rock, like you find in Crag's calderas and craters, or under the ground beneath the layers of \
		vocanic rock and pyroclastic debris."
	icon = 'icons/_smooth_doppler/turfs/closed/eclogitic_rock.dmi'
	icon_state = "eclogitic_rock"
	base_icon_state = "eclogitic_rock"
	smoothing_groups = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS
	canSmoothWith = SMOOTH_GROUP_MINERAL_WALLS
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	baseturfs = /turf/open/misc/crag_gravel
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	transform = null
	turf_type = /turf/open/misc/crag_gravel
