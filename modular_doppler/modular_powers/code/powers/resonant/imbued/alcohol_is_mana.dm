/*
	Alcohol is mana! Basically lets you upscale your cooldowns greatly by consuming alcohol.
	Effects are transfered using a signaler.
*/
/datum/power/imbued/alcohol_is_mana
	name = "Alcohol is Mana"
	desc = "Whilst some are still trying to understand if the concept of 'Mana' is real and whether it is a substance or just an ephemeral energy, you certainly have found your 'Mana'.\
	\nYour Enchanted root power has increased effectiveness depending on your degree of intoxication, up to a maximum of 500% increased effectiveness."
	security_record_text = "Subject seems to be able to wield existing magical powers much more often when inebriated."
	security_threat = POWER_THREAT_MAJOR
	value = 2
	magic_flags = POWER_MAGIC_STANDARD

	required_powers = list(/datum/power/imbued_root/enchanted)
	menu_icon = 'icons/obj/drinks/mixed_drinks.dmi'
	menu_icon_state = "wizz_fizz"

	/// How much drunkenness contributes to Enchanted's bonus recovery percentage.
	var/alcohol_to_recovery_percent = 5
	/// The cap on how much bonus recovery percentage Alcohol is Mana! can contribute.
	var/maximum_recovery_percent = 500

/datum/power/imbued/alcohol_is_mana/add(client/client_source)
	. = ..()
	RegisterSignal(power_holder, COMSIG_IMBUED_ENCHANTED_RECOVERY_MODIFIERS, PROC_REF(add_enchanted_recovery_modifier))

/datum/power/imbued/alcohol_is_mana/remove()
	. = ..()
	UnregisterSignal(power_holder, COMSIG_IMBUED_ENCHANTED_RECOVERY_MODIFIERS)

/// Sends a signal to Enchanted to modify the given amount based on your durnkenness.
/datum/power/imbued/alcohol_is_mana/proc/add_enchanted_recovery_modifier(mob/living/source, list/recovery_bonus_percents)
	SIGNAL_HANDLER

	if(!istype(source))
		return NONE

	var/drunk_amount = source.get_drunk_amount()
	if(drunk_amount <= 0)
		return NONE

	recovery_bonus_percents += min(drunk_amount * alcohol_to_recovery_percent, maximum_recovery_percent)
	return NONE
