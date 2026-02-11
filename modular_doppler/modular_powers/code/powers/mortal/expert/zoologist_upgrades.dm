/datum/power/expert/zoologist/creature_tamer
	name = "Creature Tamer"
	desc = "Creatures you befriend with Zooologist turn neutral and gain the 'pet commands' subsystem, allowing you to verbally command them to take certain actions. \
	Your cap of befriended creatures is reduced to 2, it no longer befriends other nearby creatures, and the creatures you tame will now be considered hostile to it's former peers."

	value = 6
	required_powers = list(/datum/power/expert/zoologist)
	action_path = null // So we don't give em another use of the ability.

/datum/power/expert/zoologist/creature_tamer/post_add()
	. = ..()
	var/datum/power/expert/zoologist/zoologist = power_holder.get_power(/datum/power/expert/zoologist)
	var/datum/action/cooldown/power/expert/zoologist/zoologist_action = zoologist.action_path // I really should find a better way to get the variables of actions.
	zoologist_action.taming = TRUE
	zoologist_action.taming_cap = 2

/datum/power/expert/zoologist/creature_tamer/remove()
	var/datum/power/expert/zoologist/zoologist = power_holder.get_power(/datum/power/expert/zoologist)
	var/datum/action/cooldown/power/expert/zoologist/zoologist_action = zoologist.action_path // I really should find a better way to get the variables of actions.
	zoologist_action.taming = FALSE
	zoologist_action.taming_cap = 0
