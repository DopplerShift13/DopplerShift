/// From base of /obj/item/mob_can_equip. (mob/living/M, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
#define COMSIG_ITEM_MOB_CAN_EQUIP "item_mob_can_equip"
	/// Forces mob_can_equip to return FALSE.
	#define COMPONENT_ITEM_CANT_EQUIP (1<<10) // high to avoid flag conflict

/// Trait for when you're wearing sunglasses, used by Action Movie Syndrome
#define TRAIT_WEARING_SUNGLASSES "sunglasses"
