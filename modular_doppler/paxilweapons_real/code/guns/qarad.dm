/obj/item/gun/ballistic/automatic/sol_rifle/machinegun
	name = "\improper Qarad Light Machinegun"
	desc = "A hefty machinegun commonly seen in the hands of SolFed military types. \
		Accepts any standard SolFed rifle magazine."
	icon_state = "qarad"
	worn_icon_state = "qarad"
	inhand_icon_state = "qarad"
	bolt_type = BOLT_TYPE_OPEN
	spawn_magazine_type = /obj/item/ammo_box/magazine/c40sol_rifle
	fire_delay = 0.1 SECONDS
	recoil = 0.5
	spread = 10
	projectile_wound_bonus = -10
	suppressor_x_offset = 9

/obj/item/gun/ballistic/automatic/sol_rifle/machinegun/give_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/sol_rifle/machinegun/examine_more(mob/user)
	. = ..()
	. += "The 'Qarad' variant of the rifle, what you are looking at now, \
		is a modification to turn the weapon into a light machinegun. \
		As you can see, something went terribly wrong and the entire assembly \
		ended up upside-down. The reasoning for many of the changes is, frankly, \
		known only to the engineers working on the project. It still works, \
		and that's the important part."
	return .

/obj/item/gun/ballistic/automatic/sol_rifle/machinegun/no_mag
	spawnwithmagazine = FALSE
