/datum/loadout_category/undersuit
	category_name = "Undersuit"
	category_ui_icon = FA_ICON_SHIRT
	type_to_generate = /datum/loadout_item/undersuit
	tab_order = /datum/loadout_category/suit::tab_order + 1
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/undersuit/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/undersuit/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/undersuit/other_loadout_items = list()
	for(var/datum/loadout_item/undersuit/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/*
*	LOADOUT ITEM DATUMS FOR THE UNDERSUIT SLOT
*/

/datum/loadout_item/undersuit
	abstract_type = /datum/loadout_item/undersuit

/datum/loadout_item/undersuit/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE) // don't bother storing in backpack, can't fit
	if(initial(outfit_important_for_life.uniform))
		return TRUE

/datum/loadout_item/undersuit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.uniform)
			if(equipper.jumpsuit_style == PREF_SKIRT)
				outfit.uniform = "[outfit.uniform]/skirt"
				if(!text2path(outfit.uniform))
					outfit.uniform = initial(outfit.uniform)
				LAZYADD(outfit.backpack_contents, outfit.uniform)
			else
				LAZYADD(outfit.backpack_contents, outfit.uniform)
		outfit.uniform = item_path
	else
		outfit.uniform = item_path


/**
 * PANTS
 */
/datum/loadout_item/undersuit/pants
	group = "Pants"
	abstract_type = /datum/loadout_item/undersuit/pants

/datum/loadout_item/undersuit/pants/doppler_uniform
	name = "Doppler Uniform"
	item_path = /obj/item/clothing/under/misc/doppler_uniform/standard

/datum/loadout_item/undersuit/pants/doppler_uniform/overalls
	name = "Doppler Uniform (Overalls)"
	item_path = /obj/item/clothing/under/misc/doppler_uniform/standard/overalls

/datum/loadout_item/undersuit/pants/doppler_uniform/cozy
	name = "Cozy Doppler Uniform"
	item_path = /obj/item/clothing/under/misc/doppler_uniform/standard/cozy

/datum/loadout_item/undersuit/pants/doppler_uniform/cozy/overalls
	name = "Cozy Doppler Uniform (Overalls)"
	item_path = /obj/item/clothing/under/misc/doppler_uniform/standard/cozy/overalls

/datum/loadout_item/undersuit/pants/doppler_uniform/suit/overalls/random
	name = "Cozy Doppler Uniform (Overalls, Random)"
	item_path = /obj/item/clothing/under/misc/doppler_uniform/standard/suit/overalls/colored

/datum/loadout_item/undersuit/pants/doppler_uniform/suit
	name = "Doppler Suit"
	item_path = /obj/item/clothing/under/misc/doppler_uniform/standard/suit

/datum/loadout_item/undersuit/pants/doppler_uniform/suit/overalls
	name = "Doppler Suit (Overalls)"
	item_path = /obj/item/clothing/under/misc/doppler_uniform/standard/suit/overalls

/datum/loadout_item/undersuit/pants/cowl_neck
	name = "Cowl Neck Shirt & Trousers"
	item_path = /obj/item/clothing/under/cowl_neck_shirt

/datum/loadout_item/undersuit/pants/collared_shirt
	name = "Collared Shirt & Trousers"
	item_path = /obj/item/clothing/under/collared_shirt

/datum/loadout_item/undersuit/pants/detective_suit
	name = "Hard-Worn Suit"
	item_path = /obj/item/clothing/under/rank/security/detective

/datum/loadout_item/undersuit/pants/noir_suit
	name = "Noir Suit"
	item_path = /obj/item/clothing/under/rank/security/detective/noir

/datum/loadout_item/undersuit/pants/disco
	name = "Superstar Cop Uniform"
	item_path = /obj/item/clothing/under/rank/security/detective/disco

/datum/loadout_item/undersuit/pants/aerostatic
	name = "Aerostatic Suit"
	item_path = /obj/item/clothing/under/rank/security/detective/kim

/datum/loadout_item/undersuit/pants/black_really
	name = "Executive Suit"
	item_path = /obj/item/clothing/under/suit/black_really

/datum/loadout_item/undersuit/pants/lost_mc
	name = "Lost MC Clothing"
	item_path = /obj/item/clothing/under/costume/tmc

/datum/loadout_item/undersuit/pants/buttondown_slacks
	name = "Buttondown & Slacks"
	item_path = /obj/item/clothing/under/costume/buttondown/slacks

/datum/loadout_item/undersuit/pants/mining_overalls
	name = "Explorer Overalls (Cargo, Mining)"
	item_path = /obj/item/clothing/under/rank/cargo/miner

