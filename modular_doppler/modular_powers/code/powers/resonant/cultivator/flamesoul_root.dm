/datum/power/cultivator_root/flame_soul
	name = "Flame Soul Alignment"
	desc = "You gain Energy through Aura by being able to see exposed fires (bonfires, plasma fires, etc.) or if you are on fire yourself. Activating it gives you a burning hot aura, causing your punches to do extra burn damage.\
	\nPassively, your high temprature threshold is increased by 60C regardless of species. Activating the alignment makes you completely immune to fire (but does not extinguish them).\
	\nYou gain armor III (with laser VI and fire X) across your whole body. Has diminishing effects with your worn armor."
	security_record_text = "Subject is capable of entering a heightened state by observing fires, granting them resistance to damage (especially lasers & fire), deadlier punches and the ability to ignore hot tempratures and fire."
	security_threat = POWER_THREAT_MAJOR
	action_path = /datum/action/cooldown/power/cultivator/alignment/flame_soul
	value = 6

	/// bonus to heat tolerance
	var/heat_tolerance_bonus = 60

// Gives innate resistance to heat.
/datum/power/cultivator_root/flame_soul/post_add()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_heat_damage_limit += heat_tolerance_bonus

/datum/power/cultivator_root/flame_soul/remove()
	. = ..()
	if(!iscarbon(power_holder))
		return
	var/mob/living/carbon/owner = power_holder
	owner.dna.species.bodytemp_heat_damage_limit -= heat_tolerance_bonus

/datum/action/cooldown/power/cultivator/alignment/flame_soul
	name = "Flame Soul Alignment"
	desc = "Activates your Astral-Touched Alignment aura, granting you immunity to fire, increasing your defenses (if unarmored), and increasing your strength with unarmed attacks."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "sacredflame"

	alignment_outline_color = "#e99a3f"
	alignment_activation_sound = 'sound/effects/magic/fireball.ogg'
	alignment_overlay_icon = 'icons/effects/eldritch.dmi'
	alignment_overlay_state = "ring_leader_effect"
	alignment_overlay_layer = LOW_MOB_LAYER

	alignment_damage_type = BURN
	alignment_defense = /datum/armor/alignment_flamesoul_defense

// Adds pressure immunity & cold immunity.
/datum/action/cooldown/power/cultivator/alignment/flame_soul/enable_alignment(mob/living/carbon/user)
	. = ..()
	user.add_traits(list(TRAIT_RESISTHEAT, TRAIT_NOFIRE), src)

/datum/action/cooldown/power/cultivator/alignment/flame_soul/disable_alignment(mob/living/carbon/user)
	. = ..()
	user.remove_traits(list(TRAIT_RESISTHEAT, TRAIT_NOFIRE), src)


// special laser & fire proofed armor for flamesoul.
/datum/armor/alignment_flamesoul_defense
	acid = 30
	bio = 30
	melee = 30
	bullet = 30
	bomb = 30
	energy = 30
	laser = 60
	fire = 100
	melee = 30
	wound = 30


