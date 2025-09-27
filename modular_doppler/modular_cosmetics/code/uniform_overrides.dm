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

/datum/outfit/job/chemist
	shoes = /obj/item/clothing/shoes/medical

/datum/outfit/job/paramedic
	shoes = /obj/item/clothing/shoes/medical
	suit = /obj/item/clothing/suit/toggle/labcoat/medical

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
	)
