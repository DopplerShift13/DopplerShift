// Makes jetpacks lower power
// MOD jetpacks consume twice the power
// Gas jetpacks have a lower top speed

/obj/item/tank/jetpack
	full_speed = FALSE
	drift_force = 0.25 NEWTONS
	stabilizer_force = 0.2 NEWTONS

/obj/item/tank/jetpack/improvised
	drift_force = 0.2 NEWTONS
	stabilizer_force = 0.1 NEWTONS

/obj/item/tank/jetpack/oxygen/captain
	drift_force = 0.5 NEWTONS
	stabilizer_force = 0.5 NEWTONS

/obj/item/mod/module/jetpack
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.1
	drift_force = 0.25 NEWTONS
	stabilizer_force = 0.2 NEWTONS

/obj/item/mod/module/jetpack/advanced
	drift_force = 0.5 NEWTONS
	stabilizer_force = 0.5 NEWTONS
