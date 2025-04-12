// Pre-packed medkit for healing synths and repairing their wounds rapidly in the field
/obj/item/storage/medkit/robotic_repair
	name = "robotic repair equipment kit"
	desc = "An industrial-strength plastic box filled with supplies for repairing synthetics from critical damage."
	icon = 'modular_doppler/deforest_medical_items/icons/storage.dmi'
	icon_state = "synth_medkit"
	inhand_icon_state = "medkit"
	worn_icon = 'modular_doppler/deforest_medical_items/icons/worn/worn.dmi'
	worn_icon_state = "frontier"
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound = 'sound/items/handling/ammobox_pickup.ogg'
	storage_type = /datum/storage/medical_belt/advanced

/datum/storage/medical_belt/advanced/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()

	set_holdable(list(
		/obj/item/bikehorn/rubberducky,
		/obj/item/blood_filter,
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/muzzle,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/utility/surgerycap,
		/obj/item/construction/plumbing,
		/obj/item/dnainjector,
		/obj/item/extinguisher/mini,
		/obj/item/flashlight/pen,
		/obj/item/geiger_counter,
		/obj/item/gun/syringe/syndicate,
		/obj/item/healthanalyzer,
		/obj/item/hemostat,
		/obj/item/holosign_creator/medical,
		/obj/item/implant,
		/obj/item/implantcase,
		/obj/item/implanter,
		/obj/item/lazarus_injector,
		/obj/item/lighter,
		/obj/item/pinpointer/crew,
		/obj/item/plunger,
		/obj/item/radio,
		/obj/item/reagent_containers/blood,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/medigel,
		/obj/item/reagent_containers/applicator,
		/obj/item/reagent_containers/spray,
		/obj/item/reagent_containers/syringe,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/shears,
		/obj/item/stack/medical,
		/obj/item/stack/sticky_tape, //surgical tape
		/obj/item/stamp,
		/obj/item/sensor_device,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/surgical_drapes, //for true paramedics
		/obj/item/surgicaldrill,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/wrench/medical,
		/obj/item/knife/ritual,
		/obj/item/flesh_shears,
		/obj/item/storage/hypospraykit,
		/obj/item/hypospray/mkii,
		/obj/item/reagent_containers/cup/hypovial,
		///
		/obj/item/stack/cable_coil,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/plunger,
		/obj/item/clothing/head/utility/welding,
		/obj/item/clothing/glasses/welding,
	))

/obj/item/storage/medkit/robotic_repair/stocked

/obj/item/storage/medkit/robotic_repair/stocked/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze = 1,
		/obj/item/reagent_containers/applicator/patch/robotic_patch/synth_repair = 2,
		/obj/item/stack/medical/gauze/alu_splint = 1,
		/obj/item/reagent_containers/hypospray/medipen/deforest/robot_system_cleaner = 1,
		/obj/item/reagent_containers/hypospray/medipen/deforest/coagulants = 1, // Coagulants help electrical damage
		/obj/item/healthanalyzer/simple = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/robotic_repair/preemo
	name = "premium robotic repair equipment kit"
	desc = "An industrial-strength plastic box filled with supplies for repairing synthetics from critical damage. \
		This one has extra storage on the sides for even more equipment than the standard medkit model."
	icon_state = "synth_medkit_super"

/obj/item/storage/medkit/robotic_repair/preemo/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_slots = 12
	atom_storage.max_total_storage = 12 * WEIGHT_CLASS_NORMAL

/obj/item/storage/medkit/robotic_repair/preemo/stocked

/obj/item/storage/medkit/robotic_repair/preemo/stocked/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze/twelve = 1,
		/obj/item/stack/cable_coil/thirty = 1,
		/obj/item/reagent_containers/applicator/patch/robotic_patch/synth_repair = 4,
		/obj/item/stack/medical/gauze/alu_splint = 1,
		/obj/item/reagent_containers/hypospray/medipen/deforest/robot_system_cleaner = 1,
		/obj/item/reagent_containers/hypospray/medipen/deforest/robot_liquid_solder = 1,
		/obj/item/reagent_containers/hypospray/medipen/deforest/coagulants = 1,
		/obj/item/reagent_containers/spray/dinitrogen_plasmide = 1,
		/obj/item/healthanalyzer/simple = 1,
	)
	generate_items_inside(items_inside,src)
