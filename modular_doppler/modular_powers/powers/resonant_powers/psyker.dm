

/datum/power/paracausal
	name = "Paracausal Gland"
	desc = "An organ found only in the central nervous systems of Psykers that doesn't entirely exist on our plane of existence. \
	Technically a Deviancy; however, due to its nature, this gland does not interfere with advanced psychic abilities. Violently interferes with a Dantian."
	cost = 5
	root_power = /datum/power/paracausal
	power_type = TRAIT_PATH_SUBTYPE_PSYKER
	blacklist = list(/datum/power/astral_dantian, /datum/power/umbral_dantian)

/obj/item/organ/resonant/paracausal
	name = "paracausal gland"
	desc = "An organ found only in the central nervous systems of Psykers that doesn't entirely exist on our plane of existence. Technically a Deviancy; however, due to its nature, this gland does not interfere with advanced psychic abilities. Violently interferes with a Dantian."
	icon_state = "tongueplasma"
	w_class = WEIGHT_CLASS_TINY

/datum/power/paracausal/add(mob/living/carbon/human/target)
	var/obj/item/organ/resonant/paracausal/para_organ = new ()
	para_organ.Insert(target, special = TRUE)

/datum/power/paracasual/cooldown/spell/forcewall/psychic_wall
	name = "Psychic Wall"
	desc = "Form a psychic wall, able to deflect projectiles and prevent things from going through."
	cost = 3
	root_power = /datum/power/paracausal
	power_type = TRAIT_PATH_SUBTYPE_PSYKER
	blacklist = list(/datum/power/astral_dantian, /datum/power/umbral_dantian)

/datum/power/paracasual/cooldown/spell/forcewall/psychic_wall/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/forcewall/psychic_wall(target.mind || target)
	new_action.Grant(target)

/datum/power/paracasual/cooldown/spell/pointed/psychic_projection
	name = "Psychic Projection"
	desc = "Project your psychics into a target to warp their view, and instill absolute terror that will cause them to fire their gun rapidly."
	cost = 3
	root_power = /datum/power/paracausal
	power_type = TRAIT_PATH_SUBTYPE_PSYKER
	blacklist = list(/datum/power/astral_dantian, /datum/power/umbral_dantian)

/datum/power/paracasual/cooldown/spell/pointed/psychic_projection/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/pointed/psychic_projection(target.mind || target)
	new_action.Grant(target)

/datum/power/paracasual/cooldown/spell/charged/psychic_booster
	name = "Psychic Projection"
	desc = "Project your psychics into a target to warp their view, and instill absolute terror that will cause them to fire their gun rapidly."
	cost = 2
	root_power = /datum/power/paracausal
	power_type = TRAIT_PATH_SUBTYPE_PSYKER
	blacklist = list(/datum/power/astral_dantian, /datum/power/umbral_dantian)

/datum/power/paracasual/cooldown/spell/charged/psychic_booster/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/charged/psychic_booster(target.mind || target)
	new_action.Grant(target)
