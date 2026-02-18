/obj/item/reagent_containers/applicator/pill/tea_brick
	name = "tea brick"
	desc = "A highly compressed brick of tea, To be broken into pieces and put into hot water. \
		The symbols of the 4CA are stamped onto the top, along with the personal seal of a farm \
		on New Gibraltar."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/foods.dmi'
	icon_state = "human_tea"
	layers_remaining = 15 // gives you time to think about your mistakes
	volume = 36
	list_reagents = list(
		/datum/reagent/toxin/teapowder = 36
	)
	w_class = WEIGHT_CLASS_SMALL
	/// What the brick can be broken into
	var/break_type = /obj/item/reagent_containers/applicator/pill/tea_brick_piece
	/// How many pieces is it broken into
	var/break_amount = 6

/obj/item/reagent_containers/applicator/pill/tea_brick/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/processable, TOOL_KNIFE, break_type, break_amount, 5 SECONDS, table_required = TRUE, screentip_verb = "Break")

/obj/item/reagent_containers/applicator/pill/tea_brick/mushroom
	name = "mushroom tea brick"
	desc = "A highly compressed brick of tea, To be broken into pieces and put into hot water. \
		The three moons of Tiziria are stamped onto the top, along with a certificate of quality \
		in worn down Khaishhs."
	icon_state = "lizard_tea"
	list_reagents = list(
		/datum/reagent/toxin/mushroom_powder = 36
	)

/obj/item/reagent_containers/applicator/pill/tea_brick_piece
	name = "tea brick piece"
	desc = "A highly compressed piece from a larger tea brick. Ideally put into hot water, rather than in your mouth."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/foods.dmi'
	icon_state = "human_tea_piece"
	layers_remaining = 1
	volume = 6
	list_reagents = list(
		/datum/reagent/toxin/teapowder = 6
	)

/obj/item/reagent_containers/applicator/pill/tea_brick_piece/mushroom
	name = "mushroom tea brick piece"
	icon_state = "lizard_tea_piece"
	list_reagents = list(
		/datum/reagent/toxin/mushroom_powder = 6
	)

/obj/item/food/cheese/firm_cheese_slice/bigger
	name = "firm cheese mini wheel"
	desc = "A wheel of nice, firm cheese. Smaller than it looks on the menu when you order it."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/foods.dmi'
	icon_state = "cheese"
	food_reagents = list(/datum/reagent/consumable/nutriment/fat = 6)

/obj/item/food/breadslice/hardtack
	name = "ship's bread"
	desc = "Known by many names that are far less flattering, a round piece of bread weighing a little over a tenth of a kilogram, \
		the same as every single other one that looks like it."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/foods.dmi'
	icon_state = "wheat_hardtack"
	foodtypes = GRAIN
	tastes = list("bread" = 8, "regret" = 2,)
	food_reagents = list(/datum/reagent/consumable/nutriment/stabilized = 12)

/obj/item/food/breadslice/roottack
	name = "sandbread"
	desc = "What can only barely be called bread, an important staple of the surface-faring Tizirian of history long ago."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/foods.dmi'
	icon_state = "root_hardtack"
	foodtypes = VEGETABLES | NUTS
	tastes = list("bread" = 8, "nuts" = 2, "regret" = 3,)
	food_reagents = list(/datum/reagent/consumable/nutriment/stabilized = 12)

/obj/item/food/aspic
	abstract_type = /obj/item/food/aspic
	name = "empty aspic"
	desc = "Wait, it's just gelatin?"
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/foods.dmi'
	icon_state = "aspic"
	alpha = 230
	food_reagents = list(/datum/reagent/consumable/nutriment/stabilized = 8)
	/// What type of soup we should emulate the flavours and colours of
	var/datum/reagent/consumable/nutriment/soup/soup_type

/obj/item/food/aspic/Initialize(mapload)
	. = ..()
	color = soup_type::color
	tastes = soup_type::data

// vegetable soup

/obj/item/food/aspic/vegetable_soup
	name = "vegetable aspic"
	desc = "Condensed vegetable soup, which could be eaten raw if you are either a psycho, high class, or both. \
		For everyone else, it should be boiled in a pot to turn back into soup."
	soup_type = /datum/reagent/consumable/nutriment/soup/vegetable_soup
	foodtypes = VEGETABLES

/datum/chemical_reaction/food/soup/vegetable_soup_aspic
	required_reagents = list(/datum/reagent/water = 30)
	required_ingredients = list(
		/obj/item/food/aspic/vegetable_soup = 1,
	)
	results = list(
		/datum/reagent/consumable/nutriment/soup/vegetable_soup = 30,
	)

// miso

/obj/item/food/aspic/miso
	name = "miso aspic"
	desc = "Condensed miso soup, which could be eaten raw if you are either a psycho, high class, or both. \
		For everyone else, it should be boiled in a pot to turn back into soup."
	soup_type = /datum/reagent/consumable/nutriment/soup/miso
	foodtypes = VEGETABLES | BREAKFAST

