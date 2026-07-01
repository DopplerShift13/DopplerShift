/obj/item/mod/control/pre_equipped/responsory/trooper
	theme = /datum/mod_theme/trooper
	applied_cell = /obj/item/stock_parts/power_store/cell/bluespace
	applied_modules = list(
		/obj/item/mod/module/emp_shield/advanced,
		/obj/item/mod/module/magnetic_harness,
		/obj/item/mod/module/longfall,
		/obj/item/mod/module/dna_lock,
		/obj/item/mod/module/quick_cuff,
	)
	default_pins = list(
		/obj/item/mod/module/night,
		/obj/item/mod/module/jetpack/advanced/pulse,
		/obj/item/mod/module/jump_jet,
	)

/obj/item/mod/control/pre_equipped/responsory/trooper/commander
	insignia_type = /obj/item/mod/module/insignia/void/commander
	additional_modules = /obj/item/mod/module/visor/sechud

/obj/item/mod/control/pre_equipped/responsory/trooper/autorifle
	insignia_type = /obj/item/mod/module/insignia/void/autorifle
	additional_modules = /obj/item/mod/module/shooting_assistant

/obj/item/mod/control/pre_equipped/responsory/trooper/comtech
	insignia_type = /obj/item/mod/module/insignia/void/comtech
	additional_modules = list(
		/obj/item/mod/module/visor/meson,
		/obj/item/mod/module/rad_protection,
		/obj/item/mod/module/anomaly_locked/kinesis/prebuilt/locked,
	)

/obj/item/mod/control/pre_equipped/responsory/trooper/corpsman
	insignia_type = /obj/item/mod/module/insignia/void/corpsman
	additional_modules = list(
		/obj/item/mod/module/visor/medhud,
		/obj/item/mod/module/quick_carry,
		/obj/item/mod/module/medbeam,
		/obj/item/mod/module/thread_ripper,
		/obj/item/mod/module/defibrillator/combat,
		/obj/item/mod/module/surgical_processor/emergency,
	)

/datum/mod_theme/trooper
	name = "trooper"
	desc = "A remarkably dextrous exoatmospheric suit with high-power manuevering pulse thrusters and heavy armor over a \
		light exoskeletal frame. This one comes in black."
	extended_desc = "Designed from the ground-up to rectify the needs of the Fourth Celestial Alignment's Void Corps, MODsuits \
		like these replaced more aging armored voidsuits that, while durable, were far too bulky for effective usage in boarding \
		manuevers and close combat. With a modern exoskeletal system used to both slow battery drain and support some rather \
		extensive armor plating, the suit is made complete by a set of high-power thrusters that enable terrifyingly fast movement \
		through the vacuum of space. Even still, it's mobile enough to reliably operate in conditions up to and beyond 1g of \
		gravity, while fully protecting the wearer from any sort of environmental factors that might get in the way."
	default_skin = "trooper"
	ui_theme = "ntos_darkmode"
	armor_type = /datum/armor/mod_theme_apocryphal // armor matches normal asset protection deathsquad
	resistance_flags = FIRE_PROOF | ACID_PROOF
	atom_flags = PREVENT_CONTENTS_EXPLOSION_1
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	slowdown_deployed = 0.5
	complexity_max = DEFAULT_MAX_COMPLEXITY + 10 // 25
	activation_step_time = MOD_ACTIVATION_STEP_TIME * 2
	inbuilt_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/hearing_protection,
		/obj/item/mod/module/welding/no_overlay,
		/obj/item/mod/module/shove_blocker/locked,
		/obj/item/mod/module/shock_absorber,
		/obj/item/mod/module/night,
		/obj/item/mod/module/joint_torsion,
		/obj/item/mod/module/jetpack/advanced/pulse,
		/obj/item/mod/module/jump_jet,
		/obj/item/mod/module/status_readout,
	)
	allowed_suit_storage = list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/flashlight,
		/obj/item/gun,
		/obj/item/melee,
		/obj/item/tank/internals,
		/obj/item/fireaxe,
		/obj/item/shield,
	)
	variants = list(
		"trooper" = list(
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

/obj/item/mod/module/jetpack/advanced/pulse
	name = "MOD pulse maneuvering thruster module"
	desc = "An upgraded set of maneuvering thrusters designed to operate efficiently in the vacuum of space. Although powerful \
		and purpose-built, the inertial dampeners within suffer from a poor stopping distance once the wearer is in motion."
	drift_force = 4 NEWTONS
	stabilizer_force = 1 NEWTONS
	removable = FALSE

/obj/item/mod/module/insignia/void
	incompatible_modules = list(
		/obj/item/mod/module/insignia,
		/obj/item/mod/module/insignia/raider,
		/obj/item/mod/module/insignia/void,
	)
	overlay_icon_file = 'modular_doppler/special_modsuits/icons/modules_onmob.dmi'

/obj/item/mod/module/insignia/void/commander
	color = "#4980a5"

/obj/item/mod/module/insignia/void/autorifle
	color = "#b30d1e"

/obj/item/mod/module/insignia/void/comtech
	color = "#e9c80e"

/obj/item/mod/module/insignia/void/corpsman
	color = "#ebebf5"

/obj/item/mod/module/insignia/void/breacher
	color = "#709e73"