/datum/loadout_item/undersuit/pants/mining_turtle
	name = "Explorer Turtleneck (Cargo, Mining)"
	item_path = /obj/item/clothing/under/rank/cargo/miner/lavaland

/datum/loadout_item/undersuit/pants/cargo_tech_uniform
	name = "Cargo Uniform"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech

/datum/loadout_item/undersuit/pants/cargo_tech_tanktop
	name = "Cargo Uniform Tanktop"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech/alt

/datum/loadout_item/undersuit/pants/cargo_tech_turtleneck
	name = "Cargo Turtleneck"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech/turtleneck

/datum/loadout_item/undersuit/pants/cargo_tech_rough
	name = "Cargo Rugged Uniform"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech/rough

/datum/loadout_item/undersuit/pants/combat
	name = "Combat Uniform"
	item_path = /obj/item/clothing/under/syndicate/combat

/datum/loadout_item/undersuit/pants/turtleneck
	name = "Tactical Turtleneck"
	item_path = /obj/item/clothing/under/syndicate

/datum/loadout_item/undersuit/pants/tajaran_corset
	name = "Tajaran Warrior's Corset"
	item_path = /obj/item/clothing/under/tajaran_corset

/datum/loadout_item/undersuit/pants/vulp_pants
	name = "Vulpkanin Padded Combat Pants"
	item_path = /obj/item/clothing/under/vulp_pants

/datum/loadout_item/undersuit/pants/slacks
	name = "Slacks"
	item_path = /obj/item/clothing/under/pants/slacks

/datum/loadout_item/undersuit/pants/jeans
	name = "Jeans"
	item_path = /obj/item/clothing/under/pants/jeans

/datum/loadout_item/undersuit/pants/ripped_jeans
	name = "Jeans (Ripped)"
	item_path = /obj/item/clothing/under/pants/jeans/ripped

/datum/loadout_item/undersuit/pants/moto
	name = "Moto Pants"
	item_path = /obj/item/clothing/under/pants/moto_leggings

/datum/loadout_item/undersuit/pants/track
	name = "Track Pants"
	item_path = /obj/item/clothing/under/pants/track

/datum/loadout_item/undersuit/pants/camo
	name = "Camo Pants"
	item_path = /obj/item/clothing/under/pants/camo

/datum/loadout_item/undersuit/pants/big_pants
	name = "JUNCO Megacargo Pants (Cargo)"
	item_path = /obj/item/clothing/under/pants/big_pants

/datum/loadout_item/undersuit/pants/shortalls
	name = "Short Overalls"
	item_path = /obj/item/clothing/under/shortalls

/**
 * SHORTS
 */
/datum/loadout_item/undersuit/short
	group = "Shorts"
	abstract_type = /datum/loadout_item/undersuit/short

/datum/loadout_item/undersuit/short/buttondown_shorts
	name = "Buttondown & Shorts"
	item_path = /obj/item/clothing/under/costume/buttondown/shorts

/datum/loadout_item/undersuit/short/shorts
	name = "Shorts"
	item_path = /obj/item/clothing/under/shorts

/datum/loadout_item/undersuit/short/shorter
	name = "Shorts (Shorter)"
	item_path = /obj/item/clothing/under/shorts/shorter

/datum/loadout_item/undersuit/short/shortest
	name = "Shorts (Shortest)"
	item_path = /obj/item/clothing/under/shorts/shorter/shortest

/datum/loadout_item/undersuit/short/jean_shorts
	name = "Jean Shorts"
	item_path = /obj/item/clothing/under/shorts/jeanshorts

/datum/loadout_item/undersuit/short/jean_shorter
	name = "Jean Shorts (Shorter)"
	item_path = /obj/item/clothing/under/shorts/shorter/jeans

/datum/loadout_item/undersuit/short/jeans_shortest
	name = "Jean Shorts (Shortest)"
	item_path = /obj/item/clothing/under/shorts/shorter/jeans/shortest

/**
 * SKIRTS
 */
/datum/loadout_item/undersuit/skirt
	group = "Skirts"
	abstract_type = /datum/loadout_item/undersuit/skirt

/datum/loadout_item/undersuit/skirt/buttondown_skirt
	name = "Buttondown & Skirt"
	item_path = /obj/item/clothing/under/costume/buttondown/skirt

/datum/loadout_item/undersuit/skirt/formal
	name = "Pencilskirt & Shirt"
	item_path = /obj/item/clothing/under/suit/pencil

/datum/loadout_item/undersuit/skirt/formal/pencil
	name = "Pencilskirt"
	item_path = /obj/item/clothing/under/suit/pencil/noshirt

