/obj/item/bodypart/leg/can_attach_limb(mob/living/carbon/owner, special)
	if(owner.get_organ_by_type(/obj/item/organ/tail/fish/mermaid))
		return FALSE
	else
		return ..()

/// The organ
/obj/item/organ/tail/fish/mermaid
	fillet_amount = 10 //big tail
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/mermaid

/obj/item/organ/tail/fish/mermaid/Initialize(mapload)
	. = ..()
	set_greyscale(colors = list(pick(GLOB.carp_colors)))

/obj/item/organ/tail/fish/mermaid/on_mob_insert(mob/living/carbon/owner, special, movement_flags)
	. = ..()
	make_way(owner)

/obj/item/organ/tail/fish/mermaid/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	if(QDELING(owner))
		return
	owner.adjustBruteLoss(rand(-35, -45))
	if(owner.blood_volume)
		owner.blood_volume -= (BLOOD_VOLUME_MAXIMUM / 3)
		owner.add_splatter_floor(get_turf(src), FALSE)
		visible_message(span_warning("[src] detaches, spilling out liters of [LOWER_TEXT(owner.get_bloodtype()?.name)]!"))
		playsound(src, 'sound/effects/cartoon_sfx/cartoon_splat.ogg', 50, TRUE)

/// Remove legs on insertion, if we had any
/obj/item/organ/tail/fish/mermaid/proc/make_way(mob/living/carbon/owner)
	var/obj/item/bodypart/right_leg = owner.get_bodypart(BODY_ZONE_R_LEG)
	var/obj/item/bodypart/left_leg = owner.get_bodypart(BODY_ZONE_L_LEG)
	if(right_leg)
		right_leg.dismember()
	if(left_leg)
		left_leg.dismember()

/// The bodypart overlay
/datum/bodypart_overlay/mutant/tail/mermaid
	feature_key = FEATURE_TAIL_FISH
	color_source = ORGAN_COLOR_OVERRIDE
	imprint_on_next_insertion = FALSE

/datum/bodypart_overlay/mutant/tail/mermaid/get_global_feature_list()
	return SSaccessories.tails_list_fish

/datum/bodypart_overlay/mutant/tail/mermaid/on_mob_insert(obj/item/organ/parent, mob/living/carbon/receiver)
	//there is only one type
	set_appearance_from_name(/datum/sprite_accessory/tails/fish/mermaid::name)
	receiver.dna.tail_type = FISH
	receiver.dna.features[FEATURE_TAIL_FISH] = /datum/sprite_accessory/tails/fish/mermaid::name
	receiver.dna.update_uf_block(/datum/dna_block/feature/tail_fish)

/datum/bodypart_overlay/mutant/tail/mermaid/color_image(image/overlay, layer, obj/item/bodypart/limb)
	var/color
	if(dye_color)
		color = dye_color
	else
		color = override_color(limb)
	overlay.color = color
	draw_color = color

/datum/bodypart_overlay/mutant/tail/mermaid/override_color(obj/item/bodypart/limb)
	//did we set a color in the pref menu? nice!
	if(limb?.owner.dna.features[FEATURE_MERMAID_COLOR])
		return limb.owner.dna.features[FEATURE_MERMAID_COLOR]
	//have we not? lets apply the color of the tail as instead
	else if(locate(/obj/item/organ/tail/fish/mermaid) in limb?.contents)
		var/obj/item/organ/tail/fish/mermaid/tail = limb.owner.get_organ_by_type(/obj/item/organ/tail/fish/mermaid)
		limb.owner.dna.features[FEATURE_MERMAID_COLOR] = tail.greyscale_colors
		return tail.greyscale_colors
