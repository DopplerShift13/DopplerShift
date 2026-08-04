/datum/uplink_item/dangerous/tajaran_vibroblade
	name = "\improper Tajaran Vibroblade"
	desc = "A sheath carrying a rare Tajaran vibroblade. The oscillation allows the tip to bite through many \
	substances by the weapon's own weight alone."
	item = /obj/item/storage/belt/tajaran_sheath/vibro
	cost = 8 // esword but it ignores 75% of armor and has a cool sheath
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/bolt_thrower
	name = "\improper Tiziran Bolt Thrower"
	desc = "Gauss firearms are popular for Tiziran operators owing to the perception that a slug driven without \
	sparks is safer in potentially gaseous subterranean tunnels. Unfortunately it is also popular to overclock the \
	drivers and fire bolts with sufficient velocity to create explosive cavitation in the air anyway."
	item = /obj/item/gun/ballistic/bolt_thrower
	cost = 10
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/ammo/bolt_shot
	name = "machined slugs"
	desc = "Solid lathe turned slugs of ferrous alloy, ready to be shunted through a hot coil wrap and deep into something or \
	someone unfortunate."
	item = /obj/item/ammo_box/magazine/ammo_stack/bolt_slug/full
	cost = 1
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/megachoppa
	name = "\improper Tizirian Greatsword"
	desc = "A rare variation of the utilitarian Tiziran sabre, this design relies on the cutting edge of bronze metallurgy \
	to achieve such a lengthy blade. Exotic amendments to its constituent alloys allow for keener edge and help alleviate a rare \
	phenomena where clashed blades in near vacuum can contact weld to one another."
	item = /obj/item/melee/tizirian_sword/megachoppa
	cost = 5 // weaker than an esword & can't be hidden at all
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/saber
	name = "Saber"
	desc = "Forged by the artisan clans of the Uz'ka, it's a medium-sized, one-handed weapon that can cut through lightly armored or unarmored foes with utter ease. A staple for every member when going through their rites."
	item = /obj/item/claymore/cutlass
	cost = 8 // identical to an esword but cool looking
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/baseball
	name = "Ablative Bat"
	desc = "Specially forged by the highest ranking artisan clans, this bat was given to some of the Zar'Khet to act as vanguards. Used to dispel laser fire more commonly used in hostile lands, it gave a sense of courage and pride to those in the ranks."
	item = /obj/item/melee/baseball_bat/ablative
	cost = 6 // weaker than an esword but makes you laser immune which is really funny
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/minigun
	name = "Laser Minigun Backpack"
	desc = "A hefty power-pack that comes with a linked laser minigun capable of outputting a terrifying volley of firepower in full-auto. The power-pack must be worn on your back to be utilized properly, and the minigun may need time to cool after overheating."
	item = /obj/item/minigunpack
	cost = 8 // can't exactly hide it and it has some clear downsides
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/shrink_ray
	name = "Shrink Ray"
	desc = "This is a piece of frightening Grey tech that enhances the magnetic pull of atoms in a localized space to temporarily make an object shrink. Great for break-ins, or cutting a foe down to size. "
	item = /obj/item/gun/energy/shrink_ray/thinktank
	cost = 16 // free instant passage through walls & makes an opponent drop literally all of their stuff when hit
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/spikeroach_nade
	name = "Spike Synthroach Greande"
	desc = "Synthroaches are the remnants of old bio-synth weapons. A few survived the end of their war and the clean-up efforts, and evolved into pests that are ubiquitous on most ships. This grenade is full of 'spikeroaches', synth-roaches that were once fearsome self-detonating drones and are now...still self-detonating drones."
	item = /obj/item/grenade/spawnergrenade/spikeroach
	cost = 5
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/dangerous/n20_rock
	name = "Knockout Rock"
	desc = "Harvested from anomaly-rich asteroid belts, these rocks are crystallized and unstable clumps N20 gas. Crag Jumpers export them, but they double as weapons against their oxygen breathing foes in tight quarters, releasing deadly gas."
	item = /obj/item/grenade/gas_crystal/nitrous_oxide_crystal
	cost = 4
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)
