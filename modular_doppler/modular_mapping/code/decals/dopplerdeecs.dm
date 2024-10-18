/// Updating this to actually be capable of properly repainting things using the tilecoloring and Doppler colors.
/obj/item/airlock_painter/decal/tile
	color_list = list(
		list("Neutral", "#D4D4D4"),
		list("Dark", "#0e0f0f"),
		list("Burgundy", "#79150082"),
		list("Red", "#DE3A3A"),
		list("Brown", "#A46106"),
		list("Yellow", "#EFB341"),
		list("Green", "#9FED58"),
		list("Blue", "#52B4E9"),
		list("Purple", "#D381C9"),
		list("White", "#FFFFFF"),
		list("Medical", "#B3E64C"),
		list("Science", "#4CB3E6"),
		list("Engineering", "#E6A84C"),
		list("Cargo", "#C29170"),
		list("Service", "#B34CE6"),
		list("Command", "#D9E64C"),
		list("Performance", "#E64CB3"),
		list("Security", "#E64C4C"),
	)
	/// TODO: Run over this to verify that all trimline and tile options are here.
	decal_list = list(
		list("Corner", "tile_corner"),
		list("Half", "tile_half_contrasted"),
		list("Opposing Corners", "tile_opposing_corners"),
		list("3 Corners", "tile_anticorner_contrasted"),
		list("4 Corners", "tile_fourcorners"),
		list("Trimline", "trimline"),
		list("Trimline Corner", "trimline_corner"),
		list("Trimline End", "trimline_end"),
		list("Trimline Arrow", "trimline_arrow_cw"),
		list("Trimline Arrow CCW", "trimline_arrow_ccw"),
		list("Trimline Warning", "trimline_warn"),
		list("Trimline Fill", "trimline_fill"),
		list("Trimline Fill Corner", "trimline_corner_fill"),
		list("Trimline Fill L", "trimline_fill__8"), // This is a hack that lives in the spritesheet builder and paint_floor
		list("Trimline Fill End", "trimline_end_fill"),
		list("Trimline Fill Box", "trimline_box_fill"),
	)
	nondirectional_decals = list(
		"tile_fourcorners",
		"trimline_box_fill",
	)



/// Misery, we need to redefine these bc TG undef'd them
#define TRIMLINE_SUBTYPE_HELPER(path)\
##path/line {\
	icon_state = "trimline";\
}\
##path/corner {\
	icon_state = "trimline_corner";\
}\
##path/end {\
	icon_state = "trimline_end";\
}\
##path/arrow_cw {\
	icon_state = "trimline_arrow_cw";\
}\
##path/arrow_ccw {\
	icon_state = "trimline_arrow_ccw";\
}\
##path/warning {\
	icon_state = "trimline_warn";\
}\
##path/tram {\
	icon_state = "trimline_tram";\
}\
##path/mid_joiner {\
	icon_state = "trimline_mid";\
}\
##path/filled {\
	icon_state = "trimline_box_fill";\
}\
##path/filled/line {\
	icon_state = "trimline_fill";\
}\
##path/filled/corner {\
	icon_state = "trimline_corner_fill";\
}\
##path/filled/end {\
	icon_state = "trimline_end_fill";\
}\
##path/filled/arrow_cw {\
	icon_state = "trimline_arrow_cw_fill";\
}\
##path/filled/arrow_ccw {\
	icon_state = "trimline_arrow_ccw_fill";\
}\
##path/filled/warning {\
	icon_state = "trimline_warn_fill";\
}\
##path/filled/warning/corner {\
	icon_state = "trimline_corner_warn_fill";\
}\
##path/filled/mid_joiner {\
	icon_state = "trimline_mid_fill";\
}\
##path/filled/shrink_cw {\
	icon_state = "trimline_shrink_cw";\
}\
##path/filled/shrink_ccw {\
	icon_state = "trimline_shrink_ccw";\
}
/// Ditto
#define TILE_DECAL_SUBTYPE_HELPER(path)\
##path/opposingcorners {\
	icon_state = "tile_opposing_corners";\
}\
##path/half {\
	icon_state = "tile_half";\
}\
##path/half/contrasted {\
	icon_state = "tile_half_contrasted";\
}\
##path/anticorner {\
	icon_state = "tile_anticorner";\
}\
##path/anticorner/contrasted {\
	icon_state = "tile_anticorner_contrasted";\
}\
##path/fourcorners {\
	icon_state = "tile_fourcorners";\
}\
##path/full {\
	icon_state = "tile_full";\
}\
##path/diagonal_centre {\
	icon_state = "diagonal_centre";\
}\
##path/diagonal_edge {\
	icon_state = "diagonal_edge";\
}\
##path/tram {\
	icon_state = "tile_tram";\
}



/// Greenmed
/obj/effect/turf_decal/tile/doppler_med
	name = "med-green tile decal"
	color = "#B3E64C"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_med)

/obj/effect/turf_decal/trimline/doppler_med
	color = "#B3E64C"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_med)


/// Bluesci
/obj/effect/turf_decal/tile/doppler_sci
	name = "sci-blue tile decal"
	color = "#4CB3E6"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_sci)

/obj/effect/turf_decal/trimline/doppler_sci
	color = "#4CB3E6"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_sci)


/// Orangegineering
/obj/effect/turf_decal/tile/doppler_eng
	name = "eng-orange tile decal"
	color = "#E6A84C"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_eng)

/obj/effect/turf_decal/trimline/doppler_eng
	color = "#E6A84C"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_eng)


/// Cargonia forever
/obj/effect/turf_decal/tile/doppler_cargo
	name = "cargo-brown tile decal"
	color = "#C29170"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_cargo)

/obj/effect/turf_decal/trimline/doppler_cargo
	color = "#C29170"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_cargo)


/// Service But Fancy
/obj/effect/turf_decal/tile/doppler_serv
	name = "service-purple tile decal"
	color = "#B34CE6"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_serv)

/obj/effect/turf_decal/trimline/doppler_serv
	color = "#B34CE6"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_serv)


/// Command, forever tacky
/obj/effect/turf_decal/tile/doppler_cmd
	name = "command-brass tile decal"
	color = "#D9E64C"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_cmd)

/obj/effect/turf_decal/trimline/doppler_cmd
	color = "#D9E64C"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_cmd)


/// Service But Pink
/obj/effect/turf_decal/tile/doppler_perf
	name = "performance-pink tile decal"
	color = "#E64CB3"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_perf)

/obj/effect/turf_decal/trimline/doppler_perf
	color = "#E64CB3"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_perf)


/// Security
/obj/effect/turf_decal/tile/doppler_sec
	name = "security-red tile decal"
	color = "#E64C4C"

TILE_DECAL_SUBTYPE_HELPER(/obj/effect/turf_decal/tile/doppler_sec)

/obj/effect/turf_decal/trimline/doppler_sec
	color = "#E64C4C"

TRIMLINE_SUBTYPE_HELPER(/obj/effect/turf_decal/trimline/doppler_sec)



#undef TILE_DECAL_SUBTYPE_HELPER
#undef TRIMLINE_SUBTYPE_HELPER
