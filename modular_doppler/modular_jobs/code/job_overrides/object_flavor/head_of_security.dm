
/**
 * RADIOS
 */

/obj/item/radio/headset/heads/hos
	name = "\proper the chief guard's headset"
	desc = "The headset of the sophont in charge of keeping the security team in order."

/obj/item/radio/headset/heads/hos/alt
	name = "\proper the chief guard's bowman headset"
	desc = "The headset of the sophont in charge of keeping the security team in order. Protects ears from flashbangs."

/obj/item/encryptionkey/heads/hos
	name = "\proper the chief guard's encryption key"


/**
 * CLOTHING
 */

/obj/item/storage/bag/garment/hos
	name = "chief guard's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the chief guard."

/obj/item/clothing/under/rank/security/head_of_security
	name = "chief guard's uniform"
	desc = "A security jumpsuit decorated for those few with the dedication to achieve the position of Chief Guard."

/obj/item/clothing/under/rank/security/head_of_security/skirt
	name = "chief guard's skirt"
	desc = "A security jumpskirt decorated for those few with the dedication to achieve the position of Chief Guard."

/obj/item/clothing/under/rank/security/head_of_security/skirt
	name = "chief guard's skirt"
	desc = "A security jumpskirt decorated for those few with the dedication to achieve the position of Chief Guard."

/obj/item/clothing/under/rank/security/head_of_security/grey
	name = "chief guard's grey jumpsuit"

/obj/item/clothing/under/rank/security/head_of_security/alt
	name = "chief guard's turtleneck"
	desc = "A stylish alternative to the normal chief guard jumpsuit, complete with tactical pants."

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt
	name = "chief guard's turtleneck skirt"
	desc = "A stylish alternative to the normal chief guard jumpsuit, complete with a tactical skirt."

/obj/item/clothing/under/rank/security/head_of_security/parade
	name = "chief guard's parade uniform"
	desc = "A chief guard's luxury-wear, for special occasions."

/obj/item/clothing/under/rank/security/head_of_security/parade/female
	name = "chief guard's parade uniform"
	desc = "A chief guard's luxury-wear, for special occasions."

/obj/item/clothing/under/rank/security/head_of_security/formal
	name = "chief guard's formal uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to the Chief Guard."

/obj/item/clothing/suit/jacket/hos/blue
	name = "chief guard's jacket"

/obj/item/clothing/suit/jacket/hos/tan
	name = "chief guard's jacket"

/obj/item/clothing/neck/cloak/hos
	name = "chief guard's cloak"
	desc = "Worn by the chief guard."

/obj/item/clothing/suit/armor/hos/trenchcoat/winter
	name = "chief guard's winter trenchcoat"

/obj/item/clothing/suit/armor/hos/hos_formal
	name = "\improper Chief Guard's parade jacket"

/obj/item/clothing/suit/armor/vest/leather
	name = "security overcoat"
	desc = "Lightly armored leather overcoat meant as casual wear for overseers. Bears the crest of Port Safety."

/obj/item/clothing/head/hats/hos
	name = "generic chief guard hat"
	desc = "Please contact the Port Safety Costuming Department if found."

/obj/item/clothing/head/hats/hos/cap
	name = "chief guard cap"
	desc = "The robust standard-issue cap of the Chief Guard. For showing the officers who's in charge. Looks a bit stout."

/obj/item/clothing/head/hats/hos/beret
	name = "chief guard's beret"
	desc = "A robust beret for the Chief Guard, for looking stylish while not sacrificing protection."

/obj/item/clothing/head/hats/hos/beret/navyhos
	name = "chief guard's formal beret"
	desc = "A special beret with the Chief Guard's insignia emblazoned on it. A symbol of excellence, a badge of courage, a mark of distinction."

/obj/item/clothing/head/helmet/space/plasmaman/security/head_of_security
	name = "chief guard's plasma envirosuit helmet"
	desc = "A special containment helmet designed for the Chief Guard. A pair of gold stripes are added to differentiate them from other members of security."

/obj/item/clothing/under/plasmaman/security/head_of_security
	name = "chief guard's envirosuit"
	desc = "A phorid containment suit decorated for those few with the dedication to achieve the position of Chief Guard."


/**
 * SPECIAL ITEMS
 */

/obj/item/storage/photo_album/hos
	name = "photo album (Chief Guard)"

/obj/item/computer_disk/command/hos
	name = "chief guard data disk"
	desc = "Removable disk used to download essential CG tablet apps."

/obj/item/stamp/head/hos
	name = "chief guard's rubber stamp"

/obj/item/modular_computer/pda/heads/hos
	name = "chief guard PDA"


/**
 * MACHINES
 */

/obj/machinery/computer/security/hos
	name = "\improper Chief Guard's camera console"


/**
 * STRUCTURES
 */

/obj/structure/closet/secure_closet/hos
	name = "chief guard's locker"

/obj/structure/noticeboard/hos
	name = "Chief Guard's Notice Board"
	desc = "Important notices from the Chief Guard."

/obj/structure/secure_safe/hos
	name = "chief guard's safe"


/**
 * PETS
 */

/mob/living/basic/carp/pet/lia
	desc = "A space carp found disconnected from their wider carp ecology, now domesticated. This less than intimidating carp now serves as the Chief Guard's pet."

/mob/living/basic/bear/snow/misha
	desc = "Tamed and trained by the Port Safety. Only beasts are above deceit."


/**
 * MISC OBJECTS
 * Assorted things that really don't matter.
 */

/obj/structure/statue/gold/hos
	name = "statue of the chief guard"

/obj/item/toy/figure/hos
	name = "\improper Chief Guard action figure"

/obj/item/bedsheet/hos
	name = "chief guard's bedsheet"
	desc = "It is decorated with a shield emblem. While conflict doesn't sleep, you (hopefully) do."
	dream_messages = list(
		"authority",
		"a silvery ID",
		"a successful mediation attempt for once",
		"group exercises",
		"sunglasses",
		"the chief guard",
	)


/**
 * MAPPING
 */

/area/station/command/heads_quarters/hos
	name = "\improper Chief Guard's Office"

/obj/effect/landmark/start/head_of_security
	name = "Chief Guard"
