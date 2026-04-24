// overrides various easy sources of tg sec batons

/datum/crafting_recipe/secbot
	reqs = list(
		/obj/item/assembly/signaler = 1,
		/obj/item/clothing/head/helmet/sec = 1,
		/obj/item/melee/baton/doppler_security = 1,
		/obj/item/assembly/prox_sensor = 1,
		/obj/item/bodypart/arm/right/robot = 1,
	)

/mob/living/simple_animal/bot/secbot
	baton_type = /obj/item/melee/baton/doppler_security

/datum/supply_pack/security/baton
	contains = list(/obj/item/melee/baton/doppler_security = 3)
