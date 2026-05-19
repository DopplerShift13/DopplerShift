/* Emits the same unarmed-hit signal as the default species punch path, so power riders also fire for martial arts.
* Sent by send_unarmed_hit_signal() in code\datums\martial\_martial.dm
*/
/datum/martial_art/proc/send_unarmed_hit_signal(mob/living/attacker, mob/living/defender)
	PROTECTED_PROC(TRUE)
	if(!attacker || !defender)
		return

	var/obj/item/bodypart/affecting = defender.get_bodypart(defender.get_random_valid_zone(attacker.zone_selected))
	var/armor_block = 0
	if(affecting)
		armor_block = defender.run_armor_check(affecting, MELEE)

	var/obj/item/bodypart/attacking_limb = get_attacking_limb(attacker, defender)
	if(!attacking_limb && ishuman(attacker))
		var/mob/living/carbon/human/human_attacker = attacker
		attacking_limb = human_attacker.get_active_hand()

	var/limb_sharpness = attacking_limb?.unarmed_sharpness
	SEND_SIGNAL(attacker, COMSIG_HUMAN_UNARMED_HIT, defender, affecting, 0, armor_block, limb_sharpness)
