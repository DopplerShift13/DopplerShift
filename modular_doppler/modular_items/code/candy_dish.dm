// departmental candy dispensers to ensure that there's always something for trick-or-treaters.
// bowls being a structure is kind of weird but since its something thats meant to sit on a table and be interacted with rather than in the user's hand,
// its easier to do it this way and use a seperate held /obj/item, like chairs, so players don't have to drag these around on the ground.

/obj/structure/candy_dish
	name = "hypothetical candy dish"
	abstract_type = /obj/structure/candy_dish
	icon = 'modular_doppler/modular_items/icons/candy_dish.dmi'
	/// list of things that we spawn from here. much like a loot spawner, rarity can be controlled by adding multiple to a list i.e. /obj/item/food/doppler_candy/lemon_drops = 4
	var/list/candy_list
	/// the /obj/item/ this turns into when picked up
	var/bowl_item

// interacting takes something from the candy list and applies a brief status effect that makes you too embarassed to take more
/obj/structure/candy_dish/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!user.ckey)
		return
	if(user.has_status_effect(/datum/status_effect/candy_taker))
		balloon_alert(user, "It's rude to take more so soon.")
		return
	else
		var/mob/living/carbon/candy_taker = user
		var/obj/item/candy = (pick_weight_recursive(candy_list))
		var/obj/item/our_candy = new candy(loc)
		candy_taker.put_in_hands(our_candy)
		balloon_alert(user, "You take a [our_candy.name].")
		candy_taker.apply_status_effect(/datum/status_effect/candy_taker)
		return

// turns this into an item when someone drags it to their sprite
/obj/structure/candy_dish/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(!isliving(user) || over != user)
		return

	user.visible_message(span_notice("[user] grabs \the [src.name]."), span_notice("You grab \the [src.name]."))
	balloon_alert(user, "Picked up bowl.")
	var/obj/item/candy_dish = new bowl_item(loc)
	user.put_in_hands(candy_dish)
	qdel(src)

// 30 seconds to refresh so people don't just make piles of unwanted candy at one bowl
/datum/status_effect/candy_taker
	id = "candy_taker"
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null

// this is the item that corresponds to each bowl structure
/obj/item/candy_dish
	name = "hypothetical candy dish"
	abstract_type = /obj/item/candy_dish
	icon = 'modular_doppler/modular_items/icons/candy_dish.dmi'
	throwforce = 10
	hitsound = 'sound/items/trayhit/trayhit1.ogg'
	/// our corresponding dish structure
	var/obj/structure/candy_dish/bowl_structure

/obj/item/candy_dish/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deployable, 1 SECONDS, bowl_structure)

// every department gets a unique dish with a different list of goodies, to encourage trick-or-treating.

/obj/structure/candy_dish/security
	name = "\improper Port Safety candy dish"
	desc = "A stalwart bastion of sweet treats in a bold red color."
	icon_state = "security"
	// red and spicy things, donuts
	candy_list = list(
		/obj/item/food/doppler_candy/red_twigs = 7,
		/obj/item/food/doppler_candy/tamarind = 5,
		/obj/item/food/doppler_candy/spicy_reds = 7,
		/obj/item/food/candiedapple = 2,
		/obj/item/food/donut/berry = 1,
		/obj/item/food/candy_corn = 1,
		/obj/item/food/cornchips/red = 3,
		/obj/item/food/donut = 4,
		/obj/item/food/donut/jelly/berry = 1,
		/obj/item/food/donut/choco = 1,
		/obj/item/food/hot_shots = 2,
	)
	bowl_item = /obj/item/candy_dish/security

/obj/item/candy_dish/security
	name = "\improper Port Safety candy dish"
	desc = "A stalwart bastion of sweet treats in a bold red color."
	icon_state = "security"
	bowl_structure = /obj/structure/candy_dish/security

/obj/structure/candy_dish/engineering
	name = "precisely engineered candy dish"
	desc = "Though it looks like a mundane blown glass bowl, it's actually perfectly radially symmetrical to the single micromiliter, \
	resulting in a zero percent increase in its efficacy as a bowl."
	icon_state = "engineering"
	// sour and yellow candy
	candy_list = list(
		/obj/item/food/doppler_candy/nuke_fuel = 7,
		/obj/item/food/doppler_candy/lemon_drops = 7,
		/obj/item/food/doppler_candy/energizerz = 3,
		/obj/item/food/sticko/pineapple = 3,
		/obj/item/food/shok_roks/random = 3,
		/obj/item/food/cakeslice/mothmallow = 2,
		/obj/item/food/pistachios = 2,
	)
	bowl_item = /obj/item/candy_dish/engineering

