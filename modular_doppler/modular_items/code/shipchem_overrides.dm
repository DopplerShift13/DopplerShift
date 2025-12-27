/// DOPPLER SHIFT - SHIPCHEMS MODULE
/// Reworks sprites to Shiptest style, and adds caps to beakers and bottles.
/// All base beaker sprites (Regular/Large/XL/Meta/Bluespace/Cryo), bottle & filter beaker from Shiptest
/// Test tubes made by Naaka
/// All sprites edited by Naaka for polish & better palettes

/// ACTUAL AESTHETIC CHANGES BEGIN HERE
/obj/item/reagent_containers/cup/beaker
	desc = "A beaker. It can hold up to 60 units."
	icon = 'modular_doppler/modular_items/icons/shipchems.dmi'
	fill_icon = 'modular_doppler/modular_items/icons/shipchems_reagentfillings.dmi'
	fill_icon_thresholds = list(1, 40, 60, 80, 100)
	volume = 60
	possible_transfer_amounts = list(5,10,15,20,30,60)
	amount_per_transfer_from_this = 5

/obj/item/reagent_containers/cup/beaker/oldstation
	amount_per_transfer_from_this = 5

/obj/item/reagent_containers/cup/beaker/jar
	fill_icon = 'icons/obj/medical/reagent_fillings.dmi'
	volume = 50
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)

/obj/item/reagent_containers/cup/beaker/large
	desc = "A large beaker. Can hold up to 120 units."
	fill_icon_thresholds = list(1, 40, 60, 80, 100)
	volume = 120
	possible_transfer_amounts = list(5,10,15,20,30,40,60,120)

/obj/item/reagent_containers/cup/beaker/plastic
	desc = "An extra-large beaker. Can hold up to 180 units."
	fill_icon_thresholds = list(1, 25, 50, 75, 100)
	fill_icon_state = "beakerxlarge"
	volume = 180
	possible_transfer_amounts = list(5,10,15,20,30,60,90,180)

/obj/item/reagent_containers/cup/beaker/meta
	desc = "An ultra-large beaker. Can hold up to 240 units."
	fill_icon_thresholds = list(1, 25, 50, 75, 100)
	volume = 240
	possible_transfer_amounts = list(5,10,15,20,30,60,120,240)

/obj/item/reagent_containers/cup/beaker/noreact
	desc = "A cryostasis beaker that allows for chemical storage without \
		reactions. Can hold up to 120 units."
	volume = 120

/obj/item/reagent_containers/cup/bottle
	icon = 'modular_doppler/modular_items/icons/shipchems.dmi'
	fill_icon = 'modular_doppler/modular_items/icons/shipchems_reagentfillings.dmi'
	fill_icon_thresholds = list(1, 30, 50, 70)

/obj/item/reagent_containers/cup/bottle/morphine
	icon = 'modular_doppler/modular_items/icons/shipchems.dmi'

/obj/item/reagent_containers/cup/bottle/chloralhydrate
	icon_state = "bottle"

/obj/item/reagent_containers/cup/bottle/brainrot
	icon_state = "bottle"

/obj/item/reagent_containers/cup/bottle/syrup_bottle
	fill_icon = 'icons/obj/medical/reagent_fillings.dmi'
	fill_icon_thresholds = list(0, 20, 40, 60, 80, 100)

/obj/item/reagent_containers/cup/tube
	icon = 'modular_doppler/modular_items/icons/shipchems.dmi'
	fill_icon = 'modular_doppler/modular_items/icons/shipchems_reagentfillings.dmi'

/obj/item/reagent_containers/cup/beaker/organ_jar
	icon = 'icons/obj/medical/chemical.dmi'
