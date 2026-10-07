/datum/job/roustabout
	title = JOB_ROUSTABOUT
	description = "Work for anyone who asks you, give your position a bad rep starting fights in the bar, and find an in with crew higher \
		up on the ladder than you for a better position."
	faction = FACTION_STATION
	total_positions = 10
	spawn_positions = 10
	supervisors = "anyone who needs you"
	config_tag = "ROUSTABOUT"
	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CIV
	outfit = /datum/outfit/job/roustabout
	plasmaman_outfit = /datum/outfit/plasmaman
	display_order = JOB_DISPLAY_ORDER_ROUSTABOUT
	bounty_types = CIV_JOB_BASIC
	allow_bureaucratic_error = FALSE
	department_for_prefs = /datum/job_department/assistant
	family_heirlooms = list(/obj/item/bedsheet/captain) // thank you command guard (CHANGE THIS)
	mail_goodies = list( // thank you command guard (CHANGE THIS)
		/obj/item/storage/fancy/cigarettes/cigars/havana = 10,
		/obj/item/stack/spacecash/c500 = 3,
		/obj/item/disk/nuclear/fake/obvious = 2,
		/obj/item/clothing/head/collectable/captain = 4,
	)
	job_flags = STATION_JOB_FLAGS
	rpg_title = "Laborer"

/datum/outfit/job/roustabout
	name = "Roustabout"
	jobtype = /datum/job/roustabout

	uniform = /obj/item/clothing/under/frontier_colonist
	neck = null
	shoes = /obj/item/clothing/shoes/utilishoes
	ears = /obj/item/radio/headset/headset_frontier_colonist
	backpack_contents = list()
	// backpack = null
	// satchel = null
	// duffelbag = null
	// messenger = null

	box = /obj/item/storage/box/survival
	belt = /obj/item/storage/belt/utility/full
	l_pocket = null
	r_pocket = /obj/item/modular_computer/pda/rugged/roustabout
	id_trim = /datum/id_trim/job/roustabout

/obj/item/modular_computer/pda/rugged/roustabout
	name = "industrial PDA"
	greyscale_colors = "#ece1cd#ece1cd"
	//inserted_item = /obj/item/pen/red/security
	starting_programs = list()

/datum/id_trim/job/roustabout
	assignment = JOB_ROUSTABOUT
	trim_state = "trim_stationengineer"
	sechud_icon_state = "hudroustabout"
	minimal_access = list()
	extra_access = list(
		ACCESS_MAINT_TUNNELS,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_HOP,
		)
	job = /datum/job/assistant
