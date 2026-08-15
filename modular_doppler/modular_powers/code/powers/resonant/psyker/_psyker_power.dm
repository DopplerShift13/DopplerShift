
/datum/power/psyker_power
	name = "Abstract Psyker Power"
	desc = "My claivoyance lets me see into the unseen: \
	and oh god it has shown this debug code. Please report this!"
	abstract_parent_type = /datum/power/psyker_power

	archetype = POWER_ARCHETYPE_RESONANT
	path = POWER_PATH_PSYKER
	priority = POWER_PRIORITY_BASIC
	magic_flags = POWER_MAGIC_STANDARD | POWER_MAGIC_MENTAL
	required_powers = list(/datum/power/psyker_root)
	required_allow_subtypes = TRUE
