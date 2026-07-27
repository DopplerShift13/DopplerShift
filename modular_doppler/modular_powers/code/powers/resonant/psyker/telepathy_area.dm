/datum/power/psyker_power/telepathy_area
	name = "Telepathy Area"
	desc = "Allows you to right click with your telepathy power to send the message to all creatures currently in view!"
	security_record_text = "Subject can initiate one-way communication with all visible targets."
	value = 1
	required_powers = list(/datum/power/psyker_power/telepathy)

/datum/power/psyker_power/telepathy_area/post_add()
	. = ..()
	var/datum/power/psyker_power/telepathy/telepathy_power = power_holder.get_power(/datum/power/psyker_power/telepathy)
	var/datum/action/cooldown/power/psyker/telepathy/telepathy_action = telepathy_power?.action_path
	if(telepathy_action)
		telepathy_action.aoe_enabled = TRUE
		telepathy_action.desc = "Allows you to mentally communicate messages to the target. Left click to send the message to one target, right click to all targets in view, middle click to toggle speech-bubble while typing. ."

/datum/power/psyker_power/telepathy_area/remove()
	. = ..()
	var/datum/power/psyker_power/telepathy/telepathy_power = power_holder.get_power(/datum/power/psyker_power/telepathy)
	var/datum/action/cooldown/power/psyker/telepathy/telepathy_action = telepathy_power?.action_path
	if(telepathy_action)
		telepathy_action.aoe_enabled = FALSE
		telepathy_action.desc = initial(telepathy_action.desc)
