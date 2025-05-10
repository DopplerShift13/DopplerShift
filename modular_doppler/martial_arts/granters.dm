/obj/item/book/granter/martial/mad_dog
	martial = /datum/martial_art/mad_dog
	name = "old earth manuscript"
	martial_name = "the mad dog's style"
	desc = "A small, black booklet that has traveled a very long way."
	greet = span_bolddanger("You have learned The Mad Dog's Style. Even now, you can feel your musculature hardening like steel.")
	icon_state = "book1"
	remarks = list(
		"The art of pencak silat...",
		"Strangle before snap...",
		"An unstoppable force, yielding to no wounds...",
		"Opportune pressure-points...",
		"Squeezing a trigger is like ordering takeout...",
		"Twenty men enter...",
		"No numbers can hold you down...",
	)

/obj/item/book/granter/martial/mad_dog/on_reading_finished(mob/living/carbon/user)
	. = ..()
	if(uses <= 0)
		to_chat(user, span_warning("[src] catches fire, pages fluttering into wisps of flame!"))
	AddComponent(/datum/component/burning, custom_fire_overlay() || GLOB.fire_overlay, burning_particles)

/obj/item/book/granter/martial/mad_dog/recoil(mob/living/user) // because you can put out the initial fire that happens once you stop reading it
	to_chat(user, span_warning("[src] catches fire the moment you open the cover!"))
	AddComponent(/datum/component/burning, custom_fire_overlay() || GLOB.fire_overlay, burning_particles)
