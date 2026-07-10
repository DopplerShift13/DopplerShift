/*
	Alcohol is mana! Basically lets you upscale your cooldowns greatly by consuming alcohol.
	Effects are handled on Enchanted's side.
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

/datum/power/imbued/alcohol_is_mana/post_add()
	. = ..()
	var/datum/power/imbued_root/enchanted/enchanted = power_holder.get_power(/datum/power/imbued_root/enchanted)
	if(enchanted)
		enchanted.alcohol_is_mana = TRUE

/datum/power/imbued/alcohol_is_mana/remove()
	. = ..()
	var/datum/power/imbued_root/enchanted/enchanted = power_holder.get_power(/datum/power/imbued_root/enchanted)
	if(enchanted)
		enchanted.alcohol_is_mana = FALSE
