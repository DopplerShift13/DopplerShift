/atom/movable/screen/alert/status_effect/sulfur_burning
	name = "Boiling Pool"
	desc = "You are in a pool of boiling sulfuric water! Get the hell out of there!"
	icon_state = "terrified"

/datum/status_effect/sulfur_burning
	id = "sulfur_burning"
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/sulfur_burning
	remove_on_fullheal = TRUE

/datum/status_effect/sulfur_burning/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.is_atmos_sealed(check_hands = TRUE))
			return FALSE
	to_chat(owner, span_userdanger("The boiling water burns your body!"))
	return ..()

/datum/status_effect/sulfur_burning/tick(seconds_between_ticks)
	owner.apply_damage(rand(2,6) * seconds_between_ticks, damagetype = BURN)
	if(SPT_PROB(10, seconds_between_ticks))
		var/feedback_text = pick(list(
			"Your entire body screams with pain",
			"Your skin feels like it's coming off",
			"Your body feels like it's melting together"
		))
		to_chat(owner, span_warning("[feedback_text] as the boiling pool burns you!"))

/datum/status_effect/sulfur_burning/get_examine_text()
	return span_warning("[owner.p_They()] [owner.p_are()] burning in the sulfurous spring!")

/datum/mood_event/burning_spring
	description = "FUUUUUCK!! IT BURNS!!"
	mood_change = -5

/datum/mood_event/burning_spring_left
	description = "I really gotta check the water temperature next time..."
	mood_change = -1
	timeout = 4 MINUTES
