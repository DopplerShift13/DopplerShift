/datum/design/ration
	name = "Foreign Colonization Ration"
	id = "slavic_mre"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 550)
	build_path = /obj/item/storage/box/colonial_rations
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/pljeskavica
	name = "Foreign Colonization Ration, Main Course"
	id = "slavic_burger"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 200)
	build_path = /obj/item/food/colonial_course/pljeskavica
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/nachos
	name = "Foreign Colonization Ration, Side Dish"
	id = "mexican_chips"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 150)
	build_path = /obj/item/food/colonial_course/nachos
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/blins
	name = "Foreign Colonization Ration, Dessert"
	id = "slavic_crepes"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/food/colonial_course/blins
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/spork
	name = "Foreign Colonization Ration, Utensils"
	id = "slavic_utens"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 75)
	build_path = /obj/item/storage/box/utensils
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/bubblegum
	name = "Foreign Colonization Ration, Bubblegum Pack"
	id = "slavic_gum"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/storage/box/gum/colonial
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/cup
	name = "Empty Paper Cup"
	id = "slavic_cup"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 10)
	build_path = /obj/item/reagent_containers/cup/glass/coffee/colonial/empty
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/replicator_sugar
	name = "Sugar"
	id = "slavic_sugar"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 5)
	make_reagent = /datum/reagent/consumable/sugar
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)

/datum/design/water
	name = "Water"
	id = "slavic_water"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 1)
	make_reagent = /datum/reagent/water
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_COLONIAL_FOOD,
	)
