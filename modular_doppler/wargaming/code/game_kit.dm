/obj/item/storage/briefcase/secure/wargame_kit
	name = "DIY Wargaming Kit"
	desc = "Contains everything an aspiring naval officer (or just huge fucking nerd) would need for a proper modern naval wargame."
	custom_premium_price = PAYCHECK_CREW * 2

/obj/item/storage/briefcase/secure/wargame_kit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/wargame_base_station = 1,
		/obj/item/wargame_projector/ships = 1,
		/obj/item/wargame_projector/ships/red = 1,
		/obj/item/wargame_projector/terrain = 1,
		)
	generate_items_inside(items_inside,src)
