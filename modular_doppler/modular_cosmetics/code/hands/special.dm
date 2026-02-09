/obj/item/clothing/gloves/botanic_leather/janitor
	name = "janitor gloves"
	desc = "These rubber gloves protect against thorns, barbs, prickles, glass shards and any other threats that might be found in the station's trash.  They're also quite warm."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	icon_state = "janitor_doppler"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	inhand_icon_state = null


/*
*	a gauntlet shield meant to replace the telescopic riot shield
*/

/obj/item/clothing/gloves/platillo	//instead of being a backpack riot shield, it's a glove with much more modest block
	name = "\improper PA-4N Platillo shield gauntlets"	//"little plate"
	desc = "An armored gauntlet augmented with a thick buckler of plastitanium, from which it takes its officially designated name 'platillo'. \
	Meant primarily for melee combatants to wield two handed weapons without encumbrance, the light coverage fares poorly under fire."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	icon_state = "platillo"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	worn_icon_state = "platillo"
	armor_type = /datum/armor/platillo
	block_chance = 25
	block_sound = 'sound/items/weapons/block_shield.ogg'
	body_parts_covered = HANDS | ARMS
	max_integrity = 75
	repairable_by = /obj/item/stack/sheet/mineral/titanium
	var/break_sound = 'sound/effects/bang.ogg'

///we can't block when we hold a shield.
/obj/item/clothing/gloves/platillo/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance, damage, attack_type, damage_type)
	for(var/obj/item/shield/held_shield in owner.held_items)	//since only a shield would block these gauntlets in theory
		if(held_shield.block_chance > 0)
			final_block_chance -= 25
			return
	//reproduces some code from shields. none of these give a bonus greater than 25, both so we do not obliviate the code above and because
	//it's a tiny little baby shield. ya gotta get a big one for the bennies.
	var/effective_block_chance = final_block_chance
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		effective_block_chance += 25
	if(attack_type == LEAP_ATTACK)
		effective_block_chance += 25
	if(attack_type == OVERWHELMING_ATTACK)
		effective_block_chance -= 25
	final_block_chance = clamp(effective_block_chance, 0, 100)
	. = ..()
	if(.)
		on_shield_block(owner, hitby, attack_text, damage, attack_type, damage_type)

//more reproduced shield code, this handles taking damage on block as shields do.
/obj/item/clothing/gloves/platillo/proc/on_shield_block(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	var/penetration = 0
	var/armor_flag = MELEE
	if(isprojectile(hitby))
		var/obj/projectile/bang_bang = hitby
		armor_flag = bang_bang.armor_flag
		penetration = bang_bang.armour_penetration
	else if(isitem(hitby))
		var/obj/item/weapon = hitby
		penetration = weapon.armour_penetration
	else if(isanimal(hitby))
		var/mob/living/simple_animal/critter = hitby
		penetration = critter.armour_penetration
	else if(isbasicmob(hitby))
		var/mob/living/basic/critter = hitby
		penetration = critter.armour_penetration
	take_damage(damage, damage_type, armor_flag, armour_penetration = penetration)

//makes a shieldy sound and gives us a popup when we break
/obj/item/clothing/gloves/platillo/atom_destruction(damage_flag)
	playsound(src, break_sound, 50)
	if(isliving(loc))
		loc.balloon_alert(loc, "shield broken!")
	return ..()

//we can see about how damaged we are on examine
/obj/item/clothing/gloves/platillo/examine(mob/user)
	. = ..()
	var/healthpercent = round((atom_integrity/max_integrity) * 100, 1)
	switch(healthpercent)
		if(50 to 99)
			. += span_info("It looks slightly damaged.")
		if(25 to 50)
			. += span_info("It appears heavily damaged.")
		if(0 to 25)
			. += span_warning("It's falling apart!")

//we know that wearing this with a shield won't help us
/obj/item/clothing/gloves/platillo/examine_more(mob/user)
	. = ..()
	. += span_notice("It doesn't seem like it would do much good to wear this while holding another shield.")

/datum/armor/platillo
	melee = ARMOR_LEVEL_MID
	bullet = ARMOR_LEVEL_WEAK
	laser = ARMOR_LEVEL_WEAK
	energy = ARMOR_LEVEL_WEAK
	bomb = ARMOR_LEVEL_WEAK
	bio = ARMOR_LEVEL_TINY
	fire = ARMOR_LEVEL_WEAK
	acid = ARMOR_LEVEL_TINY
	wound = WOUND_ARMOR_STANDARD
