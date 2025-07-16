/datum/uplink_item/stealthy_weapons/maddogarts
	name = "The Mad Dog's Style"
	desc = "This scroll contains the secrets of an ancient martial master's technique. You will lose the ability to use ranged weaponry, \
		but gain untold hand-to-hand combat prowess, immunity to being in critical condition, and generally become rather difficult to kill."
	item = /obj/item/book/granter/martial/mad_dog
	progression_minimum = 30 MINUTES
	cost = 24 // this shit laced. requires others to give you tc or the Independent Fixer allegiance
	surplus = 0
	purchasable_from = UPLINK_TRAITORS | UPLINK_SPY

/datum/uplink_item/stealthy_weapons/bostaff // 24 damage when wielded, deals stamina damage on right click while wielded. not super concealable, but very good for nonlethal, so it's 'stealthy'
	name = "Bo Staff"
	desc = "A highly specialized and carefully treated wooden staff with a woven grip, suitable for usage in close quarters combat. Though its \
		uncompromising size leaves it difficult to conceal, it is capable of nonlethally subduing targets just the same as overt battle, \
		although it is a master at neither."
	item = /obj/item/staff/bostaff
	cost = 4 // worse than the esword at overt battle and unconcealable
	purchasable_from = ALL // frankly, martial artist nukies would be fucking awesome
