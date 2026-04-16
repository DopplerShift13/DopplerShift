// weakened pizza bomb
/obj/item/bombcore/miniature/pizza
	range_heavy = 0

/obj/item/bombcore/miniature/pizza/traitor
	range_heavy = 1

/obj/item/pizzabox/bomb_traitor/Initialize(mapload)
	. = ..()
	if(!pizza)
		var/randompizza = pick(subtypesof(/obj/item/food/pizza) - /obj/item/food/pizza/flatbread) //also disincludes another base type
		pizza = new randompizza(src)
		update_appearance()
	register_bomb(new /obj/item/bombcore/miniature/pizza/traitor(src))
	set_wires(new /datum/wires/explosive/pizza(src))

// venezian gene kit & laser eyes injector
/obj/item/storage/organbox/preloaded/venezia_covert_kit
	name = "\"Necronom IV\" Covert Gene Kit"
	desc = "Non-lethal biological weaponry, unapparelled terrain manipulation and a formidable acid glands make these discrete tailored organs uniquely suited for kidnapping and escapes."

/obj/item/storage/organbox/preloaded/venezia_covert_kit/PopulateContents()
	new /obj/item/organ/alien/plasmavessel(src)
	new /obj/item/organ/alien/hivenode(src)
	new /obj/item/organ/alien/resinspinner(src)
	new /obj/item/organ/alien/acid(src)
	new /obj/item/organ/alien/neurotoxin(src)

/obj/item/autosurgeon/syndicate/venezia
	uses = 5

/obj/item/storage/box/syndie_kit/venezia_covert_holder
	name = "biohazard-wrapped box"
	desc = "Contains 'experimental organelles'. What does that even mean?"

/obj/item/storage/box/syndie_kit/venezia_covert_holder/PopulateContents()
	new /obj/item/storage/organbox/preloaded/venezia_covert_kit(src)
	new /obj/item/autosurgeon/syndicate/venezia(src)

/obj/item/dnainjector/lasereyesmut/venezia
	name = "\"L'Ecarlate\" Self-Defense Optic Genemod"
	desc = "Developed as an exotic yet efficient self defense genemod,it enables optic organs to project energy blasts at will. Its development was halted due to it's side effects- a permanent, intense glow from the pupils, and hefty migraines."

// echoes-dark-locations evil ass roachbomb

/obj/item/grenade/spawnergrenade/spikeroach
	name = "spike synthroach grenade"
	desc = "Have you ever had an idea so bad you wanted to do it multiple times? Good news! Contains six spike synthroaches, re-contained and re-purposed as bioweaponry. ...again. WARNING: hostile to all non-roaches, including the user!"
	spawner_type = /mob/living/basic/cockroach/hauberoach
	deliveryamt = 6

// thinktank standard firing pin shrinkray

/obj/item/gun/energy/shrink_ray/thinktank
	pin = /obj/item/firing_pin

// cybersun lasersword implant

/obj/item/autosurgeon/imp_energy_blades
	name = "proprietary autosurgeon"
	desc = "Contains classified research implants. Property of Cybersun Industries, return to local liaison if found."
	starting_organ = /obj/item/organ/cyberimp/arm/toolkit/esword
