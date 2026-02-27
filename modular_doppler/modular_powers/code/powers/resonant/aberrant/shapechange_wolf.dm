/** Inside you are two wolves. This one's an example of how to override the shapechange with special mobs.
**/
/datum/power/aberrant/shapechange_wolf
	name = "Shapechange: Wolf"
	desc = "Overrides your chosen Shapechange form with a Wolf; a sturdy creature with a strong bite attack."
	value = 1

	required_powers = list(/datum/power/aberrant/shapechange)
	/// Saved form so we can restore on removal.
	var/previous_form

/datum/power/aberrant/shapechange_wolf/post_add()
	. = ..()
	var/datum/action/cooldown/power/aberrant/shapechange/shape_action = get_shapechange_action()
	if(!shape_action)
		return
	previous_form = shape_action.animal_form
	shape_action.animal_form = /mob/living/basic/mining/wolf

/datum/power/aberrant/shapechange_wolf/remove()
	var/datum/action/cooldown/power/aberrant/shapechange/shape_action = get_shapechange_action()
	if(shape_action)
		shape_action.animal_form = previous_form
	previous_form = null
	return ..()

/datum/power/aberrant/shapechange_wolf/proc/get_shapechange_action()
	if(!power_holder?.powers)
		return null
	for(var/datum/power/aberrant/shapechange/shape_power in power_holder.powers)
		var/datum/action/cooldown/power/aberrant/shapechange/shape_action = shape_power.action_path
		if(istype(shape_action))
			return shape_action
	return null
