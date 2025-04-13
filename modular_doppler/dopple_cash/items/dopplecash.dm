// money... 2!
// + kinetic. actionable. threatening.
// + looks cool
// - not so easily portable. i consider that a benefit

// code from shiptest, who took it from eris, who came from bay...

/obj/item/libre
	name = "coin?"
	desc = "But how will it effect the economy?"
	icon = 'modular_doppler/dopple_cash/icons/money_libre.dmi'
	icon_state = "libre0"
	throwforce = 1
	throw_speed = 2
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/value = 0
	grind_results = list(/datum/reagent/iron = 10)

/obj/item/libre/Initialize(mapload, amount)
	. = ..()
	if(amount)
		value = amount
	update_appearance()

/obj/item/libre/proc/adjust_value(amount)
	value += amount
	update_appearance()

/obj/item/libre/get_item_credit_value()
	return (value)

/obj/item/libre/proc/transfer_value(amount, obj/item/libre/target)
	amount = clamp(amount, 0, value)
	value -= amount
	target.value += amount
	target.update_appearance()

	if(value == 0)
		qdel(src)
		return

	update_appearance()

/obj/item/libre/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/libre))
		var/obj/item/libre/bundle/bundle
		if(istype(W, /obj/item/libre/bundle))
			bundle = W
		else
			var/obj/item/libre/cash = W
			bundle = new (loc)
			bundle.value = cash.value
			cash.value = 0
			user.dropItemToGround(cash)
			qdel(cash)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.dropItemToGround(src)
			H.dropItemToGround(bundle)
			H.put_in_hands(src)
			H.put_in_hands(bundle)
		to_chat(user, "<span class='notice'>You add [value] libre worth of money to the bundle.<br>It now holds [bundle.value + value] libre.</span>")
		bundle.transfer_value(bundle.value, src)

/obj/item/libre/Destroy()
	. = ..()
	value = 0 // This does, in fact, help prevent money from being duped endlessly.

/obj/item/libre/bundle
	icon_state = "libre20"

/obj/item/libre/bundle/update_appearance()
	icon_state = "nothing"
	cut_overlays()
	var/remaining_value = value
	var/iteration = 0
	var/coins_only = TRUE
	var/list/coin_denominations = list(10, 5, 1)
	var/list/banknote_denominations = list(1000, 500, 200, 100, 50, 20)
	for(var/i in banknote_denominations)
		while(remaining_value >= i && iteration < 50)
			remaining_value -= i
			iteration++
			var/image/banknote = image('modular_doppler/dopple_cash/icons/money_libre.dmi', "libre[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			banknote.transform = M
			overlays += banknote
			coins_only = FALSE

	if(remaining_value)
		for(var/i in coin_denominations)
			while(remaining_value >= i && iteration < 50)
				remaining_value -= i
				iteration++
				var/image/coin = image('modular_doppler/dopple_cash/icons/money_libre.dmi', "libre[i]")
				var/matrix/M = matrix()
				M.Translate(rand(-6, 6), rand(-4, 8))
				coin.transform = M
				overlays += coin

	if(coins_only)
		if(value == 1)
			name = "one libre coin"
			desc = "Rich men have dreams. Poor men die to make them come true."
			drop_sound = 'modular_doppler/dopple_cash/sounds/coin_drop.ogg'
			pickup_sound =  'modular_doppler/dopple_cash/sounds/coin_pickup.ogg'
		else
			name = "[value] libre"
			desc = "I wouldn't wager it on blackjack."
			drop_sound = 'modular_doppler/dopple_cash/sounds/coin_drop.ogg'
			pickup_sound =  'modular_doppler/dopple_cash/sounds/coin_pickup.ogg'
	else
		name = "[value] libre"
		desc = "We saw a perfect void, a star-filled sky, and said, 'let's build a shopping mall there, two hundred stories high, and set it on fire, and make it loud enough to wake God'. And so we did."
		drop_sound = 'modular_doppler/dopple_cash/sounds/dosh_drop.ogg'
		pickup_sound =  'modular_doppler/dopple_cash/sounds/dosh_pickup.ogg'
	return ..()

/obj/item/libre/bundle/attack_self()
	var/cashamount = input(usr, "How many libre do you want to take? (0 to [value])", "Take Money", 20) as num
	cashamount = round(clamp(cashamount, 0, value))
	if(!cashamount)
		return

	else if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You need to be in arm's reach for that!</span>")
		return

	var/obj/item/libre/bundle/bundle = new(usr.loc)
	transfer_value(cashamount, bundle)
	usr.put_in_hands(bundle)
	update_appearance()

/obj/item/libre/bundle/click_alt(mob/living/user)
	var/cashamount = input(user, "How many libre do you want to take? (0 to [value])", "Take Money", 20) as num
	cashamount = round(clamp(cashamount, 0, value))
	if(!cashamount)
		return

	else if(!Adjacent(user))
		to_chat(user, "<span class='warning'>You need to be in arm's reach for that!</span>")
		return

	adjust_value(-cashamount)
	if(!value)
		user.dropItemToGround(src)
		qdel(src)

	var/obj/item/libre/bundle/bundle = new(user.loc, cashamount)
	user.put_in_hands(bundle)

/obj/item/libre/bundle/Initialize()
	. = ..()
	update_appearance()

// premade bundles for spawning

/obj/item/libre/bundle/c1/Initialize()
	value = 1
	. = ..()

/obj/item/libre/bundle/c5/Initialize()
	value = 5
	. = ..()

/obj/item/libre/bundle/c10/Initialize()
	value = 10
	. = ..()

/obj/item/libre/bundle/c20/Initialize()
	value = 20
	. = ..()

/obj/item/libre/bundle/c50/Initialize()
	value = 50
	. = ..()

/obj/item/libre/bundle/c100/Initialize()
	value = 100
	. = ..()

/obj/item/libre/bundle/c200/Initialize()
	value = 200
	. = ..()

/obj/item/libre/bundle/c500/Initialize()
	value = 500
	. = ..()

/obj/item/libre/bundle/c1000/Initialize()
	value = 1000
	. = ..()

/obj/item/libre/bundle/tiny/Initialize() // THANKS, SHIPTEST!!
	value = rand(10, 100)
	. = ..()

/obj/item/libre/bundle/small/Initialize()
	value = rand(100, 500)
	. = ..()

/obj/item/libre/bundle/medium/Initialize()
	value = rand(500, 3000)
	. = ..()

/obj/item/libre/bundle/large/Initialize()
	value = rand(2500, 6000)
	. = ..()

/proc/spawn_libre(sum, spawnloc, mob/living/carbon/human/H) // not my brightest coding but that's what i have you guys for :) used for certain transactions
	var/obj/item/libre/bundle/fundle = new (spawnloc)
	fundle.value = sum
	fundle.update_appearance()
	usr.put_in_hands(fundle)
