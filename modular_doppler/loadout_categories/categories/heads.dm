/datum/loadout_category/head
	/// How many maximum of these can be chosen
	var/max_allowed = MAX_ALLOWED_EXTRA_CLOTHES

/datum/loadout_category/head/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/head/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/head/other_loadout_items = list()
	for(var/datum/loadout_item/head/other_loadout_item in all_loadout_items)
		other_loadout_items += other_loadout_item

	if(length(other_loadout_items) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_loadout_items[1])
	return TRUE

/**
 * HATS
 */
/datum/loadout_item/head/hats
	group = "Hats"
	abstract_type = /datum/loadout_item/head/hats

/datum/loadout_item/head/hats/peakhat_tan
	name = "Tizirian Peak-Cover (Tan)"
	item_path = /obj/item/clothing/head/lizard_hat

/datum/loadout_item/head/hats/peakhat_white
	name = "Tizirian Peak-Cover (White)"
	item_path = /obj/item/clothing/head/lizard_hat/white

/datum/loadout_item/head/hats/flattop
	name = "Flat-Top (Vulpkanin)"
	item_path = /obj/item/clothing/head/vulp_hat

/datum/loadout_item/head/hats/slim_beret
	name = "Beret (Slim, Dark)"
	item_path = /obj/item/clothing/head/beret/doppler_command

/datum/loadout_item/head/hats/slim_beret_light
	name = "Beret (Slim, Light)"
	item_path = /obj/item/clothing/head/beret/doppler_command/light

/datum/loadout_item/head/hats/red_beret
	name = "Beret (Colorable)"
	item_path = /obj/item/clothing/head/beret

/datum/loadout_item/head/hats/sec_beret
	name = "Beret (Security)"
	item_path = /obj/item/clothing/head/beret/sec

/datum/loadout_item/head/hats/sec_beret_navy
	name = "Beret (Security, Blue)"
	item_path = /obj/item/clothing/head/beret/sec/navyofficer

/datum/loadout_item/head/hats/beret_badge
	name = "Beret (Colorable, Badge)"
	item_path = /obj/item/clothing/head/beret/colorable_badge

/datum/loadout_item/head/hats/cowboy_wide_feathered
	name = "Wide-Brimmed Hat (Feathered)"
	item_path = /obj/item/clothing/head/cowboy/doppler/wide/feathered

/datum/loadout_item/head/hats/cowboy_wide
	name = "Wide-Brimmed Hat"
	item_path = /obj/item/clothing/head/cowboy/doppler/wide

/datum/loadout_item/head/hats/cowboy_cattleman_wide
	name = "Cattleman Hat (Wide)"
	item_path = /obj/item/clothing/head/cowboy/doppler/cattleman/wide

/datum/loadout_item/head/hats/cowboy_cattleman
	name = "Cattleman Hat"
	item_path = /obj/item/clothing/head/cowboy/doppler/cattleman

/datum/loadout_item/head/hats/cowboy_ten_gallon
	name = "Ten-Gallon Hat"
	item_path = /obj/item/clothing/head/cowboy/white

/datum/loadout_item/head/hats/drifter_hat
	name = "Drifter Hat"
	item_path = /obj/item/clothing/head/cowboy/grey

/datum/loadout_item/head/hats/flat_brim
	name = "Flat-Brimmed Hat"
	item_path = /obj/item/clothing/head/cowboy/doppler/flat

/datum/loadout_item/head/hats/bowler_hat
	name = "Bowler Hat"
	item_path = /obj/item/clothing/head/hats/bowler

/datum/loadout_item/head/hats/fedora_greyscale
	name = "Fedora (Colorable)"
	item_path = /obj/item/clothing/head/fedora/greyscale

/datum/loadout_item/head/hats/beige_fedora
	name = "Fedora (Beige)"
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/hats/fedora
	name = "Fedora (Black)"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/hats/white_fedora
	name = "Fedora (White)"
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/hats/ushanka
	name = "Ushanka"
	item_path = /obj/item/clothing/head/costume/ushanka

