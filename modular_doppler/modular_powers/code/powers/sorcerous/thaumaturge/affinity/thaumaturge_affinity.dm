/* So, affinity is a system that applies a value to objects; and the amount of affinity is based on the item.
We have to apply this retroactively to existing items, which is what this file is for. If you make something new, include it as a var instead.
*/

/* Rule of thumb on what belongs in what category:
Tier 1 Affinity are things vaguely magical. A jester's hat, a cape, in essence any form of slightly mystical drip falls in this category. This is all you need to get access to most non-flashy, non-combat spells.
Tier 2 Affinity are things that are usually more obvious but not cumbersome. This category is primarily populated by any Spell Focus item that can fit in a backpack (pondering your orbs and the likes), or clearly magical items that aren't pronounced on the sprite (such as amulets).
Tier 3 Affinity is where you really start dressing magically. The job-specific thaumaturge robes, for example Security's, have this tier of affinity. Usually these robes provide some degree of utility, such as armor. This includes body and head slots. Spell Focuses, such as wands, that can't fit in the pocket but can fit in the belt/suit slot also go here. Most spells will cap out at this requirement.
Tier 4 Affinity is basically the full wizard dress. Any wizard robes without significant side-effects, such as the costume wizard robes, satisfy this condition.
Tier 5 Affinity is specially reserved for Spell Focus staves, which can only be worn on the back or held in hand. In turn, holding it gets you great power. Just make sure not to lose it.
Whilst Tier 5 is the cap for normal player content, Antagonist and other rare equipment can exceed these affinity tiers. Steal an actual Wizard's hat and you may just get your hands on a Tier 7 item.
*/

/obj/item/clothing/suit/wizrobe
	affinity = 4
