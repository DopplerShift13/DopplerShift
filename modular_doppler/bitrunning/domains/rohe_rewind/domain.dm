/datum/lazy_template/virtual_domain/rohe_rewind
	name = "Rohe Rewind"
	desc = "Constructed from detailed environmental scans of a training field for the Rohe Gvardi on NG, you too can experience a combat \
		simulation against state-labelled terrorists with nearly equal weaponry to you! Note: This domain is open to other runners across \
		the system, and requires them to play the part of the bad guys in order to proceed correctly."
	forced_outfit = /datum/outfit/rohe_gvardi
	help_text = "Push through and defeat the rogue army at the end in order to claim their cache."
	map_dir = "_maps/virtual_domains/doppler"
	key = "rohe_rewind"
	map_name = "rohe_rewind"
	announce_to_ghosts = TRUE
	cost = BITRUNNER_COST_MEDIUM
	difficulty = BITRUNNER_DIFFICULTY_MEDIUM
	reward_points = BITRUNNER_REWARD_HIGH
	spawner_role = "military opposing force"
	mission_min_candidates = 1
	mission_max_candidates = 4
	secondary_loot = list(
		/obj/item/clothing/head/helmet/rohe = 1,
		/obj/item/bitrunning_disk/item/sabine = 1,
	)
	external_load_flags = DOMAIN_FORBIDS_ABILITIES

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/opposing_force
	name = "Opposing Force"
	outfit = /datum/outfit/rogue_army
	prompt_name = "a local bitrunner opposing force"
	flavour_text = "Play the part of a Kaitiaki militant that defends the end of the training course from the incoming assault team."
	you_are_text = "You are a Kaitiaki militant under assault by 4CA aligned local Gvardi. Cooperate with your allies and defeat the incoming assault."
	important_text = "Defend your cache at all costs!"
	allow_loadout = FALSE
