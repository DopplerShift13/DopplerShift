/obj/item/food/doppler_candy
	icon = 'modular_doppler/modular_food_drinks_and_chems/icons/candy.dmi'
	abstract_type = /obj/item/food/doppler_candy
	food_flags = FOOD_FINGER_FOOD
	foodtypes = JUNKFOOD | SUGAR
	junkiness = 25
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_2

// security candy, which is red and spicy things.

/obj/item/food/doppler_candy/red_twigs
	name = "\improper Red Twigs licorice"
	desc = "Waxy sugar sticks with a hollow core. They aren't that bad when they haven't been sitting on top of a \
	primary school teacher's desk for seven years."
	icon_state = "red_twigs"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 10,
	)
	tastes = list("red #9" = 1, "wax" = 1, "slight sweetness" = 1)

/obj/item/food/doppler_candy/tamarind
	name = "\improper Tamaro tamarind candy"
	desc = "The candied fruit of the tamarind tree rolled in chili powder, a classic Central American treat that's \
	spread across settled space with the help of key partnership campigns with idols and influencers. Consequently, \
	a lot of people eating it lately don't seem to know if they should be enjoying themselves."
	icon_state = "tamarind"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/nutriment = 1,	// technically contains fruit
	)
	tastes = list("mild chile" = 1, "fruity flavor" = 1, "sugary sweetness" = 1)

/obj/item/food/doppler_candy/spicy_reds
	name = "\improper Spicy Reds cinammon drops"
	desc = "Ellipsoidic grains of gum arabic, corn syrup, and artificial cinammon flavorings. In spite of the name, \
	these are utterly mild."
	icon_state = "spicy_reds"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 10,
	)
	tastes = list("vaguely cinammonesque flavorings" = 3, "stale gum" = 1)

// engineering candy, which is yellow and sour.

/obj/item/food/doppler_candy/nuke_fuel
	name = "\improper Nuke Fuel sour candy"
	desc = "The popular rumor about a kid burning a hole in his tongue with these was actually true. There were photographs \
	of it. It hasn't done anything to slow sales."
	icon_state = "nuke_fuel"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 4,
		/datum/reagent/consumable/lemonjuice = 1,
		/datum/reagent/consumable/sour_sugar = 10,
	)
	tastes = list("battery acid" = 2, "citric acid" = 1, "sugary sweetness" = 1)

/obj/item/food/doppler_candy/lemon_drops
	name = "\improper Citraheadz lemon drops"
	desc = "A long time ago these would be made by rolling lemon juice and simple syrup together in a hot skillet. \
	Now they're made by tumbling lemon juice and simple syrup together in a drum, but it doesn't stop people from \
	confidently claiming that these aren't as good."
	icon_state = "lemon_drops"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 5,
	)
	tastes = list("lemon" = 3, "sugary sweetness" = 2, "nostalgia" = 1)

/obj/item/food/doppler_candy/energizerz
	name = "\improper Energizerz caffeinated drops"
	desc = "A potently caffeinated pill with a dizzying array of additional extracts. These are pretty famous on influencer-driven\
	social media for a robust partnership campaign and pretty infamous to healthcare professionals for being linked to caffeine \
	overdoses. A clause on the back label admonishes against eating these if you're pregnant, elderly, or under 18."
	icon_state = "energizerz"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/medicine/modafinil = 10,	// good luck!
		/datum/reagent/consumable/coffee = 10,
	)
	tastes = list("sour medicine" = 1, "bitterness" = 2, "despair" = 1)

// medical stuff. it sucks.

/obj/item/food/doppler_candy/dentabite
	name = "\improper Dentabite dental chew"
	desc = "Compressed xantham gum and gelatin with mint for flavor and fresh breath. No one said you had to be a \
	dog to have one."
	icon_state = "dentabite"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,	// the healthiest thing in this lineup
	)
	tastes = list("a healthy treat" = 1, "hygenic fun" = 1, "green food coloring" = 1)
	foodtypes = JUNKFOOD

/obj/item/toothbrush	// barring us adding dental mechanics this only exists for the medical candy dish and does nothing
	name = "toothbrush"
	desc = "A soft bristled cleaning brush for your teeth."
	icon = 'modular_doppler/modular_food_drinks_and_chems/icons/candy.dmi'
	icon_state = "toothbrush"

/obj/item/food/bubblegum/mint_gum
	name = "mint gum"
	desc = "A stick of seafoam green spearmint flavored gum arabic."
	color = "#7cbea5"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 1,
		/datum/reagent/consumable/mintextract = 2,
	)
	tastes = list("mint" = 3,)

