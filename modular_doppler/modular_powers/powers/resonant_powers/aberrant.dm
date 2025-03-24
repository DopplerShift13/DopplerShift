/**
 * Root powers
 */

// A proc to be ran when a root power that conflicts with cybernetics is applied
/mob/living/carbon/human/proc/cybernetics_sickness_process()
	if(src.check_cybernetics() == TRUE)
		src.apply_status_effect(/datum/status_effect/cybernetics_conflict)
	RegisterSignal(src, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(on_organ_gain), TRUE)
	RegisterSignal(src, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(on_organ_lose), TRUE)

/mob/living/carbon/human/proc/check_cybernetics()
	var/cybernetic_found = FALSE
	for(var/obj/item/organ/organ as anything in src.organs)
		// allows razor claws for now, so beasties can still have claws and not die. Eventually make an organic version hopefully
		if(IS_ROBOTIC_ORGAN(organ) && !(organ.organ_flags & ORGAN_HIDDEN))
			cybernetic_found = TRUE
			break
	return cybernetic_found

/mob/living/carbon/human/proc/on_organ_gain(datum/source, obj/item/organ/new_organ, special)
	SIGNAL_HANDLER
	if(IS_ROBOTIC_ORGAN(new_organ) && !(new_organ.organ_flags & ORGAN_HIDDEN))
		src.apply_status_effect(/datum/status_effect/cybernetics_conflict)

/mob/living/carbon/human/proc/on_organ_lose(datum/source, special)
	SIGNAL_HANDLER
	if(!src.check_cybernetics())
		src.remove_status_effect(/datum/status_effect/cybernetics_conflict)

/datum/status_effect/cybernetics_conflict
	id = "cybernetics_abberant_conflict"
	alert_type = /atom/movable/screen/alert/status_effect/cybernetics_conflict
	var/disgust_per_tick = 1
	var/max_disgust = DISGUST_LEVEL_DISGUSTED
	var/max_tox = 75

/datum/status_effect/cybernetics_conflict/tick(seconds_between_ticks)
	owner.adjust_disgust(disgust_per_tick, max_disgust)
	if(owner.getToxLoss() < 75)
		owner.adjustToxLoss(3)

/atom/movable/screen/alert/status_effect/cybernetics_conflict
	name = "Cybernetics conflict"
	desc = "Your resonant deviancies are conflicting with the cybernetics within you, making you increasingly ill"
	maptext_y = 2
	attached_effect = /datum/status_effect/cybernetics_conflict
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
	desc = "You're far more athletic than the average person. This conflicts with cybernetic organs, causing sickness"
	cost = 3
	root_power = /datum/power/muscly
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_MUSCLY, TRAIT_STRENGTH, TRAIT_STIMMED)

/datum/power/muscly/add(mob/living/carbon/human/target)
	target.mind.set_level(/datum/skill/athletics, 4, silent = TRUE)
	target.cybernetics_sickness_process()

/datum/power/monsterstrength
	name = "Musculoskeletal Redistribution"
	desc = "A Deviancy characterized by an abnormally muscular upper body, providing advantages in hand-to-hand combat at the cost of the dexterity required for fine manipulation, e.g. pulling a firearm's trigger"
	cost = 5
	root_power = /datum/power/muscly
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_MONSTERSTRENGTH, TRAIT_CHUNKYFINGERS)

/datum/power/monsterstrength/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/touch/monstrous_stance(target.mind || target)
	new_action.Grant(target)
	var/obj/item/bodypart/arm/right/right_arm = target.get_bodypart(BODY_ZONE_R_ARM)
	right_arm.unarmed_damage_high = initial(right_arm.unarmed_damage_high) + 5
	right_arm.unarmed_damage_low = right_arm.unarmed_damage_high
	var/obj/item/bodypart/arm/left/left_arm = target.get_bodypart(BODY_ZONE_L_ARM)
	left_arm.unarmed_damage_high = initial(left_arm.unarmed_damage_high) + 5
	left_arm.unarmed_damage_low = left_arm.unarmed_damage_high


/datum/action/cooldown/spell/touch/monstrous_stance
	name = "Monstrous Stance"
	desc = "Channel your unnatural strength into a single devestating blow"
	button_icon_state = "scream_for_me"
	cooldown_time = 1 MINUTES
	spell_requirements = NONE
	invocation_type = INVOCATION_NONE
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	draw_message = span_notice("You tense your arm in preperation to deliver a devestating blow")
	drop_message = span_notice("You relax your arm")
	hand_path = /obj/item/melee/touch_attack/monstrous_strike

/obj/item/melee/touch_attack/monstrous_strike
	name = "monstrous strike"
	desc = "A prepared strike of inhuman strength"
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "scream_for_me"
	inhand_icon_state = "monster_strike"

