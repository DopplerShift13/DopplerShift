/obj/item/reagent_containers/cup/hypovial
	name = "broken hypovial"
	desc = "You probably shouldn't be seeing this. Shout at a coder."
	icon = 'modular_doppler/modular_items/hyposprays/icons/vials.dmi'
	icon_state = "hypovial"
	greyscale_config = /datum/greyscale_config/hypovial
	fill_icon_state = "hypovial_fill"
	spillable = FALSE
	volume = 10
	possible_transfer_amounts = list(1,2,5,10)
	fill_icon_thresholds = list(10, 25, 50, 75, 100)
	var/chem_color = "#FFFFFF" //Used for hypospray overlay
	var/type_suffix = "-s"
	fill_icon = 'modular_doppler/modular_items/hyposprays/icons/hypospray_fillings.dmi'

/obj/item/reagent_containers/cup/hypovial/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/hypovial, TRUE)

/datum/atom_skin/hypovial
	abstract_type = /datum/atom_skin/hypovial

/datum/atom_skin/hypovial/sterile
	preview_name = "Sterile"
	new_icon_state = "hypovial"

/datum/atom_skin/hypovial/generic
	preview_name = "Generic"
	new_icon_state = "hypovial-generic"

/datum/atom_skin/hypovial/brute
	preview_name = "Brute"
	new_icon_state = "hypovial-brute"

/datum/atom_skin/hypovial/burn
	preview_name = "Burn"
	new_icon_state = "hypovial-burn"

/datum/atom_skin/hypovial/toxin
	preview_name = "Toxin"
	new_icon_state = "hypovial-tox"

/datum/atom_skin/hypovial/oxyloss
	preview_name = "Oxyloss"
	new_icon_state = "hypovial-oxy"

/datum/atom_skin/hypovial/crit
	preview_name = "Crit"
	new_icon_state = "hypovial-crit"

/datum/atom_skin/hypovial/buff
	preview_name = "Buff"
	new_icon_state = "hypovial-buff"

/obj/item/reagent_containers/cup/hypovial/update_overlays()
	. = ..()
	// Search the overlays for the fill overlay from reagent_containers, and nudge its layer down to have it look correct.
	chem_color = "#FFFFFF"
	var/list/generated_overlays = .
	for(var/added_overlay in generated_overlays)
		if(istype(added_overlay, /mutable_appearance))
			var/mutable_appearance/overlay_image = added_overlay
			if(findtext(overlay_image.icon_state, fill_icon_state) != 0)
				overlay_image.layer = layer - 0.01
				chem_color = overlay_image.color

/obj/item/reagent_containers/cup/hypovial/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/reagent_containers/cup/hypovial/on_reagent_change()
	update_icon()

//Fit in all hypos
/obj/item/reagent_containers/cup/hypovial/small
	name = "hypovial"
	desc = "A small, 50u capacity vial compatible with most hyposprays."
	volume = 50
	possible_transfer_amounts = list(1,2,5,10,15,25,50)

//Styles

/obj/item/reagent_containers/cup/hypovial/small/style
	icon_state = "hypovial"

/obj/item/reagent_containers/cup/hypovial/small/style/generic
	icon_state = "hypovial-generic"

/obj/item/reagent_containers/cup/hypovial/small/style/brute
	icon_state = "hypovial-brute"

/obj/item/reagent_containers/cup/hypovial/small/style/burn
	icon_state = "hypovial-burn"

/obj/item/reagent_containers/cup/hypovial/small/style/toxin
	icon_state = "hypovial-tox"

/obj/item/reagent_containers/cup/hypovial/small/style/oxy
	icon_state = "hypovial-oxy"

/obj/item/reagent_containers/cup/hypovial/small/style/crit
	icon_state = "hypovial-crit"

/obj/item/reagent_containers/cup/hypovial/small/style/buff
	icon_state = "hypovial-buff"

//Fit in CMO hypo only
/obj/item/reagent_containers/cup/hypovial/large
	name = "large hypovial"
	icon_state = "hypoviallarge"
	fill_icon_state = "hypoviallarge_fill"
	desc = "A large, 100u capacity vial that fits only in the most deluxe hyposprays."
	volume = 100
	possible_transfer_amounts = list(1,2,5,10,20,30,40,50,100)
	type_suffix = "-l"

//Styles

/obj/item/reagent_containers/cup/hypovial/large/style/
	icon_state = "hypoviallarge"

/obj/item/reagent_containers/cup/hypovial/large/style/generic
	icon_state = "hypoviallarge-generic"

/obj/item/reagent_containers/cup/hypovial/large/style/brute
	icon_state = "hypoviallarge-brute"

/obj/item/reagent_containers/cup/hypovial/large/style/burn
	icon_state = "hypoviallarge-burn"

/obj/item/reagent_containers/cup/hypovial/large/style/toxin
	icon_state = "hypoviallarge-tox"

/obj/item/reagent_containers/cup/hypovial/large/style/oxy
	icon_state = "hypoviallarge-oxy"

