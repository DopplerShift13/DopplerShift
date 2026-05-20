GLOBAL_LIST_INIT(possible_quirk_extracts, list(
	"Grey" = /obj/item/slime_extract/grey,
	"Green" = /obj/item/slime_extract/green,
	"Cerulean" = /obj/item/slime_extract/cerulean,
	"Blue" = /obj/item/slime_extract/blue,
	"Dark Blue" = /obj/item/slime_extract/darkblue,
	"Purple" = /obj/item/slime_extract/purple,
	"Dark Purple" = /obj/item/slime_extract/darkpurple,
	"Orange" = /obj/item/slime_extract/orange,
	"Yellow" = /obj/item/slime_extract/yellow,
	"Red" = /obj/item/slime_extract/red,
	"Pink" = /obj/item/slime_extract/pink,
	"Light Pink" = /obj/item/slime_extract/pink,
	"Black" = /obj/item/slime_extract/black,
	"Oil" = /obj/item/slime_extract/oil,
	"Sepia" = /obj/item/slime_extract/sepia,
	"Bluespace" = /obj/item/slime_extract/bluespace,
	"Rainbow" = /obj/item/slime_extract/rainbow,
	"Metal" = /obj/item/slime_extract/metal,
	"Silver" = /obj/item/slime_extract/silver,
	"Gold" = /obj/item/slime_extract/gold,
	"Adamantine" = /obj/item/slime_extract/adamantine,
	"Pyrite" = /obj/item/slime_extract/pyrite,
))

/datum/quirk/item_quirk/luminescent
	name = "Luminescent"
	desc = "You are more resonant-inclined than the rest of your slimy peers, and gain one slime extract of your choosing. Exclusive to Slimepeople."
	value = 1
	icon = FA_ICON_MAGIC
	gain_text = span_notice("You feel a power welling up within your core.")
	lose_text = span_warning("The power in your core fades...")
	medical_record_text = "Patient possesses a unique core."
	// a variable holding the extract spawned so we can keep track of it
	var/obj/item/slime_extract/spawned_extract
/datum/quirk/item_quirk/luminescent/add_unique(client/client_source)
	if(isjelly(quirk_holder))
	// fetch the quirk
	var/extract_path = GLOB.possible_quirk_extracts[client_source.prefs?.read_preference(/datum/preference/choiced/luminescent_extract)]
	// instantiate it in nullspace
	spawned_extract = new extract_path()
	// put in hands
	give_item_to_holder(spawned_extract, list(LOCATION_RPOCKET, LOCATION_LPOCKET, LOCATION_BACKPACK, LOCATION_HANDS))

/datum/quirk_constant_data/luminescent
		associated_typepath = /datum/quirk/item_quirk/luminescent
		customization_options = list(/datum/preference/choiced/luminescent_extract)

/datum/preference/choiced/luminescent_extract
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "luminescent_extract"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/luminescent_extract/init_possible_values()
	return list("Random") + assoc_to_keys(GLOB.possible_quirk_extracts)

/datum/preference/choiced/luminescent_extract/create_default_value()
	return "Random"

/datum/preference/choiced/luminescent_extract/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return "Luminescent" in preferences.all_quirks

/datum/preference/choiced/luminescent/apply_to_human(mob/living/carbon/human/target, value)
	return
