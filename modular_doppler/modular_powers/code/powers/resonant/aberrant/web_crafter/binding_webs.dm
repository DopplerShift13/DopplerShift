// Creates snaaaares
/datum/power/aberrant/binding_webs
	name = "Binding Webs"
	desc = " Allows you to craft web restraints and web bolas using web crafter. Web restraints are functionally similar to zipties. Web Bolas can be thrown just like regular bolas."
	security_record_text = "Subject can craft bolas and restraints from their spider silk."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	required_powers = list(/datum/power/aberrant/web_crafter)

/datum/power/aberrant/binding_webs/post_add(client/client_source)
	. = ..()
	var/datum/action/cooldown/power/aberrant/web_crafter/action = get_web_crafter_action()
	if(!action)
		return
	action.web_craft_entries |= /datum/web_craft_entry/web_restraints
	action.web_craft_entries |= /datum/web_craft_entry/web_bola

/datum/power/aberrant/binding_webs/remove()
	var/datum/action/cooldown/power/aberrant/web_crafter/action = get_web_crafter_action()
	if(!action)
		return
	action.web_craft_entries -= /datum/web_craft_entry/web_restraints
	action.web_craft_entries -= /datum/web_craft_entry/web_bola

/datum/power/aberrant/binding_webs/proc/get_web_crafter_action()
	if(!power_holder)
		return null
	for(var/datum/action/cooldown/power/aberrant/web_crafter/action in power_holder.actions)
		return action
	return null

// Reflavored
/obj/item/restraints/handcuffs/cable/zipties/web
	name = "web ties"
	desc = "Sticky strings meant for binding pesky hands. Be careful not to get yourself stuck!"
	breakouttime = 60 SECONDS // sticky = better
	/// Tracks if this was actually used as cuffs so we can delete on uncuff only.
	var/was_cuffed = FALSE

// If you're not a web weaver yourself, you might get yourself stuck using it instead. Or if you're clumsy, it will DEFINETLY happy.
/obj/item/restraints/handcuffs/cable/zipties/web/attempt_to_cuff(mob/living/carbon/victim, mob/living/user)
	if(iscarbon(user) && !HAS_TRAIT(user, TRAIT_WEB_SURFER) && (HAS_TRAIT(user, TRAIT_CLUMSY) || prob(50)))
		to_chat(user, span_warning("Your hands get stuck in the webs!"))
		apply_cuffs(user, user)
		return
	return ..()

/obj/item/restraints/handcuffs/cable/zipties/web/equipped(mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HANDCUFFED)
		was_cuffed = TRUE
		RegisterSignal(src, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_uncuffed))

// why do we not have an uncuff proc on cuffs hello?!?!?!
/obj/item/restraints/handcuffs/cable/zipties/web/on_uncuffed(datum/source, mob/living/wearer)
	..()
	if(was_cuffed)
		qdel(src)

// Just normal bolas but extra webby and the same caveat as handcuffs.
/obj/item/restraints/legcuffs/bola/web
	name = "web bola"
	desc = "A bola made out of a sticky material. Throwing this will definetly get at least one involved party stuck."
	breakouttime = 6 SECONDS // sticky = better
	icon = 'modular_doppler/modular_powers/icons/items/restraints.dmi'
	/// Tracks if this was actually used as legcuffs so we can delete on uncuff only.
	var/was_cuffed = FALSE

// Just like webcuffs, chance of ensnaring yourself instead
/obj/item/restraints/legcuffs/bola/web/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, gentle = FALSE, quickstart = TRUE, throw_type_path = /datum/thrownthing)
	if(iscarbon(thrower) && !HAS_TRAIT(thrower, TRAIT_WEB_SURFER) && (HAS_TRAIT(thrower, TRAIT_CLUMSY) || prob(50)))
		to_chat(thrower, span_warning("The bola sticks to your hands, whiffing the throw and entangling yourself instead!"))
		ensnare(thrower)
		return
	return ..()

/obj/item/restraints/legcuffs/bola/web/equipped(mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_LEGCUFFED)
		was_cuffed = TRUE
		RegisterSignal(src, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_uncuffed))

/obj/item/restraints/legcuffs/bola/web/proc/on_uncuffed(datum/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER
	if(was_cuffed)
		qdel(src)
