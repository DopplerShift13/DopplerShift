/**
 * Root powers
 */

/datum/power/cuprous_heart
	name = "Cuprous Heart"
	desc = "Your heart and blood are Living Copper. Your wounds and injuries naturally seal themselves, and you're resistant \
	to Resonant effects, but your blood does not replenish naturally and is hard to synthesize."
	cost = 5
	root_power = /datum/power/cuprous_heart
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT

/obj/item/organ/heart/resonant/copper
	name = "cuprous heart"
	desc = "This heart appears to be made out of pure copper. You could scrap this for a fair amount of dosh."

/datum/power/cuprous_heart/add(mob/living/carbon/human/target)

	var/obj/item/organ/heart/copper_heart = null
	var/obj/item/organ/heart/old_heart = target.get_organ_slot(ORGAN_SLOT_HEART)
	if(old_heart && IS_ORGANIC_ORGAN(old_heart))
		copper_heart = /obj/item/organ/heart/resonant/copper
	if(!isnull(copper_heart))
		copper_heart = new copper_heart
		copper_heart.Insert(target, special = TRUE)

/datum/power/muscly
	name = "Condensed Musculature"
	desc = "You're far more athletic than the average person."
	cost = 3
	root_power = /datum/power/muscly
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_MUSCLY, TRAIT_STRENGTH, TRAIT_STIMMED)

/datum/power/muscly/add(mob/living/carbon/human/target)
	target.mind.set_level(/datum/skill/athletics, 4, silent = TRUE)

/datum/power/monsterstrength
	name = "Monstrous Strength"
	desc = "Gain the ability to hit much harder with your unarmed attacks as well as block foes back with your blows. At the cost of being able to use batons or guns"
	cost = 5
	root_power = /datum/power/muscly
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_MONSTERSTRENGTH, TRAIT_CHUNKYFINGERS)

/datum/power/monsterstrength/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/monstrous_stance(target.mind || target)
	var/obj/item/bodypart/arm/right/right_arm = target.get_bodypart(BODY_ZONE_R_ARM)
	right_arm.unarmed_damage_high = initial(right_arm.unarmed_damage_high) + 5
	right_arm.unarmed_damage_low = initial(right_arm.unarmed_damage_low) + 5
	var/obj/item/bodypart/arm/left/left_arm = target.get_bodypart(BODY_ZONE_L_ARM)
	left_arm.unarmed_damage_high = initial(left_arm.unarmed_damage_high) + 5
	left_arm.unarmed_damage_high = initial(left_arm.unarmed_damage_high) + 5

/datum/action/cooldown/spell/monstrous_stance
	name = "Monstrous Stance"
	desc = "Channel your unnatural strength into a single devestating blow"
	button_icon_state = "scream_for_me"
	cooldown_time = 1.5 MINUTES
	spell_requirements = NONE
	invocation_type = INVOCATION_NONE
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

