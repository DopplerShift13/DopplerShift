/obj/item/gun/ballistic/automatic/sol_rifle/machinegun
	name = "\improper Qarad Heavy Rapid Blaster"
	desc = "A large Donk(tm) blaster capable of rapidly throwing darts across the room."
	icon_state = "qarad"
	worn_icon_state = "qarad"
	inhand_icon_state = "qarad"
	bolt_type = BOLT_TYPE_OPEN
	spawn_magazine_type = /obj/item/ammo_box/magazine/c40sol_rifle
	fire_delay = 0.1 SECONDS
	spread = 10
	projectile_wound_bonus = -10
	suppressor_x_offset = 9
	gun_flags = NOT_A_REAL_GUN
	clumsy_check = FALSE

/obj/item/gun/ballistic/automatic/sol_rifle/machinegun/give_autofire()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/sol_rifle/machinegun/no_mag
	spawnwithmagazine = FALSE
