/obj/item/storage/belt/military/pouches
	icon = 'modular_doppler/modular_cosmetics/icons/obj/belt/webbing_skins.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/mob/belt/webbing_skins.dmi'
	name = "tactical combat pouches"
	desc = "A web of pockets hung across your chest for storing various murder implements."
	icon_state = "militarywebbing2"
	worn_icon_state = "militarywebbing2"
	uses_advanced_reskins = TRUE
	unique_reskin = list(
		"Regular" = list(
			RESKIN_ICON_STATE = "militarywebbing2",
			RESKIN_WORN_ICON_STATE = "militarywebbing2"
		),
		"Evil" = list(
			RESKIN_ICON_STATE = "evilwebbing",
			RESKIN_WORN_ICON_STATE = "evilwebbing"
		)
	)

//preloaded variant for a security loadout package
/obj/item/storage/belt/military/pouches/security_gunner_package
	desc = "A web of pockets hung across your chest for storing various murder implements. A label screenprinted to the pouch \
	designates it as Port Authority standard issue."

/obj/item/storage/belt/military/pouches/security_gunner_package/PopulateContents()
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/assembly/flash/handheld(src)