/datum/action/cooldown/spell/monstrous_stance/cast(mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return
	var/datum/martial_art/monstrous_strike/mstrike = new()
	mstrike.teach(target, make_temporary = TRUE)

/datum/martial_art/monstrous_strike
	name = "Monstrous Strike"
	id = MARTIALART_MONSTERSTRIKE

/datum/martial_art/monstrous_strike/harm_act(mob/living/attacker, mob/living/defender)
	var/final_damage = rand(15, 20)
	var/datum/martial_art/monstrous_strike/mstrike = new()
	var/atk_verb = pick("punch", "smash", "crack")
	if(defender.check_block(attacker, final_damage, "[attacker]'s [atk_verb]", UNARMED_ATTACK))
		return

	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	defender.visible_message(
		span_danger("[attacker] [atk_verb]ed [defender] with such inhuman strength that it sends [defender.p_them()] flying backwards!"), \
		span_userdanger("You're [atk_verb]ed by [attacker] with such inhuman strength that it sends you flying backwards!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("You [atk_verb] [defender] with such inhuman strength that it sends [defender.p_them()] flying backwards!"))
	defender.apply_damage(final_damage, attacker.get_attack_type())
	playsound(defender, 'sound/effects/meteorimpact.ogg', 25, TRUE, -1)
	var/throwtarget = get_edge_target_turf(attacker, get_dir(attacker, get_step_away(defender, attacker)))
	defender.throw_at(throwtarget, 2, 2, attacker)
	mstrike.remove(attacker)
	log_combat(attacker, defender, "[atk_verb] (Monstrous Strike)")

/datum/power/blood_spike
	name = "Blood spike"
	desc = "Manipulate your own blood into a jagged spike able to be thrown for low damage but high embed chance. Each use reduces your own blood level by 5%"
	cost = 2
	root_power = /datum/power/blood_spike
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_BLOODSPIKE)

/datum/power/blood_spike/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/blood_spike(target.mind || target)

/datum/action/cooldown/spell/blood_spike
	name = "Form Blood Spike"
	desc = "Form a spike made from your own blood, it makes a poor weapon but can be throw for low damage but a high chance to embed"
	button_icon = 'icons/obj/weapons/thrown.dmi'
	button_icon_state = "tonguespike"
	cooldown_time = 0
	spell_requirements = NONE
	invocation_type = INVOCATION_NONE
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

/datum/action/cooldown/spell/blood_spike/cast(mob/living/carbon/human/target)
	. = ..()
	target.put_in_hands(/obj/item/throwing_star/blood_spike)
	target.blood_volume = initial(target.blood_volume) - 28

/obj/item/throwing_star/blood_spike
	name = "Blood spike"
	desc = "A mass of blood formed into a spike and congealed by resonant means"
	icon_state = "tonguespike"
	icon = 'icons/obj/weapons/thrown.dmi'
	inhand_icon_state = null
	force = 8
	throwforce = 5
	embed_type = /datum/embedding/blood_spike

/datum/embedding/blood_spike
	pain_mult = 3
	fall_chance = 20
	jostle_chance = 20
	remove_pain_mult = 2
	rip_time = 2 SECONDS

/datum/power/bone_shield
	name = "Bone Shield"
	desc = "Twist and sculp the bone in your arm to form a fragile but protective bone shield. It will have a very high chance of blocking an attack for you but will shatter in the process. Forming one is harmless to you but exhausting"
	cost = 2
	root_power = /datum/power/bone_shield
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_BONESHIELD)

/datum/power/bone_shield/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/bone_shield(target.mind || target)

/datum/action/cooldown/spell/bone_shield
	name = "Form Bone Shield"
	desc = "Channel resonance through your very bones to cause your arm's bones to grow into a delicate but protective shield. This exhausts you in the process"
	button_icon = 'icons/obj/weapons/shields.dmi'
	button_icon_state = "moonflower_shield"
	cooldown_time =  1.5 MINUTES
	spell_requirements = NONE
	invocation_type = INVOCATION_NONE
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS

/datum/action/cooldown/spell/bone_shield/cast(mob/living/carbon/human/target)
	. = ..()
	target.adjustStaminaLoss(75)
	target.put_in_hands(/obj/item/shield/goliath/resonant)

/obj/item/shield/goliath/resonant
	name = "Fused Bone Shield"
	desc = "A fragile shield formed of your own bone, easy to block attacks with but likely to shatter from it"
	force = 5
	block_chance = 90
	shield_break_leftover = /obj/item/stack/sheet/bone

/obj/item/shield/goliath/resonant/on_shield_block(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	. = ..()
	src.atom_destruction()


/datum/power/bestial
	name = "Latent Bestial Traits"
	desc = "Your hearing is sharper than normal, but loud noises hurt your ears much more."
	root_power = /datum/power/bestial
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	cost = 5
	power_traits = list(TRAIT_POWER_BESTIAL)
