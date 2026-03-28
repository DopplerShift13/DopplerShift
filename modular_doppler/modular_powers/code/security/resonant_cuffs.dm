// Antiresonant cuffs. They're like normal cuffs but slightly worse and put a dampener on resonant folk.
/obj/item/restraints/handcuffs/antiresonant
	name = "eschatite handcuffs"
	desc = "Handcuffs laced with a smooth, dark material similar to magnetite called Eschatite, harvested from a reality anchor. Capable of suppressing resonant powers on whoever is made to wear them. Slightly less sturdy than regular handcuffs."
	icon = 'modular_doppler/modular_powers/icons/items/restraints.dmi'
	icon_state = "anti_resonant_cuffs"
	breakouttime = 50 SECONDS
	handcuff_time = 4.5 SECONDS
	custom_price = PAYCHECK_COMMAND

	// we save the mob so we don't end up orphaning the silence remover
	var/mob/living/cuffed_mob

/obj/item/restraints/handcuffs/antiresonant/attempt_to_cuff(mob/living/carbon/victim, mob/living/user)
	. = ..()
	playsound(victim, 'sound/effects/magic/magic_block.ogg', 75, TRUE, -2)

/obj/item/restraints/handcuffs/antiresonant/equipped(mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDCUFFED)
		to_chat(user, span_warning("A shudder goes down your spine; [name] seem to suppress resonant powers!"))
		user.dispel(src)
		ADD_TRAIT(user, TRAIT_RESONANCE_SILENCED, src)
		cuffed_mob = user

/obj/item/restraints/handcuffs/antiresonant/on_uncuffed(datum/source, mob/living/wearer)
	..()
	if(cuffed_mob)
		REMOVE_TRAIT(cuffed_mob, TRAIT_RESONANCE_SILENCED, src)
		cuffed_mob = null

/obj/item/restraints/handcuffs/antiresonant/Destroy(force)
	if(cuffed_mob)
		REMOVE_TRAIT(cuffed_mob, TRAIT_RESONANCE_SILENCED, src)
		cuffed_mob = null
	return ..()

// Vendor entry lives in modular_vending/code/tg_vendors/sectech.dm