/obj/item/reagent_containers/cup/hypovial/large/style/crit
	icon_state = "hypoviallarge-crit"

/obj/item/reagent_containers/cup/hypovial/large/style/buff
	icon_state = "hypoviallarge-buff"

//Hypos that are in the CMO's kit round start
/obj/item/reagent_containers/cup/hypovial/large/deluxe
	name = "deluxe hypovial"
	icon_state = "hypoviallarge-buff"
	list_reagents = list(/datum/reagent/medicine/omnizine = 15, /datum/reagent/medicine/leporazine = 15, /datum/reagent/medicine/atropine = 15)

/obj/item/reagent_containers/cup/hypovial/large/salglu
	name = "large green hypovial (salglu)"
	icon_state = "hypoviallarge-oxy"
	list_reagents = list(/datum/reagent/medicine/salglu_solution = 50)

/obj/item/reagent_containers/cup/hypovial/large/synthflesh
	name = "large orange hypovial (synthflesh)"
	icon_state = "hypoviallarge-crit"
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 50)

/obj/item/reagent_containers/cup/hypovial/large/multiver
	name = "large black hypovial (multiver)"
	icon_state = "hypoviallarge-tox"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 50)

//Some bespoke helper types for preloaded combat medkits.
/obj/item/reagent_containers/cup/hypovial/large/advbrute
	name = "Brute Heal"
	icon_state = "hypoviallarge-brute"
	list_reagents = list(/datum/reagent/medicine/c2/libital = 50, /datum/reagent/medicine/sal_acid = 50)

/obj/item/reagent_containers/cup/hypovial/large/advburn
	name = "Burn Heal"
	icon_state = "hypoviallarge-burn"
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 50, /datum/reagent/medicine/oxandrolone = 50)

/obj/item/reagent_containers/cup/hypovial/large/advtox
	name = "Toxin Heal"
	icon_state = "hypoviallarge-tox"
	list_reagents = list(/datum/reagent/medicine/pen_acid = 100)

/obj/item/reagent_containers/cup/hypovial/large/advoxy
	name = "Oxy Heal"
	icon_state = "hypoviallarge-oxy"
	list_reagents = list(/datum/reagent/medicine/c2/tirimol = 50, /datum/reagent/medicine/salbutamol = 50)

/obj/item/reagent_containers/cup/hypovial/large/advcrit
	name = "Crit Heal"
	icon_state = "hypoviallarge-crit"
	list_reagents = list(/datum/reagent/medicine/atropine = 100)

/obj/item/reagent_containers/cup/hypovial/large/advomni
	name = "All-Heal"
	icon_state = "hypoviallarge-buff"
	list_reagents = list(/datum/reagent/medicine/regen_jelly = 100)

/obj/item/reagent_containers/cup/hypovial/large/numbing
	name = "Numbing"
	icon_state = "hypoviallarge-generic"
	list_reagents = list(/datum/reagent/medicine/mine_salve = 50, /datum/reagent/medicine/morphine = 50)

//Some bespoke helper types for preloaded paramedic kits.
/obj/item/reagent_containers/cup/hypovial/small/libital
	name = "brute hypovial (libital)"
	icon_state = "hypovial-brute"

/obj/item/reagent_containers/cup/hypovial/small/libital/Initialize(mapload)
	. = ..()
	reagents.add_reagent(reagent_type = /datum/reagent/medicine/c2/libital, amount = 50, added_purity = 1)

/obj/item/reagent_containers/cup/hypovial/small/lenturi
	name = "burn hypovial (lenturi)"
	icon_state = "hypovial-burn"

/obj/item/reagent_containers/cup/hypovial/small/lenturi/Initialize(mapload)
	. = ..()
	reagents.add_reagent(reagent_type = /datum/reagent/medicine/c2/lenturi, amount = 50, added_purity = 1)

/obj/item/reagent_containers/cup/hypovial/small/seiver
	name = "tox hypovial (seiver)"
	icon_state = "hypovial-tox"

/obj/item/reagent_containers/cup/hypovial/small/seiver/Initialize(mapload)
	. = ..()
	reagents.add_reagent(reagent_type = /datum/reagent/medicine/c2/seiver, amount = 50, reagtemp = 975, added_purity = 1)

/obj/item/reagent_containers/cup/hypovial/small/convermol
	name = "tox hypovial (convermol)"
	icon_state = "hypovial-oxy"

/obj/item/reagent_containers/cup/hypovial/small/convermol/Initialize(mapload)
	. = ..()
	reagents.add_reagent(reagent_type = /datum/reagent/medicine/c2/convermol, amount = 50, added_purity = 1)

/obj/item/reagent_containers/cup/hypovial/small/atropine
	name = "crit hypovial (atropine)"
	icon_state = "hypovial-crit"

/obj/item/reagent_containers/cup/hypovial/small/atropine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(reagent_type = /datum/reagent/medicine/atropine, amount = 50, added_purity = 1)
