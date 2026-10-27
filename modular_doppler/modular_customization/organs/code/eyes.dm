/obj/item/organ/eyes/bug
	blink_animation = FALSE

/obj/item/organ/eyes/ramatan
	blink_animation = FALSE

/obj/item/organ/eyes/lizard
	synchronized_blinking = TRUE

/obj/item/organ/eyes/pod
	eye_color_left = null
	eye_color_right = null

/obj/item/organ/eyes/snail/generate_body_overlay(mob/living/carbon/human/parent)
	var/list/parent_overlays = ..()
	for(var/mutable_appearance/overlay as anything in parent_overlays)
		overlay.layer = ABOVE_BODY_FRONT_HEAD_LAYER
	return parent_overlays
