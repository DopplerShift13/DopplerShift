/obj/item/clothing/accessory/breathing
	name = "breathing dogtag"
	desc = "A dogtag which labels what kind of gas a person may breathe."
	icon_state = "allergy"
	above_suit = FALSE
	attachment_slot = NONE
	var/breath_type

/obj/item/clothing/accessory/breathing/examine(mob/user)
	. = ..()
	. += "The dogtag reads: I breathe [breath_type]."

/obj/item/clothing/accessory/breathing/accessory_equipped(obj/item/clothing/under/uniform, user)
	. = ..()
	RegisterSignal(user, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/obj/item/clothing/accessory/breathing/accessory_dropped(obj/item/clothing/under/uniform, user)
	. = ..()
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE)

/obj/item/clothing/accessory/breathing/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/accessory_wearer = user
	examine_list += "[accessory_wearer.p_Their()] <b>[name]</b> reads: 'I breathe [breath_type]'."


/obj/item/clothing/accessory/vaporizer
	name = "\improper Stardress hydro-vaporizer"
	desc = "An expensive device manufactured for the civilian work-force of the Azulean military power. \
	Relying on an internal battery, the coil mechanism synthesizes a hydrogen oxygen mixture, \
	which can then be used to moisturize the wearer's skin. \n\n\
	<i>A label on its back warns about the potential dangers of electro-magnetic pulses.</i> \n\
	<b>ctrl-click</b> in-hand to hide the device while worn. \n\
	Can also be worn inside of a pocket."
	obj_flags = UNIQUE_RENAME
	attachment_slot = NONE

/datum/design/vaporizer
	name = "Hydro-Vaporizer"
	id = "vaporizer"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/accessory/vaporizer
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE
