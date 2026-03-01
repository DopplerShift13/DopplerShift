// Base two web crafting items that come with web_crafter
/datum/web_craft_entry/cloth
	desc = "Cloth made from your silk! Practically indistinguishable, but you might make people awkward if they start wearing clothes made from it."
	spawn_type = /obj/item/stack/sheet/cloth
	hunger_cost = 7
	craft_time = 1 SECONDS

/datum/web_craft_entry/stickyweb
	desc = "A sticky web; sticky for everyone but you. Your colleagues may not appreciate it."
	spawn_type = /obj/structure/spider/stickyweb
	hunger_cost = 5
	craft_time = 1 SECONDS
	icon = 'icons/effects/web.dmi'
	icon_state = "webpassage"

// Binding Webs
/datum/web_craft_entry/web_bola
	desc = "Sticky bola. Others can't use it without risking snaring themselves."
	spawn_type = /obj/item/restraints/legcuffs/bola/web
	hunger_cost = 10

/datum/web_craft_entry/web_restraints
	desc = "Sticky zipties. Destroyed after use; others can't use it without risking binding themselves."
	spawn_type = /obj/item/restraints/handcuffs/cable/zipties/web
	hunger_cost = 10

// Snare Webs
/datum/web_craft_entry/web_snare
	desc = "Creates a barely visible web snare that traps the legs of any mob that walk through it."
	spawn_type = /obj/structure/spider/web_snare
	hunger_cost = 10
	craft_time = 2 SECONDS

// Tripwire Webs
/datum/web_craft_entry/tripwire_web
	desc = "Creates a barely visible tripwire snare that silently tells you if a mob walk throughs it."
	spawn_type = /obj/structure/spider/tripwire_web
	hunger_cost = 5
	craft_time = 1 SECONDS

/datum/web_craft_entry/tripwire_web/spawn_structure(mob/living/user, turf/target_turf)
	return new /obj/structure/spider/tripwire_web(target_turf, user)
