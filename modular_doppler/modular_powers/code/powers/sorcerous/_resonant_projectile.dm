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
	// We have to play coy with the existing magic resistance system, for checking against resonance use victim.can_block_resonance(antimagic_charge_cost)
	var/antimagic_flags = MAGIC_RESISTANCE
	/// determines the drain cost on the antimagic item
	var/antimagic_charge_cost = 1

	// The power that made the projectile.
	var/datum/action/cooldown/power/creating_power

// TODO: actually uhh, add resonant anti-magic to this lmao.
/obj/projectile/resonant/prehit_pierce(atom/target)
	. = ..()

	if(isliving(target))
		var/mob/living/victim = target
		if(victim.can_block_magic(antimagic_flags, antimagic_charge_cost) || victim.can_block_resonance(antimagic_charge_cost))
			visible_message(span_warning("[src] fizzles on contact with [victim]!"))
			return PROJECTILE_DELETE_WITHOUT_HITTING

	if(istype(target, /obj/machinery/hydroponics)) // even plants can block antimagic
		var/obj/machinery/hydroponics/plant_tray = target
		if(!plant_tray.myseed)
			return
		if(plant_tray.myseed.get_gene(/datum/plant_gene/trait/anti_magic))
			visible_message(span_warning("[src] fizzles on contact with [plant_tray]!"))
			return PROJECTILE_DELETE_WITHOUT_HITTING