/datum/loadout_item/head/hats/ushanka_sec
	name = "Ushanka (Security)"
	item_path = /obj/item/clothing/head/costume/ushanka/sec

/datum/loadout_item/head/hats/wrussian
	name = "Papakha (Black)"
	item_path = /obj/item/clothing/head/costume/papakha

/datum/loadout_item/head/hats/wrussianw
	name = "Papakha (White)"
	item_path = /obj/item/clothing/head/costume/papakha/white

/datum/loadout_item/head/hats/beanie
	name = "Beanie (Colorable)"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/hats/rastafarian
	name = "Beanie (Rastafarian)"
	item_path = /obj/item/clothing/head/rasta

/datum/loadout_item/head/hats/nurse_hat
	name = "Nurse Hat (Medical)"
	item_path = /obj/item/clothing/head/costume/nursehat

/**
 * CAPS
 */
/datum/loadout_item/head/caps
	group = "Caps"
	abstract_type = /datum/loadout_item/head/caps

/datum/loadout_item/head/caps/frontier_cap
	name = "Frontier Cap"
	item_path = /obj/item/clothing/head/soft/frontier_colonist

/datum/loadout_item/head/caps/frontier_med
	name = "Frontier Medical Cap"
	item_path = /obj/item/clothing/head/soft/frontier_colonist/medic

/datum/loadout_item/head/caps/security_cap
	name = "Security Cap"
	item_path = /obj/item/clothing/head/soft/sec

/datum/loadout_item/head/caps/para_cap
	name = "Paramedic Cap (Medical)"
	item_path = /obj/item/clothing/head/soft/paramedic

/datum/loadout_item/head/caps/cargo_cap
	name = "Cargo Cap"
	item_path = /obj/item/clothing/head/soft

/datum/loadout_item/head/caps/jan_cap
	name = "Janitor Cap (Service)"
	item_path = /obj/item/clothing/head/hats/janitor_doppler

/datum/loadout_item/head/caps/mining_cap
	name = "Explorer Cap (Mining)"
	item_path = /obj/item/clothing/head/mining_cap

/datum/loadout_item/head/caps/earcap
	name = "Earcap (Tajaran)"
	item_path = /obj/item/clothing/head/tajaran_hat

/datum/loadout_item/head/caps/black_cap
	name = "Cap (Black)"
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/caps/grey_cap
	name = "Cap (Grey)"
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/caps/white_cap
	name = "Cap (White)"
	item_path = /obj/item/clothing/head/soft/mime

/datum/loadout_item/head/caps/red_cap
	name = "Cap (Red)"
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/caps/orange_cap
	name = "Cap (Orange)"
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/caps/yellow_cap
	name = "Cap (Yellow)"
	item_path = /obj/item/clothing/head/soft/yellow

/datum/loadout_item/head/caps/green_cap
	name = "Cap (Green)"
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/caps/blue_cap
	name = "Cap (Blue)"
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/caps/purple_cap
	name = "Cap (Purple)"
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/caps/rainbow_cap
	name = "Cap (Rainbow)"
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/caps/colonial_cap
	name = "Colonial Cap"
	item_path = /obj/item/clothing/head/hats/colonial

/datum/loadout_item/head/caps/security_colonial_cap
	name = "Colonial Security Cap"
	item_path = /obj/item/clothing/head/cap_colonysec

/datum/loadout_item/head/caps/delinquent_cap
	name = "Deliquent Cap"
	item_path = /obj/item/clothing/head/costume/delinquent

/datum/loadout_item/head/caps/mail_cap
	name = "Mail Cap"
	item_path = /obj/item/clothing/head/costume/mailman

/datum/loadout_item/head/caps/blue_surgery
	name = "Surgery Cap (Medical, Blue)"
	item_path = /obj/item/clothing/head/utility/surgerycap

