/obj/item/bombcore/miniature/pizza //I'm making the original safe rather than creating a safe sub-type since I believe there are more random places for a pizzabomb to spawn that we don't want to gib
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

