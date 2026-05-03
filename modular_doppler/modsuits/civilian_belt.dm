/obj/item/mod/control/pre_equipped/civilian/Initialize(mapload)
	..()
	theme = /datum/mod_theme/civilian
	applied_modules = list(
		/obj/item/mod/module/welding,
		/obj/item/mod/module/flashlight,
	)
	return .. ()
