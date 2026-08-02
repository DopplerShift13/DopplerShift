// Base two web crafting items that come with web_crafter
/datum/web_craft_entry/cloth
	desc = "Cloth made from your silk! Practically indistinguishable, but you might make people awkward if they start wearing clothes made from it."
	spawn_type = /obj/item/stack/sheet/cloth
	cost = ABERRANT_HUNGER_TRIVIAL * 3.5
	craft_time = 1 SECONDS

/datum/web_craft_entry/stickyweb
	desc = "A sticky web; sticky for everyone but you. Your colleagues may not appreciate it."
	spawn_type = /obj/structure/spider/stickyweb
	cost = ABERRANT_HUNGER_TRIVIAL * 2.5
	craft_time = 1 SECONDS
	icon = 'icons/effects/web.dmi'
	icon_state = "webpassage"

// Binding Webs
/datum/web_craft_entry/web_bola
	desc = "Sticky bola. Others can't use it without risking snaring themselves."
	spawn_type = /obj/item/restraints/legcuffs/bola/web
	cost = ABERRANT_HUNGER_MINOR / 2

/datum/web_craft_entry/web_restraints
	desc = "Sticky zipties. Destroyed after use; others can't use it without risking binding themselves."
	spawn_type = /obj/item/restraints/handcuffs/cable/zipties/web
	cost = ABERRANT_HUNGER_MINOR / 2

// Snare Webs
/datum/web_craft_entry/web_snare
	desc = "Creates a barely visible web snare that traps the legs of any mob that walk through it."
	spawn_type = /obj/structure/spider/web_snare
	cost = ABERRANT_HUNGER_MINOR / 2
	craft_time = 2 SECONDS

// Tripwire Webs
/datum/web_craft_entry/tripwire_web
	desc = "Creates a barely visible tripwire snare that silently tells you if a mob walk throughs it."
	spawn_type = /obj/structure/spider/tripwire_web
	cost = ABERRANT_HUNGER_TRIVIAL * 2.5
	craft_time = 1 SECONDS

/datum/web_craft_entry/tripwire_web/spawn_structure(mob/living/user, turf/target_turf)
	return new /obj/structure/spider/tripwire_web(target_turf, user)
