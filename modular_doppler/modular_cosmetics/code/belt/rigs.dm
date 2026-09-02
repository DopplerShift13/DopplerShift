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
	supported_bodyshapes = null
	bodyshape_icon_files = null

/datum/storage/heavy_ammo_belt
	max_slots = 3
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/heavy_ammo_belt/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(GLOB.tool_items + list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
	))

/obj/item/storage/belt/military/pouches/heavy_ammo
	name = "tactical combat bags"
	desc = "A web of general purpose pouches hung across your chest for storing nothing but ammo."
	icon_state = "gunnerwebbing"
	worn_icon_state = "gunnerwebbing"
	storage_type = /datum/storage/heavy_ammo_belt
	unique_reskin = list(
		"Regular" = list(
			RESKIN_ICON_STATE = "gunnerwebbing",
			RESKIN_WORN_ICON_STATE = "gunnerwebbing"
		),
		"Evil" = list(
			RESKIN_ICON_STATE = "evilgunner",
			RESKIN_WORN_ICON_STATE = "evilgunner"
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

//parc armory version with sindaryo mags
/obj/item/storage/belt/military/pouches/sindaryo

/obj/item/storage/belt/military/pouches/sindaryo/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_box/magazine/wt550m9(src)

//void corps standard version
/obj/item/storage/belt/military/pouches/voidcorps

/obj/item/storage/belt/military/pouches/voidcorps/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_box/magazine/karim(src)

//void corps automatic rifleman version - even just three boxes is such a hilarious amount of ammo
/obj/item/storage/belt/military/pouches/heavy_ammo/voidcorps

/obj/item/storage/belt/military/pouches/heavy_ammo/voidcorps/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/ammo_box/magazine/minhir(src)

//shocktrooper version that's forced to be evil black
/obj/item/storage/belt/military/pouches/shocktrooper
	icon_state = "evilwebbing"
	worn_icon_state = "evilwebbing"
	uses_advanced_reskins = FALSE

/obj/item/storage/belt/military/pouches/shocktrooper/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_box/magazine/smgm45(src)
