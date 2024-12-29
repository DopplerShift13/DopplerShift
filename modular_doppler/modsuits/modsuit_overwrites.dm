/obj/item/mod/control/pre_equipped/engineering
	theme = /datum/mod_theme/engineering
	applied_modules = list(
		/obj/item/mod/module/storage,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/rad_protection,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/tether,
		/obj/item/mod/module/magboot,
		/obj/item/mod/module/anomaly_locked/kinesis/weak,
	)
	default_pins = list(
		/obj/item/mod/module/magboot,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/tether,
		/obj/item/mod/module/anomaly_locked/kinesis/weak,
	)

/obj/item/mod/control/pre_equipped/advanced
	theme = /datum/mod_theme/advanced
	applied_cell = /obj/item/stock_parts/power_store/cell/super
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/rad_protection,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/headprotector,
		/obj/item/mod/module/tether,
		/obj/item/mod/module/anomaly_locked/kinesis/upgraded,
	)
	default_pins = list(
		/obj/item/mod/module/magboot/advanced,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/jetpack,
		/obj/item/mod/module/tether,
		/obj/item/mod/module/anomaly_locked/kinesis/upgraded,
	)

/obj/item/mod/control/pre_equipped/chrono
	theme = /datum/mod_theme/chrono
	starting_frequency = null
	applied_core = /obj/item/mod/core/infinite
	applied_modules = list(
		/obj/item/mod/module/eradication_lock,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/timeline_jumper,
		/obj/item/mod/module/timestopper,
		/obj/item/mod/module/rewinder,
		/obj/item/mod/module/tem,
		/obj/item/mod/module/anomaly_locked/kinesis/plus,
		/obj/item/mod/module/anomaly_locked/kinesis/plus/prebuilt,
	)
	default_pins = list(
		/obj/item/mod/module/timestopper,
		/obj/item/mod/module/timeline_jumper,
		/obj/item/mod/module/rewinder,
		/obj/item/mod/module/tem,
		/obj/item/mod/module/anomaly_locked/kinesis/plus,
		/obj/item/mod/module/anomaly_locked/kinesis/plus/prebuilt,
	)

/obj/item/mod/control/pre_equipped/atmospheric
	theme = /datum/mod_theme/atmospheric
	applied_modules = list(
		/obj/item/mod/module/storage,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/rad_protection,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/magboot,
		/obj/item/mod/module/t_ray,
		/obj/item/mod/module/quick_carry,
		/obj/item/mod/module/headprotector,
		/obj/item/mod/module/mister/atmos,
	)
	default_pins = list(
		/obj/item/mod/module/magboot,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/mister/atmos,
	)

/obj/item/mod/control/pre_equipped/medical
	theme = /datum/mod_theme/medical
	applied_modules = list(
		/obj/item/mod/module/storage,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/health_analyzer,
		/obj/item/mod/module/quick_carry,
		/obj/item/mod/module/anomaly_locked/kinesis/upgraded,
	)

/obj/item/mod/control/pre_equipped/rescue
	theme = /datum/mod_theme/rescue
	applied_cell = /obj/item/stock_parts/power_store/cell/super
	applied_modules = list(
		/obj/item/mod/module/storage/large_capacity,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/health_analyzer,
		/obj/item/mod/module/injector,
		/obj/item/mod/module/anomaly_locked/kinesis/upgraded,
		/obj/item/mod/module/defibrillator,
	)
