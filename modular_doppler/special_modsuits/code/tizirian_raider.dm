/obj/item/mod/control/pre_equipped/raider
	theme = /datum/mod_theme/raider
	starting_frequency = MODLINK_FREQ_SYNDICATE
	applied_cell = /obj/item/stock_parts/power_store/cell/super
	applied_modules = list( // leaves 3 capacity open for whatever modules you want without removing any
		/obj/item/mod/module/shock_absorber,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/magnetic_harness/melee,
		/obj/item/mod/module/sheath/filled,
		/obj/item/mod/module/thermal_regulator,
		/obj/item/mod/module/longfall,
		/obj/item/mod/module/pathfinder,
		/obj/item/mod/module/dna_lock,
		/obj/item/mod/module/hat_stabilizer/syndicate,
	)
	default_pins = list(
		/obj/item/mod/module/thermal_regulator,
		/obj/item/mod/module/sheath/filled,
		/obj/item/mod/module/pathfinder,
		/obj/item/mod/module/night,
	)

/datum/mod_theme/raider
	name = "raider"
	desc = "A voidworthy armoured suit used by claws-to-hull EVA forces in Talunan service, or by the raider aftermarket they tend to fall into."
	extended_desc = "A twist on the design of the traditional breastplate, turned into a voidworthy suit with a tightly \
		fitting underlayer. The helmet's design serves a twofold purpose, one to accomodate for the wide range of snout and \
		head shapes within the empire, and a second to deflect impacts coming from head-on. While many of these suits are \
		empire-issue, their aftermarket as the armour of choice for raiders gives them a mixed reputation. \
		Due to the design, the suit is not \"impossible\" for plantigrades to wear, but the experience can be described best \
		as \"pretty uncomfortable\"."
	default_skin = "raider"
	ui_theme = "neutral"
	armor_type = /datum/armor/mod_theme_infiltrator
	resistance_flags = FIRE_PROOF | ACID_PROOF
	atom_flags = PREVENT_CONTENTS_EXPLOSION_1
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	slowdown_deployed = 0
	complexity_max = DEFAULT_MAX_COMPLEXITY - 3 // 12
	activation_step_time = MOD_ACTIVATION_STEP_TIME * 0.5
	slot_flags = ITEM_SLOT_BELT
	inbuilt_modules = list(
		/obj/item/mod/module/storage/belt,
		/obj/item/mod/module/hearing_protection,
		/obj/item/mod/module/night,
		/obj/item/mod/module/welding/no_overlay,
		/obj/item/mod/module/insignia/raider,
		/obj/item/mod/module/shove_blocker/locked, // this was going to be power kick originally but it looks too goofy
	)
	allowed_suit_storage = list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/flashlight,
		/obj/item/gun,
		/obj/item/melee,
		/obj/item/tank/internals,
		/obj/item/tank/jetpack,
		/obj/item/storage/belt/holster,
		/obj/item/construction,
		/obj/item/fireaxe,
		/obj/item/pipe_dispenser,
		/obj/item/storage/bag,
		/obj/item/pickaxe,
		/obj/item/resonator,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/storage/medkit,
		/obj/item/storage/belt/tajaran_sheath,
		/obj/item/storage/belt/lizard_sabre,
	)
	variants = list(
		"raider" = list(
			MOD_ICON_OVERRIDE = 'modular_doppler/special_modsuits/icons/mod.dmi',
			MOD_WORN_ICON_OVERRIDE = 'modular_doppler/special_modsuits/icons/mod_worn.dmi',
			/obj/item/clothing/head/mod = list(
				UNSEALED_LAYER = NECK_LAYER,
				UNSEALED_CLOTHING = SNUG_FIT,
				SEALED_CLOTHING = THICKMATERIAL|STOPSPRESSUREDAMAGE|BLOCK_GAS_SMOKE_EFFECT|HEADINTERNALS,
				UNSEALED_INVISIBILITY = HIDEFACIALHAIR,
				SEALED_INVISIBILITY = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT,
				SEALED_COVER = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF,
				UNSEALED_MESSAGE = HELMET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = HELMET_SEAL_MESSAGE,
				CAN_OVERSLOT = TRUE,
			),
			/obj/item/clothing/suit/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT,
				UNSEALED_MESSAGE = CHESTPLATE_UNSEAL_MESSAGE,
				SEALED_MESSAGE = CHESTPLATE_SEAL_MESSAGE,
				CAN_OVERSLOT = TRUE,
			),
			/obj/item/clothing/gloves/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
				UNSEALED_MESSAGE = GAUNTLET_UNSEAL_MESSAGE,
				SEALED_MESSAGE = GAUNTLET_SEAL_MESSAGE,
			),
			/obj/item/clothing/shoes/mod = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDAMAGE,
				CAN_OVERSLOT = TRUE,
				UNSEALED_MESSAGE = BOOT_UNSEAL_MESSAGE,
				SEALED_MESSAGE = BOOT_SEAL_MESSAGE,
			),
		),
	)

#define INSIGNIA_COLOUR_ORANGE "#d99f3a"
#define INSIGNIA_COLOUR_LIZARD_BLOOD "#7fe7ce"
#define INSIGNIA_COLOUR_RED "#b73737"
#define INSIGNIA_COLOUR_PURPLE "#945d9b"
#define INSIGNIA_COLOUR_GREEN "#559961"
#define INSIGNIA_COLOUR_BLUE "#4699a6"