/datum/chemical_reaction/food/soup/miso_soup_aspic
	required_reagents = list(/datum/reagent/water = 30)
	required_ingredients = list(
		/obj/item/food/aspic/miso = 1,
	)
	results = list(
		/datum/reagent/consumable/nutriment/soup/miso = 30,
	)

// borschchchsst

/obj/item/food/aspic/beet
	name = "borscht aspic"
	desc = "Condensed borscht, which could be eaten raw if you are either a psycho, high class, or both. \
		For everyone else, it should be boiled in a pot to turn back into soup."
	soup_type = /datum/reagent/consumable/nutriment/soup/white_beet
	foodtypes = VEGETABLES

/datum/chemical_reaction/food/soup/borscht_aspic
	required_reagents = list(/datum/reagent/water = 30)
	required_ingredients = list(
		/obj/item/food/aspic/beet = 1,
	)
	results = list(
		/datum/reagent/consumable/nutriment/soup/white_beet = 30,
	)

// tizirian black broth

/obj/item/food/aspic/black_broth
	name = "black broth aspic"
	desc = "Condensed Tizirian black broth, which could be eaten raw if you are either a psycho, high class, or both. \
		For everyone else, it should be boiled in a pot to turn back into soup."
	soup_type = /datum/reagent/consumable/nutriment/soup/black_broth
	foodtypes = MEAT | VEGETABLES | GORE

/datum/chemical_reaction/food/soup/black_broth_aspic
	required_reagents = list(/datum/reagent/water = 30)
	required_ingredients = list(
		/obj/item/food/aspic/black_broth = 1,
	)
	results = list(
		/datum/reagent/consumable/nutriment/soup/black_broth = 30,
	)

// satsuma soup

/obj/item/food/aspic/satsuma
	name = "satsuma black aspic"
	desc = "Condensed Satsuma black soup, which could be eaten raw if you are either a psycho, high class, or both. \
		For everyone else, it should be boiled in a pot to turn back into soup."
	soup_type = /datum/reagent/consumable/nutriment/soup/satsuma_black
	foodtypes = MEAT | VEGETABLES | GORE

/datum/chemical_reaction/food/soup/satsuma_aspic
	required_reagents = list(/datum/reagent/water = 30)
	required_ingredients = list(
		/obj/item/food/aspic/satsuma = 1,
	)
	results = list(
		/datum/reagent/consumable/nutriment/soup/satsuma_black = 30,
	)

// assorted containers (but small)

/obj/item/reagent_containers/condiment/flour/small_ration
	name = "small flour sack"
	desc = "A maritime ration-sized portion of flour, containing just enough to make a single good loaf of bread to fuel the day."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/food_containers.dmi'
	list_reagents = list(/datum/reagent/consumable/flour = 15)
	possible_transfer_amounts = list(5, 10, 15)
	volume = 15

/obj/item/reagent_containers/condiment/rice/small_ration
	name = "small rice sack"
	desc = "A maritime ration-sized portion of rice, containing just enough to make the universe's saddest rice dish."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/food_containers.dmi'
	list_reagents = list(/datum/reagent/consumable/rice = 10)
	possible_transfer_amounts = list(5, 10)
	volume = 10

/obj/item/reagent_containers/condiment/sugar/small_ration
	name = "small sugar sack"
	desc = "A maritime ration-sized portion of sugar, containing just enough to make the day just a tiny bit sweeter."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/food_containers.dmi'
	list_reagents = list(/datum/reagent/consumable/sugar = 10)
	possible_transfer_amounts = list(5, 10)
	volume = 10

/obj/item/reagent_containers/condiment/small_ration_korta_flour
	name = "small korta flour sack"
	desc = "A maritime ration-sized portion of korta flour, containing just enough to make a single good loaf of bread to fuel the day."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/food_containers.dmi'
	icon_state = "flour_korta"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/korta_flour = 10)
	possible_transfer_amounts = list(5, 10)
	volume = 10
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/soymilk/small_ration
	name = "small soy milk"
	desc = "It's soy milk. White and nutritious goodness! This one is significantly smaller than normal cartons; just enough to make some rootdough with."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/food_containers.dmi'
	list_reagents = list(/datum/reagent/consumable/soymilk = 15)
	possible_transfer_amounts = list(5, 10, 15)
	volume = 15

/obj/item/reagent_containers/condiment/milk/small_ration
	name = "small milk"
	desc = "It's milk. White and nutritious goodness! This one is significantly smaller than normal cartons; just enough to make some cheese with."
	icon = 'modular_doppler/modular_quirks/paycheck_rations/icons/food_containers.dmi'
	list_reagents = list(/datum/reagent/consumable/milk = 15)
	possible_transfer_amounts = list(5, 10, 15)
	volume = 15
