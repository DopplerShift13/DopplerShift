/datum/outfit/centcom/ert/parc
	name = "Port Authority Response Corps Commander"

	id = /obj/item/card/id/advanced/centcom/ert/parc
	ears = /obj/item/radio/headset/headset_frontier_colonist/ert/parc
	uniform = /obj/item/clothing/under/rank/engineering/breach_skinsuit/pressuresuit
	suit = /obj/item/clothing/suit/hazardvest/parc
	l_pocket = /obj/item/storage/epic_loot_org_pouch/ert_ammo_preset
	r_pocket = /obj/item/storage/epic_loot_medpen_case/ert_med_preset
	shoes = /obj/item/clothing/shoes/combat/pressureboots
	gloves = /obj/item/clothing/gloves/combat/pressuregloves
	head = /obj/item/clothing/head/soft/parc

	back = /obj/item/storage/backpack/rucksack
	box = /obj/item/storage/box/survival/centcom
	backpack_contents = list(
		/obj/item/storage/medkit/robotic_repair/stocked = 1,
		/obj/item/storage/medkit/tactical_lite = 1,
		/obj/item/gun/ballistic/automatic/pistol/kieran = 1,
		/obj/item/melee/baton/doppler_security/loaded = 1,
	)

	belt = null
	glasses = null
	additional_radio = null
	mask = null
	suit_store = null

/datum/outfit/centcom/ert/parc/officer
	name = "Port Authority Response Corps Officer"

	id = /obj/item/card/id/advanced/centcom/ert/parc/officer

/datum/outfit/centcom/ert/voidcorps
	name = "Void Corps Commander"

	id = /obj/item/card/id/advanced/centcom/ert/voidcorps
	ears = /obj/item/radio/headset/headset_frontier_colonist/ert/voidcorps
	uniform = /obj/item/clothing/under/syndicate/combat/eva
	l_pocket = /obj/item/storage/epic_loot_org_pouch/ert_ammo_preset
	r_pocket = /obj/item/storage/epic_loot_medpen_case/ert_med_preset
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	mask = /obj/item/clothing/mask/gas/sechailer

	suit_store = /obj/item/gun/ballistic/automatic/karim/voidcorps
	belt = /obj/item/storage/belt/military/pouches/voidcorps
	box = /obj/item/storage/box/survival/centcom
	back = /obj/item/mod/control/pre_equipped/responsory/trooper/commander
	backpack_contents = list(
		/obj/item/tank/internals/oxygen = 1,
		/obj/item/storage/medkit/tactical_lite = 1,
		/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed = 1,
		/obj/item/melee/energy/sword/saber = 1,
		/obj/item/melee/baton/doppler_security/loaded = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c980grenade/prefilled = 1,
	)

/datum/outfit/centcom/ert/voidcorps/autorifle
	name = "Void Corps Automatic Rifleman"

	id = /obj/item/card/id/advanced/centcom/ert/voidcorps/autorifle
	suit_store = /obj/item/gun/ballistic/automatic/karim/minhir
	belt = /obj/item/storage/belt/military/pouches/heavy_ammo/voidcorps
	back = /obj/item/mod/control/pre_equipped/responsory/trooper/autorifle
	backpack_contents = list(
		/obj/item/tank/internals/oxygen = 1,
		/obj/item/storage/medkit/tactical_lite = 1,
		/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed = 1,
		/obj/item/knife/combat = 1,
		/obj/item/melee/baton/doppler_security/loaded = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c980grenade/prefilled = 1,
	)

/datum/outfit/centcom/ert/voidcorps/breacher
	name = "Void Corps Breacher"

	id = /obj/item/card/id/advanced/centcom/ert/voidcorps/breacher
	suit_store = /obj/item/shield/ballistic
	belt = /obj/item/storage/belt/grenade/full
	back = /obj/item/mod/control/pre_equipped/responsory/trooper/breacher
	backpack_contents = list(
		/obj/item/tank/internals/oxygen = 1,
		/obj/item/storage/medkit/tactical_lite = 1,
		/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed = 1,
		/obj/item/melee/energy/sword/saber = 1,
		/obj/item/melee/baton/doppler_security/loaded = 1,
	)

/datum/outfit/centcom/ert/voidcorps/comtech
	name = "Void Corps Combat Technician"

	id = /obj/item/card/id/advanced/centcom/ert/voidcorps/comtech
	l_pocket = /obj/item/storage/toolset/voidcorps
	back = /obj/item/mod/control/pre_equipped/responsory/trooper/comtech
	backpack_contents = list(
		/obj/item/tank/internals/oxygen = 1,
		/obj/item/storage/medkit/tactical_lite = 1,
		/obj/item/gun/energy/coherent_beam_cutter/selfcharging = 1,
		/obj/item/knife/combat = 1,
		/obj/item/melee/baton/doppler_security/loaded = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c980grenade/prefilled = 1,
	)

/datum/outfit/centcom/ert/voidcorps/corpsman
	name = "Void Corps Corpsman"

	id = /obj/item/card/id/advanced/centcom/ert/voidcorps/corpsman
	back = /obj/item/mod/control/pre_equipped/responsory/trooper/corpsman
	backpack_contents = list(
		/obj/item/tank/internals/oxygen = 1,
		/datum/storage/medkit/tactical = 1,
		/obj/item/reagent_containers/hypospray/combat/nanites =1,
		/obj/item/gun/ballistic/automatic/pistol/kieran/suppressed = 1,
		/obj/item/knife/combat = 1,
		/obj/item/ammo_box/magazine/ammo_stack/c980grenade/prefilled = 1,
	)
