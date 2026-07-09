/* Simple example of an upgrade, though more like a sidegrade here.
Most of the effects are already baked into the existing power for convenience.
*/
/datum/power/theologist/imbue_armaments
	name = "Imbue Armaments"
	desc = "Changes Smiting Strike to no longer be removed when it passes hands, and allows you to have an unlimited amount of items blessed. Reduces the smite effect's knockback by 2 and damage by 5."
	security_record_text = "Subject can bless the weapons of others to enhance their lethality."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	required_powers = list(/datum/power/theologist/smiting_strike)

/datum/power/theologist/imbue_armaments/post_add()
	. = ..()
	var/datum/power/theologist/smiting_strike/smiting_strike = power_holder.get_power(/datum/power/theologist/smiting_strike)
	var/datum/action/cooldown/power/theologist/smiting_strike/smite_action = smiting_strike.action_path // I really should find a better way to get the variables of actions.
	smite_action.smite_damage -= 5
	smite_action.smite_knockback -= 2
	smite_action.can_imbue_multiples = TRUE

/datum/power/theologist/imbue_armaments/remove()
	var/datum/power/theologist/smiting_strike/smiting_strike = power_holder.get_power(/datum/power/theologist/smiting_strike)
	var/datum/action/cooldown/power/theologist/smiting_strike/smite_action = smiting_strike.action_path
	smite_action.smite_damage += 5
	smite_action.smite_knockback += 2
	smite_action.can_imbue_multiples = FALSE
