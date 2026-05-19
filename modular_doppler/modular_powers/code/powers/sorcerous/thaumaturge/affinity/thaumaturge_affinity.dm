/obj/item
	/// Used for the affinity system in the Powers system by Thaumaturge to determine their magical strengh.
	var/affinity = 0
	/// Item gets affinity from being worn instead of being held; useful for items that can be worn but arent obj/item/clothing
	var/affinity_worn_override

/* So, affinity is a system that applies a value to objects; and the amount of affinity is based on the item.
We have to apply this retroactively to existing items, which is what this file is for. If you make something new, include it as a var instead.
*/

/*
A lot of Affinity asignments are vibe-based depending on looks, visibility and rarirty, but the rule of thumb I tend to use is;
- T1: If it goes in a weird slot (neck, mask, undersuit, shoes, gloves) OR if it has some association with 'magic' or pretending to be magical (e.g short capes) and isn't traditionally part of a classical caster archetype (Bard, Druid, Cleric, Wizard) it goes here.
- T2: Magical headwear with bonus stats (armor). Handheld affinity items that fit in pockets+. T1 equipment that covers a lot of the sprite (capes, full-head masks, etc.)
- T3: Magical headwear with NO bonus stats, Magical Bodywear with bonus stats. Rare magic-looking items in weird slots. Handheld affinity items that don't fit in pockets but do fit in the backpack.
- T4: Magical bodywear with NO bonus stats. Handheld affinity items that don't fit in pocket or backpack but allow suit slots/belt slot.
- T5: Handheld affinity items that don't fit anywhere (but the backpack). Most antag robes.
- T6+: Go with your gut based on rarity, looks and antag. Wiz robes are usually T7.
*/

/*
	Tier 1
*/
 // its not as pointy but itlll do
/obj/item/clothing/head/costume/paper_hat
	affinity = 1

// the various neck-slot capes that cover too little of the sprite to pass. or are the poncho; because I cant recall a single magic-man wearing a poncho.
/obj/item/clothing/neck/face_scarf
	affinity = 1
/obj/item/clothing/neck/mantle
	affinity = 1
/obj/item/clothing/neck/doppler_mantle
	affinity = 1
/obj/item/clothing/neck/basic_poncho
	affinity = 1
/obj/item/clothing/neck/ranger_poncho
	affinity = 1
/obj/item/clothing/neck/patterned_poncho
	affinity = 1

// we all loved to larp with bedsheet capes when we were younger
/obj/item/bedsheet
	affinity = 1
	affinity_worn_override = TRUE

// there's an argument to be made for plague doctors being mystical.
/obj/item/clothing/mask/gas/plaguedoctor
	affinity = 1

// Animal masks are like a classic ritual in a lot of folklore so I am giving some leeway here. Small are T1, big are T2.
/obj/item/clothing/mask/animal/small
	affinity = 1

// There's enough anime of magic maids to justify this.
/obj/item/clothing/under/rank/civilian/janitor/maid
	affinity = 1
/obj/item/clothing/under/costume/maid
	affinity = 1
/obj/item/clothing/accessory/maidapron
	affinity = 1

/*
	Tier 2:
*/
// Capes are about as caster as it gets and cover enough of the sprite to justify t2.
/obj/item/clothing/neck/wide_cape
	affinity = 2
/obj/item/clothing/neck/robe_cape
	affinity = 2
/obj/item/clothing/neck/long_cape
	affinity = 2


/obj/item/staff // the base item is small
	affinity = 2

// Nullrods come in a lot of shapes and forms; by default we give it affinity 2 unless it fucks with slots and is clearly magical.
/obj/item/nullrod
	affinity = 2

// Animal masks that arent small
/obj/item/clothing/mask/animal
	affinity = 2
/*
	Tier 3:
*/
// Jester hat
/obj/item/clothing/head/costume/jester
	affinity = 3

// Clown Mitre
/obj/item/clothing/head/chaplain/clownmitre
	affinity = 4

// Nun hood
/obj/item/clothing/head/chaplain/habit_veil
	affinity = 3

// Shrine maiden wig
/obj/item/clothing/head/costume/shrine_wig
	affinity = 3

// Gohei; this is apparently the asian equivelant of a staff. Regardless they lose points cause they fit in the backpack.
/obj/item/gohei
	affinity = 3

// Narsie cult looks sufficiently magical, but they don't get the antag pass because you can get these from Lavaland and are already very robust.
/obj/item/clothing/suit/hooded/cultrobes
	affinity = 3

// Rare enough cloak-slot dropped by Lavaland Elites.
/obj/item/clothing/neck/cloak/herald_cloak
	affinity = 3

// Heretic focues arent too pronounced but theyre antag items so they get preferential treatment
/obj/item/clothing/neck/heretic_focus
	affinity = 3

