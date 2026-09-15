/obj/item/firing_pin/mounted
	name = "mounted weapon interlock"
	desc = "A mechanism that only allows the gun to fire when it is mounted to the ground."
	icon_state = "firing_pin_explorer"
	fail_message = "not mounted!"
	pin_removable = FALSE

/obj/item/firing_pin/mounted/pin_auth(mob/living/user)
	if(!istype(gun.loc, /obj/vehicle/ridden/mounted_turret))
		return FALSE // If it's not in a mounted turret, don't shoot
	return TRUE
