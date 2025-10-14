/obj/item/organ/pod_hair
	name = "podperson hair"
	desc = "Base for many-o-salads."

	restyle_flags = EXTERNAL_RESTYLE_PLANT

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_POD_HAIR
	organ_flags = parent_type::organ_flags | ORGAN_EXTERNAL
	dna_block = /datum/dna_block/feature/pod_hair

	bodypart_overlay = /datum/bodypart_overlay/mutant/pod_hair

/datum/bodypart_overlay/mutant/pod_hair
    layers = EXTERNAL_ADJACENT | EXTERNAL_FRONT

/datum/bodypart_overlay/mutant/pod_hair/color_image(image/overlay, draw_layer, obj/item/organ/orgie)
	if(orgie == null)
		return ..()
	if(orgie.owner == null)
		return ..()
	if(draw_layer == bitflag_to_layer(EXTERNAL_ADJACENT))
		overlay.color = orgie.owner.dna.features["pod_hair_color_1"]
		return overlay
	else if(draw_layer == bitflag_to_layer(EXTERNAL_FRONT))
		overlay.color = orgie.owner.dna.features["pod_hair_color_2"]
		return overlay
	return ..()
