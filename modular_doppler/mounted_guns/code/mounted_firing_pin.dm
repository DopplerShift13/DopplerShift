/obj/item/firing_pin/mounted
	name = "mounted weapon firing pin"
	desc = "A firing pin that allows the gun to fire only when it is mounted to the ground."
	icon_state = "firing_pin_explorer"
	fail_message = "not mounted!"

/obj/item/firing_pin/mounted/pin_auth(mob/living/user)
	if(!istype(gun.loc, /obj/vehicle/ridden/mounted_turret))
		return FALSE // If it's not in a mounted turret, don't shoot
	return TRUE
