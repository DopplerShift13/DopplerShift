/*
*	for lathe recipes that aren't part of the colony kit stuff
*/

/datum/design/platillo_gauntlets
	name = "\improper PA-4N Platillo shield gauntlets"
	desc = "An armored gauntlet augmented with a thick buckler of plastitanium, from which it takes its officially designated name 'platillo'. \
	Meant primarily for melee combatants to wield two handed weapons without encumbrance, the light coverage fares poorly under fire."
	id = "platillo"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/plasma =  SMALL_MATERIAL_AMOUNT * 3,
		)
	build_path = /obj/item/clothing/gloves/platillo
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_MELEE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
	autolathe_exportable = FALSE
