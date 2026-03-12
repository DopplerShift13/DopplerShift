/// sound loop for the vibroblade below

/datum/looping_sound/vibroblade
	mid_sounds = list('modular_doppler/modular_sounds/sound/items/tajaran_vibroblade.ogg')
	mid_length = 8 SECONDS
	volume = 40
	vary = TRUE

/// a tajaran counterpart to the tiziran choppa. kind of like a nerfed captain's sabre.

/obj/item/melee/tajaran_sword
	name = "\improper Tajaran duelist's sword"
	desc = "Seemingly archaic weapons have persisted as relevant side arms amongst Tajaran ruffians who \
	seek to cultivate face in daring street fights against rival Houses. This one bears a blade of novel \
	alloy and a protective cup hilt, but pales to the capabilities of finer Tajaran weapons."
	icon = 'modular_doppler/species_clothes/icons/tajara/gear.dmi'
	icon_state = "rapier"
	worn_icon = 'modular_doppler/species_clothes/icons/tajara/gear_worn.dmi'
	worn_icon_state = "rapier"
	lefthand_file = 'modular_doppler/species_clothes/icons/tajara/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/tajara/righthand.dmi'
	inhand_icon_state = "rapier"
	inhand_x_dimension = 64
	icon_angle = -45
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	block_sound = 'sound/items/weapons/parry.ogg'
	obj_flags = CONDUCTS_ELECTRICITY
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = UNIQUE_RENAME
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	tool_behaviour = TOOL_KNIFE
	toolspeed = 1.5
	force = 15
	throwforce = 10
	armour_penetration = 45
	block_chance = 30
	wound_bonus = 0
	exposed_wound_bonus = 10
	demolition_mod = 0.75
	attack_verb_continuous = list("slashes", "slices", "cuts", "stabs", "pierces", "perforates", "ventilates",)
	attack_verb_simple = list("slash", "slice", "cut", "stab", "pierce", "perforate", "ventilate",)
	var/belt_suffix = "_rapier"


/// antag version. like if the captain's sabre was an esword.

/obj/item/melee/tajaran_sword/vibro
	name = "\improper Tajaran vibroblade"
	desc = "A simple thrust with extended arms is all that is needed to drive this point through most materials. \
	A high frequency vibration ensures the tip will work into the target with nothing more than the weapon's own \
	inertia."
	icon_state = "vibrorapier"
	worn_icon_state = "vibrorapier"
	inhand_icon_state = "vibrorapier"
	force = 15	// doubled to thirty when you hit the aura button
	armour_penetration = 45 // increases to 75
	block_chance = 10	// doesn't have a bell guard + this would just be better than the esword if it also blocked good
	wound_bonus = 10
	exposed_wound_bonus = 20
	belt_suffix = "_vibro"

	/// force in vibro mode
	var/active_force = 30
	/// the nice humming noise we make when we're turned on
	var/datum/looping_sound/vibroblade/vibroloop

/obj/item/melee/tajaran_sword/vibro/Initialize(mapload)
	. = ..()
	vibroloop = new(src)
	AddComponent( \
		/datum/component/transforming, \
		transform_cooldown_time = (CLICK_CD_MELEE * 0.25), \
		force_on = active_force, \
		throwforce_on = active_force, \
		sharpness_on = sharpness, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		attack_verb_continuous_on = list("slashes", "slices", "cuts", "stabs", "pierces", "perforates", "ventilates"), \
		attack_verb_simple_on = list("slash", "slice", "cut", "stab", "pierce", "perforate", "ventilate"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/tajaran_sword/vibro/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER
	to_chat(user, span_notice("As you activate [src], [active ? "the blade hums with potential" : "the blade falls silent"]."))
	armour_penetration = (active ? 75 : initial(armour_penetration))
	if(active)
		vibroloop.start()
	else
		vibroloop.stop()
	return COMPONENT_NO_DEFAULT_MESSAGE

/// the sheath for these

/obj/item/storage/belt/tajaran_sheath
	name = "duelist's sheath"
	desc = "A decorated sheath for the thin dueling swords favored by Tajaran swashbucklers."
	icon = 'modular_doppler/species_clothes/icons/tajara/gear.dmi'
	icon_state = "sheath"
	worn_icon = 'modular_doppler/species_clothes/icons/tajara/gear_worn.dmi'
	worn_icon_state = "sheath"
	lefthand_file = 'modular_doppler/species_clothes/icons/generic/lefthand.dmi'
	righthand_file = 'modular_doppler/species_clothes/icons/generic/righthand.dmi'
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = UNIQUE_RENAME
	interaction_flags_click = parent_type::interaction_flags_click | NEED_DEXTERITY | NEED_HANDS
	storage_type = /datum/storage/tajaran_sheath

/obj/item/storage/belt/tajaran_sheath/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/storage/belt/tajaran_sheath/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("Alt-click it to quickly draw the blade.")

/obj/item/storage/belt/tajaran_sheath/click_alt(mob/user)
	if(length(contents))
		var/obj/item/sword = contents[1]
		user.visible_message(span_notice("[user] takes [sword] out of [src]."), span_notice("You take [sword] out of [src]."))
		user.put_in_hands(sword)
		playsound(user, 'sound/items/sheath.ogg', 50, TRUE)
		update_appearance()
	else
		balloon_alert(user, "it's empty!")
	return CLICK_ACTION_SUCCESS

/obj/item/storage/belt/tajaran_sheath/update_icon_state()
	icon_state = initial(icon_state)
	worn_icon_state = initial(worn_icon_state)
	for(var/obj/item/melee/tajaran_sword/belt_content in contents)
		if(belt_content)
			icon_state += belt_content.belt_suffix
			worn_icon_state += belt_content.belt_suffix
			break
	return ..()

/obj/item/storage/belt/tajaran_sheath/PopulateContents()
	new /obj/item/melee/tajaran_sword(src)
	update_appearance()

/datum/storage/tajaran_sheath
	max_slots = 1
	do_rustle = TRUE
	max_specific_storage = WEIGHT_CLASS_BULKY
	click_alt_open = FALSE

/datum/storage/tajaran_sheath/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(/obj/item/melee/tajaran_sword)

/obj/item/storage/belt/tajaran_sheath/vibro/PopulateContents()
	new /obj/item/melee/tajaran_sword/vibro(src)
	update_appearance()
