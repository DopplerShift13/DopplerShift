
/datum/action/cooldown/spell/touch/prestidigitation
	name = "Prestidigitation"
	desc = "Channel electricity to your hand to shock people with. Mostly harmless! Mostly... "
	button_icon_state = "zap"
	sound = 'sound/effects/magic/staff_healing.ogg'
	cooldown_time = 7 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE
	can_cast_on_self = TRUE

	hand_path = /obj/item/melee/touch_attack/prestidigitation
	draw_message = span_notice("You channel resonance around your hand.")
	drop_message = span_notice("You let the resonance around your hand dissipate.")

/datum/action/cooldown/spell/touch/prestidigitation/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(!iscarbon(victim))
		return FALSE
	victim.wash(CLEAN_SCRUB)
	return TRUE

/datum/action/cooldown/spell/touch/prestidigitation/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(!iscarbon(victim))
		return FALSE
	var/obj/item/cigarette/cig = attached_hand.help_light_cig(victim)
	if(isnull(cig))
		return FALSE
	cig.light("With a single flick of [caster.p_their()] wrist, [caster] smoothly lights [caster == victim ? caster.p_their() : "[victim]'s"] [cig]. Damn [caster.p_theyre()] cool.")
	return TRUE

/obj/item/melee/touch_attack/prestidigitation
	name = "\improper prestidigitation"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "zapper"
	inhand_icon_state = "zapper"

	// I can light my candles *from a distance*.
	reach = 2
	// Doesn't need a permit, as opposed to other touch attacks.
	item_flags = ABSTRACT | HAND_ITEM
	// Allow you to light candles with this.
	heat = HIGH_TEMPERATURE_REQUIRED - 100
	/// Sparks effect for special effects.
	var/datum/effect_system/spark_spread/sparks

/obj/item/melee/touch_attack/prestidigitation/Initialize(mapload)
	. = ..()
	sparks = new
	sparks.set_up(2, 0, src)
	sparks.attach(src)

/obj/item/melee/touch_attack/prestidigitation/ignition_effect(atom/atom, mob/user)
	if(!get_temperature())
		return
	return span_infoplain(span_rose("With a single flick of [user.p_their()] wrist, [user] smoothly lights [atom]. Damn [user.p_theyre()] cool."))

/obj/item/melee/touch_attack/prestidigitation/attack_self(mob/user)
	sparks.start()
