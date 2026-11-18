// Modular edits to syndicatebomb.dm to allow explosive experts to deduce the color of explosive wires

/obj/machinery/syndicatebomb/
	/// List of which experts have already examined the bomb
	var/list/examined_bomb = list()

/// Called when an explosive expert examines the bomb
/obj/machinery/syndicatebomb/proc/expert_examine(mob/user)
	// One expert can at most reveal half of the detonation wires
	for(var/i in examined_bomb)
		if(i == user)
			return
	var/datum/wires/syndicatebomb/bomb_wires = wires
	var/wires_revealed = 0
	var/list/found_wires = list()
	var/boom_wires = 2
	// Number of boom wires is never stored everywhere so we need to recalculate how many we have
	if(add_boom_wires)
		var/dud_wires
		boom_wires = clamp(round(timer_set / 45, 1), 2, 12)
		if(boom_wires >= 3)
			dud_wires = floor(boom_wires / 2)
			boom_wires -= dud_wires
	// Go through every wire and roll to see if it's revealed unless we've already revealed half of the wires.
	for(var/i in bomb_wires.wires)
		if((bomb_wires.parse_wire(i) == WIRE_BOOM) && (wires_revealed < floor(boom_wires / 2) && prob(50)))
			var/color_to_add = bomb_wires.get_color_of_wire(i)
			found_wires += color_to_add
			wires_revealed++
	// Failed to find any sort of wires.
	if(wires_revealed == 0)
		to_chat(user, span_danger("You fail to deduce the location of any detonation wires..."))
		return
	// Return early for a different message for only finding one wire.
	if(wires_revealed == 1)
		to_chat(user, span_nicegreen("You deduce that the <font color=[found_wires[1]]>[found_wires[1]]</font> wire would detonate the bomb. Best not to touch that one."))
		return
	var/list/combined_wires = list()
	for(var/b in found_wires)
		if(found_wires.Find(b) != (found_wires.len))
			combined_wires += ("<font color='[b]'>[b]</font>")
		else
			combined_wires += ("and <font color='[b]'>[b]</font>")
	combined_wires = combined_wires.Join(", ")
	to_chat(user, span_nicegreen("You deduce that the [combined_wires] wires would detonate the bomb. Best not to touch those ones."))

/obj/machinery/syndicatebomb/activate()
	. = ..()
	examined_bomb = list()

/obj/machinery/syndicatebomb/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_POWER_EXPLOSIVES_SPECIALIST))
		. += span_notice("<i>If you took a look at the wires while the panel was open, you may be able to deduce the color of some of the detonation wires...</i>")

/datum/wires/syndicatebomb/interact(mob/user)
	if(HAS_TRAIT(user, TRAIT_POWER_EXPLOSIVES_SPECIALIST) && interactable(user))
		var/obj/machinery/syndicatebomb/bomb = holder
		bomb.expert_examine(user)
		bomb.examined_bomb.Add(user)
	return ..()




