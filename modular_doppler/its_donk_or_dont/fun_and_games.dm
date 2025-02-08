/obj/machinery/vending/donksofttoyvendor_super
	name = "\improper Playtime Expert Fun & Games Vendor"
	desc = "The ultra rare Fun & Games machine, filled with the rarest and most powerful Donk(tm) armaments."
	icon_state = "snackdonk"
	panel_type = "panel18"
	light_mask = "donksoft-light-mask"
	product_slogans = "Get your cool toys today!;Trigger a valid hunter today!;Quality toy weapons for cheap prices!;Give them to HoPs for all access!;Give them to HoS to get permabrigged!"
	product_ads = "Feel robust with your toys!;Express your inner child today!;Toy weapons don't kill people, but valid hunters do!;Who needs responsibilities when you have toy weapons?;Make your next murder FUN!"
	vend_reply = "Come back for more!"
	products = list(
		/obj/item/ammo_box/foambox/riot/mini = INFINITY,
		/obj/item/ammo_box/foambox/riot = INFINITY,
		/obj/item/storage/belt/secsword/donk = INFINITY,
		/obj/item/melee/energy/sword/holographic/green = INFINITY,
		/obj/item/grenade/frag/impact = INFINITY,
		/obj/item/grenade/frag/impact/smaller = INFINITY,
		/obj/item/motiondetector = INFINITY,
		/obj/item/suppressor = INFINITY,
		/obj/item/ammo_box/magazine/karim = INFINITY,
		/obj/item/ammo_box/magazine/c8marsian = INFINITY,
		/obj/item/ammo_box/magazine/c12nomi = INFINITY,
		/obj/item/ammo_box/magazine/c35sol_pistol = INFINITY,
		/obj/item/ammo_box/magazine/c35sol_pistol/stendo = INFINITY,
		/obj/item/ammo_box/magazine/c40sol_rifle = INFINITY,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = INFINITY,
		/obj/item/gun/ballistic/revolver/shotgun_revolver = INFINITY,
		/obj/item/gun/ballistic/automatic/xhihao_smg = INFINITY,
		/obj/item/gun/ballistic/automatic/sol_rifle = INFINITY,
		/obj/item/gun/ballistic/automatic/sol_rifle/evil = INFINITY,
		/obj/item/gun/ballistic/revolver/sol = INFINITY,
		/obj/item/gun/ballistic/marsian_super_rifle = INFINITY,
		/obj/item/gun/ballistic/automatic/karim = INFINITY,
		/obj/item/gun/ballistic/automatic/lanca = INFINITY,
		/obj/item/gun/ballistic/automatic/pistol/sol = INFINITY,
		/obj/item/gun/ballistic/automatic/pistol/sol/evil = INFINITY,
		/obj/item/gun/ballistic/automatic/miecz = INFINITY,
		/obj/item/gun/ballistic/automatic/nomi_shotgun = INFINITY,
		/obj/item/gun/ballistic/rifle/osako = INFINITY,
		/obj/item/gun/ballistic/rifle/osako/scoped = INFINITY,
		/obj/item/gun/ballistic/automatic/sol_rifle/machinegun = INFINITY,
		/obj/item/gun/ballistic/shotgun/ramu = INFINITY,
		/obj/item/gun/ballistic/automatic/suppressed_rifle/marksman = INFINITY,
		/obj/item/gun/ballistic/shotgun/riot/sol = INFINITY,
		/obj/item/gun/ballistic/shotgun/riot/sol/evil = INFINITY,
		/obj/item/gun/ballistic/automatic/seiba_smg = INFINITY,
		/obj/item/gun/ballistic/automatic/sol_smg = INFINITY,
		/obj/item/gun/ballistic/automatic/pistol/trappiste = INFINITY,
		/obj/item/gun/ballistic/revolver/takbok = INFINITY,
		/obj/item/gun/ballistic/automatic/suppressed_rifle = INFINITY,
		/obj/item/gun/ballistic/automatic/pistol/weevil = INFINITY,
	)
	refill_canister = /obj/item/vending_refill/donksoft
	payment_department = NO_FREEBIES
	all_products_free = TRUE
	onstation_override = TRUE

/obj/machinery/vending/donksofttoyvendor/default_deconstruction_screwdriver(mob/user, icon_state_open, icon_state_closed, obj/item/screwdriver)
	return

/obj/item/vending_refill/donksoft
	machine_name = "Donksoft Toy Vendor"
	icon_state = "refill_donksoft"
