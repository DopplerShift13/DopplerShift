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
	Meant primarily for melee combatants to wield two handed weapons without encumberance, the light coverage fares poorly under fire."
	icon = 'modular_doppler/modular_cosmetics/icons/obj/hands/gloves.dmi'
	icon_state = "platillo"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/hands/gloves.dmi'
	worn_icon_state = "platillo"
	armor_type = /datum/armor/platillo
	block_chance = 25
	block_sound = 'sound/items/weapons/block_shield.ogg'
	body_parts_covered = HANDS | ARMS

/// negates block chance if there's a shield in either hand
/obj/item/clothing/gloves/platillo/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance, damage, attack_type, damage_type)
	. = ..()
	if(owner.held_items == typesof(/obj/item/shield))
		final_block_chance = 0

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
