/obj/item/storage/box/papersack/cannabis
	name = "bag of weed"
	desc = "This thing absolutely reeks. There's a solid chance you're getting fired for this."
	design_choice = "SmileyFace"

/obj/item/storage/box/papersack/cannabis/PopulateContents()
	. = ..()
	for(var/i in 1 to 7)
		new /obj/item/food/grown/cannabis(src)
