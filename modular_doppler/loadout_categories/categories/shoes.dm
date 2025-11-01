/datum/loadout_category/shoes
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/shoes/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/shoes/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/shoes/other_loadout_items = list()
	for(var/datum/loadout_item/shoes/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/datum/loadout_item/shoes/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.shoes))
		.. ()
		return TRUE

/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.shoes)
			LAZYADD(outfit.backpack_contents, outfit.shoes)
		outfit.shoes = item_path
	else
		outfit.shoes = item_path

/**
 * BOOTS
 */
/datum/loadout_item/shoes/boots
	group = "Boots"
	abstract_type = /datum/loadout_item/shoes/boots

/datum/loadout_item/shoes/boots/jackboots
	name = "Jackboots"
	item_path = /obj/item/clothing/shoes/jackboots

/datum/loadout_item/shoes/boots/jackboots/greyscale
	name = "Jackboots (Colorable)"
	item_path = /obj/item/clothing/shoes/jackboots/recolorable

/datum/loadout_item/shoes/boots/colonial_boots
	name = "Colonial Half-boots"
	item_path = /obj/item/clothing/shoes/jackboots/colonial

/datum/loadout_item/shoes/boots/colonial_boots/greyscale
	name = "Colonial Half-boots (Colorable)"
	item_path = /obj/item/clothing/shoes/jackboots/colonial/greyscale

/datum/loadout_item/shoes/boots/frontier_boots
	name = "Heavy Boots"
	item_path = /obj/item/clothing/shoes/jackboots/frontier_colonist

/datum/loadout_item/shoes/boots/aerostatic
	name = "Aerostatic Boots"
	item_path = /obj/item/clothing/shoes/kim

/datum/loadout_item/shoes/boots/workboots
	name = "Work Boots"
	item_path = /obj/item/clothing/shoes/workboots

/datum/loadout_item/shoes/boots/dark_workboots
	name = "Tactical Work Boots"
	item_path = /obj/item/clothing/shoes/workboots/black

/datum/loadout_item/shoes/boots/workboots_mining
	name = "Mining Boots"
	item_path = /obj/item/clothing/shoes/workboots/mining

/datum/loadout_item/shoes/boots/winterboots
	name = "Winter Boots"
	item_path = /obj/item/clothing/shoes/winterboots

/datum/loadout_item/shoes/boots/cowboy_brown
	name = "Cowboy Boots (Brown)"
	item_path = /obj/item/clothing/shoes/cowboy/laced

/datum/loadout_item/shoes/boots/cowboy_black
	name = "Cowboy Boots (Black)"
	item_path = /obj/item/clothing/shoes/cowboy/black/laced

/datum/loadout_item/shoes/boots/cowboy_white
	name = "Cowboy Boots (White)"
	item_path = /obj/item/clothing/shoes/cowboy/white/laced

/datum/loadout_item/shoes/boots/cowboy_lizard
	name = "Cowboy Boots (Lizard)"
	item_path = /obj/item/clothing/shoes/cowboy/lizard

/datum/loadout_item/shoes/boots/pirate
	name = "Pirate Boots"
	item_path = /obj/item/clothing/shoes/pirate

/datum/loadout_item/shoes/boots/magboots
	name = "Magboots"
	item_path = /obj/item/clothing/shoes/magboots

/**
 * OTHER SHOES
 */
/datum/loadout_item/shoes/other
	group = "Other Shoes"
	abstract_type = /datum/loadout_item/shoes/other

/datum/loadout_item/shoes/other/laceup
	name = "Laceup Shoes"
	item_path = /obj/item/clothing/shoes/laceup

/datum/loadout_item/shoes/other/greyscale_laceups
	name = "Laceup Shoes (Colorable)"
	item_path = /obj/item/clothing/shoes/colorable_laceups

/datum/loadout_item/shoes/other/disco
	name = "Green Lizardskin Shoes"
	item_path = /obj/item/clothing/shoes/discoshoes

/datum/loadout_item/shoes/other/medical
	name = "Medical Shoes"
	item_path = /obj/item/clothing/shoes/medical

/datum/loadout_item/shoes/other/sneakers
	name = "Sneakers"
	item_path = /obj/item/clothing/shoes/sneakers

/datum/loadout_item/shoes/other/sandal
	name = "Sandals"
	item_path = /obj/item/clothing/shoes/sandal

/datum/loadout_item/shoes/other/greyscale_sandals
	name = "Sandals (Colorable)"
	item_path = /obj/item/clothing/shoes/colorable_sandals

/datum/loadout_item/shoes/other/sandals_laced
	name = "Sandals (Velcro)"
	item_path = /obj/item/clothing/shoes/sandal/velcro

/datum/loadout_item/shoes/other/sandals_laced_black
	name = "Sandals (Black, Velcro)"
	item_path = /obj/item/clothing/shoes/sandal/alt/velcro

/**
 * SHIN COVERS
 */
/datum/loadout_item/shoes/shins
	group = "Shin Covers"
	abstract_type = /datum/loadout_item/shoes/shins

/datum/loadout_item/shoes/shins/lizard_shin_guards
	name = "Tizirian Shin Guards"
	item_path = /obj/item/clothing/shoes/lizard_shins

/datum/loadout_item/shoes/shins/tajaran_greaves
	name = "Greaves (Gold-Plate, Tajaran)"
	item_path = /obj/item/clothing/shoes/tajaran_shins

/datum/loadout_item/shoes/shins/vulp_greaves
	name = "Greaves (Alloy, Vulpkanin)"
	item_path = /obj/item/clothing/shoes/vulp_shins

/datum/loadout_item/shoes/shins/wraps
	name = "Cloth Footwraps"
	item_path = /obj/item/clothing/shoes/wraps

/datum/loadout_item/shoes/shins/wraps/leggy
	name = "Cloth Legwraps"
	item_path = /obj/item/clothing/shoes/wraps/leggy

/**
 * FUN
 */
/datum/loadout_item/shoes/fun
	group = "Fun Shoes"
	abstract_type = /datum/loadout_item/shoes/fun

/datum/loadout_item/shoes/fun/sneakers_rainbow
	name = "Rainbow Sneakers"
	item_path = /obj/item/clothing/shoes/sneakers/rainbow

/datum/loadout_item/shoes/fun/glow_shoes
	name = "Glow Shoes (Colorable)"
	item_path = /obj/item/clothing/shoes/glow

/datum/loadout_item/shoes/fun/swag
	name = "Drip Shoes"
	item_path = /obj/item/clothing/shoes/swagshoes

/datum/loadout_item/shoes/fun/wheelys
	name = "Wheelys"
	item_path = /obj/item/clothing/shoes/wheelys

/datum/loadout_item/shoes/fun/rainbowwheelies
	name = "Wheelys (Rainbow)"
	item_path = /obj/item/clothing/shoes/wheelys/rainbow

/datum/loadout_item/shoes/fun/skates
	name = "Roller Skates"
	item_path = /obj/item/clothing/shoes/wheelys/rollerskates

/datum/loadout_item/shoes/fun/rollerblades
	name = "Roller Blades"
	item_path = /obj/item/clothing/shoes/rollerblades

/datum/loadout_item/shoes/fun/clown_shoes
	name = "Clown Shoes"
	item_path = /obj/item/clothing/shoes/clown_shoes

/datum/loadout_item/shoes/fun/jester_shoes
	name = "Jester Shoes"
	item_path = /obj/item/clothing/shoes/jester_shoes
