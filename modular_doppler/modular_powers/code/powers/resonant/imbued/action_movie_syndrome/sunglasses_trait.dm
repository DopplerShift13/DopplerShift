/// Becuase it turns out sunglasses don't actually have any commonality, as even flash protection is not a guarantee.
/// Going to swallow the bullet now and give everything sugnlasses.
/// There's probably a better location to put this?
#define TRAIT_WEARING_SUNGLASSES "sunglasses"

/obj/item/clothing/glasses/sunglasses/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)

/obj/item/clothing/glasses/hud/health/sunglasses/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)

/obj/item/clothing/glasses/hud/diagnostic/sunglasses/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)

/obj/item/clothing/glasses/hud/security/sunglasses/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)

/obj/item/clothing/glasses/hud/spacecop/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)

/obj/item/clothing/glasses/hud/ar/aviator/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)

/obj/item/clothing/glasses/osi/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)

/obj/item/clothing/glasses/overwatch/Initialize(mapload)
	. = ..()
	attach_clothing_traits(TRAIT_WEARING_SUNGLASSES)
