// these are how players make the candy dishes for halloween

/datum/crafting_recipe/security_dish
	result = /obj/item/candy_dish/security
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/clothing/under/rank/security/doppler/guard = 1,
	)
	time = 1 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/engineering_dish
	result = /obj/item/candy_dish/engineering
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/clothing/under/rank/engineering/engineer = 1,
	)
	time = 1 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/medical_dish
	result = /obj/item/candy_dish/medical
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/clothing/under/rank/medical/doctor = 1,
	)
	time = 1 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/cargo_dish
	result = /obj/item/candy_dish/cargo
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/clothing/under/rank/cargo/tech = 1,
	)
	time = 1 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/service_dish
	result = /obj/item/candy_dish/cargo
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/clothing/under/rank/civilian/clown = 1,
	)
	time = 1 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/science_dish
	result = /obj/item/candy_dish/science
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/clothing/under/rank/rnd/scientist = 1,
	)
	time = 1 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/command_dish
	result = /obj/item/candy_dish/command
	reqs = list(
		/obj/item/reagent_containers/cup/bowl = 1,
		/obj/item/clothing/under/rank/captain = 1,
	)
	time = 1 SECONDS
	category = CAT_MISC
