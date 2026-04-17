/// Unholy mobs for various Theologist powers. Includes subtypes.
GLOBAL_LIST_INIT(unholy_mobs, typecacheof(list(
	/mob/living/basic/mining, // mining mobs
	/mob/living/simple_animal/hostile/asteroid, // mining mobs
	/mob/living/simple_animal/hostile/megafauna, // megafauna
	/mob/living/basic/boss, //megafauna
	/mob/living/basic/skeleton, // undead
	/mob/living/basic/zombie, // undead
	/mob/living/basic/revenant, // undead
	/mob/living/basic/construct, // cult constructs
	/mob/living/basic/heretic_summon, // heretic
)))

/// Shapechanger power.
GLOBAL_LIST_INIT(shapechange_form_types, list(
	"Parrot" = /mob/living/basic/parrot,
	"Penguin" = /mob/living/basic/pet/penguin/emperor,
	"Stoat" = /mob/living/basic/stoat,
	"Fox" = /mob/living/basic/pet/fox,
	"Cat" = /mob/living/basic/pet/cat,
	"Corgi" = /mob/living/basic/pet/dog/corgi,
	"Mouse" = /mob/living/basic/mouse,
	"Lizard" = /mob/living/basic/lizard,
	"Snake" = /mob/living/basic/snake,
	"Cockroach" = /mob/living/basic/cockroach,
	"Duct Spider" = /mob/living/basic/spider/maintenance,
	"Bat" = /mob/living/basic/bat,
	"Butterfly" = /mob/living/basic/butterfly,
))

/// Shapechanger: Spider power.
GLOBAL_LIST_INIT(shapechange_spider_form_types, list(
	"Hunter" = /mob/living/basic/spider/giant/hunter,
	"Guard" = /mob/living/basic/spider/giant/guard,
	"Ambush" = /mob/living/basic/spider/giant/ambush,
))

/// Light sizes for bioluminescene
GLOBAL_LIST_INIT(bioluminescence_sizes, list(
	"Small" = 2,
	"Medium" = 3,
	"Large" = 4,
))
