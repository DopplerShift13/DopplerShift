/*
	To deal with those pesky resonant users that keep using their POWERS.
*/

/datum/power/thaumaturge/brazen_bindings
	name = "Brazen Bindings"
	desc = "Summons a set of manacles made from brass, capable of dispelling and disabling Resonant powers on the bound target. The magic that made them is fragile, causing them to break once someone escapes. \
	\nRequires Affinity 1. Additional affinity increases the time it takes to break out."
	security_record_text = "Subject can conjure anti-resonant manacles out of thin air."
	security_threat = POWER_THREAT_MAJOR
	value = 3

	action_path = /datum/action/cooldown/power/thaumaturge/brazen_bindings
	required_powers = list(/datum/power/thaumaturge_root)

/datum/action/cooldown/power/thaumaturge/brazen_bindings
	name = "Brazen Bindings"
	desc = "Summons a set of manacles made from brass, capable of dispelling and disabling Resonant powers on the bound target. The magic that made them is fragile, causing them to break once someone escapes."
	button_icon = 'icons/obj/weapons/restraints.dmi'
	button_icon_state = "brass_manacles"

	required_affinity = 1
	prep_cost = 3

/datum/action/cooldown/power/thaumaturge/brazen_bindings/use_action(mob/living/user, atom/target)
	if(user.get_active_held_item() && user.get_inactive_held_item())
		user.balloon_alert(user, "hands are not empty!")
		return FALSE

	// Creates item, adds the special phantasmal tool properties, give to user.
	var/obj/item/restraints/handcuffs/antiresonant/brazen/new_cuffs = new /obj/item/restraints/handcuffs/antiresonant/brazen
	new_cuffs.breakouttime += (affinity - 1) * 5
	user.put_in_hands(new_cuffs)
	playsound(user, 'sound/effects/magic/magic_missile.ogg', 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	return TRUE

// the special ones conjured by thaumaturges.
/obj/item/restraints/handcuffs/antiresonant/brazen/
	name = "brazen manacles"
	desc = "Bulky, enchanted and resonant manacles made out of brass and laden with (cheap) gemstones. They're held together using a sliver of resonant power, causing them to break into an unuseable mess once removed."
	icon = 'icons/obj/weapons/restraints.dmi'
	icon_state = "brass_manacles"
	w_class = WEIGHT_CLASS_NORMAL
	breakouttime = 30 SECONDS // default for 1affinity. For comparison, zipties are 30seconds and normal cuffs are 1min.
	handcuff_time = 6 SECONDS
	color = null // only til we get a proper sprite for the base cuffs, which are currrently colored red.

/obj/item/restraints/handcuffs/antiresonant/brazen/on_uncuffed(datum/source, mob/living/wearer)
	. = ..()
	qdel(src)