/datum/action/cooldown/power/cultivator/alignment/flame_soul/aura_farm()
	var/total = 0
	var/mob/living/owner_mob = owner
	if(!owner_mob)
		return total

	var/object_on_fire_value = CULTIVATOR_AURA_FARM_MINOR * 0.3 // stuff that is on fire that shouldnt be e.g a paper stack
	var/natural_fire_object_value = CULTIVATOR_AURA_FARM_MINOR * 0.5 // exposed flames that are intended e.g candles
	var/big_natural_fire_object_value = CULTIVATOR_AURA_FARM_MODERATE // exposed flames that are intended and big e.g bonfires
	var/fire_turf_value = CULTIVATOR_AURA_FARM_MINOR // turfs being on fire e.g plasma fire
	var/smoking_value = CULTIVATOR_AURA_FARM_MODERATE // smoking is cool and good for aura.
	var/lava_value = CULTIVATOR_AURA_FARM_MINOR // lava turfs: hot shit.

	var/others_on_fire_value = CULTIVATOR_AURA_FARM_MODERATE // someone else is on fire
	var/user_on_fire_value = CULTIVATOR_AURA_FARM_MAJOR // we're on fire

	// Big ol list of objects that are meant to be onfire.
	var/static/list/natural_fire_typecache = typecacheof(list(
		/obj/item/flashlight/flare,
		/obj/item/flashlight/flare/candle,
		/obj/item/match,
		/obj/item/lighter,
		/obj/item/oxygen_candle,
		/obj/item/sparkler,
		/obj/structure/wall_torch
	))


	// Big ol list of big objects that are meant to be on fire.
	var/static/list/big_natural_fire_typecache = typecacheof(list(
		/obj/structure/bonfire,
		/obj/structure/fireplace,
		/obj/structure/firepit
	))

	// Checks for hotspots aka is the engine on fire and does that let us aura farm? Also checks for lava
	for(var/turf/open/open_turf in view(owner_mob))
		if(istype(open_turf, /turf/open/lava))
			total += lava_value
		if(open_turf.active_hotspot)
			total += fire_turf_value

	// Check if there is anyone on fire nearby.
	for(var/mob/living/burning_mob in view(owner_mob))
		if(burning_mob == owner_mob) // we check this separetely.
			continue
		if(burning_mob.on_fire)
			total += others_on_fire_value

	// Check if we are on fire.
	if(owner_mob.on_fire)
		total += user_on_fire_value

	// Check if we are smoking something in our mask slot.
	var/obj/item/mask_item = owner_mob.get_item_by_slot(ITEM_SLOT_MASK)
	if(istype(mask_item, /obj/item/cigarette))
		var/obj/item/cigarette/smoking_item = mask_item
		if(smoking_item.lit)
			total += smoking_value

	// Goes through all the objects in view.
	for(var/obj/scene_object in view(owner_mob))
		// List that goes through all the big items and checks if they are on fire.
		if(is_type_in_typecache(scene_object, big_natural_fire_typecache))
			if(istype(scene_object, /obj/structure/bonfire))
				var/obj/structure/bonfire/bonfire_object = scene_object
				if(bonfire_object.burning)
					total += big_natural_fire_object_value
				continue
			if(istype(scene_object, /obj/structure/fireplace))
				var/obj/structure/fireplace/fireplace_object = scene_object
				if(fireplace_object.lit)
					total += big_natural_fire_object_value
				continue
			if(istype(scene_object, /obj/structure/firepit))
				var/obj/structure/firepit/firepit_object = scene_object
				if(firepit_object.active)
					total += big_natural_fire_object_value
				continue
		// List that goes through all the smaller scene objects and check if they are on fire.
		if(is_type_in_typecache(scene_object, natural_fire_typecache))
			if(istype(scene_object, /obj/item/flashlight/flare))
				var/obj/item/flashlight/flare/flare_object = scene_object
				if(flare_object.light_on)
					total += natural_fire_object_value
				continue
			if(istype(scene_object, /obj/structure/wall_torch))
				var/obj/structure/wall_torch/wall_torch_object = scene_object
				if(wall_torch_object.burning)
					total += natural_fire_object_value
				continue
			if(istype(scene_object, /obj/item/oxygen_candle))
				var/obj/item/oxygen_candle/oxygen_candle_object = scene_object
				if(oxygen_candle_object.processing)
					total += natural_fire_object_value
				continue
			if(istype(scene_object, /obj/item/match))
				var/obj/item/match/match_object = scene_object
				if(match_object.lit)
					total += natural_fire_object_value
				continue
			if(istype(scene_object, /obj/item/lighter))
				var/obj/item/lighter/lighter_object = scene_object
				if(lighter_object.lit)
					total += natural_fire_object_value
				continue
			if(istype(scene_object, /obj/item/sparkler))
				var/obj/item/sparkler/sparkler_object = scene_object
				if(sparkler_object.lit)
					total += natural_fire_object_value
				continue

		// Checks if the item is on fire when its nto meant to be on fire.
		if(scene_object.resistance_flags & ON_FIRE)
			total += object_on_fire_value

	return total
