// adds dopplerified bodytype support to all security uniforms
/obj/item/clothing/under/rank/security/doppler
	abstract_type = /obj/item/clothing/under/rank/security/doppler
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE, BODYSHAPE_TESHARI)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_digi.dmi',
		BODYSHAPE_TESHARI_T = 'modular_doppler/modular_species/species_types/teshari/icons/clothing/uniform.dmi'
	)

// security guard stuff

/obj/item/clothing/under/rank/security/doppler/guard
	name = "\improper Port Safety uniform"
	desc = "Owing to the prevailing economic conditions of the time, these were printed locally within \
	the Crusoe's Rest out of available materials. As a result, the fabric contents tag boasts a dizzying \
	array of common and exotic textile fibres alike."
	icon_state = "secwear1"

/obj/item/clothing/under/rank/security/doppler/guard_alt
	name = "\improper Port Safety colorblocked uniform"
	desc = "53.21% COTTON, 19.34% NYLON, 18.58% RAYON, 7.13% CASEIN, 1.74% ARAMID"
	icon_state = "secwear2"

/obj/item/clothing/under/rank/security/doppler/skirt
	name = "\improper Port Safety utility skirt"
	desc = "Dense broadcloth and a pleated cut give this uniform a heavy presence in spite of the \
	mobile and breezy fit."
	icon_state = "secskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/security/doppler/skirt_alt
	name = "\improper Port Safety colorblocked skirt"
	desc = "These are printed locally within Crusoe's Rest out of available materials, and this particular \
	pattern features a longer skirt that still feels protective on your legs, but offers more water drainage \
	for cruising the surface of New Gibraltar."
	icon_state = "secskirt2"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY


// detective stuff

/obj/item/clothing/under/rank/security/doppler/detective
	name = "\improper Port Safety investigative uniform"
	desc = "Printed in New Gibraltar to catalogue specifications. The shell material boasts modest protection \
	against caustic chemical solutions used in niche forensic applications."
	icon_state = "detwear"

/obj/item/clothing/under/rank/security/doppler/detective/skirt
	name = "\improper Port Safety investigative uniform skirt"
	desc = "A seven month campaign to expand investigator uniform regulations resulted in hundreds of pages of \
	meeting minutes and precisely zero of the predicted chemical spillage incidents, to date."
	icon_state = "detskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

// armory keeper stuff

/obj/item/clothing/under/rank/security/doppler/warden
	name = "\improper Port Safety dispatch officer's uniform"
	desc = "57.21% COTTON 18.34% NYLON 15.58% RAYON 7.13% CASEIN 1.74% ARAMID"
	icon_state = "wardenwear"

/obj/item/clothing/under/rank/security/doppler/warden/skirt
	name = "\improper Port Safety dispatch officer's uniform skirt"
	desc = "An easy wearing uniform with generously buttoned cuffs that are easy to turn up and fasten back. \
	It's optimized for long days in a stool at the armory workbench."
	icon_state = "wardenskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY


// head of safety stuff

/obj/item/clothing/under/rank/security/doppler/head_of_security
	name = "\improper Port Safety chief guard's uniform"
	desc = "63.43% COTTON 14.14% NYLON 13.30% RAYON 7.13% CASEIN 2% ARAMID"
	icon_state = "hoswear"
	armor_type = /datum/armor/clothing_under/security_head_of_security
	strip_delay = 6 SECONDS

/obj/item/clothing/under/rank/security/doppler/head_of_security/skirt
	name = "\improper Port Safety chief guard's uniform skirt"
	desc = "Boldly colorblocked panels were focus tested to improve visibility and civilian compliance by as much as 7%. \
	Much fuss was made in the requisition meetings about whether these studies had any bearing on real world statistical performance."
	icon_state = "hosskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
