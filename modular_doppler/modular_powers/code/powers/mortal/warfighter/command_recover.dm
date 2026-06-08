/*
	Gets someone up as if shook a couple of times. Also contains the lore dump on how commander powers work and their overarching mechanics.
	Gateway power for all the commander stuff
*/
/datum/power/warfighter/command_recover
	name = "Commander"
	desc = "There's many facets to a good leader, but being able to delegate and manage people under pressure is an art of it's own. \
	You gain the 'Command: Recover' ability. Using it on someone will cause them to recover from stuns faster (as if shook on help intent). Has a moderate cooldown. \
	For any and all command abilities in this category, the effect is increased if you are in the same department as the target, and even further if you are a head of staff (regardless of department). \
	Command abilities can never be used on yourself, and require the target to be able to see or hear you."
	security_record_text = "Subject has an unusual charisma and can motivate others to recover from incapacitating effects faster."
	value = 4
	action_path = /datum/action/cooldown/power/warfighter/command/recover

/datum/action/cooldown/power/warfighter/command/recover
	name = "Command: Recover"
	desc = "Command a target to recover, with an effect similar to shaking them with help intent several times."

	cooldown_time = 200
	button_icon = 'icons/hud/guardian.dmi'
	button_icon_state = "dextrous"
	action_symbol = "move"

/datum/action/cooldown/power/warfighter/command/recover/use_action(mob/living/user, mob/living/carbon/target)
	..()
	// Basically the same amounts as shaking up twice multiplied by commander modifiers.
	target.AdjustStun(-6 SECONDS * (commander_modifier + 1))
	target.AdjustKnockdown(-6 SECONDS * (commander_modifier + 1))
	target.AdjustUnconscious(-6 SECONDS * (commander_modifier + 1))
	target.AdjustSleeping(-10 SECONDS * (commander_modifier + 1))
	target.AdjustParalyzed(-6 SECONDS * (commander_modifier + 1))
	target.AdjustImmobilized(-6 SECONDS * (commander_modifier + 1))
	target.shake_up_animation() // visual
	return TRUE
