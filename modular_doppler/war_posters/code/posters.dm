#define WAR_POSTER_MOOD "war_poster"
#define WAR_POSTER_RANGE 7

/obj/structure/sign/poster/doppler_war
	name = "abstract war poster"
	desc = "Surely, if this was coded correctly, you would be angry."
	abstract_type = /obj/structure/sign/poster/doppler_war
	icon = 'modular_doppler/war_posters/icons/posters.dmi'
	icon_state = "tesh_unity"

	/// Those of our aligned faction recieve a small mood buff when seeing this poster - other factions get a debuff. Neutral doesn't care at all.
	var/aligned_faction = WAR_FACTION_NEUTRAL
	/// Assoc list of (WAR_FACTION -> list(string, chance)). Used in pickweight to determine what people think when they see the poster, depending on
	var/list/faction_reactions = list()
	/// Assoc list of (WAR_FACTION -> /datum/mood_event). Used to determine the actual mood event given.
	var/list/faction_moods = list()
	/// Proximity sensor for the above vars
	var/datum/proximity_monitor/advanced/war_demoraliser/demoraliser

/obj/structure/sign/poster/doppler_war/on_placed_poster()
	demoraliser = new(src, WAR_POSTER_RANGE, TRUE, aligned_faction, WAR_POSTER_MOOD, faction_reactions, faction_moods, READING_CHECK_LIGHT)
	return ..()

/obj/item/poster/doppler_random
	abstract_type = /obj/item/poster/doppler_random
	var/obj/structure/sign/poster/poster_basetype

/obj/item/poster/doppler_random/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	var/list/valid_subtypes = subtypesof(poster_basetype)
	for (var/datum/subtype as anything in valid_subtypes)
		if (subtype.abstract_type == subtype)
			valid_subtypes -= subtype
	var/obj/structure/sign/poster/picked = pick(valid_subtypes)
	new_poster_structure = new picked(src)
	return ..()

/obj/item/storage/box/doppler_war_posters
	name = "propaganda poster box"
	desc = "A box usually containing a number of posters for propaganda purposes."
	abstract_type = /obj/item/storage/box/doppler_war_posters
	var/obj/item/poster/poster_path

/obj/item/storage/box/doppler_war_posters/PopulateContents()
	. = ..()

	var/i = 0
	while (i++ < 7)
		new poster_path(src)

/obj/item/poster/doppler_random/random_teshari
	name = "random teshari poster"
	poster_basetype = /obj/structure/sign/poster/doppler_war/teshari
	icon = 'modular_doppler/war_posters/icons/posters.dmi'
	icon_state = "rolled_tesh"

/obj/item/storage/box/doppler_war_posters/teshari
	poster_path = /obj/item/poster/doppler_random/random_teshari

/obj/structure/sign/poster/doppler_war/teshari
	name = "teshari war poster"
	poster_item_name = "teshari war poster"
	poster_item_desc = "A pro-teshari propaganda poster, espousing the evils of the Talunan empire and the virtue of Sirsiai's defense. Aisi Tarischi."
	poster_item_icon_state = "rolled_tesh"
	printable = TRUE
	aligned_faction = WAR_FACTION_TESHARI
	abstract_type = /obj/structure/sign/poster/doppler_war/teshari

/obj/structure/sign/poster/doppler_war/teshari/unity
	name = "Ilisime (Unity)"
	desc = "A poster encouraging the teshari diaspora - from stars, from sea, from earth, from dust - to unite in defense of their shattered homeworld, Sirisai."
	icon_state = "tesh_unity"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"All for Sirisai. Aisi Tarischi!" = 10,
			"Sophonts in arms, we can save Teshari kind." = 10,
			"Unity...? I'm not alone here." = 8
		),
		WAR_FACTION_TIZIRA = list(
			"Look at them, standing in front of their flag like they're the 'victims'." = 10,
			"...your unity won't do much when you're outnumbered and outgunned, you vultures." = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_sympathy,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_wrong,
	)

