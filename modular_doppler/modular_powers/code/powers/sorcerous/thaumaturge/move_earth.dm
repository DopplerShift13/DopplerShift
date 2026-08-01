/datum/power/thaumaturge/move_earth
	name = "Move Earth"
	desc = "Fires a blast of arcane power which can destroy rock. \
	\nRequires Affinity 2."
	security_record_text = "Subject can conjure kinetic blasts similar to those created by excavation tools."
	security_threat = POWER_THREAT_MAJOR
	value = 4

	action_path = /datum/action/cooldown/power/thaumaturge/move_earth
	required_powers = list(/datum/power/thaumaturge_root)
	required_allow_subtypes = TRUE

/datum/action/cooldown/power/thaumaturge/move_earth
	name = "Move Earth"
	desc = "Fires a blast of arcane power which can destroy rock."
	button_icon = 'icons/obj/mining.dmi'
	button_icon_state = "kineticgun"

	max_charges = 0 // To do otherwise would make mining with this a real chore
	required_affinity = 2
	anti_magic_on_target = FALSE

	/// The projectile we fire
	var/obj/projectile/projectile_path = /obj/projectile/kinetic/miner
	cooldown_time = 2 SECONDS
	click_to_activate = TRUE
	aim_assist = FALSE // complex targeting
