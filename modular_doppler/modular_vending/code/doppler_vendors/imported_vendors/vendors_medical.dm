/obj/machinery/vending/deforest_medvend
	name = "EaC First Aid Station"
	desc = "A vending machine that dispenses some basic medical supplies, put here by the EAC or \"Everywhere A Clinic\" program to bring \
		medical care to places where the 4CA cannot, or has yet to, build fully fledged medical facilities. Every libre spent in this machine \
		goes directly to funding logistics to resupply it for others to use."
	icon = 'modular_doppler/modular_vending/icons/imported_vendors.dmi'
	icon_state = "medvend"
	panel_type = "panel15"
	light_mask = "medvend-light-mask"
	light_color = LIGHT_COLOR_COPPER_OXIDE
	product_slogans = ""
	product_categories = list(
		list(
			"name" = "First Aid",
			"icon" = "notes-medical",
			"products" = list(
				/obj/item/stack/medical/ointment/red_sun = 4,
				/obj/item/stack/medical/ointment = 4,
				/obj/item/stack/medical/bruise_pack = 4,
				/obj/item/stack/medical/gauze/sterilized = 4,
				/obj/item/stack/medical/suture/coagulant = 4,
				/obj/item/stack/medical/suture = 4,
				/obj/item/stack/medical/suture/bloody = 2,
				/obj/item/stack/medical/mesh = 4,
				/obj/item/stack/medical/mesh/bloody = 2,
				/obj/item/stack/medical/bandage = 4,
				/obj/item/reagent_containers/applicator/patch/robotic_patch/synth_repair = 4,
				/obj/item/stack/medical/gauze/alu_splint = 2,
				/obj/item/storage/medkit/civil_defense/stocked = 2,
			),
		),
		list(
			"name" = "Chems",
			"icon" = "syringe",
			"products" = list(
				/obj/item/storage/pill_bottle/painkiller = 4,
				/obj/item/storage/pill_bottle/prescription_stimulant = 4,
				/obj/item/reagent_containers/hypospray/medipen/doppler/sensory = 3,
				/obj/item/reagent_containers/hypospray/medipen/doppler/adrenaline = 3,
				/obj/item/reagent_containers/hypospray/medipen/doppler/regen = 3,
				/obj/item/reagent_containers/hypospray/medipen/doppler/antidote = 3,
				/obj/item/reagent_containers/hypospray/medipen/doppler/emergency = 3,
				/obj/item/inhaler/disposable/protozene = 3,
				/obj/item/inhaler/disposable/soberup = 3,
				/obj/item/inhaler/disposable/aslanane = 3,
				/obj/item/inhaler/disposable/asthma = 3,
				/obj/item/reagent_containers/hypospray/medipen/doppler/robot_system_cleaner = 3,
				/obj/item/reagent_containers/hypospray/medipen/doppler/robot_liquid_solder = 3,
			),
		),
	)
	contraband = list(
		/obj/item/reagent_containers/hypospray/medipen/doppler/twitch = 2,
		/obj/item/inhaler/disposable/demoneye = 2,
	)
	refill_canister = /obj/item/vending_refill/medical_everywhere
	allow_custom = TRUE
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND * 4
	payment_department = NO_FREEBIES
	onstation_override = 1

/obj/item/vending_refill/medical_everywhere
	machine_name = "EaC First Aid Station"
	icon_state = "refill_medical"
