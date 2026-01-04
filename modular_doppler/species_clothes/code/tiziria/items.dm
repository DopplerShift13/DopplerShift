/obj/item/melee/tizirian_sword
	name = "\improper Tizirian chopping sword"
	desc = "'Chopper' is, at best, a poor translation of the true name in Khaishhs. It speaks well to the \
		purpose of this blade however, being a strong blade made to defeat the armor and scales that historical \
		Tizirans would have had to defeat. The design persists to this day through tradition."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "choppa"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "choppa"
	lefthand_file = 'modular_doppler/species_clothes/icons/tiziria/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/tiziria/righthand.dmi'
	inhand_icon_state = "choppa"
	inhand_x_dimension = 64
	icon_angle = -45
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	block_sound = 'sound/items/weapons/block_shield.ogg'
	obj_flags = CONDUCTS_ELECTRICITY
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = UNIQUE_RENAME
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	tool_behaviour = TOOL_KNIFE
	toolspeed = 0.8
	force = 16
	throwforce = 10
	armour_penetration = 25
	block_chance = 1 // Nah, I'd win
	wound_bonus = 0
	exposed_wound_bonus = 20
	attack_verb_continuous = list("attacks", "slashes", "slices", "tears", "lacerates", "rips", "dices", "rends")
	attack_verb_simple = list("attack", "slash", "slice", "tear", "lacerate", "rip", "dice", "rend")
	var/list/alt_continuous = list("bashes", "clobbers", "crushes")
	var/list/alt_simple = list("bash", "clobber", "crush")

/obj/item/melee/tizirian_sword/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, speed = 4 SECONDS, effectiveness = 100)
	alt_continuous = string_list(alt_continuous)
	alt_simple = string_list(alt_simple)
	AddComponent(/datum/component/alternative_sharpness, NONE, alt_continuous, alt_simple, 0)

/obj/item/melee/tizirian_sword/attack(mob/living/target_mob, mob/living/user, list/modifiers)
	if(sharpness == SHARP_EDGED)
		hitsound = 'sound/items/weapons/rapierhit.ogg'
	else
		hitsound = 'modular_doppler/modular_sounds/sound/items/sec_jitte.ogg'
	return ..()

// Sheath

/obj/item/storage/belt/lizard_sabre
	name = "chopping sword sheath"
	desc = "A minimalist sheath adorned with clasps of Tizirian bronze."
	icon = 'modular_doppler/species_clothes/icons/tiziria/gear.dmi'
	icon_state = "sheath"
	worn_icon = 'modular_doppler/species_clothes/icons/tiziria/gear_worn.dmi'
	worn_icon_state = "sheath"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = UNIQUE_RENAME
	interaction_flags_click = parent_type::interaction_flags_click | NEED_DEXTERITY | NEED_HANDS
	storage_type = /datum/storage/lizard_belt

/obj/item/storage/belt/lizard_sabre/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/storage/belt/lizard_sabre/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("Alt-click it to quickly draw the blade.")

/obj/item/storage/belt/lizard_sabre/click_alt(mob/user)
	if(length(contents))
		var/obj/item/sword = contents[1]
		user.visible_message(span_notice("[user] takes [sword] out of [src]."), span_notice("You take [sword] out of [src]."))
		user.put_in_hands(sword)
		playsound(user, 'sound/items/sheath.ogg', 50, TRUE)
		update_appearance()
	else
		balloon_alert(user, "it's empty!")
	return CLICK_ACTION_SUCCESS

/obj/item/storage/belt/lizard_sabre/update_icon_state()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	for(var/obj/item/belt_content in contents)
		/*if(!contents.len)
			icon_state = initial(icon_state)
			worn_icon_state = initial(worn_icon_state)
			*/
		if(istype(belt_content, /obj/item/melee/tizirian_sword/boffa))
			icon_state += "_boffa"
			worn_icon_state += "_boffa"
			return
		else if(istype(belt_content, /obj/item/melee/tizirian_sword))
			icon_state += "_choppa"
			worn_icon_state += "_choppa"
			return
	return ..()

/obj/item/storage/belt/lizard_sabre/PopulateContents()
	new /obj/item/melee/tizirian_sword(src)
	update_appearance()

/datum/storage/lizard_belt
	max_slots = 1
	do_rustle = TRUE
	max_specific_storage = WEIGHT_CLASS_BULKY
	click_alt_open = FALSE

/datum/storage/lizard_belt/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(/obj/item/melee/tizirian_sword)

/obj/item/melee/tizirian_sword/boffa
	name = "\improper Tiziran training sword"
	desc = "A polymer made from bitumenic discharge shaped into a facisimilie of the chopping sabres \
	favored still by Tiziran warriors. Distributed to nascent striplings for their training, it's also \
	found a niche amongst lizard-obsessive collectors and martial artists in 4CA controlled space. These \
	tend to be a little shorter than the genuine articles."
	icon_state = "boffa"
	worn_icon_state = "boffa"
	inhand_icon_state = "boffa"
	hitsound = 'sound/items/weapons/genhit1.ogg'
	block_sound = 'sound/items/weapons/block_shield.ogg'
	obj_flags = null
	sharpness = null
	tool_behaviour = TOOL_KNIFE
	force = 5 // yeeeeeouch!
	throwforce = 5
	armour_penetration = 0
	exposed_wound_bonus = 0
	attack_verb_continuous = list("bonks", "bops", "bashes", "slaps", "thumps", "thwacks", "wallops", "biffs")
	attack_verb_simple = list("bonk", "bop", "bash", "slap", "thump", "thwack", "wallop", "biff")