/// Misc modules
/obj/item/mod/module/insignia/raider
	incompatible_modules = list(
		/obj/item/mod/module/insignia,
		/obj/item/mod/module/insignia/raider,
	)
	overlay_icon_file = 'modular_doppler/special_modsuits/icons/modules_onmob.dmi'
	/// List of random insignia colours to pick from
	var/list/insignia_colours = list(
		INSIGNIA_COLOUR_ORANGE,
		INSIGNIA_COLOUR_LIZARD_BLOOD,
		INSIGNIA_COLOUR_RED,
		INSIGNIA_COLOUR_PURPLE,
		INSIGNIA_COLOUR_GREEN,
		INSIGNIA_COLOUR_BLUE,
	)

/obj/item/mod/module/insignia/raider/Initialize(mapload)
	. = ..()
	color = pick(insignia_colours)

/obj/item/mod/module/insignia/raider/get_configuration()
	. = ..()
	.["insignia_color"] = add_ui_configuration("Insignia Color", "color", color)

/obj/item/mod/module/insignia/raider/configure_edit(key, value)
	switch(key)
		if("insignia_color")
			value = input(usr, "Pick new insignia color", "Insignia Color") as color|null
			if(!value)
				return
			if(is_color_dark(value, 50))
				balloon_alert(mod.wearer, "too dark!")
				return
			color = value
			update_clothing_slots()

#undef INSIGNIA_COLOUR_ORANGE
#undef INSIGNIA_COLOUR_LIZARD_BLOOD
#undef INSIGNIA_COLOUR_RED
#undef INSIGNIA_COLOUR_PURPLE
#undef INSIGNIA_COLOUR_GREEN
#undef INSIGNIA_COLOUR_BLUE

/obj/item/mod/module/welding/no_overlay
	name = "MODsuit flash-protected optical suite"
	complexity = 0
	removable = FALSE
	incompatible_modules = list(
		/obj/item/mod/module/welding,
		/obj/item/mod/module/welding/syndicate,
	)
	overlay_state_inactive = null

/obj/item/mod/module/magnetic_harness/melee
	name = "MOD sword harness module"
	desc = "A tether cable running between the suit and a weapon held in the user's hand, snapping the weapon back onto \
		the suit if dropped."
	complexity = 1
	use_energy_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/magnetic_harness/melee,
	)
	magnet_delay = 0.2 SECONDS

/obj/item/mod/module/magnetic_harness/melee/New(loc, ...)
	. = ..()
	guns_typecache = typecacheof(list(
		/obj/item/melee,
	))

// modsuit holster module but specialized for melee weapons
// unfortunately has no clean way to edit what it can hold
/obj/item/mod/module/sheath
	name = "MOD sheath module"
	desc = "Utilizing the internal space left over in most suits, or failing that a strap on the belt, \
		this module can holster nearly any melee weapon within."
	icon_state = "holster"
	module_type = MODULE_USABLE
	complexity = 2
	incompatible_modules = list(
		/obj/item/mod/module/holster,
		/obj/item/mod/module/sheath,
	)
	cooldown_time = 0.5 SECONDS
	allow_flags = MODULE_ALLOW_INACTIVE
	/// The thing we have sheathed
	var/datum/weakref/sheathed_ref
	/// List of types we allow in the sheath
	var/list/sheath_types = list(
		/obj/item/melee,
	)

/obj/item/mod/module/sheath/filled/Initialize(mapload)
	. = ..()
	var/sheathed = new /obj/item/melee/tizirian_sword(src)
	sheathed_ref = WEAKREF(sheathed)

/obj/item/mod/module/sheath/on_use(mob/activator)
	if(sheathed_ref?.resolve())
		unsheathe_item()
	else
		sheathe_item()

/obj/item/mod/module/sheath/proc/sheathe_item()
	var/obj/item/gun/holding = mod.wearer.get_active_held_item()
	if(isnull(holding))
		balloon_alert(mod.wearer, "nothing to sheath!")
		return
	if(!is_type_in_list(holding, sheath_types) || holding.w_class > WEIGHT_CLASS_BULKY)
		balloon_alert(mod.wearer, "doesn't fit!")
		return
	if(!mod.wearer.transferItemToLoc(holding, src, force = FALSE, silent = TRUE))
		balloon_alert(mod.wearer, "can't sheathe!")
		return
	sheathed_ref = WEAKREF(holding)
	balloon_alert(mod.wearer, "weapon sheathed")
	playsound(src, 'sound/items/sheath.ogg', 100, TRUE)

/obj/item/mod/module/sheath/proc/unsheathe_item()
	var/obj/item/to_unsheathe = sheathed_ref?.resolve()
	if(isnull(to_unsheathe))
		return
	if(!mod.wearer.put_in_active_hand(to_unsheathe, forced = FALSE, ignore_animation = TRUE))
		balloon_alert(mod.wearer, "can't unsheathe!")
		return
	balloon_alert(mod.wearer, "weapon drawn")
	playsound(src, 'sound/items/unsheath.ogg', 100, TRUE)

/obj/item/mod/module/sheath/on_uninstall(deleting = FALSE)
	. = ..()
	var/obj/item/sheathed = sheathed_ref?.resolve()
	if(isnull(sheathed))
		return
	sheathed.forceMove(mod.drop_location())

/obj/item/mod/module/sheath/Exited(atom/movable/gone, direction)
	if(gone == sheathed_ref?.resolve())
		sheathed_ref = null
	return ..()

/obj/item/mod/module/sheath/Destroy()
	sheathed_ref = null
	return ..()
