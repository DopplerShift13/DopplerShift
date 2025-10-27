/datum/bodypart_overlay/mutant/pod_hair/color_images(list/image/overlays, layer, obj/item/bodypart/limb)
	if(isnull(limb))
		return ..()
	if(isnull(limb.owner))
		return ..()
	if(!length(limb.owner.dna.features[FEATURE_POD_HAIR_COLORS]))
		return ..()
	if(layer == -BODY_FRONT_LAYER)
		draw_color = list(limb.owner.dna.features[FEATURE_POD_HAIR_COLORS][2]) // This sucks
	else
		draw_color = limb.owner.dna.features[FEATURE_POD_HAIR_COLORS]
	return ..()

/datum/sprite_accessory/pod_hair
	color_src = USE_MATRIXED_COLORS
