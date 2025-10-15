/datum/bodypart_overlay/mutant/pod_hair/color_image(image/overlay, draw_layer, obj/item/bodypart/limb)
	if(isnull(limb))
		return ..()
	if(isnull(limb.owner))
		return ..()
	if(!length(limb.owner.dna.features[FEATURE_POD_HAIR_COLORS]))
		return ..()
	if(draw_layer == bitflag_to_layer(EXTERNAL_ADJACENT))
		overlay.color = limb.owner.dna.features[FEATURE_POD_HAIR_COLORS][1]
		return overlay
	else if(draw_layer == bitflag_to_layer(EXTERNAL_FRONT))
		overlay.color = limb.owner.dna.features[FEATURE_POD_HAIR_COLORS][2]
		return overlay
	return ..()