/datum/action/cooldown/spell/touch/monstrous_stance/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	var/atk_verb = pick("punch", "smash", "crack")
	caster.do_attack_animation(victim, ATTACK_EFFECT_PUNCH)
	victim.visible_message(
		span_danger("[caster] [atk_verb]ed [victim] with such inhuman strength that it sends [victim.p_them()] flying backwards!"), \
		span_userdanger("You're [atk_verb]ed by [caster] with such inhuman strength that it sends you flying backwards!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		null,
		caster,
	)
	to_chat(caster, span_danger("You [atk_verb] [victim] with such inhuman strength that it sends [victim.p_them()] flying backwards!"))
	victim.apply_damage(25, def_zone = caster.zone_selected)
	playsound(victim, 'sound/effects/meteorimpact.ogg', 25, TRUE, -1)
	var/throwtarget = get_edge_target_turf(caster, get_dir(caster, get_step_away(victim, caster)))
	victim.throw_at(throwtarget, 2, 2, caster)
	return TRUE

/datum/power/blood_spike
	name = "Blood spike"
	desc = "Manipulate your own blood into a jagged spike able to be thrown for low damage but high embed chance. Each use reduces your own blood level by 5%. This conflicts with cybernetic organs, causing sickness"
	cost = 2
	root_power = /datum/power/blood_spike
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_BLOODSPIKE)

/datum/power/blood_spike/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/blood_spike(target.mind || target)
	new_action.Grant(target)
	target.cybernetics_sickness_process()

/datum/action/cooldown/spell/blood_spike
	name = "Form Blood Spike"
	desc = "Form a spike made from your own blood, it makes a poor weapon but can be throw for low damage but a high chance to embed"
	button_icon = 'icons/obj/weapons/thrown.dmi'
	button_icon_state = "tonguespike"
	cooldown_time = 0
	spell_requirements = NONE
	invocation_type = INVOCATION_NONE
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	sound = 'sound/effects/wounds/blood3.ogg'

/datum/action/cooldown/spell/blood_spike/cast(mob/living/carbon/human/target)
	. = ..()
	var/obj/item/throwing_star/blood_spike/new_spike = new /obj/item/throwing_star/blood_spike
	if(!target.put_in_hands(new_spike, del_on_fail = TRUE))
		reset_spell_cooldown()
		if (target.usable_hands == 0)
			to_chat(target, span_warning("You dont have any usable hands!"))
		else
			to_chat(target, span_warning("Your hands are full!"))
		return FALSE
	target.visible_message(
		span_danger("[target] rips blood from their veins and forms it into a spike!"),
		span_danger("You rip blood from your veins and form it into a spike!"))
	playsound(target, sound, 50, vary = TRUE)
	target.blood_volume -= 28

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
	desc = "Twist and sculp the bone in your arm to form a fragile but protective bone shield. It will have a very high chance of blocking an attack for you but will shatter in the process. Forming one is harmless to you but exhausting. This conflicts with cybernetic organs, causing sickness"
	cost = 2
	root_power = /datum/power/bone_shield
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	power_traits = list(TRAIT_POWER_BONESHIELD)

/datum/power/bone_shield/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/bone_shield(target.mind || target)
	new_action.Grant(target)
	target.cybernetics_sickness_process()

/datum/action/cooldown/spell/bone_shield
	name = "Form Bone Shield"
	desc = "Channel resonance through your very bones to cause your arm's bones to grow into a delicate but protective shield. This exhausts you in the process"
	button_icon = 'modular_doppler/hearthkin/tribal_extended/icons/shields.dmi'
	button_icon_state = "goliath_shield"
	cooldown_time =  1.5 MINUTES
	spell_requirements = NONE
	invocation_type = INVOCATION_NONE
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	sound = 'sound/effects/wounds/crack2.ogg'

/datum/action/cooldown/spell/bone_shield/cast(mob/living/carbon/human/target)
	. = ..()
	var/obj/item/shield/goliath/resonant/new_shield = new /obj/item/shield/goliath/resonant
	if(!target.put_in_hands(new_shield, del_on_fail = TRUE))
		reset_spell_cooldown()
		if (target.usable_hands == 0)
			to_chat(target, span_warning("You dont have any usable hands!"))
		else
			to_chat(target, span_warning("Your hands are full!"))
		return FALSE
	target.visible_message(
		span_danger("[target]'s arm begins to twist and grob into a bone shield!"),
		span_danger("You twist and grow your arms bone to form a shield!"))
	playsound(target, sound, 50, vary = TRUE)
	target.adjustStaminaLoss(75)


/obj/item/shield/goliath/resonant
	name = "Fused Bone Shield"
	desc = "A fragile shield formed of your own bone, easy to block attacks with but likely to shatter from it"
	force = 5
	block_chance = 90
	shield_break_leftover = /obj/item/stack/sheet/bone

/obj/item/shield/goliath/resonant/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/shield/goliath/resonant/on_shield_block(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	. = ..()
	src.atom_destruction()

/obj/item/shield/goliath/resonant/attack_self(mob/user)
	user.visible_message(
		span_danger("[user]'s bashes their shield causing it to crumble!"),
		span_danger("You bash your shield causing it to crumble!"))
	src.atom_destruction()



/datum/power/bestial
	name = "Latent Bestial Traits"
	desc = "Your hearing is sharper than normal, but loud noises hurt your ears much more."
	root_power = /datum/power/bestial
	power_type = TRAIT_PATH_SUBTYPE_ABERRANT
	cost = 5
	power_traits = list(TRAIT_POWER_BESTIAL)
