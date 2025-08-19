/datum/species/human/mermaid
	name = "\improper Mermaid"
	plural_form = "Mermaids"
	id = SPECIES_MERMAID
	mutant_organs = list(/obj/item/organ/tail/fish/mermaid)
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right,
		BODY_ZONE_HEAD = /obj/item/bodypart/head,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest,
	)
	inherent_traits = list(
		TRAIT_WATER_ADAPTATION,
		TRAIT_MUTANT_COLORS,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_AQUATIC

	species_cookie = /obj/item/food/chips/shrimp
	payday_modifier = 1.0

/datum/species/human/mermaid/randomize_main_appearance_element(mob/living/carbon/human/human_being)
	human_being.dna.features[FEATURE_MUTANT_COLOR] = skintone2hex(pick(GLOB.skin_tones))
	human_being.dna.update_uf_block(/datum/dna_block/feature/mermaid_color)

/datum/species/human/mermaid/on_species_gain(mob/living/carbon/carbon_being, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(isdummy(carbon_being))
		return
	carbon_being.set_lying_down()
	carbon_being.on_fall()

/datum/species/human/mermaid/prepare_human_for_preview(mob/living/carbon/human/preview_human)
	preview_human.set_haircolor("#a54ea1", update = FALSE)
	preview_human.set_hairstyle("Ponytail (Country)", update = TRUE)
	preview_human.dna.features[FEATURE_MUTANT_COLOR] = skintone2hex("asian1")
	preview_human.dna.features[FEATURE_MERMAID_COLOR] = COLOR_CARP_TEAL
	regenerate_organs(preview_human)
	preview_human.update_body(is_creating = TRUE)

/datum/species/human/mermaid/get_species_description()
	return "Nothing yet."

/datum/species/human/mermaid/get_species_lore()
	return list(
		"Nothing yet.",
	)

/obj/item/bodypart/leg/can_attach_limb(mob/living/carbon/owner, special)
	if(owner.get_organ_by_type(/obj/item/organ/tail/fish/mermaid))
		return FALSE
	else
		return ..()


/// The organ
/obj/item/organ/tail/fish/mermaid
	name = "mermaid tail"
	fillet_amount = 10 //big tail
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/mermaid
	external_bodyshapes = BODYSHAPE_MERMAID
	restyle_flags = NONE

/obj/item/organ/tail/fish/mermaid/Initialize(mapload)
	. = ..()
	set_greyscale(colors = list(pick(GLOB.carp_colors)))

/obj/item/organ/tail/fish/mermaid/on_mob_insert(mob/living/carbon/owner, special, movement_flags)
	. = ..()
	get_your_sealegs(owner)
	owner.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

/obj/item/organ/tail/fish/mermaid/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	if(QDELING(owner))
		return
	owner.cure_trauma_type(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)
	owner.adjustBruteLoss(rand(-35, -45))
	if(owner.blood_volume)
		owner.blood_volume -= (BLOOD_VOLUME_MAXIMUM / 3)
		owner.spray_blood(REVERSE_DIR(owner.dir))
		visible_message(span_warning("[src] detaches, spilling out liters of [LOWER_TEXT(owner.get_bloodtype()?.name)]!"))
		playsound(src, 'sound/effects/cartoon_sfx/cartoon_splat.ogg', 50, TRUE)
	get_greyscale_color_from_draw_color()
	owner.bodyshape &= ~BODYSHAPE_MERMAID

/// Remove legs on insertion, if we had any
/obj/item/organ/tail/fish/mermaid/proc/get_your_sealegs(mob/living/carbon/owner)
	var/obj/item/bodypart/right_leg = owner.get_bodypart(BODY_ZONE_R_LEG)
	var/obj/item/bodypart/left_leg = owner.get_bodypart(BODY_ZONE_L_LEG)
	if(right_leg)
		right_leg.dismember()
	if(left_leg)
		left_leg.dismember()


/// The bodypart overlay
/datum/bodypart_overlay/mutant/tail/mermaid
	feature_key = FEATURE_TAIL_FISH
	color_source = NONE

/datum/bodypart_overlay/mutant/tail/mermaid/get_global_feature_list()
	return SSaccessories.tails_list_fish

/datum/bodypart_overlay/mutant/tail/mermaid/on_mob_insert(obj/item/organ/limb, mob/living/carbon/receiver)
	set_appearance(/datum/sprite_accessory/tails/fish/mermaid)
	receiver.dna.features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/tails/fish/mermaid::name
	receiver.dna.update_uf_block(/datum/dna_block/feature/tail_fish)

/datum/bodypart_overlay/mutant/tail/mermaid/color_image(image/overlay, layer, obj/item/bodypart/limb)
	var/color
	//dye has priority
	if(dye_color)
		color = dye_color
	//do we have dna set through preferences?
	else if(limb?.owner?.dna.features[FEATURE_MERMAID_COLOR])
		color = limb.owner.dna.features[FEATURE_MERMAID_COLOR]
	//no prefs set, inherit the color of the organ and set the dna
	else if(locate(/obj/item/organ/tail/fish/mermaid) in limb?.contents)
		var/obj/item/organ/tail/fish/mermaid/tail = limb.owner.get_organ_by_type(/obj/item/organ/tail/fish/mermaid)
		limb.owner.dna.features[FEATURE_MERMAID_COLOR] = tail.greyscale_colors
		limb.owner.dna.update_uf_block(/datum/dna_block/feature/mermaid_color)
		color = tail.greyscale_colors
	draw_color = color
	overlay.color = color

/datum/bodypart_overlay/mutant/tail/mermaid/can_draw_on_bodypart(obj/item/bodypart/limb)
	return TRUE //always draw
