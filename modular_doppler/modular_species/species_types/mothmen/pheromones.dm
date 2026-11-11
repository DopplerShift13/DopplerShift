/obj/effect/moth_dust
	name = "Pheromone cloud"
	desc = "A cloud of dust and pheromones communicable only to Veniri senses"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	var/message = "This dust cloud isn't communicating much of anything at the moment"

/obj/effect/moth_dust/Initialize(mapload)
	. = ..()
	var/image/dust_image = image(icon = icon, loc = src, icon_state = icon_state, layer = OBJ_LAYER)
	dust_image.layer = OBJ_LAYER
	dust_image.override = TRUE
	apply_wibbly_filters(dust_image)
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/pheromone_user, "moth_dust", dust_image)
	new /obj/effect/particle_effect/sparks/quantum(get_turf(src))

/obj/effect/moth_dust/examine(mob/user)
	. = ..()
	. += span_slime(message)

/obj/effect/moth_dust/attack_hand(mob/living/user, list/modifiers)
	. = ..()

	var/new_message = input(user, "What should this dust cloud read?", "Pheromone Editing")
	if(isnull(new_message) || new_message == "")
		return
	else
		user.visible_message(span_notice("You begin to alter the pheromone cloud's message"))
		if(!do_after(user, 2 SECONDS ))
			return
		message = new_message
		new /obj/effect/particle_effect/sparks/quantum(get_turf(src))


/obj/effect/moth_dust/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	user.visible_message(span_notice("You begin to spread disperse the dust and pheromone mixture away."))
	if(do_after(user, 2 SECONDS ))
		qdel(src)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN


/datum/atom_hud/alternate_appearance/basic/pheromone_user/mobShouldSee(mob/viewer)
	if(!isliving(viewer))
		return FALSE
	return viewer.GetComponent(/datum/component/pheromone_user)

/datum/action/cooldown/spell/conjure/pheromone_cloud
	name = "Create Dust Cloud"
	desc = "Create a cloud of Veniri Pheromones ready to have a message imprinted on them."
	sound = 'sound/effects/magic/summonitems_generic.ogg'
	button_icon_state = "smoke"

	school = SCHOOL_CONJURATION
	cooldown_time = 30 SECONDS
	spell_requirements = null

	invocation_type = INVOCATION_NONE

	summon_radius = 0
	summon_amount = 1
	summon_type = list(/obj/effect/moth_dust)

/datum/component/pheromone_user
	//We use this to cleanly track the spell and who can see dust clouds
	var/datum/action/cooldown/spell/conjure/pheromone_cloud/action = new

/datum/component/pheromone_user/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/pheromone_user/RegisterWithParent()
	action.Grant(parent)

/datum/component/pheromone_user/UnregisterFromParent()
	action.Remove(parent)