/datum/loadout_item/head/caps/burgundy_surgery
	name = "Surgery Cap (Medical, Burgundy)"
	item_path = /obj/item/clothing/head/utility/surgerycap/purple

/datum/loadout_item/head/caps/green_surgery
	name = "Surgery Cap (Medical, Green)"
	item_path = /obj/item/clothing/head/utility/surgerycap/green

/datum/loadout_item/head/caps/black_surgery
	name = "Surgery Cap (Medical, Black)"
	item_path = /obj/item/clothing/head/utility/surgerycap/black

/**
 * HELMETS
 */
/datum/loadout_item/head/helmets
	group = "Helmets"
	abstract_type = /datum/loadout_item/head/helmets

/datum/loadout_item/head/helmets/soft_helmet
	name = "Soft Helmet"
	item_path = /obj/item/clothing/head/frontier_colonist_helmet

/datum/loadout_item/head/helmets/vulp_skirmisher
	name = "Skirmisher Helmet (Vulpkanin)"
	item_path = /obj/item/clothing/head/helmet/vulp

/datum/loadout_item/head/helmets/tajaran_helmet
	name = "Tajaran Flophelmet"
	item_path = /obj/item/clothing/head/helmet/tajaran

/datum/loadout_item/head/helmets/tajaran_high_helmet
	name = "Tajaran High Flophelmet"
	item_path = /obj/item/clothing/head/helmet/tajaran/contract

/datum/loadout_item/head/helmets/lizard_helmet_tan
	name = "Tizirian Helmet (Tan)"
	item_path = /obj/item/clothing/head/helmet/lizard

/datum/loadout_item/head/helmets/lizard_helmet_white
	name = "Tizirian Helmet (White)"
	item_path = /obj/item/clothing/head/helmet/lizard/white

/datum/loadout_item/head/helmets/lizard_helmet_tan_glass
	name = "Tizirian Glassed Helmet (Tan)"
	item_path = /obj/item/clothing/head/helmet/lizard/glass

/datum/loadout_item/head/helmets/lizard_helmet_white_glass
	name = "Tizirian Glassed Helmet (White)"
	item_path = /obj/item/clothing/head/helmet/lizard/white/glass

/datum/loadout_item/head/helmets/fullhelmet
	name = "Yennika Full Helmet"
	item_path = /obj/item/clothing/head/helmet/sec/fullhelmet

/datum/loadout_item/head/helmets/fullhelmet/get_item_information()
	. = ..()
	.[FA_ICON_CIRCLE_EXCLAMATION] = "Cannot be taken off!"

/datum/loadout_item/head/helmets/breach_helmet
	name = "Breach Helmet"
	item_path = /obj/item/clothing/head/utility/hardhat/welding/doppler_dc

/datum/loadout_item/head/helmets/orange_hardhat
	name = "Hard Hat (Orange)"
	item_path = /obj/item/clothing/head/utility/hardhat/orange

/datum/loadout_item/head/helmets/yellow_hardhat
	name = "Hard Hat (Yellow)"
	item_path = /obj/item/clothing/head/utility/hardhat

/datum/loadout_item/head/helmets/white_hardhat
	name = "Hard Hat (White)"
	item_path = /obj/item/clothing/head/utility/hardhat/white

/datum/loadout_item/head/helmets/blue_hardhat
	name = "Hard Hat (Blue)"
	item_path = /obj/item/clothing/head/utility/hardhat/dblue

/datum/loadout_item/head/helmets/red_hardhat
	name = "Hard Hat (Red)"
	item_path = /obj/item/clothing/head/utility/hardhat/red

/**
 * HAIR ACCESSORIES
 */
/datum/loadout_item/head/hair_accessories
	group = "Hair Accessories"
	abstract_type = /datum/loadout_item/head/hair_accessories

