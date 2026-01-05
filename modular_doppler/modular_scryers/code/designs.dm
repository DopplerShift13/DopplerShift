
/**
 * Designs to allow for creating modular scryers.
 * Non-modular overrides hooking into this are:
 * - code/modules/research/techweb/nodes/engi_nodes.dm (/datum/techweb_node/telecomms)
 */

/datum/design/brick_scryerphone
	name = "Brick Scryerphone"
	desc = "A large brick of a phone modified to hook into the MODlink network."
	id = "modlink_scryer_brick"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/brick_phone_scryer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
