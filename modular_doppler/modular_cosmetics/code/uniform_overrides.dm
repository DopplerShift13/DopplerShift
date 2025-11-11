/datum/outfit/job/janitor
	uniform = /obj/item/clothing/under/rank/civilian/janitor/doppler
	suit = /obj/item/clothing/suit/apron/janitor_cloak
	gloves = /obj/item/clothing/gloves/botanic_leather/janitor

/datum/outfit/job/cmo
	uniform = /obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck
	shoes = /obj/item/clothing/shoes/medical

/datum/outfit/job/doctor
	shoes = /obj/item/clothing/shoes/medical
	suit = /obj/item/clothing/suit/toggle/labcoat/medical
	backpack = /obj/item/storage/backpack/medical
	satchel = /obj/item/storage/backpack/satchel/medical
	duffelbag = /obj/item/storage/backpack/duffelbag/medical
	messenger = /obj/item/storage/backpack/messenger/medical

/datum/outfit/job/chemist
	shoes = /obj/item/clothing/shoes/medical
	backpack = /obj/item/storage/backpack/chemistry
	satchel = /obj/item/storage/backpack/satchel/chemistry
	duffelbag = /obj/item/storage/backpack/duffelbag/chemistry
	messenger = /obj/item/storage/backpack/messenger/chemistry

/datum/outfit/job/paramedic
	shoes = /obj/item/clothing/shoes/medical
	suit = /obj/item/clothing/suit/toggle/labcoat/medical
	duffelbag = /obj/item/storage/backpack/duffelbag/paramed

/datum/outfit/job/virologist
	backpack = /obj/item/storage/backpack/virology
	satchel = /obj/item/storage/backpack/satchel/virology
	duffelbag = /obj/item/storage/backpack/duffelbag/virology
	messenger = /obj/item/storage/backpack/messenger/virology

/datum/outfit/job/coroner
	backpack = /obj/item/storage/backpack/coroner
	satchel = /obj/item/storage/backpack/satchel/coroner
	duffelbag = /obj/item/storage/backpack/duffelbag/coroner
	messenger = /obj/item/storage/backpack/messenger/coroner

/datum/outfit/job/miner
	suit = /obj/item/clothing/suit/armor/vest/miningjacket
	ears = /obj/item/radio/headset/headset_frontier_colonist/mining
	gloves = /obj/item/clothing/gloves/doppler_mining
	neck = /obj/item/broadcast_camera/mining

/obj/item/storage/box/survival/mining
	mask_type = /obj/item/clothing/mask/neck_gaiter

/datum/outfit/job/security
	suit_store = null
	backpack_contents = list(
		/obj/item/signature_beacon/security_equipment_package = 1,
		/obj/item/evidencebag = 1,
	)
