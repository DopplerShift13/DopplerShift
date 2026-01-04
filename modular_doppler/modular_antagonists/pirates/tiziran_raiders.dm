/datum/pirate_gang/tiziran
	name = "Tiziran Raiders"
	is_heavy_threat = TRUE
	ship_template_id = "tiziran_raider_shuttle"
	ship_name_pool = "tiziran_ships"

	threat_title = "Submit or Die!"
	threat_content = "Your warriors are weak and your masters are far from here. Surrender %PAYOFF credits to %SHIPNAME, or we will take what is ours!"
	arrival_announcement = "Your warriors are weak and your masters are far from here. Surrender or suffer!"
	possible_answers = list("We accept your gracious parlay.","Stick your head in a nacelle!")

	response_received = "We have taken what is ours!"
	response_too_late = "We wait no longer! Perish!"
	response_not_enough = "This is an insult! Perish!"
	response_rejected = "You will pay in flesh and blood!"

/datum/pirate_gang/tiziran/New()
	. = ..()
	ship_name = pick(strings(DOPPLER_PIRATE_NAMES_FILE, ship_name_pool))


/datum/outfit/pirate/tiziran
	name = "Tiziran Raider"
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/pirate
	uniform = /obj/item/clothing/under/lizard_kilt
	suit = /obj/item/clothing/suit/armor/lizard
	back = /obj/item/storage/backpack/lizard
	glasses = /obj/item/clothing/glasses/lizard_hud
	gloves = /obj/item/clothing/gloves/lizard_gloves
	head = /obj/item/clothing/head/helmet/lizard
	shoes = /obj/item/clothing/shoes/lizard_shins
	belt = /obj/item/storage/belt/lizard_sabre

/obj/effect/mob_spawn/ghost_role/human/pirate/tiziran
	name = "\improper Tiziran sleeper"
	desc = "A cryogenic stasis bed for long term space travel. Tizirans find the brief window of consciousness before hypersleep spares them the \
	chill especially unpleasant."
	you_are_text = "Whether privateer or private pirate, you are a crew of Tiziran raiders terrorizing the sector's merchant-spacers."
	flavour_text = "This utopist installation sits on a wealth of libre and minerals it can't protect. Shame for them."
	prompt_name = "Tiziran raider"
	outfit = /datum/outfit/pirate/tiziran
	rank = "swabbie"
	icon_state = "oldpod"
	base_icon_state = "oldpod"
	fluff_spawn = /obj/structure/showcase/machinery/empty_tiziran_pod

/obj/effect/mob_spawn/ghost_role/human/pirate/tiziran/create(mob/mob_possessor, newname)
	. = ..()
	var/mob/living/spawned_mob = .
	spawned_mob.faction = list(ROLE_SYNDICATE)

/obj/effect/mob_spawn/ghost_role/human/pirate/tiziran/captain
	name = "\improper Tiziran command sleeper"
	rank = "captain"

/obj/structure/showcase/machinery/empty_tiziran_pod
	name = "empty sleeper pod"
	desc = "Still cold, still humming. Whoever was in this is probably still nearby."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "oldpod-open"

/obj/machinery/suit_storage_unit/tiziran_raiders
	suit_type = /obj/item/clothing/suit/space/pirate/tiziran
	helmet_type = /obj/item/clothing/head/helmet/space/pirate/tiziran_raider
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/tank/jetpack/oxygen/harness

/obj/machinery/suit_storage_unit/tiziran_raiders/red
	suit_type = /obj/item/clothing/suit/space/pirate/tiziran/red
	helmet_type = /obj/item/clothing/head/helmet/space/pirate/tiziran_raider/red

/obj/machinery/suit_storage_unit/tiziran_raiders/yellow
	suit_type = /obj/item/clothing/suit/space/pirate/tiziran/yellow
	helmet_type = /obj/item/clothing/head/helmet/space/pirate/tiziran_raider/yellow
