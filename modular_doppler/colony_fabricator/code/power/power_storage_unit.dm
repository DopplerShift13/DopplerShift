/obj/item/circuitboard/machine/battery_pack
	name = "Battery Pack"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/smes/battery_pack
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/power_store/battery = 1,
		/datum/stock_part/capacitor = 1,
	)
	def_components = list(/obj/item/stock_parts/power_store/battery = /obj/item/stock_parts/power_store/battery/high/empty)

/obj/machinery/power/smes/battery_pack
	name = "battery pack"
	desc = "A collection of large power cells wired together inside of a non-conductive box in order to stop people \
		like you from touching them and electrocuting yourself. You get the general idea that this thing should be kept \
		well away from water and fire, lest you suffer the wrath of whatever's inside the battery."
	icon = 'modular_doppler/colony_fabricator/icons/power_storage_unit/small_battery.dmi'
	input_level_max = 50 KILO WATTS
	output_level_max = 50 KILO WATTS
	resistance_flags = FLAMMABLE
	circuit = /obj/item/circuitboard/machine/battery_pack
	/// Is this battery currently undergoing a spectacular failure
	var/tesla_car_company_mode = FALSE
	/// Is the battery currently sparking and exploding
	var/sparking = FALSE

/obj/machinery/power/smes/battery_pack/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

/obj/machinery/power/smes/battery_pack/precharged
	charge = STANDARD_BATTERY_CHARGE * 10

/obj/item/circuitboard/machine/large_battery_pack
	name = "Large Battery Pack"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/smes/battery_pack/large
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/power_store/battery = 3,
		/datum/stock_part/capacitor = 1,
	)
	def_components = list(/obj/item/stock_parts/power_store/battery = /obj/item/stock_parts/power_store/battery/high/empty)

// Larger station batteries, hold more but have less in/output
/obj/machinery/power/smes/battery_pack/large
	name = "large battery pack"
	desc = "A large collection of large power cells wired together inside of a non-conductive box in order to stop people \
		like you from touching them and electrocuting yourself. This one is much larger than usual, a veritable \
		mountain of batteries just waiting to catch on fire. You get the general idea that this thing should be kept \
		well away from water and fire, lest you suffer the wrath of whatever's inside the battery."
	icon = 'modular_doppler/colony_fabricator/icons/power_storage_unit/large_battery.dmi'
	circuit = /obj/item/circuitboard/machine/large_battery_pack
	input_level_max = 12.5 KILO WATTS
	output_level_max = 12.5 KILO WATTS

/obj/machinery/power/smes/battery_pack/large/precharged
	charge = (STANDARD_BATTERY_CHARGE * 10) * 3 // There's three batteries now

// New and unique ways to blow up and die
/obj/machinery/power/smes/battery_pack/fire_act(exposed_temperature, exposed_volume)
	if(!total_charge())
		return ..() // If the battery is empty then dont explode
	spectacular_failure()
	return ..()

/obj/machinery/power/smes/battery_pack/update_overlays()
	. = ..()
	if(sparking)
		. += mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE, appearance_flags = RESET_COLOR|KEEP_APART)

/obj/machinery/power/smes/battery_pack/expose_reagents(list/reagents, datum/reagents/source, methods, volume_modifier, show_message)
	. = ..()
	if(!total_charge())
		return // If the battery is empty then dont explode
	for(var/datum/reagent/water/water in reagents)
		spectacular_failure()
		return

/// Sets our sparking state and updates it visually
/obj/machinery/power/smes/battery_pack/proc/set_sparks(new_sparking = TRUE)
	sparking = new_sparking
	update_appearance(UPDATE_OVERLAYS)

/// Rolls the dice and chooses a destructive mode of failure, only one can happen at once
/obj/machinery/power/smes/battery_pack/proc/spectacular_failure()
	if(tesla_car_company_mode)
		return // We are already about to blow up.
	tesla_car_company_mode = TRUE
	var/disaster_mode = roll("1d20")
	switch(disaster_mode)
		if(1 to 2)
			brave_lithium_battery()
			addtimer(CALLBACK(src, PROC_REF(blow_up_electrical)), 8 SECONDS)
		if(3 to 8)
			brave_lithium_battery()
			addtimer(CALLBACK(src, PROC_REF(electric_boots)), 8 SECONDS)
		if(9 to 14)
			brave_lithium_battery()
			addtimer(CALLBACK(src, PROC_REF(richard_hammond)), 8 SECONDS)
		else // You got lucky, this time
			addtimer(CALLBACK(src, PROC_REF(able_to_blow_up_again)), 2 MINUTES)

// This proc is dedicated to the brave lithium-ion batteries that risk their lives every single day
// Living and working inside of a galaxy note seven
/// Makes effects like a lithium battery about to blow up
/obj/machinery/power/smes/battery_pack/proc/brave_lithium_battery()
	set_sparks(TRUE)
	visible_message(span_boldwarning("[src] starts to hiss and spark violently!"), blind_message = span_boldwarning("You hear a violent hissing and sparking!"))
	playsound(src, 'sound/machines/steam_hiss.ogg', 50, TRUE)
	set_light(3, 2, LIGHT_COLOR_ELECTRIC_CYAN, l_on = TRUE)

/// Blows up according to how charged the battery was
/obj/machinery/power/smes/battery_pack/proc/blow_up_electrical()
	var/current_charge = total_charge()
	var/power_modifier = (current_charge / total_capacity) + 0.25 // Max charge batteries are even bigger, good luck pal
	explosion(src, 0, 1 * power_modifier, 5 * power_modifier, 7 * power_modifier, 7 * power_modifier, smoke = TRUE)
	set_sparks(FALSE)
	set_light(l_on = FALSE)
	addtimer(CALLBACK(src, PROC_REF(able_to_blow_up_again)), 30 SECONDS) // If it somehow survives it can blow up again later

/// Makes a big electric zap
/obj/machinery/power/smes/battery_pack/proc/electric_boots()
	var/current_charge = total_charge()
	tesla_zap(source = src, zap_range = 5, power = current_charge / 100, cutoff = 1e3, zap_flags = ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN | ZAP_LOW_POWER_GEN | ZAP_ALLOW_DUPLICATES)
	take_damage(max_integrity * 0.8) // At least its not blowing up this time ??
	set_sparks(FALSE)
	set_light(l_on = FALSE)
	addtimer(CALLBACK(src, PROC_REF(able_to_blow_up_again)), 30 SECONDS) // If it somehow survives it can blow up again later

/// Spawns a bunch of hydrogen and then lights it on fire
/obj/machinery/power/smes/battery_pack/proc/richard_hammond()
	var/current_charge = total_charge()
	var/power_modifier = (current_charge / total_capacity) + 0.25
	playsound(src, 'sound/effects/spray3.ogg', 50, TRUE)
	var/turf/our_turf = get_turf(src)
	our_turf.atmos_spawn_air("[GAS_HYDROGEN]=[40 * power_modifier];[GAS_O2]=[20 * power_modifier];[TURF_TEMPERATURE(FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 50)]")
	do_sparks(3, FALSE, src)
	take_damage(max_integrity * 0.8)
	set_sparks(FALSE)
	set_light(l_on = FALSE)
	addtimer(CALLBACK(src, PROC_REF(able_to_blow_up_again)), 30 SECONDS) // If it somehow survives it can blow up again later

/// Sets the battery to be able to explode once again, in case you weren't careful already
/obj/machinery/power/smes/battery_pack/proc/able_to_blow_up_again()
	tesla_car_company_mode = FALSE
