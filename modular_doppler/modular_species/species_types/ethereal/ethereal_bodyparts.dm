// MODULAR ETHEREAL OVERRIDES

/obj/item/bodypart/head/ethereal
	icon_greyscale = BODYPART_ICON_ETHEREAL
	bodyshape = BODYSHAPE_HUMANOID
	head_flags = HEAD_HAIR|HEAD_FACIAL_HAIR|HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_DEBRAIN

/obj/item/bodypart/head/ethereal/lustrous
	icon_greyscale = BODYPART_ICON_ETHEREAL
	bodyshape = BODYSHAPE_HUMANOID

/obj/item/bodypart/chest/ethereal
	icon_greyscale = BODYPART_ICON_ETHEREAL
	bodyshape = BODYSHAPE_HUMANOID

/obj/item/bodypart/arm/left/ethereal
	icon_greyscale = BODYPART_ICON_ETHEREAL
	bodyshape = BODYSHAPE_HUMANOID

/obj/item/bodypart/arm/right/ethereal
	icon_greyscale = BODYPART_ICON_ETHEREAL
	bodyshape = BODYSHAPE_HUMANOID

/obj/item/bodypart/leg/left/ethereal
	icon_greyscale = BODYPART_ICON_ETHEREAL
	bodyshape = BODYSHAPE_HUMANOID

/obj/item/bodypart/leg/right/ethereal
	icon_greyscale = BODYPART_ICON_ETHEREAL
	bodyshape = BODYSHAPE_HUMANOID

/obj/item/organ/eyes/ethereal
	var/eye_overlay_icon = 'modular_doppler/modular_species/species_types/ethereal/icons/organs/ethereal_eyes.dmi'
	blink_animation = FALSE

/// Redirects this organ's eye appearances to the Ethereal eye icon file rather than the default file.
/obj/item/organ/eyes/ethereal/generate_body_overlay(mob/living/carbon/human/parent)
	. = ..()
	var/left_eye_icon_state = "[eye_icon_state]_l"
	var/right_eye_icon_state = "[eye_icon_state]_r"
	for(var/mutable_appearance/eye_overlay as anything in .)
		if(eye_overlay.icon_state != left_eye_icon_state && eye_overlay.icon_state != right_eye_icon_state)
			continue
		eye_overlay.icon = eye_overlay_icon
