/// Shapechange spider override.
/datum/power/aberrant/shapechange_spider
	name = "Shapechange: Spider"
	desc = "Overrides your chosen Shapechange form with a spider variant. \n Hunters are fast but fragile, guards are slow and sturdy and ambush spiders are very slow, but have strong grabs, hard-hitting attacks and invisiblity in webs."
	value = 3

	required_powers = list(/datum/power/aberrant/shapechange)
	/// Saved form so we can restore on removal.
	var/previous_form

/datum/power/aberrant/shapechange_spider/post_add()
	. = ..()
	var/datum/action/cooldown/power/aberrant/shapechange/shape_action = get_shapechange_action()
	if(!shape_action)
		return
	previous_form = shape_action.animal_form
	shape_action.animal_form = get_spider_form()
	power_holder?.refresh_security_power_records()

/datum/power/aberrant/shapechange_spider/remove()
	var/datum/action/cooldown/power/aberrant/shapechange/shape_action = get_shapechange_action()
	if(shape_action)
		shape_action.animal_form = previous_form
		power_holder?.refresh_security_power_records()
	previous_form = null
	return ..()

/// Gets and returns the shapeshift action responsible
/datum/power/aberrant/shapechange_spider/proc/get_shapechange_action()
	if(!power_holder?.powers)
		return null
	for(var/datum/power/aberrant/shapechange/shape_power in power_holder.powers)
		var/datum/action/cooldown/power/aberrant/shapechange/shape_action = shape_power.action_path
		if(istype(shape_action))
			return shape_action
	return null

/// Gets the preference choiced options for the spider form
/datum/power/aberrant/shapechange_spider/proc/get_spider_form()
	var/choice = power_holder?.client?.prefs?.read_preference(/datum/preference/choiced/shapechange_spider_form)
	if(isnull(choice))
		choice = "Guard"
	var/spider_type = GLOB.shapechange_spider_form_types[choice]
	if(ispath(spider_type))
		return spider_type
	return GLOB.shapechange_spider_form_types["Guard"]

/// Preference choice for Shapechange spider form selection.
/datum/preference/choiced/shapechange_spider_form
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "shapechange_spider_form"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/shapechange_spider_form/create_default_value()
	return "Guard"

/datum/preference/choiced/shapechange_spider_form/init_possible_values()
	var/list/values = list()
	for(var/choice in GLOB.shapechange_spider_form_types)
		values += choice
	return values

/datum/preference/choiced/shapechange_spider_form/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return TRUE

/datum/preference/choiced/shapechange_spider_form/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/shapechange_spider
	associated_typepath = /datum/power/aberrant/shapechange_spider
	customization_options = list(/datum/preference/choiced/shapechange_spider_form)
