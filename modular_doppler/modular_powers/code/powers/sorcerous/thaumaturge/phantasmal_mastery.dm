/datum/power/thaumaturge/phantasmal_mastery
	name = "Phantasmal Tool Mastery"
	desc = "Your experience with the Phantasmal Tool spell allows it to be cast without needing charges, though it now requires Affinity 3 in order to be cast."
	value = 3
	required_powers = list(/datum/power/thaumaturge/phantasmal_tool)

/datum/power/thaumaturge/phantasmal_mastery/post_add()
	. = ..()
	var/datum/power/thaumaturge/phantasmal_tool/tool_power = power_holder.get_power(/datum/power/thaumaturge/phantasmal_tool)
	var/datum/action/cooldown/power/thaumaturge/phantasmal_tool/tool_action = tool_power?.action_path
	if(tool_action)
		tool_action.max_charges = null
		tool_action.power_refunds = FALSE
		tool_action.required_affinity = 3
		tool_action.enable()
		var/atom/movable/ui_element = tool_action.get_atom_moveable()
		if(ui_element && tool_action.charge_overlay)
    		ui_element.cut_overlay(tool_action.charge_overlay)
    		tool_action.charge_overlay = null

/datum/power/thaumaturge/phantasmal_mastery/remove()
	. = ..()
	var/datum/power/thaumaturge/phantasmal_tool/tool_power = power_holder.get_power(/datum/power/thaumaturge/phantasmal_tool)
	var/datum/action/cooldown/power/thaumaturge/phantasmal_tool/tool_action = tool_power?.action_path
	if(tool_action)
		tool_action.max_charges = THAUMATURGE_MAX_CHARGES_BASE
		tool_action.power_refunds = TRUE
		tool_action.required_affinity = 1
