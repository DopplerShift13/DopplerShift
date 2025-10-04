/obj/item/signature_beacon/security_equipment_package
	name = "Port Safety Field Loadout Injector"
	desc = "The bleeding edge in JIT supply chains, this device minimizes equipment warehousing costs by ensuring that employee gear remains \
	offset until such time as the employee arrives for work."

	selection_base_type = /datum/signature_equipment/security_equipment_package

/datum/signature_equipment/security_equipment_package/gunnery_kit
	name = "Gunnery Kit"
	icon_item_type = /obj/item/security_gunnery_kit
	spawned_item_type = /obj/item/storage/toolbox/guncase/modular/sportsco_large_case/security_gunnery_package

/datum/signature_equipment/security_equipment_package/support_kit
	name = "Support Kit"
	icon_item_type = /obj/item/security_support_kit
	spawned_item_type = /obj/item/storage/toolbox/guncase/modular/sportsco_large_case/security_support_package

/datum/signature_equipment/security_equipment_package/jitte_belt
	name = "Jitte Belt"
	icon_item_type = /obj/item/storage/belt/secsword/full
	spawned_item_type = /obj/item/storage/belt/secsword/full

// these exist purely to populate the radial selection menu with a sprite that shows both 'things' those kits get

/obj/item/security_gunnery_kit
	icon = 'modular_doppler/modular_weapons/icons/obj/gunsets.dmi'
	icon_state = "security_gunnery_package"

/obj/item/security_support_kit
	icon = 'modular_doppler/modular_weapons/icons/obj/gunsets.dmi'
	icon_state = "security_support_package"

/obj/item/storage/belt/security/webbing/full/PopulateContents()
	. = ..()
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/assembly/flash/handheld(src)