/datum/loadout_item/head/hair_accessories/bow_large
	name = "Bow (Large)"
	item_path = /obj/item/clothing/head/bow

/datum/loadout_item/head/hair_accessories/bow_small
	name = "Bow (Small)"
	item_path = /obj/item/clothing/head/bow/small

/datum/loadout_item/head/hair_accessories/bow_back
	name = "Bow (Back)"
	item_path = /obj/item/clothing/head/bow/back

/datum/loadout_item/head/hair_accessories/bow_sweet
	name = "Bow (Sweet)"
	item_path = /obj/item/clothing/head/bow/sweet

/datum/loadout_item/head/hair_accessories/maid_headband
	name = "Maid Headband"
	item_path = /obj/item/clothing/head/costume/maid_headband

/datum/loadout_item/head/hair_accessories/hair_tie
	name = "Hairtie"
	item_path = /obj/item/clothing/head/hair_tie

/datum/loadout_item/head/hair_accessories/hair_tie_scrunchie
	name = "Hairtie (Scrunchie)"
	item_path = /obj/item/clothing/head/hair_tie/scrunchie

/datum/loadout_item/head/hair_accessories/hair_tie_plastic
	name = "Hairtie (Plastic)"
	item_path = /obj/item/clothing/head/hair_tie/plastic_beads

/**
 * FLOWERS
 */
/datum/loadout_item/head/flowers
	group = "Flowers"
	abstract_type = /datum/loadout_item/head/flowers

/datum/loadout_item/head/flowers/rose
	name = "Flower (Rose)"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/flowers/poppy
	name = "Flower (Poppy)"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/flowers/sunflower
	name = "Flower (Sunflower)"
	item_path = /obj/item/food/grown/sunflower

/datum/loadout_item/head/flowers/geranium
	name = "Flower (Geranium)"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/flowers/harebell
	name = "Flower (Harebell)"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/flowers/lily
	name = "Flower (Lily)"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/flowers/moonflower
	name = "Flower (Moonflower)"
	item_path = /obj/item/food/grown/moonflower

/datum/loadout_item/head/flowers/fraxinella
	name = "Flower (Fraxinella)"
	item_path = /obj/item/food/grown/poppy/geranium/fraxinella

/datum/loadout_item/head/flowers/fireblossom
	name = "Flower (Fireblossom)"
	item_path = /obj/item/food/grown/ash_flora/fireblossom

/datum/loadout_item/head/flowers/garland
	name = "Garland"
	item_path = /obj/item/clothing/head/costume/garland

/datum/loadout_item/head/flowers/garland/rainbowbunch
	name = "Garland (Rainbow)"
	item_path = /obj/item/clothing/head/costume/garland/rainbowbunch

/datum/loadout_item/head/flowers/garland/sunflower
	name = "Garland (Sunflower)"
	item_path = /obj/item/clothing/head/costume/garland/sunflower

/datum/loadout_item/head/flowers/garland/poppy
	name = "Garland (Poppy)"
	item_path = /obj/item/clothing/head/costume/garland/poppy

/datum/loadout_item/head/flowers/garland/lily
	name = "Garland (Lily)"
	item_path = /obj/item/clothing/head/costume/garland/lily

/**
 * COSTUME
 */
/datum/loadout_item/head/costume
	group = "Costume"
	abstract_type = /datum/loadout_item/head/costume

/datum/loadout_item/head/costume/witch
	name = "Witch Hat"
	item_path = /obj/item/clothing/head/wizard/marisa/fake

/datum/loadout_item/head/costume/wizard
	name = "Wizard Hat"
	item_path = /obj/item/clothing/head/wizard

/datum/loadout_item/head/costume/fancy_cap
	name = "Fancy Hat"
	item_path = /obj/item/clothing/head/costume/fancy

/datum/loadout_item/head/costume/top_hat
	name = "Top Hat"
	item_path = /obj/item/clothing/head/hats/tophat

