#define TESHARI_QUALITY_MALUS -3

/obj/item/food/meat/slab/chicken/teshari
	name = "teshari meat"
	desc = "A slab of teshari muscle, notoriously thick and chock-full of heavy metals. Does not taste very good, and is certainly not good for you."
	tastes = list("metal" = 1, "tough meat" = 1)
	foodtypes = MEAT | RAW | GORE
	venue_value = FOOD_MEAT_MUTANT
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/fat = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/lead = 1,
	)

/obj/item/food/meat/slab/chicken/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)
	RegisterSignal(src, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, GLOBAL_PROC_REF(adjust_teshari_meat_quality))

/obj/item/food/meat/slab/chicken/teshari/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/meat/steak/chicken/teshari, rand(30 SECONDS, 90 SECONDS), TRUE, TRUE)

/obj/item/food/meat/slab/chicken/teshari/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE,  /obj/item/food/meat/rawcutlet/chicken/teshari, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Cut")

/obj/item/food/meat/slab/chicken/teshari/examine(mob/user)
	. = ..()

	. += span_smallnotice("You can use a small amount of universal enzyme to boil out the lead. Won't make it taste any better, though.")

/obj/item/food/meat/steak/chicken/teshari
	name = "teshari steak"
	desc = "A prepared slab of teshari muscle. Marginally better tasting. Still as unhealthy."
	tastes = list("metal" = 1, "tough meat" = 1)
	foodtypes = MEAT | GORE
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/fat = 1,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/lead = 1,
	)

/obj/item/food/meat/steak/chicken/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)
	RegisterSignal(src, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, GLOBAL_PROC_REF(adjust_teshari_meat_quality))

/obj/item/food/meat/rawcutlet/chicken/teshari
	name = "raw teshari cutlet"
	tastes = list("metal" = 1, "tough meat" = 1)
	foodtypes = MEAT | RAW | GORE
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/lead = 0.2)

/obj/item/food/meat/rawcutlet/chicken/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)
	RegisterSignal(src, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, GLOBAL_PROC_REF(adjust_teshari_meat_quality))

/obj/item/food/meat/cutlet/chicken/teshari
	name = "teshari cutlet"
	tastes = list("metal" = 1, "tough meat" = 1)
	foodtypes = MEAT | GORE
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/lead = 0.2)

/obj/item/food/meat/cutlet/chicken/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)
	RegisterSignal(src, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, GLOBAL_PROC_REF(adjust_teshari_meat_quality))

/obj/item/food/raw_meatball/chicken/teshari
	name = "raw teshari meatball"
	tastes = list("metal" = 1, "tough meat" = 1)
	meatball_type = /obj/item/food/meatball/chicken/teshari
	patty_type = /obj/item/food/raw_patty/chicken/teshari
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/lead = 0.2)

/obj/item/food/raw_meatball/chicken/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)
	RegisterSignal(src, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, GLOBAL_PROC_REF(adjust_teshari_meat_quality))

/obj/item/food/meatball/chicken/teshari
	name = "teshari meatball"
	tastes = list("metal" = 1, "tough meat" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/lead = 0.2)

/obj/item/food/meatball/chicken/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)

/obj/item/food/raw_patty/chicken/teshari
	name = "raw teshari patty"
	tastes = list("metal" = 1, "tough meat" = 1)
	patty_type = /obj/item/food/patty/human/teshari
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/lead = 0.2)

/obj/item/food/raw_patty/chicken/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)
	RegisterSignal(src, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, GLOBAL_PROC_REF(adjust_teshari_meat_quality))

/obj/item/food/patty/human/teshari
	name = "teshari patty"
	tastes = list("metal" = 1, "tough meat" = 1)
	icon_state = "chicken_patty"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/lead = 0.2)

/obj/item/food/patty/human/teshari/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/quality_food_ingredient, TESHARI_QUALITY_MALUS)
	RegisterSignal(src, COMSIG_FOOD_GET_EXTRA_COMPLEXITY, GLOBAL_PROC_REF(adjust_teshari_meat_quality))

/datum/food_processor_process/meat/chicken
	blacklist = list(/obj/item/food/meat/slab/chicken/teshari)

/datum/food_processor_process/meat/chicken/teshari
	input = /obj/item/food/meat/slab/chicken/teshari
	output = /obj/item/food/raw_meatball/chicken/teshari
	blacklist = null

/datum/chemical_reaction/lead_neutralization
	required_container_accepts_subtypes = TRUE
	required_container = /obj/item/food/meat/slab/chicken/teshari
	reaction_tags = REACTION_TAG_FOOD | REACTION_TAG_EASY
	reaction_flags = REACTION_INSTANT
	mix_message = "As soon as the enzyme contacts the flesh, it sizzles - moisture boiling out of the muscle, taking lead residue with it..."
	mix_sound = 'sound/effects/chemistry/bufferadd.ogg'

	required_catalysts = list(
		/datum/reagent/consumable/enzyme = 0.1
	)
	required_reagents = list(/datum/reagent/lead = 0.1)

/// A simple callback function for COMSIG_FOOD_GET_EXTRA_COMPLEXITY.
/proc/adjust_teshari_meat_quality(datum/signal_source, list/extra_complexity)
	SIGNAL_HANDLER

	extra_complexity[1] += TESHARI_QUALITY_MALUS

#undef TESHARI_QUALITY_MALUS
