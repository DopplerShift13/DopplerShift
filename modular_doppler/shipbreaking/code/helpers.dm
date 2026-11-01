/// How much difference in turf pressure between sides of an object will make it explode when disassembled
#define PRESSURE_DIFF_TO_EXPLODE 50

/// Checks between all sides of an object, returning a dir to explode in if a high enough pressure difference is detected
/atom/proc/check_pressure_rupture_direction()
	var/atmos_pressure_difference = 0
	var/rupture_direction = null
	var/list/adjacent_turfs = get_adjacent_open_turfs(src)
	for(var/turf/open/adjacent_turf as anything in adjacent_turfs)
		var/turf/open/opposite_turf = get_step(src, get_dir(adjacent_turf, src))
		if(!istype(opposite_turf))
			continue
		adjacent_turfs -= opposite_turf // stops us from double checking turfs
		var/adjacent_pressure = adjacent_turf.air.return_pressure()
		var/opposite_pressure = opposite_turf.air.return_pressure()
		var/temporary_pressure_difference = abs(adjacent_pressure - opposite_pressure)
		atmos_pressure_difference = max(temporary_pressure_difference, atmos_pressure_difference)
		if(adjacent_pressure > opposite_pressure)
			rupture_direction = get_dir(adjacent_turf, opposite_turf)
		else
			rupture_direction = get_dir(opposite_turf, adjacent_turf)
	return rupture_direction

#undef PRESSURE_DIFF_TO_EXPLODE