// You can teleport with it but given its megafauna loot we can be a bit lax
/obj/item/hierophant_club
	affinity = 3

// Its the bible! Given we allow tomes, I'm sure some people will want to larp a cleric or otherwise have some magic religion. Print more bibles!
/obj/item/book/bible
	affinity = 3

/*
	Tier 4
*/
// Fits the criteria for wands but since its lavaland loot it gets a +1
/obj/item/lava_staff
	affinity = 4

// Carp suit (magicarp)
/obj/item/clothing/suit/hooded/carp_costume
	affinity = 4

// Cueball hat. It sparks and makes your head a big white orb.
/obj/item/clothing/head/costume/cueball
	affinity = 4

// Owl Wings (pretty druidy)
/obj/item/clothing/suit/toggle/owlwings // (includes griffon wings
	affinity = 4

// Dracula is pretty wizardy
/obj/item/clothing/suit/costume/dracula
	affinity = 4

// Costumes that are basically wizard drip.
/obj/item/clothing/suit/costume/imperium_monk
	affinity = 4
/obj/item/clothing/suit/hooded/mysticrobe
	affinity = 4

// Cleric/priest robes with no defenses.
/obj/item/clothing/suit/chaplainsuit/whiterobe
	affinity = 4
/obj/item/clothing/suit/chaplainsuit/habit
	affinity = 4
/obj/item/clothing/suit/chaplainsuit/clownpriest
	affinity = 4

// I dont know what a touhou or a shrine maiden is but its magical apparently.
/obj/item/clothing/suit/costume/shrine_maiden
	affinity = 4

// Banshees are valid.
/obj/item/clothing/suit/costume/whitedress
	affinity = 4
/obj/item/clothing/under/dress/wedding_dress
	affinity = 4

// We should add frost powers tbh.
/obj/item/clothing/suit/costume/drfreeze_coat
	affinity = 4

// Heretic void cloak. The hood actually gives T5 to reflect you can cast only with the hood up.
/obj/item/clothing/suit/hooded/cultrobes/void
	affinity = 4

// The heretic book. Bonus points for being antag and heretic spell focus.
/obj/item/codex_cicatrix
	affinity = 4

// Did you know the perceptomatrix lets you cast spells?
/obj/item/clothing/head/helmet/perceptomatrix
	affinity = 4

/*
	Tier 4: Wizrobes specifically.
*/

// Wizrobes (Fakes)
/obj/item/clothing/suit/wizrobe/fake
	affinity = 4
/obj/item/clothing/suit/wizrobe/marisa/fake
	affinity = 4
/obj/item/clothing/suit/wizrobe/tape/fake
	affinity = 4

// Wizrobe hats (Fakes)
/obj/item/clothing/head/wizard/fake
	affinity = 4
/obj/item/clothing/head/costume/witchwig
	affinity = 4
/obj/item/clothing/head/collectable/wizard
	affinity = 4
/obj/item/clothing/head/wizard/marisa/fake
	affinity = 4
/obj/item/clothing/head/wizard/tape/fake
	affinity = 4
/obj/item/clothing/head/wizard/chanterelle
	affinity = 4

/*
	Tier 5+
*/

// Nullrods that are bulky and clearly magical
/obj/item/nullrod/staff
	affinity = 5
/obj/item/nullrod/vibro/spellblade
	affinity = 5
/obj/item/vorpalscythe
	affinity = 5
/obj/item/nullrod/claymore/darkblade // its a cult sword and it glows thats good enough
	affinity = 5
/obj/item/nullrod/pitchfork
	affinity = 5
/obj/item/nullrod/pride_hammer
	affinity = 5

// Haunted blade, the heretic sword that gives you cool shit.
/obj/item/melee/cultblade/haunted
	affinity = 5

// Heretic cloak with hood up: This is invisible, but also heretics can cast spells with it so this is fine.
/obj/item/clothing/head/hooded/cult_hoodie/void
	affinity = 5

// Eldrich heretic robes with hood up.
/obj/item/clothing/head/hooded/cult_hoodie/eldritch
	affinity = 5

// Slightly better staves, as a treat.
/obj/item/storm_staff
	affinity = 6
/obj/item/rod_of_asclepius
	affinity = 6

// Real Wizrobes (antag only)
/obj/item/clothing/head/wizard
	affinity = 6
/obj/item/clothing/suit/wizrobe
	affinity = 7
/obj/item/clothing/suit/wizrobe/paper // this ones a bit special since its space loot but rare space loot.
	affinity = 6

// This is the actual magnum opus of Wizardy; unless a Wizard item is made to delibaretely interact with thaumaturge, there shouldn't be anything exceeding this.
/obj/item/mod/control/pre_equipped/enchanted
	affinity = 8
	affinity_worn_override = TRUE