/datum/loadout_item/undersuit/skirt/formal/pencil/black_really
	name = "Pencilskirt (Executive)"
	item_path = /obj/item/clothing/under/suit/pencil/black_really

/datum/loadout_item/undersuit/skirt/formal/pencil/charcoal
	name = "Pencilskirt (Charcoal)"
	item_path = /obj/item/clothing/under/suit/pencil/charcoal

/datum/loadout_item/undersuit/skirt/formal/pencil/checkered
	name = "Pencilskirt & Shirt (Checkered)"
	item_path = /obj/item/clothing/under/suit/pencil/checkered

/datum/loadout_item/undersuit/skirt/formal/pencil/checkered/noshirt
	name = "Pencilskirt (Checkered)"
	item_path = /obj/item/clothing/under/suit/pencil/checkered/noshirt

/datum/loadout_item/undersuit/skirt/formal/pencil/tan
	name = "Pencilskirt (Tan)"
	item_path = /obj/item/clothing/under/suit/pencil/tan

/datum/loadout_item/undersuit/skirt/formal/pencil/green
	name = "Pencilskirt (Green)"
	item_path = /obj/item/clothing/under/suit/pencil/green

/datum/loadout_item/undersuit/skirt/lizard_kilt_tan
	name = "Tizirian War Kilt (Tan)"
	item_path = /obj/item/clothing/under/lizard_kilt

/datum/loadout_item/undersuit/skirt/lizard_kilt_white
	name = "Tizirian War Kilt (White)"
	item_path = /obj/item/clothing/under/lizard_kilt/white

/datum/loadout_item/undersuit/skirt/simple
	name = "Skirt (Simple)"
	item_path = /obj/item/clothing/under/shorts/shorter/skirt

/datum/loadout_item/undersuit/skirt/medium
	name = "Skirt (Medium)"
	item_path = /obj/item/clothing/under/dress/skirt/medium

/datum/loadout_item/undersuit/skirt/long
	name = "Skirt (Long)"
	item_path = /obj/item/clothing/under/dress/skirt/long

/datum/loadout_item/undersuit/skirt/highwaisted
	name = "Skirt (High-Waisted)"
	item_path = /obj/item/clothing/under/dress/skirt/highwaisted_skirt

/datum/loadout_item/undersuit/skirt/mini
	name = "Skirt (Mini)"
	item_path = /obj/item/clothing/under/dress/skirt/miniskirt

/datum/loadout_item/undersuit/skirt/cargo_tech_uniform_skirt
	name = "Cargo Uniform Skirt"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech/skirt

/datum/loadout_item/undersuit/skirt/cargo_tech_tankskirt
	name = "Cargo Uniform Tanktop & Skirt"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech/skirt/alt

/datum/loadout_item/undersuit/skirt/cargo_tech_turtleskirt
	name = "Cargo Turtleneck & Skirt"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech/turtleskirt

/datum/loadout_item/undersuit/skirt/cargo_tech_rough_skirt
	name = "Cargo Rugged Skirt Uniform"
	item_path = /obj/item/clothing/under/rank/doppler_cargo/tech/rough_skirt

/**
 * DRESSES
 */
/datum/loadout_item/undersuit/dress
	group = "Dresses"
	abstract_type = /datum/loadout_item/undersuit/dress

/datum/loadout_item/undersuit/dress/evening
	name = "Evening Dress"
	item_path = /obj/item/clothing/under/dress/eveninggown

/datum/loadout_item/undersuit/dress/sun
	name = "Sun Dress"
	item_path = /obj/item/clothing/under/dress/sundress

/datum/loadout_item/undersuit/dress/striped
	name = "Striped Dress"
	item_path = /obj/item/clothing/under/dress/striped

/datum/loadout_item/undersuit/dress/tango
	name = "Tango Dress"
	item_path = /obj/item/clothing/under/dress/tango

/datum/loadout_item/undersuit/dress/jacket_dress
	name = "Dress & Jacket"
	item_path = /obj/item/clothing/under/dress/skirt

/datum/loadout_item/undersuit/dress/plaid
	name = "Plaid Dress"
	item_path = /obj/item/clothing/under/dress/skirt/plaid

/datum/loadout_item/undersuit/dress/turtle_dress
	name = "Turtleneck Dress"
	item_path = /obj/item/clothing/under/dress/skirt/turtleskirt

/datum/loadout_item/undersuit/dress/tutu
	name = "Pink Tutu"
	item_path = /obj/item/clothing/under/dress/doppler/pinktutu

/datum/loadout_item/undersuit/dress/flower
	name = "Flower Dress"
	item_path = /obj/item/clothing/under/dress/doppler/flower

