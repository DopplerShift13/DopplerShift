#define HEAT_EFFECT_COOLDOWN (3 SECONDS)

/datum/component/powerful_heat_radiator
	/// How far away should mobs be directly warmed?
	var/range = 3
	/// How much should the temperature change per second?
	var/temp_per_second = 0.1 // 1C per 10 seconds
	/// What body temperature should we bring mobs up to?
	var/max_temperature = BODYTEMP_HEAT_DAMAGE_LIMIT + 5 // A little too spicy for humans
	/// A list of being heated to active alerts
	var/list/mob/living/current_alerts = list()
	/// Cooldown between showing the heat effect
	COOLDOWN_DECLARE(last_heat_effect_time)

/datum/component/powerful_heat_radiator/Initialize(range = 4, temp_per_second = 0.05, max_temperature = BODYTEMP_HEAT_DAMAGE_LIMIT + 5)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	START_PROCESSING(SSaura, src)
	src.range = range
	src.temp_per_second = temp_per_second
	src.max_temperature = max_temperature

/datum/component/powerful_heat_radiator/Destroy(force)
	STOP_PROCESSING(SSaura, src)
	var/alert_category = "aura_heating_[REF(src)]"
	for(var/mob/living/alert_holder as anything in current_alerts)
		alert_holder.clear_alert(alert_category)
	current_alerts.Cut()
	return ..()

/datum/component/powerful_heat_radiator/process(seconds_per_tick)
	var/should_show_effect = COOLDOWN_FINISHED(src, last_heat_effect_time)
	if(should_show_effect)
		COOLDOWN_START(src, last_heat_effect_time, HEAT_EFFECT_COOLDOWN)
	var/list/to_heat = list()
	var/alert_category = "aura_heating_[REF(src)]"
	for(var/mob/living/candidate in view(range, parent))
		to_heat[candidate] = TRUE
	for(var/mob/living/candidate as anything in to_heat)
		if(!current_alerts[candidate])
			var/atom/movable/screen/alert/aura_heating/alert = candidate.throw_alert(alert_category, /atom/movable/screen/alert/aura_heating, new_master = parent)
			alert.desc = "You can feel the heat blasting off of [parent]."
			current_alerts[candidate] = TRUE
		candidate.adjust_bodytemperature(temp_per_second, max_temp = max_temperature)
		if(should_show_effect)
			new /obj/effect/temp_visual/radiator_heat(get_turf(candidate))
	for(var/mob/living/remove_alert_from as anything in current_alerts - to_heat)
		remove_alert_from.clear_alert(alert_category)
		current_alerts -= remove_alert_from

/atom/movable/screen/alert/aura_heating
	name = "Radiator Heating"
	icon_state = "template"

/obj/effect/temp_visual/radiator_heat //color is white by default, set to whatever is needed
	name = "heating steam"
	icon = 'icons/effects/steam.dmi'
	icon_state = "steam_triple"
	duration = 1 SECONDS
	alpha = 155

/obj/effect/temp_visual/radiator_heat/Initialize(mapload)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

#undef HEAT_EFFECT_COOLDOWN
