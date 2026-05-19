// Ideally if you make projectiles for this system that are resonant based, you use this one to actually auto-handle the antimagic stuff.
// Otherwise this is largely similar to obj/projectile/magic
/obj/projectile/resonant
	name = "bolt"
	icon_state = "energy"
	damage = 0 // MOST magic projectiles pass the "not a hostile projectile" test, despite many having negative effects
	damage_type = OXY
	armour_penetration = 100
	armor_flag = NONE
	/// determines what type of antimagic can block the spell projectile.
	/// We have to play coy with the existing magic resistance system, for checking against resonance use victim.can_block_resonance(antimagic_charge_cost)
	var/antimagic_flags = MAGIC_RESISTANCE
	/// determines the drain cost on the antimagic item
	var/antimagic_charge_cost = ANTIRESONANCE_BASE_CHARGE_COST

	/// The power that made the projectile.
	var/datum/action/cooldown/power/creating_power

// TODO: actually uhh, add resonant anti-magic to this lmao.
/obj/projectile/resonant/prehit_pierce(atom/target)
	. = ..()

	if(isliving(target))
		var/mob/living/victim = target
		if(victim.can_block_resonance(antimagic_charge_cost) || victim.can_block_magic(antimagic_flags, antimagic_charge_cost))
			visible_message(span_warning("[src] fizzles on contact with [victim]!"))
			return PROJECTILE_DELETE_WITHOUT_HITTING

	if(istype(target, /obj/machinery/hydroponics)) // even plants can block antimagic
		var/obj/machinery/hydroponics/plant_tray = target
		if(!plant_tray.myseed)
			return
		if(plant_tray.myseed.get_gene(/datum/plant_gene/trait/anti_magic))
			visible_message(span_warning("[src] fizzles on contact with [plant_tray]!"))
			return PROJECTILE_DELETE_WITHOUT_HITTING

// Signalers for dispels; in the event you're shooting into an antimagic zone or something like that.
/obj/projectile/resonant/fire(fire_angle, atom/direct_target)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))

/obj/projectile/resonant/Destroy()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	UnregisterSignal(src, COMSIG_ATOM_DISPEL)

/// Vanishes the projectile when it is dispelled.
/obj/projectile/resonant/proc/on_dispel(obj/projectile/projectile, atom/dispeller)
	SIGNAL_HANDLER
	if(dispeller)
		projectile.visible_message(span_warning("[name] disappears into thin air as it makes contact with [dispeller]!"))
	else
		projectile.visible_message(span_warning("[name] disappears into thin air!"))
	qdel(projectile)
