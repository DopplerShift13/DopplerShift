// new dopplerian cargo uniforms

/obj/item/clothing/under/rank/doppler_cargo
	icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_obj.dmi'
	icon_state = "suits"
	worn_icon = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_mob.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	supported_bodyshapes = list(BODYSHAPE_HUMANOID, BODYSHAPE_DIGITIGRADE)
	bodyshape_icon_files = list(
		BODYSHAPE_HUMANOID_T = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_mob.dmi',
		BODYSHAPE_DIGITIGRADE_T = 'modular_doppler/modular_cosmetics/icons/cargo_resprite/doppler_cargo_mob_digi.dmi'
	)

/obj/item/clothing/under/rank/doppler_cargo/tech
	name = "cargo technician's uniform"
	desc = "A high durability tech-textile top with a pair of roomy cargo pants."
	icon_state = "cargo_uniform"

/obj/item/clothing/under/rank/doppler_cargo/tech/skirt
	name = "cargo technician's skirt"
	desc = "A durable techthread top and skirt set."
	icon_state = "cargo_skirt"

/obj/item/clothing/under/rank/doppler_cargo/tech/alt
	name = "cargo technician's tanktop uniform"
	desc = "A sleeveless variant on the cargo uniform standard and a popular choice for poorly ventilated warehouses."
	icon_state = "cargo_tanktop"

/obj/item/clothing/under/rank/doppler_cargo/tech/skirt/alt
	name = "cargo technician's tanktop and skirt uniform"
	desc = "A sleeveless variant on the cargo uniform standard paired with a rugged take on a skirt."
	icon_state = "cargo_tankskirt"

/obj/item/clothing/under/rank/doppler_cargo/tech/fancy
	name = "cargo technician's dress uniform"
	desc = "A dress uniform in crisp-pressed and violently starched fabric."
	icon_state = "cargo_fancypants"

/obj/item/clothing/under/rank/doppler_cargo/tech/fancy_skirt
	name = "cargo technician's dress skirt"
	desc = "A dress skirt uniform in crisp-pressed and violently starched fabric."
	icon_state = "cargo_fancyskirt"

/obj/item/clothing/under/rank/doppler_cargo/tech/turtleneck
	name = "cargo technician's turtleneck"
	desc = "A cozy turtleneck sweater and slack set. The fabric is nice looking and wrinkle-resistant, yet \
	woe to the hapless one who actually sweats in them."
	icon_state = "cargo_turtleneck"

/obj/item/clothing/under/rank/doppler_cargo/tech/turtleskirt
	name = "cargo technician's turtleneck and skirt"
	desc = "A cozy turtleneck sweater and skirt set. The fabric is nice looking and wrinkle-resistant, and the \
	breezy skirt alleviates the cloying fabric."
	icon_state = "cargo_turtleskirt"

/obj/item/clothing/under/rank/doppler_cargo/tech/rough
	name = "cargo technician's rugged uniform"
	desc = "A hardwearing laborer's set with a familiar logo emblazoned. Equally popular with physical laborers and \
	fashionable Marsian streetwear heads."
	icon_state = "cargo_rough"

/obj/item/clothing/under/rank/doppler_cargo/tech/rough_skirt
	name = "cargo technician's rugged skirt"
	desc = "A hardwearing laborer's skirt set with a familiar logo. The rugged skirt design is practical for warehouse work."
	icon_state = "cargo_roughskirt"
