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
	family_heirlooms = list(
		/obj/item/crowbar/red/caravan,
		/obj/item/wrench/caravan,
		/obj/item/tethergun,
	)
	mail_goodies = list(
		/obj/effect/spawner/random/entertainment/cigarette_pack = 3,
		/obj/item/stack/spacecash/c100 = 3,
		/obj/item/trench_tool = 2,
		/obj/item/clothing/gloves/color/yellow = 2,
		/obj/item/crowbar/red/caravan = 2,
		/obj/item/wrench/caravan = 2,
		/obj/item/tethergun = 2,
	)
	job_flags = STATION_JOB_FLAGS
	rpg_title = "Laborer"

/datum/outfit/job/roustabout
	name = "Roustabout"
	jobtype = /datum/job/roustabout

	neck = null
	uniform = /obj/item/clothing/under/frontier_colonist
	head = /obj/item/clothing/head/soft/frontier_colonist
	shoes = /obj/item/clothing/shoes/jackboots/frontier_colonist
	suit = /obj/item/clothing/suit/toggle/jacket/frontier_colonist/worker
	ears = /obj/item/radio/headset/headset_frontier_colonist
	gloves = /obj/item/clothing/gloves/frontier_colonist
	backpack = /obj/item/storage/backpack/industrial/frontier_colonist
	satchel = /obj/item/storage/backpack/satchel/eng/frontier_colonist
	messenger = /obj/item/storage/backpack/messenger/eng/frontier_colonist
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering/frontier_colonist
	backpack_contents = list(
		/obj/item/clothing/mask/gas/atmos/frontier_colonist,
	)
	box = /obj/item/storage/box/survival
	belt = /obj/item/storage/belt/utility/frontier_colonist
	belt_contents = list(
		/obj/item/crowbar/red,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/extinguisher/mini,
	)
	l_pocket = /obj/item/spess_knife
	r_pocket = /obj/item/modular_computer/pda/rugged/roustabout
	id_trim = /datum/id_trim/job/roustabout

/datum/outfit/job/roustabout/pre_equip(mob/living/carbon/human/H, visuals_only)
	var/random_hat = pick(
		/obj/item/clothing/head/soft/frontier_colonist,
		/obj/item/clothing/head/frontier_colonist_helmet,
		/obj/item/clothing/head/frontier_colonist_helmet/hardhat,
	)
	head = random_hat

/obj/item/modular_computer/pda/rugged/roustabout
	name = "industrial PDA"
	greyscale_colors = "#ece1cd#ece1cd"
	inserted_item = /obj/item/pen/fourcolor
	starting_programs = list(
		/datum/computer_file/program/bounty_board,
		/datum/computer_file/program/restock_tracker,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/skill_tracker,
	)

/datum/id_trim/job/roustabout
	assignment = JOB_ROUSTABOUT
	trim_state = "trim_stationengineer"
	sechud_icon_state = "hudroustabout"
	minimal_access = list(
		ACCESS_MAINT_TUNNELS,
		ACCESS_EXTERNAL_AIRLOCKS,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_CONSTRUCTION,
		ACCESS_TECH_STORAGE,
		ACCESS_AUX_BASE,
		ACCESS_JANITOR,
		ACCESS_SERVICE,
	)
	extra_access = list(
		ACCESS_ENGINEERING,
		ACCESS_ENGINE_EQUIP,
	)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_HOP,
	)
	job = /datum/job/roustabout

/obj/effect/landmark/start/roustabout
	name = "Roustabout"
	icon_state = "roustabout"
	icon = 'modular_doppler/modular_jobs/icons/landmarks.dmi'