/obj/item/storage/box/gum/mint
	name = "mint gum packet"
	desc = "Emblazoned with a near familir logo. Upon closer inspection, this is clearly the generic version, and for a discount \
	grocer to boot."
	icon = 'modular_doppler/modular_food_drinks_and_chems/icons/candy.dmi'
	icon_state = "mint_gum"
	spawning_gum_type = /obj/item/food/bubblegum/mint_gum

// cargo candy. expensive box candy, jawbreakers, rock candy

/obj/item/food/doppler_candy/jawbreaker
	name = "jawbreaker"
	desc = "A candy core rolled in industrial drums with flavored and dyed syrups until it reaches a ponderous size. \
	Cracking one apart reveals sedimentary candy layers."
	icon_state = "jawbreaker"
	worn_icon = 'modular_doppler/modular_food_drinks_and_chems/icons/food_mob_icons.dmi'
	worn_icon_state = "jawbreaker"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 5,
	)
	slot_flags = ITEM_SLOT_MASK


// picks a color and makes us chewable
/obj/item/food/doppler_candy/jawbreaker/Initialize(mapload)
	. = ..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	AddElement(/datum/element/chewable)

/obj/item/food/doppler_candy/jawbreaker/jumbo
	name = "\improper Heavy Hitter jawbreaker"
	desc = "Behold. It's gargantuan. A near perfect spheroid with the powdery smell of confectioner's sugar and syrup."
	icon_state = "heavy_hitter"
	food_reagents = list( // rare pull so its like an improved lollipop
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/iron = 10,
		/datum/reagent/consumable/sugar = 20,
		/datum/reagent/medicine/omnizine = 5,
	)

/obj/item/food/doppler_candy/rock_candy
	name = "rock candy"
	desc = "Sugar cooled into crystaline crags on a charming little stick. The hard edges are intimidating to lick, but the \
	colorful glassy transparency is too alluring to resist."
	icon_state = "rock_candy_stick"
	worn_icon = 'modular_doppler/modular_food_drinks_and_chems/icons/food_mob_icons.dmi'
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/medicine/mine_salve = 5, // it's rocks
		/datum/reagent/consumable/sugar = 5,
	)
	var/mutable_appearance/head
	var/head_color = rgb(0, 0, 0)

// we reproduce some lollipop icon cutting stuff because it doesn't like having children
/obj/item/food/doppler_candy/rock_candy/Initialize(mapload)
	. = ..()
	head = mutable_appearance('modular_doppler/modular_food_drinks_and_chems/icons/candy.dmi', "rock_candy")
	change_head_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))
	AddElement(/datum/element/chewable)

/obj/item/food/doppler_candy/rock_candy/proc/change_head_color(C)
	head_color = C
	cut_overlay(head)
	head.color = C
	add_overlay(head)

/obj/item/food/rock_candy/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..(hit_atom)
	throw_speed = 1
	throwforce = 0

/obj/item/food/doppler_candy/sour_brat_kits
	name = "\improper Sour Brat Kits sour gummy candy"
	desc = "A popular candy from the Shattered Empire that can be generously described as a facisimile of a Tajara rendered in sugary \
	gelatin and rolled in a sour coating. The advertising campaign features the little candies wreaking havoc on polite Tajara society, \
	hence the evocative name."
	icon_state = "sour_brat_kits"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/sour_sugar = 5,
	)
	tastes = list("currant" = 1, "citric acid" = 2, "citron" = 1, "candy melon" = 1)

/obj/item/food/doppler_candy/milk_balls
	name = "box of malted milk balls"
	desc = ""
	icon_state = "milk_balls"
	food_reagents = list(
		/datum/reagent/consumable/milk = 3,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/coco = 2,
	)

// service candy, chocolate and fruit

/obj/item/food/doppler_candy/orange_leather
	name = "\improper Outrageous Orange fruit snack"
	desc = ""
	icon_state = "orange_leather"
	food_reagents = list(
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/consumable/orangejuice = 2,
	)

/obj/item/food/doppler_candy/sour_melon_leather
	name = "\improper Sour Melon fruit snack"
	desc = ""
	icon_state = "sour_melon_leather"
	food_reagents = list(
		/datum/reagent/consumable/sour_sugar = 3,
		/datum/reagent/consumable/watermelonjuice = 2,
	)

/obj/item/food/doppler_candy/mizzie_mast
	name = "\improper Mizzie Mast promotional chocolate bar"
	desc = ""
	icon_state = "mizzie_mast"