/datum/loadout_item/head/costume/sombrero_green
	name = "Green Sombrero"
	item_path = /obj/item/clothing/head/costume/sombrero/green

/datum/loadout_item/head/costume/propeller_hat
	name = "Propeller Hat"
	item_path = /obj/item/clothing/head/soft/propeller_hat

/datum/loadout_item/head/costume/jester
	name = "Jester Hat (Small)"
	item_path = /obj/item/clothing/head/costume/jester

/datum/loadout_item/head/costume/jesteralt
	name = "Jester Hat (Large)"
	item_path = /obj/item/clothing/head/costume/jesteralt

/datum/loadout_item/head/costume/pirate
	name = "Pirate Hat (Classic)"
	item_path = /obj/item/clothing/head/costume/pirate

/datum/loadout_item/head/costume/pirate/captain
	name = "Pirate Hat (Captain)"
	item_path = /obj/item/clothing/head/costume/pirate/captain

/datum/loadout_item/head/costume/crown
	name = "Crown"
	item_path = /obj/item/clothing/head/costume/crown

/datum/loadout_item/head/costume/kitty_ears
	name = "Kitty Ears"
	item_path = /obj/item/clothing/head/costume/kitty

/datum/loadout_item/head/costume/rabbit_ears
	name = "Rabbit Ears"
	item_path = /obj/item/clothing/head/costume/rabbitears

/datum/loadout_item/head/costume/tv_head
	name = "TV Head"
	item_path = /obj/item/clothing/head/costume/tv_head

/datum/loadout_item/head/costume/cardborg
	name = "Cardborg"
	item_path = /obj/item/clothing/head/costume/cardborg

/datum/loadout_item/head/costume/cone
	name = "Traffic Cone"
	item_path = /obj/item/clothing/head/cone

/datum/loadout_item/head/costume/rice_hat
	name = "Rice Hat"
	item_path = /obj/item/clothing/head/costume/rice_hat

/datum/loadout_item/head/costume/wig
	name = "Natural Wig"
	item_path = /obj/item/clothing/head/wig/natural

/**
 * MISCELLANEOUS
 */
/datum/loadout_item/head/misc
	group = "Miscellaneous"
	abstract_type = /datum/loadout_item/head/misc

/datum/loadout_item/head/misc/mirror
	name = "Head Mirror (Medical)"
	item_path = /obj/item/clothing/head/utility/head_mirror

/datum/loadout_item/head/misc/chef
	name = "Chef Hat (Service)"
	item_path = /obj/item/clothing/head/utility/chefhat

/datum/loadout_item/head/misc/vulp_bandana
	name = "Bandana (Vulpkanin)"
	item_path = /obj/item/clothing/head/vulp_hat/headband

/datum/loadout_item/head/misc/bandana
	name = "Bandana (Thin)"
	item_path = /obj/item/clothing/head/costume/tmc

/datum/loadout_item/head/misc/flowing_headband
	name = "Flowing Headband"
	item_path = /obj/item/clothing/head/flowing_headband

/datum/loadout_item/head/misc/bear_pelt
	name = "Bear Pelt"
	item_path = /obj/item/clothing/head/costume/bearpelt

/datum/loadout_item/head/misc/the_hood
	name = "Standalone Hood"
	item_path = /obj/item/clothing/head/standalone_hood

/datum/loadout_item/head/misc/decker_headphones
	name = "Decker Headphones"
	item_path = /obj/item/clothing/head/costume/deckers

/datum/loadout_item/head/misc/welding
	name = "Welding Mask"
	item_path = /obj/item/clothing/head/utility/welding

/datum/loadout_item/head/misc/nightcap_blue
	name = "Nightcap (Blue)"
	item_path = /obj/item/clothing/head/costume/nightcap/blue

/datum/loadout_item/head/misc/nightcap_red
	name = "Nightcap (Red)"
	item_path = /obj/item/clothing/head/costume/nightcap/red
