// guard stuff

/obj/item/clothing/suit/jacket/officer/doppler
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	armor_type = /datum/armor/suit_armor

/obj/item/clothing/suit/jacket/officer/doppler/ps_a1
	name = "\improper PS-A1 uniform jacket"
	desc = "Synth-shearling regenerated from a slurry of biomass and programmatic data gleaned from a medal-winning \
	line of wooly sheep backed with a sturdy canvas-like shell. The interior tag makes dubious or optimistic boasts \
	about its water resistance."
	icon_state = "sechoodie"

/obj/item/clothing/suit/jacket/officer/doppler/ps_a4
	name = "\improper PS-A4 uniform jacket"
	desc = "A hip length cousin to other shearling jackets commonly issued to Port Safety guards. It fits a little bit \
	different in spite of holding the same sizing specs, owing to nuances in different pattern techs and their approach \
	to garment fitting."
	icon_state = "sechoodie2"

/obj/item/clothing/suit/jacket/officer/doppler/ps_b2
	name = "\improper PS-B2 uniform jacket"
	desc = "Made of the same synth-shearling as the A1 and A4, the B2 comes equipped with a different first letter in the \
	name. More importantly, this one comes with as a distinct high-visibility safety patch across the back, meant to increase \
	the quality of life for Port Safety guards having to cross in front of the wide array of personal transport vehicles buzzing \
	through the streets and alleyways of Low Heaven. The interior tag still makes rather hopeful claims about its waterproof \
	nature, but you've never seen anyone zip one of these for a reason."
	icon_state = "sechoodie3"

/obj/item/clothing/suit/armor/vest/alt/sec
	name = "\improper PS Type 98c body armor"
	desc = "Ceramic plates suspended in pockets of newton rated nonwoven textiles, providing approximately adequate \
	protection against most mundane types of weaponry. Additional padding is provided primarily for user comfort."
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	icon_state = "sec_armor"

// armory keeper stuff

/obj/item/clothing/suit/jacket/officer/doppler/ps_b1
	name = "\improper PS-B1 chore coat"
	desc = "A single-breasted, armored coat with a high collar and optional buttons to guard against the elements. Most wearers of this \
	coat tend to lack the taste for impractical and ostentatious fashion found in their Chief Guard superiors, so they'll often pin one \
	flap back to keep the full pair from obstructing movements such as 'dropping to a knee to properly fire a gun,' whatever that does."
	icon_state = "warden_coat"

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "\improper PS-B1A personnel protective system"
	desc = "This greatcoat, a model often associated with leaving the protective enviroshields of the capital of Low Heaven and other \
	cities on New Gibraltar, comes overlayed with a menacing flak vest comprised of newton rated nonwovens with lightweight metal plates. \
	While this is on paper too warm and heavy for indoor environments such as 'the one you're in,' it does give the wearer more bulk than \
	they otherwise have."
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	icon_state = "warden_armored"

// head of safety stuff

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "\improper PS-D5 greatcoat"
	desc = "An ankle length personal protective system with sizable internal pockets. The outer shell, made of 100% regenerated calfhide, \
	bears a formidable appearance but a disarmingly charming tendency to squeak. This one has an advanced soft-insert to give it a level of \
	protection that could even stop low-caliber firearms, provided one's opponent is kind enough to use subsonic ammunition to stop from \
	piercing the hull of wherever you are right now."
	icon_state = "hos_armored"
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	pocket_storage_type = /datum/storage/pockets/jacket/jumbo

// lazily sets this back to the tg default
/obj/item/clothing/suit/armor/hos/trenchcoat/winter
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/obj/item/clothing/suit/jacket/officer/doppler/ps_d1
	name = "\improper PS-D1 greatcoat"
	desc = "Strongly resembling some cultures' ideas of a strong commander-type, this is a suitable wear for a Chief Guard. A heavy armored \
	exterior, straight lines and blocky shoulders, this model is reported to take just about forever to button up or down, but the waxed \
	outside material provides both waterproofing and a slick shine to it all."
	icon_state = "hos_casual"

// the furtive detective, so easily forgotten

/obj/item/clothing/suit/jacket/officer/doppler/det_trench
	name = "vintage coat"
	desc = "The single most signature item a Detective carries besides their clipboard and a tacky firearm, this is an oilskin trenchcoat \
	meant as an outer shell to protect the wearer's nicest clothing from the environmental conditions of any planet they might find themselves \
	on. Regrettably, this coat protects very little against emotional turmoil, moral ambiguity, and troublesome seductresses that just came \
	through your door."
	icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security_obj.dmi'
	worn_icon = 'modular_doppler/modular_cosmetics/icons/security_resprite/doppler_security.dmi'
	icon_state = "dets_coat"
