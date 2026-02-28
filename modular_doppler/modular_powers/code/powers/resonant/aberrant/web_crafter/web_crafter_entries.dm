// Base two web crafting items that come with web_crafter
/datum/web_craft_entry/cloth
	desc = "Cloth made from your silk! Practically indistinguishable, but you might make people awkward if they start wearing clothes made from it."
	spawn_type = /obj/item/stack/sheet/cloth
	hunger_cost = 7

/datum/web_craft_entry/stickyweb
	desc = "A sticky web; sticky for everyone but you. Your colleagues may not appreciate it."
	spawn_type = /obj/structure/spider/stickyweb
	hunger_cost = 5
	icon = 'icons/effects/web.dmi'
	icon_state = "webpassage"

// Snare Crafter
/datum/web_craft_entry/web_bola
	spawn_type = /obj/item/restraints/legcuffs/bola/web
	hunger_cost = 10

/datum/web_craft_entry/web_restraints
	spawn_type = /obj/item/restraints/handcuffs/cable/zipties/web
	hunger_cost = 10

// Tripwire Webs
/datum/web_craft_entry/tripwire_web
	spawn_type = /obj/structure/spider/tripwire_web
	hunger_cost = 5

/datum/web_craft_entry/tripwire_web/spawn_structure(mob/living/user, turf/target_turf)
	return new /obj/structure/spider/tripwire_web(target_turf, user)
