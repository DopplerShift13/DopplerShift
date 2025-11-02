#define ROBOTIC_LIGHT_BRUTE_MSG "marred"
#define ROBOTIC_MEDIUM_BRUTE_MSG "dented"
#define ROBOTIC_HEAVY_BRUTE_MSG "falling apart"

#define ROBOTIC_LIGHT_BURN_MSG "scorched"
#define ROBOTIC_MEDIUM_BURN_MSG "charred"
#define ROBOTIC_HEAVY_BURN_MSG "smoldering"

//Teshari normal

/obj/item/bodypart/arm/left/robot/android/teshari
	name = "cybernetic left raptoral forelimb"
	desc = "A skeletal limb wrapped in pseudomuscles and membranous feathers, with a low-conductivity case."
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)

	limb_id = "teshari"
	icon_state = "teshari_l_arm"

/obj/item/bodypart/arm/right/robot/android/teshari
	name = "cybernetic right raptoral forelimb"
	desc = "A skeletal limb wrapped in pseudomuscles and membranous feathers, with a low-conductivity case."
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)

	limb_id = "teshari"
	icon_state = "teshari_r_arm"

/obj/item/bodypart/leg/left/robot/android/teshari
	name = "cybernetic left raptoral hindlimb"
	desc = "A skeletal limb wrapped in pseudomuscles and membranous feathers, with a low-conductivity case."
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)
	speed_modifier = -0.1

	limb_id = "teshari"
	icon_state = "teshari_l_leg"

/obj/item/bodypart/leg/right/robot/android/teshari
	name = "cybernetic right raptoral hindlimb"
	desc = "A skeletal limb wrapped in pseudomuscles and membranous feathers, with a low-conductivity case."
	icon_static =  'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)
	speed_modifier = -0.1

	limb_id = "teshari"
	icon_state = "teshari_r_leg"

/obj/item/bodypart/chest/robot/android/teshari
	name = "cybernetic raptoral torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell, covered in a layer of membranous feathers."
	icon_static =  'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)

	robotic_emp_paralyze_damage_percent_threshold = 0.5

	limb_id = "teshari"
	icon_state = "teshari_chest"

/obj/item/bodypart/head/robot/android/teshari
	name = "cybernetic raptoral head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals. A layer of membranous feathers covers the stark metal."
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW
	unarmed_damage_high = TESHARI_PUNCH_HIGH

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)

	head_flags = HEAD_EYESPRITES

	limb_id = "teshari"
	icon_state = "teshari_head"

// teshari_ advanced

/obj/item/bodypart/arm/left/robot/android/teshari_advanced
	name = "advanced left raptoral forelimb"
	desc = "An advanced robotic hindlimb. Covered in a layer of reactive, membranous feathers, this limb is nearly indistinguishable from the real thing."
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = 0.8
	burn_modifier = 1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	limb_id = "teshari_advanced"
	icon_state = "teshari_advanced_l_arm"

/obj/item/bodypart/arm/right/robot/android/teshari_advanced
	name = "advanced right raptoral forelimb"
	desc = "An advanced robotic hindlimb. Covered in a layer of reactive, membranous feathers, this limb is nearly indistinguishable from the real thing."
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	limb_id = "teshari_advanced"
	icon_state = "teshari_advanced_r_arm"

/obj/item/bodypart/leg/left/robot/android/teshari_advanced
	name = "advanced left raptoral hindlimb"
	desc = "An advanced robotic hindlimb. Covered in a layer of reactive, membranous feathers, this limb is nearly indistinguishable from the real thing."
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	limb_id = "teshari_advanced"
	icon_state = "teshari_advanced_l_leg"

/obj/item/bodypart/leg/right/robot/android/teshari_advanced
	name = "advanced right raptoral hindlimb"
	desc = "An advanced robotic hindlimb. Covered in a layer of reactive, membranous feathers, this limb is nearly indistinguishable from the real thing."
	icon_static = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	icon = 'modular_doppler/modular_species/species_types/teshari/icons/augments_teshari.dmi'
	bodyshape = parent_type::bodyshape | BODYSHAPE_TESHARI

	unarmed_damage_low = TESHARI_PUNCH_LOW * 2
	unarmed_damage_high = TESHARI_PUNCH_HIGH * 3

	brute_modifier = TESHARI_BRUTE_MODIFIER - (1 - parent_type::brute_modifier)
	burn_modifier = TESHARI_BURN_MODIFIER - (1 - parent_type::brute_modifier)
	speed_modifier = -0.1

	max_damage = LIMB_MAX_HP_ADVANCED
	body_damage_coeff = LIMB_BODY_DAMAGE_COEFFICIENT_ADVANCED

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	limb_id = "teshari_advanced"
	icon_state = "teshari_advanced_r_leg"

#undef ROBOTIC_LIGHT_BRUTE_MSG
#undef ROBOTIC_MEDIUM_BRUTE_MSG
#undef ROBOTIC_HEAVY_BRUTE_MSG

#undef ROBOTIC_LIGHT_BURN_MSG
#undef ROBOTIC_MEDIUM_BURN_MSG
#undef ROBOTIC_HEAVY_BURN_MSG
