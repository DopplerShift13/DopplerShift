// OBJECTS (The guns themselves)

/obj/item/gun/ballistic/automatic/pistol
	name = "\improper Stalwart pistol"
	desc = "An easily concealable Mk. 1 Stalwart pistol of remarkable quality. Chambered in 6mm, fitted with a counterweight and a threaded barrel."
	desc_controls = "This gun can fit a silencer! To apply it, equip the silencer and apply it to the gun in your off-hand."	//From now on we will refer to all suppressors as silencers. Really hoping this gunjak ragebait works.
	icon = 'modular_doppler/modular_weapons/icons/overhaul/handguns.dmi'
	icon_state = "stalwart"

/obj/item/gun/ballistic/automatic/pistol/examine_more(mob/user)
	. = ..()
	. += span_notice("Xin-Jang Armories' Mk. I Stalwart - originally known as the Type-11 - is a run of the mill self-loading pistol made for civilian and law enforcement use.\
	The Stalwart is the final iteration of a line of reasonably priced self defense handguns, making up a good chunk of the Marsian company's yearly revenue in bulk orders.\
	It's mid-tier, but there's nothing really to complain about. It's easy to use, has a comfortable grip and most importantly – it's reliable. Don't overthink it.")

/obj/item/gun/ballistic/automatic/pistol/clandestine
	name = "\improper Osprey pistol"
	desc = "A rare but venerable Osprey Longslide pistol. Chambered in 7.5mm, handles similarly to the Mk. 1 Stalwart."
	desc_controls = "This gun can fit a silencer! To apply it, equip the silencer and apply it to the gun in your off-hand."
	icon_state = "osprey"
	accepted_magazine_type = /obj/item/ammo_box/magazine/m10mm
	empty_indicator = FALSE
	suppressor_x_offset = 0

/obj/item/gun/ballistic/automatic/pistol/clandestine/examine_more(mob/user)
	. = ..()
	. += span_notice("Xin-Jang Armories' show pony, the 'Mk. IV Osprey Field Pistol' - originally known as the Type-15 - is a single action, tilting barrel semi-automatic pistol with a proprietary recoil mitigation system.\
	The Osprey is significantly larger and heavier than other contemporary military pistols, earning it a favored spot with exoskeleton users and pretentious mercenaries above all.\
	The proprietary 7.5×30mm cartridge is claimed to have an effective range—in terms of accuracy and terminal ballistics—of at least 100 meters for targets of up to 150 kg while maintaining relatively low recoil and good controllability.\
	This particular model, the Osprey Longslide, is a common choice for criminals and users of large frames due to it's massive profile and it's menacing presence.")

/obj/item/gun/ballistic/automatic/pistol/clandestine/fisher
	name = "\improper Ansem/SC pistol"
	desc = "A modified variant of the Ansem, spiritual successor to the Makarov, featuring an integral suppressor and push-button trigger on the grip \
	for an underbarrel-mounted disruptor, similar in operation to the standalone SC/FISHER. Chambered in 10mm."
	desc_controls = "Right-click to use the underbarrel disruptor. Two shots maximum between self-charges."
	icon_state = "pistol_evil_fisher"
	suppressed = TRUE
	can_suppress = FALSE
	can_unsuppress = FALSE
	var/obj/item/gun/energy/recharge/fisher/underbarrel

/obj/item/gun/ballistic/automatic/pistol/clandestine/fisher/examine_more(mob/user)
	. = ..()
	. += span_notice("The Ansem/SC is a Scarborough Arms-manufactured overhaul suite for the also Scarborough Arms-manufactured Ansem handgun, designed for special \
	operators who like to operate operationally, and/or people who really, really hate lightbulbs, and tend to fight people who really like lightbulbs. \
	The slide is lengthened and has an integrated suppressor, while a compact kinetic light disruptor was mounted underneath the barrel. \
	Scarborough Arms has never actually officially responded to allegations that they're involved with the modification and/or manufacture \
	of the SC/FISHER or similar disruptor weapons. Operators are reminded that kinetic light disruptors do not actually physically harm targets.<br>\
	Caveat emptor.")
