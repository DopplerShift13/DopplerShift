/obj/structure/stairs/ramp
	name = "earthen ramp"
	desc = "A ramp of made of compacted earth, probably from the ground around it."
	icon = 'modular_doppler/mapping/crag_outpost/icons/ramps.dmi'
	icon_state = "ramp_dirt"
	base_icon_state = "ramp_dirt"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER_OBJECT
	smoothing_groups = SMOOTH_GROUP_DIRT_RAMP
	canSmoothWith = SMOOTH_GROUP_DIRT_RAMP
	/// What was used to build this ramp
	var/obj/item/stack/build_stack = /obj/item/stack/ore/crag_sand
	/// How much was used to build this ramp
	var/stack_amount = 4
	/// How far this ramp is pixel shifted in its direction
	var/directional_pixel_shift = 10

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/stairs/ramp, 10)

/obj/structure/stairs/ramp/Initialize(mapload)
	. = ..()
	setDir(dir)
	if((pixel_x == 0) && (pixel_y == 0))
		set_pixel_shift_on_direction(dir)

/obj/structure/stairs/ramp/handle_deconstruct(disassembled)
	if(!isnull(build_stack) && stack_amount)
		new build_stack(drop_location(), stack_amount)
	return ..()

/obj/structure/stairs/ramp/setDir(newdir)
	. = ..()
	set_pixel_shift_on_direction(newdir)

/// Sets the ramp's pixel shifting depending on what dir we're facing
/obj/structure/stairs/ramp/proc/set_pixel_shift_on_direction(direction)
	switch(direction)
		if(NORTH)
			pixel_y = directional_pixel_shift
		if(SOUTH)
			pixel_y = -directional_pixel_shift
		if(EAST)
			pixel_x = directional_pixel_shift
		if(WEST)
			pixel_x = -directional_pixel_shift

/obj/structure/stairs/ramp/smoothing_allowed(atom/smoothing_with, direction, junction)
	if(dir != smoothing_with.dir)
		return NONE
	return junction

/obj/structure/stairs/ramp/set_smoothed_icon_state(new_junction)
	smoothing_junction = new_junction
	var/smooth_left = (smoothing_junction & turn(dir, -90))
	var/smooth_right = (smoothing_junction & turn(dir, 90))
	if(smooth_left && smooth_right)
		icon_state = "[base_icon_state]_middle"
	else if (smooth_left)
		icon_state = "[base_icon_state]_left"
	else if (smooth_right)
		icon_state = "[base_icon_state]_right"
	else
		icon_state = base_icon_state

/obj/structure/stairs/ramp/concrete
	name = "eclogiticrete ramp"
	desc = "A ramp made of eclogiticrete, with a helpful rim along the sides and directional markings for the perspective-impaired."
	icon_state = "ramp_concrete"
	base_icon_state = "ramp_concrete"
	smoothing_groups = SMOOTH_GROUP_CONCRETE_RAMP
	canSmoothWith = SMOOTH_GROUP_CONCRETE_RAMP
	build_stack = /obj/item/stack/sheet/crag_concrete

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/stairs/ramp/concrete, 10)
