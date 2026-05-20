/*
*	a couple of items that don't really do anything, but that can be interacted with in some kind of way.
*/

/obj/item/fidget_toy
	name = "fidget toy"
	icon = 'modular_doppler/modular_items/icons/toys.dmi'
	abstract_type = /obj/item/fidget_toy
	w_class = WEIGHT_CLASS_TINY
	obj_flags = UNIQUE_RENAME

	/// what verbs do we use when interacting with our toy? should be continuous, e.g. "chews"
	var/fidget_verb_continuous
	/// what verbs do we use when interacting with our toy? should be simple, e.g. "chew"
	var/fidget_verb_simple
	/// what sound do we play when we fidget?
	var/list/fidget_sound
	/// cooldown on the fidget messages and sounds so that they're only a little annoying
	COOLDOWN_DECLARE(fidget_cooldown)

/obj/item/fidget_toy/attack_self(mob/user, modifiers)	// when used, fidget toys send a message, make a noise, and start a short cooldown. pretty simple!
	. = ..()
	if(!COOLDOWN_FINISHED(src, fidget_cooldown))
		return FALSE
	COOLDOWN_START(src, fidget_cooldown, 3 SECONDS)
	user.visible_message(span_notice("[user] [pick(fidget_verb_continuous)] the [src]"), span_notice("You [pick(fidget_verb_simple)] the [src]"))
	playsound(src, pick(fidget_sound), 25, TRUE)

/obj/item/fidget_toy/chewy
	name = "melty face chew toy"
	desc = "A piece of molded foodsafe silicone. Some find it satisfying to chew."
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/neck/necklaces.dmi'
	icon_state = "melty"
	slot_flags = ITEM_SLOT_NECK
	fidget_verb_continuous = list("chews", "gnaws", "teethes",)
	fidget_verb_simple = list("chew", "gnaw", "teethe",)
	fidget_sound = list('sound/items/weapons/bite.ogg',)

/obj/item/fidget_toy/chewy/dog_tag
	name = "dog tag chew toy"
	icon_state = "dog_tag"

/obj/item/fidget_toy/chewy/chewybear
	name = "chewy bear"
	icon_state = "chewybear"

/obj/item/fidget_toy/chewy/bone
	name = "bone chew toy"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/fidget_toy/chewy/bone"
	post_init_icon_state = "bone"
	greyscale_config = /datum/greyscale_config/bone
	greyscale_config_worn = /datum/greyscale_config/bone/worn
	greyscale_colors = "#9282ee"
	slot_flags = ITEM_SLOT_MASK
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/fidget_toy/chewy/builderbrick
	name = "builderbrick chew toy"
	icon_state = "builderbrick"

/obj/item/fidget_toy/chewy/raver_chewtoy
	name = "\improper Marsian raver chew toy"
	desc = "A retro throwback that has started to gain purchase in the Marsian underground amongst afficianados of \
	jabber. Its adherents swear by it to prevent damage by narcotic-induced teeth grinding."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/fidget_toy/chewy/raver_chewtoy"
	post_init_icon_state = "raver_chewtoy"
	greyscale_config = /datum/greyscale_config/raver_chewtoy
	greyscale_config_worn = /datum/greyscale_config/raver_chewtoy/worn
	greyscale_colors = "#d2629c#ffffff#d2629c"
	slot_flags = ITEM_SLOT_MASK
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/fidget_toy/chewy/raver_chewtoy/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "placement")

/obj/item/fidget_toy/poppable
	name = "dolphin poppable"
	desc = "A urethane sheet pockmarked in semi-spherical chambers. The domes provide a satisfying feeling and sound when depressed."
	icon_state = "doppie"
	fidget_verb_continuous = list("pops", "impels", "depresses", "squashes", "scrunches", "drives", "compacts",)
	fidget_verb_simple = list("pop", "impel", "depress", "squash", "scrunch", "drive", "compact",)
	fidget_sound = list(
		'sound/items/door_remote/door_remote_switch1.ogg',
		'sound/items/door_remote/door_remote_switch2.ogg',
		'sound/items/door_remote/door_remote_switch3.ogg',
		)

/obj/item/fidget_toy/poppable/phanic
	name = "\improper Phanic the Weasel poppable"
	desc = "A urethane sheet pockmarked in semi-spherical chambers. This one resembles a popular character."
	icon_state = "phanic"

/obj/item/fidget_toy/poppable/apple
	name = "apple poppable"
	icon_state = "apple"

/obj/item/fidget_toy/fidget_spinner
	name = "spinner fidget"
	desc = "A device consisting of four arms arrayed around a central node, each carrying their own node in turn. \
	Each node bears a sealed cartridge bearing. It serves no particular purpose."
	icon_state = "spinner"
	fidget_verb_continuous = list("spins",)
	fidget_verb_simple = list("spin",)
	fidget_sound = list(
		'sound/items/weapons/gun/revolver/spin1.ogg',
		'sound/items/weapons/gun/revolver/spin2.ogg',
		'sound/items/weapons/gun/revolver/spin3.ogg',
	)
	throwforce = 10 // >:3c

/obj/item/fidget_toy/fidget_spinner/attack_self(mob/user, modifiers)	// makes it spin! yay!
	. = ..()
	SpinAnimation(4, 2)
