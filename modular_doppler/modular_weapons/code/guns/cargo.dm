/datum/supply_pack/imports/wt550
	name = "Sindaryo PDW Crate"
	desc = "(*!&@#I know a guy, over on New Gibraltar. He has mountains of these things, I don't know why. \
		Maybe he's a collector or something. It's not important, what is, is that he's willing to part with \
		a few if you have the right kind of compensation.!#@*$"
	hidden = FALSE
	cost = CARGO_CRATE_VALUE * 7
	contains = list(
		/obj/item/gun/ballistic/automatic/wt550 = 2,
		/obj/item/ammo_box/magazine/wt550m9 = 2,
	)
	crate_type = /obj/structure/closet/crate/secure/syndicate/gorlex/weapons/bustedlock

/datum/supply_pack/imports/wt550ammo
	name = "Sindaryo Ammo Crate"
	desc = "(*!&@#We never found where he even got all of these, I never think it wise to ask anyway. \
		I'm not going to start pushing the guy with a mountain of clone guns on where he got them all.!#@*$"
	hidden = FALSE
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/ammo_box/magazine/wt550m9 = 2,
		/obj/item/ammo_box/magazine/wt550m9/wtap = 2,
		/obj/item/ammo_box/magazine/wt550m9/wtic = 2,
	)
	crate_name = "emergency crate"
	crate_type = /obj/structure/closet/crate/secure/syndicate/gorlex/weapons/bustedlock

/datum/supply_pack/security/armory/battle_rifle
	name = "Faline Saint-Marcielle Modele 2490 Crate"
	desc = "The finest in long arm technology, reliable and in a caliber that isn't locked behind a SINGLE DRM paywall."
	cost = CARGO_CRATE_VALUE * 50
	contains = list(
		/obj/item/gun/ballistic/automatic/marcielle = 2,
		/obj/item/gun/ballistic/automatic/marcielle/sport = 1,
		/obj/item/ammo_box/magazine/marcielle = 4,
	)
	crate_name = "battle rifle crate"

/datum/supply_pack/security/armory/br_mag
	name = "Saint-Marcielle Magazine Crate"
	desc = "Six .34 magazines, able to be used in the Saint-Marcielle rifles."
	cost = CARGO_CRATE_VALUE * 7
	contains = list(
		/obj/item/ammo_box/magazine/marcielle = 2,
		/obj/item/ammo_box/magazine/marcielle/special = 2,
		/obj/item/ammo_box/magazine/marcielle/squash =2,
	)
	crate_name = ".34 magazine crate"

/datum/supply_pack/security/armory/ballistic
	name = "Combat Shotguns Crate"
	desc = "For when the enemy absolutely needs to be replaced with lead. \
		Contains three Matragano Modello 20 combat shotguns to fill this spot."
	cost = CARGO_CRATE_VALUE * 17.5
	contains = list(
		/obj/item/gun/ballistic/shotgun/automatic/combat = 3,
		/obj/item/storage/belt/bandolier = 3,
	)
	crate_name = "combat shotguns crate"

/datum/supply_pack/security/armory/riot_shotguns
	name = "Riot Shotguns Crate"
	desc = "For when the enemy needs just a little lead. \
		Contains three Matragano PS 2 shotguns to fill this spot."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(
		/obj/item/gun/ballistic/shotgun/riot = 3,
		/obj/item/storage/belt/bandolier = 3,
	)
	crate_name = "riot shotguns crate"

/datum/supply_pack/security/armory/lesbiab_rifle
	name = "Tian-Diyu Double-Rifle Crate"
	desc = "Sometimes, you just want something gone. Like just no more."
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/item/gun/ballistic/marsian_super_rifle = 2,
	)
	crate_name = "high power rifle crate"

/datum/supply_pack/goody/dumdum38
	special = TRUE

/datum/supply_pack/goody/match38
	special = TRUE

/datum/supply_pack/goody/rubber
	special = TRUE

/datum/supply_pack/goody/dumdum38br
	special = TRUE

/datum/supply_pack/goody/match38br
	special = TRUE

/datum/supply_pack/goody/rubber
	special = TRUE

/datum/supply_pack/goody/mars_single
	name = "Javiro Detective Special Single-Pack"
	desc = "The power of the New Gibraltar 6mm, with none of the regulations behind the submachineguns that use it!"
	cost = PAYCHECK_CREW * 14
	access = ACCESS_WEAPONS
	access_view = null
	contains = list(
		/obj/item/gun/ballistic/revolver/c38/detective
	)

/datum/supply_pack/goody/ballistic_single
	name = "Riot Shotgun Single-Pack"
	desc = "Sometimes you just need a little more gun, contains one Matragano PS 2."
	cost = PAYCHECK_COMMAND * 9
	access = ACCESS_WEAPONS
	access_view = null
	contains = list(
		/obj/item/gun/ballistic/shotgun/riot,
	)

/datum/supply_pack/goody/crash_rifle
	name = "Crash Rifle Single-Pack"
	desc = "A reliable weapon for when you plan on crashing in the middle of nowhere."
	cost = PAYCHECK_COMMAND * 9
	access = ACCESS_WEAPONS
	access_view = null
	contains = list(
		/obj/item/gun/ballistic/rifle/crash,
	)

/datum/supply_pack/goody/osako_rifle
	name = "Osako Rifle Single-Pack"
	desc = "Old reliable, though never as overkill as those old Sakhno rifles they keep trying to pawn on us."
	cost = PAYCHECK_COMMAND * 9
	access = ACCESS_WEAPONS
	access_view = null
	contains = list(
		/obj/item/gun/ballistic/rifle/osako,
	)
