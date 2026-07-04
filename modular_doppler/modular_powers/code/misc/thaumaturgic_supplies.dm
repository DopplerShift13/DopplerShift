/datum/supply_pack/costumes_toys/thaumaturgic
	name = "Thaumaturgic Crate"
	desc = "Contains 3 spell focusi for Thaumaturges to wield; plus 3 additional sets of random (discount) robes and hats to help the proccess."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/spell_focus = 3,
		/obj/item/clothing/head/wizard/fake = 3,
		/obj/item/clothing/suit/wizrobe/fake = 3,
	)
	crate_name = "thaumaturge crate"
	crate_type = /obj/structure/closet/crate/wooden

	/// Amount of hats in the crate (not including the random chance for real robes).
	var/num_hats = 3
	/// Amount of robes in the crate (not including the random chance for real robes).
	var/num_robes = 3
	/// Pool of hats that the crate can come with
	var/list/hat_pool = list(
		/obj/item/clothing/head/wizard/fake,
		/obj/item/clothing/head/costume/witchwig,
		/obj/item/clothing/head/collectable/wizard,
		/obj/item/clothing/head/wizard/marisa/fake,
		/obj/item/clothing/head/wizard/tape/fake,
		/obj/item/clothing/head/wizard/chanterelle,
		/obj/item/clothing/head/wizard/secwiz,
		/obj/item/clothing/head/wizard/viszard
	)
	/// Pool of robes that the crate can come with
	var/list/robe_pool = list(
		/obj/item/clothing/suit/wizrobe/fake,
		/obj/item/clothing/suit/wizrobe/marisa/fake,
		/obj/item/clothing/suit/wizrobe/tape/fake,
		/obj/item/clothing/suit/wizrobe/secwiz,
		/obj/item/clothing/suit/wizrobe/viszard
	)

	/// There's a small chance that we manage to sneak in real wizard robes, in percentages.
	var/real_robe_set_chance = 5
	/// List of robe combos that can be sneaked in.
	var/list/real_robe_sets = list(
		list(
			/obj/item/clothing/suit/wizrobe/magusblue,
			/obj/item/clothing/head/wizard/magus,
		),
		list(
			/obj/item/clothing/head/wizard/magus,
			/obj/item/clothing/suit/wizrobe/magusred,
		),
		list(
			/obj/item/clothing/head/wizard/black,
			/obj/item/clothing/suit/wizrobe/black,
		),
		list(
			/obj/item/clothing/head/wizard/tape,
			/obj/item/clothing/suit/wizrobe/tape,
		),
		list(
			/obj/item/clothing/head/wizard/santa,
			/obj/item/clothing/suit/wizrobe/santa,
		),
		list(
			/obj/item/clothing/head/wizard,
			/obj/item/clothing/suit/wizrobe,
		),
	)
// Fills it with at least 3 spell focuses and a random selection of hats and robes.
/datum/supply_pack/costumes_toys/thaumaturgic/fill(obj/structure/closet/crate/C)
	for(var/spawn_index in 1 to 3)
		new /obj/item/spell_focus(C)

	// chance for real robes
	if(prob(real_robe_set_chance))
		var/list/selected_set = pick(real_robe_sets)
		for(var/robe_item_type in selected_set)
			new robe_item_type(C)

	var/list/hats = hat_pool.Copy()
	for(var/spawn_index in 1 to min(num_hats, length(hats)))
		var/hat_type = pick_n_take(hats)
		new hat_type(C)

	var/list/robes = robe_pool.Copy()
	for(var/spawn_index in 1 to min(num_robes, length(robes)))
		var/robe_type = pick_n_take(robes)
		new robe_type(C)
