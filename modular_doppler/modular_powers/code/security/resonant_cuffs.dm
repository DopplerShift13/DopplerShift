// Antiresonant cuffs. They're like normal cuffs but slightly worse and put a dampener on resonant folk.
/obj/item/restraints/handcuffs/antiresonant
	name = "resonant suppressant handcuffs"
	desc = "Handcuffs laced with leaded brass on the interior, with a plentitude of runes and a bit of circuitry sticking out. Capable of suppressing resonant powers. How R&D came up with this one is a miracle in itself."
	icon_state = "handcuffAlien"
	color = "#ee3d3d" // til we get a proper sprite for these things.
	breakouttime = 50 SECONDS
	handcuff_time = 4.5 SECONDS
	custom_price = PAYCHECK_COMMAND * 0.6

/obj/item/restraints/handcuffs/antiresonant/attempt_to_cuff(mob/living/carbon/victim, mob/living/user)
	. = ..()
	playsound(victim, 'sound/effects/magic/magic_block.ogg', 75, TRUE, -2)

/obj/item/restraints/handcuffs/antiresonant/equipped(mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDCUFFED)
		to_chat(user, span_warning("A shudder goes down your spine; [name] seem to suppress resonant powers!"))
		user.dispel(src)
		ADD_TRAIT(user, TRAIT_RESONANCE_SILENCED, src)
		RegisterSignal(src, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(on_uncuff)) // Surely there is an unequip proc I am just missing?

/obj/item/restraints/handcuffs/antiresonant/proc/on_uncuff(datum/source)
	REMOVE_TRAIT(usr, TRAIT_RESONANCE_SILENCED, src)
	UnregisterSignal(src, COMSIG_ITEM_PRE_UNEQUIP)

// Adds the antiresonant cuffs to the sec vend.
/obj/machinery/vending/security
	products_doppler = list(
		/obj/item/restraints/handcuffs/antiresonant = 6,
	)