/obj/item/candy_dish/engineering
	name = "precisely engineered candy dish"
	desc = "Though it looks like a mundane blown glass bowl, it's actually perfectly radially symmetrical to the single micromiliter, \
	resulting in a zero percent increase in its efficacy as a bowl."
	icon_state = "engineering"
	bowl_structure = /obj/structure/candy_dish/engineering

/obj/structure/candy_dish/medical
	name = "perfectly sterilized candy dish"
	desc = "Strict interpretations of the Hippocratic Oath lead to disappointing contents for this one."
	icon_state = "medical"
	// toothbrushes and healthy stuff, yuck!
	candy_list = list(
		/obj/item/toothbrush = 10, // effed up
		/obj/item/food/doppler_candy/dentabite = 5,
		/obj/item/storage/box/gum/mint = 5,
		/obj/item/food/mint = 1,
		/obj/item/food/grown/banana = 2,
		/obj/item/food/grown/citrus/orange = 2,
		/obj/item/food/no_raisin/healthy = 5,
		/obj/item/food/peanuts/random = 5,
		/obj/item/food/pistachios = 3,
		/obj/item/food/semki/healthy = 3,
	)
	bowl_item = /obj/item/candy_dish/medical

/obj/item/candy_dish/medical
	name = "perfectly sterilized candy dish"
	desc = "Strict interpretations of the Hippocratic Oath lead to disappointing contents for this one."
	icon_state = "medical"
	bowl_structure = /obj/structure/candy_dish/medical

/obj/structure/candy_dish/cargo
	name = "productive and punctual candy dish"
	desc = ""
	icon_state = "cargo"
	// rock candy, jawbreakers, premium box candy
	candy_list = list(
		/obj/item/food/doppler_candy/jawbreaker = 20, // higher values to make the jumbo jabreaker a rarer pull
		/obj/item/food/doppler_candy/jawbreaker = 1,
		/obj/item/food/doppler_candy/sour_brat_kits = 20,
		/obj/item/food/doppler_candy/milk_balls = 10,
		/obj/item/food/chococoin = 7,
		/obj/item/food/fudgedice = 5,
		/obj/item/food/cnds/random = 5,
		/obj/item/food/spacetwinkie = 5,
		/obj/item/food/peanuts/random = 5,
		/obj/item/food/sticko/random = 3,
	)
	bowl_item = /obj/item/candy_dish/cargo

/obj/item/candy_dish/cargo
	name = "productive and punctual candy dish"
	desc = ""
	icon_state = "cargo"
	bowl_structure = /obj/structure/candy_dish/cargo

/obj/structure/candy_dish/service
	name = ""
	desc = ""
	icon_state = "service"
	// chocolates, fruity candy, tiny liquor bottles
	candy_list = list(
		/obj/item/reagent_containers/cup/glass/bottle/whiskey/tiny = 5,
		/obj/item/reagent_containers/cup/glass/bottle/amaretto/tiny = 5,
		/obj/item/food/doppler_candy/orange_leather = 5,
		/obj/item/food/doppler_candy/sour_melon_leather = 5,
		/obj/item/food/candiedapple = 3,
		/obj/item/food/chocolatebar = 3,
		/obj/item/food/chocoorange = 3,
		/obj/item/food/bonbon/peanut_butter_cup = 2,
	)
	bowl_item = /obj/item/candy_dish/service

/obj/item/candy_dish/service
	name = ""
	desc = ""
	icon_state = "service"
	bowl_structure = /obj/structure/candy_dish/service

/obj/structure/candy_dish/science
	name = ""
	desc = ""
	icon_state = "science"
	candy_list = list(
	)
	bowl_item = /obj/item/candy_dish/science

/obj/item/candy_dish/science
	name = ""
	desc = ""
	icon_state = "science"
	bowl_structure = /obj/structure/candy_dish/service
