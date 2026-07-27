// Snares on the ground! Its like a beartrap but it doesnt hurt and destroys itself after.
/datum/power/aberrant/snare_webs
	name = "Snare Webs"
	desc = "Allows you to craft snares. These are placed on the ground and are hard to see; but can be disarmed.\
	\n Mobs without the ability to walk through webs will be legcuffed if they walk through it.\
	\n Simple mobs instead receive a slowing status effect for 8 seconds."
	security_record_text = "Subject can craft leg snaring traps from their spider silk."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	required_powers = list(/datum/power/aberrant/web_crafter)

/datum/power/aberrant/snare_webs/post_add(client/client_source)
	..()
	var/datum/action/cooldown/power/aberrant/web_crafter/action = get_web_crafter_action()
	if(!action)
		return
	action.web_craft_entries |= /datum/web_craft_entry/web_snare

/datum/power/aberrant/snare_webs/remove()
	var/datum/action/cooldown/power/aberrant/web_crafter/action = get_web_crafter_action()
	if(!action)
		return
	action.web_craft_entries -= /datum/web_craft_entry/web_snare

/// Gets the approrpiate web crafter action
/datum/power/aberrant/snare_webs/proc/get_web_crafter_action()
	if(!power_holder)
		return null
	for(var/datum/action/cooldown/power/aberrant/web_crafter/action in power_holder.actions)
		return action
	return null

// Web snare (applied to legs)
/obj/item/restraints/legcuffs/beartrap/web_snare
	name = "web snare"
	desc = "Sticky silk woven into a snare."
	icon = 'icons/effects/web.dmi'
	icon_state = "sticky_overlay"
	armed = TRUE
	trap_damage = 0
	breakouttime = 8 SECONDS
	item_flags = DROPDEL
	/// Tracks if this was actually used as legcuffs so we can delete on uncuff only.
	var/was_cuffed = FALSE

/obj/item/restraints/legcuffs/beartrap/web_snare/update_icon_state()
	. = ..()
	icon_state = "sticky_overlay"
	return .

/obj/item/restraints/legcuffs/beartrap/web_snare/attack_self(mob/user)
	return

/obj/item/restraints/legcuffs/beartrap/web_snare/spring_trap(atom/movable/target, ignore_movetypes = FALSE, hit_prone = FALSE)
	if(isliving(target) && HAS_TRAIT(target, TRAIT_WEB_SURFER))
		return
	return ..(target, ignore_movetypes, hit_prone)

/obj/item/restraints/legcuffs/beartrap/web_snare/equipped(mob/living/user, slot)
	..()
	if(slot == ITEM_SLOT_LEGCUFFED)
		was_cuffed = TRUE
		RegisterSignal(src, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(on_uncuffed))

/// When the cuffs are removed, destroy em.
/obj/item/restraints/legcuffs/beartrap/web_snare/proc/on_uncuffed(datum/source, force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER
	if(was_cuffed)
		qdel(src)

// Web snare structure (trigger on ground)
/obj/structure/spider/web_snare
	name = "web snare"
	desc = "A barely visible snare woven from silk."
	icon = 'icons/effects/web.dmi'
	icon_state = "sticky_overlay"
	anchored = TRUE
	density = FALSE
	alpha = 15
	max_integrity = 10

/obj/structure/spider/web_snare/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!isliving(mover))
		return .
	var/mob/living/target = mover
	if(HAS_TRAIT(target, TRAIT_WEB_SURFER))
		return .
	if(target.mob_size >= MOB_SIZE_HUGE) // the bigger they are the harder they don't fall.
		qdel(src) // us humans dont care about tiny webs either.
		return .
	trigger_snare(target)
	return TRUE

/// When the snare is triggered.
/obj/structure/spider/web_snare/proc/trigger_snare(mob/living/target)
	if(!iscarbon(target))
		trigger_snare_noncarbon(target)
		return
	trigger_snare_carbon(target)

/// Applies the snare legtrap to the target.
/obj/structure/spider/web_snare/proc/trigger_snare_carbon(mob/living/target)
	var/mob/living/carbon/carbon_target = target
	if(carbon_target.legcuffed || carbon_target.num_legs < 2) // no legs to cuff
		qdel(src)
		return
	var/obj/item/restraints/legcuffs/beartrap/web_snare/snare = new /obj/item/restraints/legcuffs/beartrap/web_snare
	carbon_target.equip_to_slot(snare, ITEM_SLOT_LEGCUFFED)
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)
	target.visible_message(span_danger("\The [src] ensnares [target]!"), span_userdanger("\The [src] ensnares you!"))
	qdel(src)

/// Non-carbons get a passive slowdown instead for 10sec.
/obj/structure/spider/web_snare/proc/trigger_snare_noncarbon(mob/living/target)
	target.add_movespeed_modifier(/datum/movespeed_modifier/web_snare, update = TRUE)
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)
	target.visible_message(span_danger("\The [src] ensnares [target]!"), span_userdanger("\The [src] ensnares you!"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/web_snare), 10 SECONDS)
	qdel(src)

/datum/movespeed_modifier/web_snare
	multiplicative_slowdown = 1
