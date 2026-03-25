/obj/item/gun/energy/e_gun/hos
	obj_flags = CONDUCTS_ELECTRICITY | UNIQUE_RENAME

//In Which Reginold Copies The Entire Code For Firing A Pneumatic Cannon So We Can Check If Someone Has A Trait Instead Of Not Doing That
/obj/item/pneumatic_cannon/proc/Fire(mob/living/user, atom/target)
	if(!istype(user) && !target)
		return
	var/discharge = 0
	if(!can_trigger_gun(user))
		return
	if(!loadedItems || !loadedWeightClass)
		to_chat(user, span_warning("\The [src] has nothing loaded."))
		return
	if(!tank && checktank)
		to_chat(user, span_warning("\The [src] can't fire without a source of gas."))
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You can't bring yourself to fire \the [src]! You don't want to risk harming anyone...") )
		return
	if(tank && !tank.remove_air(gasPerThrow * pressure_setting))
		to_chat(user, span_warning("\The [src] lets out a weak hiss and doesn't react!"))
		return
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(75) && clumsyCheck && iscarbon(user))
		var/mob/living/carbon/C = user
		C.visible_message(span_warning("[C] loses [C.p_their()] grip on [src], causing it to go off!"), span_userdanger("[src] slips out of your hands and goes off!"))
		C.dropItemToGround(src, TRUE)
		if(prob(10))
			target = get_turf(user)
		else
			var/list/possible_targets = range(3,src)
			target = pick(possible_targets)
		discharge = 1
	if(!discharge)
		user.visible_message(span_danger("[user] fires \the [src]!"), \
				    		 span_danger("You fire \the [src]!"))
	log_combat(user, target, "fired at", src)
	var/turf/T = get_target(target, get_turf(src))
	playsound(src, fire_sound, 50, TRUE)
	fire_items(T, user)
	if(pressure_setting >= 3 && iscarbon(user)) && !HAS_TRAIT(user, TRAIT_CANNONEER))
		var/mob/living/carbon/C = user
		C.visible_message(span_warning("[C] is thrown down by the force of the cannon!"), span_userdanger("[src] slams into your shoulder, knocking you down!"))
		C.Paralyze(60)