/obj/structure/sign/poster/doppler_war/teshari/execution
	name = "Schatara shitilushu (Our execution)"
	desc = "A kneeled teshari is presented for execution by a Tiziran blade. You could be next on the block. Act now!"
	icon_state = "tesh_warn"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"We will shatter their Tiziran steel with our resolve. Aisi Tarischi." = 10,
			"I won't be next. Noone will. We can stop the Tizirans here and now." = 10,
		),
		WAR_FACTION_TIZIRA = list(
			"They struck first! They're the instigators! But the TIZIRANS are the executioners?!" = 10,
			"Stars, such a damned overreaction. Those birds could end this war whenever they choose." = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_sympathy,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_wrong,
	)

/obj/structure/sign/poster/doppler_war/teshari/enemy
	name = "Shushire Metara (Enemy yours)"
	desc = "Depicted on this poster is a rather over-built Tiziran, contrasted with the rather small form of a typical Teshari. Labels, in schechi, read: \"IMPERIALIST\", and \"UNITED\". Clear propaganda, if you've ever seen it."
	icon_state = "tesh_enemy"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"Their brutishness will be their downfall. All for Sirisai." = 10,
		),
		WAR_FACTION_TIZIRA = list(
			"Of course they choose to depict Tizirans as brutes. It's all they can really do." = 10,
			"...could they not have chosen a less stereotyped image for their propaganda?" = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_sympathy,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_wrong,
	)

/obj/structure/sign/poster/doppler_war/teshari/burn
	name = "Ilisischa! (Inferno!)"
	desc = "A rather striking image of a rather furious-looking teshari staring at the camera, torch in-hand, setting the Tiziran flag alight. Written beneath in Schechi runes reads \"Fight back!\""
	icon_state = "tesh_burn"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"We'll fight for every damn inch of land they take. Sirisai will stand." = 10,
			"Raise your arms, raise your wings, raise your rifles..." = 10,
		),
		WAR_FACTION_TIZIRA = list(
			"The flag? Really? That's just cliche..." = 10,
			"...of course, if they had their way, they'd burn Tizira to the ground as well. Animals. Vultures." = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_sympathy,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_wrong,
	)

/obj/item/poster/doppler_random/random_tiziran
	name = "random tiziran poster"
	poster_basetype = /obj/structure/sign/poster/doppler_war/tiziran
	icon = 'modular_doppler/war_posters/icons/posters.dmi'
	icon_state = "rolled_tizira"

/obj/item/storage/box/doppler_war_posters/tiziran
	poster_path = /obj/item/poster/doppler_random/random_tiziran

/obj/structure/sign/poster/doppler_war/tiziran
	name = "tiziran war poster"
	poster_item_name = "tiziran war poster"
	poster_item_desc = "A pro-tizira propaganda poster, generally encouraging enlistment and patriotism."
	poster_item_icon_state = "rolled_tizira"
	printable = TRUE
	abstract_type = /obj/structure/sign/poster/doppler_war/tiziran
	aligned_faction = WAR_FACTION_TIZIRA

/obj/structure/sign/poster/doppler_war/tiziran/pride
	name = "Tizira. (Tizira.)"
	desc = "A depiction of the Tiziran flag. Three moon dieties - Atra'Kor, Atra'Kal, and Atra'Neff, topped and nurtured by the sun-god Atra'Asl. \
	Explained beneath, the wings depict the tiziran peoples' shared faith and unity. This is what we fight for, the poster suggests. What we defend."
	icon_state = "tizira_pride"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"The tiziran flag. The poster child (literally) of imperialist slaughter." = 10,
			"If these gods of theirs are real, they would weep at the lizards' senseless war." = 10
		),
		WAR_FACTION_TIZIRA = list(
			"The tiziran flag. A reminder of what we are fighting for." = 10,
			"May the moon gods watch over Tizira's soldiers." = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_wrong,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_sympathy,
	)