/datum/loadout_item/undersuit/dress/penta
	name = "Pentagram Dress"
	item_path = /obj/item/clothing/under/dress/doppler/pentagram

/datum/loadout_item/undersuit/dress/strapless
	name = "Strapless Dress"
	item_path = /obj/item/clothing/under/dress/doppler/strapless

/datum/loadout_item/undersuit/dress/halter_dress
	name = "Halter Dress"
	item_path = /obj/item/clothing/under/dress/doppler/halter_dress

/datum/loadout_item/undersuit/dress/sweaterdress
	name = "Keyhole Sweater Dress"
	item_path = /obj/item/clothing/under/dress/doppler/sweaterdress

/datum/loadout_item/undersuit/dress/maid
	name = "Maid Dress"
	item_path = /obj/item/clothing/under/costume/maid

/datum/loadout_item/undersuit/dress/maid_uniform
	name = "Maid Uniform"
	item_path = /obj/item/clothing/under/rank/civilian/janitor/maid

/datum/loadout_item/undersuit/dress/qipao
	name = "Qipao"
	item_path = /obj/item/clothing/under/dress/doppler/qipao

/datum/loadout_item/undersuit/dress/qipao/customtrim
	name = "Qipao (Custom Trim)"
	item_path = /obj/item/clothing/under/dress/doppler/qipao/customtrim

/**
 * FULLBODY
 */
/datum/loadout_item/undersuit/fullbody
	group = "Full Body"
	abstract_type = /datum/loadout_item/undersuit/fullbody

/datum/loadout_item/undersuit/fullbody/dress_cheongsam
	name = "Cheongsam"
	item_path = /obj/item/clothing/under/dress/doppler/cheongsam

/datum/loadout_item/undersuit/fullbody/dress_cheongsam/customtrim
	name = "Cheongsam (Custom Trim)"
	item_path = /obj/item/clothing/under/dress/doppler/cheongsam/customtrim

/datum/loadout_item/undersuit/fullbody/dress_yukata
	name = "Custom Yukata"
	item_path = /obj/item/clothing/under/costume/yukata/greyscale

/datum/loadout_item/undersuit/fullbody/dress_kimono
	name = "Custom Kimono"
	item_path = /obj/item/clothing/under/costume/kimono/greyscale

/datum/loadout_item/undersuit/fullbody/bodysuit
	name = "Bodysuit"
	item_path = /obj/item/clothing/under/bodysuit

/datum/loadout_item/undersuit/fullbody/jumpsuit
	name = "Colorable Jumpsuit"
	item_path = /obj/item/clothing/under/color

/datum/loadout_item/undersuit/fullbody/jumpskirt
	name = "Colorable Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt

/datum/loadout_item/undersuit/fullbody/jumpskirt/rainbow
	name = "Raindow Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/rainbow

/datum/loadout_item/undersuit/fullbody/frontier
	name = "Frontier Jumpsuit"
	item_path = /obj/item/clothing/under/frontier_colonist

/datum/loadout_item/undersuit/fullbody/osi
	name = "OSI Jumpsuit"
	item_path = /obj/item/clothing/under/costume/osi

/datum/loadout_item/undersuit/fullbody/athletas_bodysuit
	name = "ATHLETAS Bodysuit"
	item_path = /obj/item/clothing/under/athletas_bodysuit

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/undersuit/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/undersuit/misc

/datum/loadout_item/undersuit/misc/loincloth
	name = "Loincloth"
	item_path = /obj/item/clothing/under/dress/skirt/loincloth

/datum/loadout_item/undersuit/misc/loincloth_alt
	name = "Loincloth, Alt"
	item_path = /obj/item/clothing/under/dress/skirt/loincloth/loincloth_alt

/datum/loadout_item/undersuit/misc/dress_giantscarf
	name = "Giant Scarf"
	item_path = /obj/item/clothing/under/dress/doppler/giant_scarf

/datum/loadout_item/undersuit/misc/gear_harness
	name = "Gear Harness"
	item_path = /obj/item/clothing/under/misc/gear_harness

/datum/loadout_item/undersuit/misc/gear_harness_visible
	name = "Gear Harness (Visible)"
	item_path = /obj/item/clothing/under/misc/gear_harness/visible

/datum/loadout_item/undersuit/misc/bunnysuit
	name = "Bunny Suit"
	item_path = /obj/item/clothing/under/costume/bunnysuit

/datum/loadout_item/undersuit/misc/biosuit_alt
	name = "Biosuit (White)"
	item_path = /obj/item/clothing/under/underlayer/white
