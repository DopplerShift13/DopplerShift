/obj/item/card/id/advanced/centcom/portauthority
	name = "\improper Port Authority ID"
	desc = "An ID card used by official Port Authority personnel."
	icon_state = "card_platinum"
	inhand_icon_state = "platinum_id"
	trim = /datum/id_trim/centcom/commander/portauthority

/obj/item/card/id/advanced/centcom/portauthority/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_TASTEFULLY_THICK_ID_CARD, INNATE_TRAIT)

/obj/item/card/id/advanced/centcom/portauthority/pcat
	name = "\improper Pallas Cargo and Transport ID"
	desc = "An ID card used by official Pallas Cargo and Transport personnel."
	trim = /datum/id_trim/centcom/commander/portauthority/pcat

/obj/item/card/id/advanced/centcom/ert/voidcorps
	name = "\improper Void Corps ID"
	desc = "An ID card used by official Void Corps personnel."
	icon_state = "card_black"
	inhand_icon_state = "card_grey"
	trim = /datum/id_trim/centcom/ert/voidcorps/commander

/obj/item/card/id/advanced/centcom/ert/voidcorps/autorifle
	trim = /datum/id_trim/centcom/ert/voidcorps/autorifle

/obj/item/card/id/advanced/centcom/ert/voidcorps/breacher
	trim = /datum/id_trim/centcom/ert/voidcorps/breacher

/obj/item/card/id/advanced/centcom/ert/voidcorps/comtech
	trim = /datum/id_trim/centcom/ert/voidcorps/comtech

/obj/item/card/id/advanced/centcom/ert/voidcorps/corpsman
	trim = /datum/id_trim/centcom/ert/voidcorps/corpsman

/obj/item/card/id/advanced/centcom/ert/parc
	name = "\improper Port Authority Response Corps ID"
	desc = "An ID card used by official Port Authority Response Corps officers."
	icon_state = "card_platinum"
	inhand_icon_state = "platinum_id"
	trim = /datum/id_trim/centcom/ert/parc/commander

/obj/item/card/id/advanced/centcom/ert/parc/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_TASTEFULLY_THICK_ID_CARD, INNATE_TRAIT)

/obj/item/card/id/advanced/centcom/ert/parc/officer
	trim = /datum/id_trim/centcom/ert/parc/officer
