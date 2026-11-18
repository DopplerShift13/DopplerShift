#define SHELL_TRANSPARENCY_ALPHA 90

/datum/species/snail
	preview_outfit = /datum/outfit/snail_preview
	mutantliver = /obj/item/organ/liver/snail //This is just a better liver to deal with toxins, it's a thematic thing.
	mutantheart = /obj/item/organ/heart/snail //This gives them the shell buff where they take less damage from behind, and their heart's more durable.
	exotic_bloodtype = BLOOD_TYPE_INSECTOID
	digitigrade_customization = DIGITIGRADE_OPTIONAL
	digi_leg_overrides = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/insectoid,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/insectoid,
	)

/datum/outfit/snail_preview
	name = "Snail (Species Preview)"
	uniform = /obj/item/clothing/under/rank/medical/chemist/pharmacologist/skirt
	mask = /obj/item/clothing/mask/surgical

/datum/species/snail/on_species_gain(mob/living/carbon/new_snailperson, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	new_snailperson.update_icons()

/obj/item/storage/backpack/snail
	/// Whether or not a bluespace anomaly core has been inserted
	var/storage_core = FALSE
	alternate_worn_layer = ABOVE_BODY_FRONT_LAYER //This makes them layer over tails like the cult backpack; some tails really shouldn't appear over them!

/obj/item/storage/backpack/snail/Initialize(mapload)
	. = ..()
	atom_storage.max_total_storage = 30
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/doppler/snailbag)

/datum/atom_skin/doppler/snailbag
	abstract_type = /datum/atom_skin/doppler/snailbag

/datum/atom_skin/doppler/snailbag/conical
	preview_name = "Conical Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "coneshell"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "coneshell"

/datum/atom_skin/doppler/snailbag/round
	preview_name = "Round Shell"
	new_icon = 'icons/obj/storage/backpack.dmi'
	new_icon_state = "snailshell"
	new_worn_file = 'icons/mob/clothing/back/backpack.dmi'
	new_worn_icon_state = "snailshell"

/datum/atom_skin/doppler/snailbag/cinnamon
	preview_name = "Cinnamon Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "cinnamonshell"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "cinnamonshell"

/datum/atom_skin/doppler/snailbag/caramel
	preview_name = "Caramel Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "caramelshell"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "caramelshell"

/datum/atom_skin/doppler/snailbag/metal
	preview_name = "Metal Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "mechashell"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "mechashell"

/datum/atom_skin/doppler/snailbag/pyramid
	preview_name = "Pyramid Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "pyramidshell"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "pyramidshell"

/datum/atom_skin/doppler/snailbag/ivory_pyramid
	preview_name = "Ivory Pyramid Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "pyramidshellwhite"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "pyramidshellwhite"

/datum/atom_skin/doppler/snailbag/spiral
	preview_name = "Spiral Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "spiralshell"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "spiralshell"

/datum/atom_skin/doppler/snailbag/ivory_spiral
	preview_name = "Ivory Spiral Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "spiralshellwhite"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "spiralshellwhite"

/datum/atom_skin/doppler/snailbag/rocky
	preview_name = "Rocky Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "rockshell"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "rockshell"

/datum/atom_skin/doppler/snailbag/ivory_rocky
	preview_name = "Ivory Rocky Shell"
	new_icon = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_obj.dmi'
	new_icon_state = "rockshellwhite"
	new_worn_file = 'modular_doppler/modular_species/species_types/snails/icons/shell/shell_mob.dmi'
	new_worn_icon_state = "rockshellwhite"

/obj/item/storage/backpack/snail/build_worn_icon(
	default_layer = 0,
	default_icon_file = null,
	isinhands = FALSE,
	female_uniform = NO_FEMALE_UNIFORM,
	override_state = null,
	override_file = null,
	mutant_styles = NONE,
	humie = null,
)

	var/mutable_appearance/standing = ..()
	if(storage_core == TRUE)
		standing.add_filter("bluespace_shell", 2, list("type" = "outline", "color" = COLOR_BLUE_LIGHT, "alpha" = SHELL_TRANSPARENCY_ALPHA, "size" = 1))
	return standing

/obj/item/storage/backpack/snail/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(storage_core || !istype(tool, /obj/item/assembly/signaler/anomaly/bluespace))
		return NONE

	qdel(tool)
	upgrade_to_bluespace(user)
	to_chat(user, span_notice("You insert [tool] into your shell, and it starts to glow blue with expanded storage potential!"))
	return ITEM_INTERACT_SUCCESS

/// Upgrades the storage capacity of the snail shell and gives it a glowy blue outline
/obj/item/storage/backpack/snail/proc/upgrade_to_bluespace(mob/living/wearer)
	add_filter("bluespace_shell", 2, list("type" = "outline", "color" = COLOR_BLUE_LIGHT, "size" = 1))
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	storage_core = TRUE
	var/old_inventory = atom_storage.return_inv(FALSE)
	emptyStorage()
	create_storage(max_specific_storage = WEIGHT_CLASS_GIGANTIC, max_total_storage = 35, max_slots = 30, storage_type = /datum/storage/bag_of_holding)
	for(var/obj/item/stored_item in old_inventory)
		atom_storage.attempt_insert(stored_item, override = TRUE, messages = FALSE, force = TRUE)
	name = "snail shell of holding"
	update_appearance()

	// Update the worn sprite with the blue outline too if applicable
	if(isnull(wearer))
		wearer = loc
	if(istype(wearer))
		wearer.update_worn_back()

/datum/species/snail/prepare_human_for_preview(mob/living/carbon/human/snail)
	turn_off_every_species_feature(snail)
	snail.dna.features[FEATURE_MUTANT_COLOR] = "#797289"
	snail.hairstyle = "Phoenix Half-Shaven"
	snail.hair_color = "#4C3C7E"
	snail.eye_color_left = "#615188"
	snail.eye_color_right = "#615188"
	regenerate_organs(snail, src, visual_only = TRUE)
	snail.update_body(TRUE)

/datum/species/snail/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "home",
			SPECIES_PERK_NAME = "Shellback",
			SPECIES_PERK_DESC = "Snails have a shell fused to their back. It offers great storage and most importantly gives them 50% brute damage reduction from behind, or while resting. Alt click to change the sprite!",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "wine-glass",
			SPECIES_PERK_NAME = "Poison Resistance",
			SPECIES_PERK_DESC = "Snails have a higher tolerance for poison owing to their robust livers.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "heart",
			SPECIES_PERK_NAME = "Double Hearts",
			SPECIES_PERK_DESC = "Snails have two hearts, meaning it'll take more to break theirs.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bone",
			SPECIES_PERK_NAME = "Boneless",
			SPECIES_PERK_DESC = "Snails are invertebrates, meaning they don't take bone wounds, but are easier to delimb.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "crutch",
			SPECIES_PERK_NAME = "Sheer Mollusk Speed",
			SPECIES_PERK_DESC = "Snails move incredibly slow while standing. They move much faster while crawling, and can stick to the floors when the gravity is out.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "frown",
			SPECIES_PERK_NAME = "Weak Fighter",
			SPECIES_PERK_DESC = "Snails punch half as hard as a human.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "skull",
			SPECIES_PERK_NAME = "Salt Weakness",
			SPECIES_PERK_DESC = "Salt burns snails, and salt piles will block their path.",
		),
	)

	return to_add

#undef SHELL_TRANSPARENCY_ALPHA
