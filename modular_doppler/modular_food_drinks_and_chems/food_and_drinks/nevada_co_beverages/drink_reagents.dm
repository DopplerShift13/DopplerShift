/datum/reagent/consumable/icetea/nevada
	name = "Nevada Iced Tea"
	description = "A patent pending concotion of the leaf dust left on the floor of a tea processing plant \
	and sweetener blends."
	color = "#755c2e"
	taste_description = "sweet green tea"

/datum/reagent/consumable/berryjuice/blueberry
	name = "Blueberry Juice"
	description = "A delicious juicing of one particular kind of berry."
	color = "#4c3cd8"
	taste_description = "blueberries"

/datum/reagent/consumable/berryjuice/raspberry
	name = "Raspberry Juice"
	description = "A delicious juicing of one particular kind of berry."
	color = "#921b35"
	taste_description = "raspberries"

/datum/reagent/consumable/lemonade/nevada
	name = "Nevada Lemonade"
	description = "Sweet, tangy lemonade. Good for the soul, proprietary recipe."
	color = "#FFE978"
	taste_description = "sunshine and summertime"

/datum/reagent/consumable/nutriment/clown_preworkout
	name = "Nevada PowerClown Pre-Workout Blend"
	description = "A vile blend of protein. Useful for bulking up, if you can keep it down."
	color = "#f17d86"
	quality = DRINK_NICE
	taste_description = "powdered chalk and oat milk"
	brute_heal = 0.6
	nutriment_factor = 6 // watered down
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	default_container = /obj/item/reagent_containers/cup/soda_cans/doppler/nevada_tea/preworkout

/datum/reagent/consumable/ethanol/gin_goblin
	name = "Gin Goblin"
	description = "A splash of dry gin watered down with a healthy serving of Nevada iced tea."
	color = "#96d6b6"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "sweet and tart"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/chemical_reaction/drink/gin_goblin
	results = list(/datum/reagent/consumable/ethanol/gin_goblin = 10)
	required_reagents = list(
		/datum/reagent/consumable/ethanol/gin = 5,
		/datum/reagent/consumable/icetea/nevada = 5,
	)
	reaction_tags = REACTION_TAG_DRINK | REACTION_TAG_EASY | REACTION_TAG_OTHER

/datum/reagent/consumable/ethanol/clown_cream
	name = "Clown Cream"
	description = "A vile concotion of protein powder, heavy cream, egg yolk, and grain alcohol first popularized by an obscure \
	old holovid about a boxer."
	color = "#96d6b6"
	boozepwr = 45
	taste_description = "a dire concotion of protein and fat"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_MEDIUM

/datum/chemical_reaction/drink/clown_cream
	results = list(/datum/reagent/consumable/ethanol/clown_cream = 15)
	required_reagents = list(
		/datum/reagent/consumable/nutriment/clown_preworkout = 5,
		/datum/reagent/consumable/cream = 3,
		/datum/reagent/consumable/eggyolk = 2,
		/datum/reagent/consumable/ethanol/hooch = 5,
	)
	reaction_tags = REACTION_TAG_DRINK | REACTION_TAG_EASY | REACTION_TAG_OTHER