/obj/structure/sign/poster/doppler_war/tiziran/enlist
	name = "Za'Haious Rar! (Enlist!)"
	desc = "While many Tizirans face obligate military service, few reach professional status. This poster encourages the reader to fully commit themselves to the Talunan ranks, and earn their prestige in white."
	icon_state = "tizira_enlist"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"More officers to command their mindless brutes into the tundras of Sirisai..." = 10,
			"You could excuse the grunts. They didn't choose. But the whitecaps? Irredeemable." = 10
		),
		WAR_FACTION_TIZIRA = list(
			"Nothing's more prideful than giving yourself to the defense of the mother sands. Respect to them all." = 10,
			"It's not for everyone. But that white armor could give anyone a new look into life." = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_wrong,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_sympathy,
	)

/obj/structure/sign/poster/doppler_war/tiziran/enlisttwo
	name = "Hekiek Mor'Shuxi? (Are you doing your part?)"
	desc = "The armored Tiziran curiously glances through her visor-glass to the viewer, as if to ask: 'Are you giving your all for your home?'"
	icon_state = "tizira_enlisttwo"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"Doing your part? What's your part, helping a senseless imperialist war for territory?" = 10,
			"Doing my part, sure. Just not the one you want, you damned geckos." = 10
		),
		WAR_FACTION_TIZIRA = list(
			"The more soldiers for the war, the better. We need to end this as soon as we can." = 10,
			"Every Tiziran should fight for their home. It's your home. To stand by would be to invite... chaos." = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_wrong,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_sympathy,
	)

/obj/structure/sign/poster/doppler_war/tiziran/enlistthree
	name = "Hexire Tizira (Tizira needs you)"
	desc = "A series of career-service tizirans are lined up. Supported by the Tiziran emblem, the poster urges the reader to enlist for protracted service against the Teshari menace."
	icon_state = "tizira_enlistthree"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"The only menace here are you Tiziran imperialists." = 10,
			"...how many of those Tizirans will die for their lie?" = 10,
			"Just more grunts to the slaughter. This violence needs to end." = 10,
		),
		WAR_FACTION_TIZIRA = list(
			"The more soldiers for the war, the better. We need to end this as soon as we can." = 10,
			"Those birds had no idea what kind of war they'd start." = 10
		),
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_wrong,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_sympathy,
	)

/obj/item/poster/doppler_random/random_isolationist
	name = "random isolationist poster"
	poster_basetype = /obj/structure/sign/poster/isolationist
	icon = 'modular_doppler/war_posters/icons/posters.dmi'
	icon_state = "rolled_iso"

/obj/item/storage/box/doppler_war_posters/isolationist
	poster_path = /obj/item/poster/doppler_random/random_isolationist

/obj/structure/sign/poster/isolationist
	name = "isolationist war poster"
	poster_item_name = "isolationist war poster"
	poster_item_desc = "An isolationist propaganda poster, condemning the 4CA for its attempted involvement in the tizira/teshari war."
	poster_item_icon_state = "rolled_iso"
	icon = 'modular_doppler/war_posters/icons/posters.dmi'
	abstract_type = /obj/structure/sign/poster/isolationist

/obj/structure/sign/poster/isolationist/bigbrother
	name = "Big Brother"
	desc = "An eye overlooks a row of individuals, flanked by the 4CA's primary color. The hand closes around the galaxy. The 4CA expands."
	icon_state = "iso_bigbrother"

/obj/structure/sign/poster/isolationist/stayout
	name = "4CA Stay Out!"
	desc = "Both the Tizirans and the Teshari refuse direct 4CA intervention in their war. Yet, the alignment pushes anyway. This poster summarizes the way many people feel about this."
	icon_state = "iso_stayout"

#undef WAR_POSTER_MOOD
#undef WAR_POSTER_RANGE
