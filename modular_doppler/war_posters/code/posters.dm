#define WAR_POSTER_MOOD "war_poster"
#define WAR_POSTER_RANGE 7

/obj/structure/sign/poster/proc/randomise_further(obj/structure/sign/poster/selected_path)
	return

/obj/structure/sign/poster/doppler_war
	name = "abstract war poster"
	desc = "Surely, if this was coded correctly, you would be angry."
	abstract_type = /obj/structure/sign/poster/doppler_war
	icon = 'modular_doppler/war_posters/icons/posters.dmi'
	icon_state = "tesh_unity"

	/// Those of our aligned faction recieve a small mood buff when seeing this poster - other factions get a debuff. Neutral doesn't care at all.
	var/aligned_faction = WAR_FACTION_NEUTRAL
	/// Assoc list of (WAR_FACTION -> list(/datum/war_demoralisation_reaction, chance)). Used in pickweight to determine what people think when they see the poster, depending on
	var/list/faction_reactions = list()
	var/list/faction_moods = list()
	/// Proximity sensor for the above vars
	var/datum/proximity_monitor/advanced/war_demoraliser/demoraliser

/obj/structure/sign/poster/doppler_war/randomise_further(obj/structure/sign/poster/doppler_war/selected_path)
	. = ..()

	faction_reactions = selected_path::faction_reactions
	faction_moods = selected_path::faction_moods

/obj/structure/sign/poster/doppler_war/on_placed_poster()
	demoraliser = new(src, WAR_POSTER_RANGE, TRUE, aligned_faction, WAR_POSTER_MOOD, faction_reactions, faction_moods, READING_CHECK_LIGHT)
	return ..()

/obj/item/poster/random_teshari
	name = "random teshari poster"
	poster_type = /obj/structure/sign/poster/doppler_war/teshari/random
	icon = 'modular_doppler/war_posters/icons/posters.dmi'
	icon_state = "rolled_tesh"

/obj/structure/sign/poster/doppler_war/teshari
	name = "teshari war poster"
	poster_item_name = "teshari war poster"
	poster_item_desc = "A pro-teshari propoganda poster, espousing the evils of the Talunan empire and the virtue of Sirsiai's defense. Aisi Tarischi."
	poster_item_icon_state = "rolled_tesh"
	printable = TRUE
	aligned_faction = WAR_FACTION_TESHARI
	abstract_type = /obj/structure/sign/poster/doppler_war/teshari

/obj/structure/sign/poster/doppler_war/teshari/random
	name = "random teshari poster"
	random_basetype = /obj/structure/sign/poster/doppler_war/teshari
	icon_state = "tesh_unity"
	never_random = TRUE

/obj/structure/sign/poster/doppler_war/teshari/unity
	name = "Ilisime. (Unity.)"
	desc = "A poster encouraging the teshari diaspora - from stars, from sea, from earth, from dust - to unite in defense of their shattered homeworld, Sirisai."
	icon_state = "tesh_unity"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"All for Sirisai. Aisi Tarischi!" = 10,
			"Sophonts in arms, we can save Teshari kind." = 10,
			"Unity...? I'm not alone here." = 8
		),
		WAR_FACTION_TIZIRA = list(

		),
		WAR_FACTION_ISOLATIONIST = list(
			"Ugh! More propoganda!" = 10,
			"Keep your war posters out of my workspace." = 10
		)
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_sympathy,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_wrong,
		WAR_FACTION_ISOLATIONIST = /datum/mood_event/war_poster_wrong
	)

/obj/structure/sign/poster/doppler_war/teshari/execution
	name = "Schatara Shitilushu. (Our Execution.)"
	desc = "A kneeled teshari is presented for execution by a Tiziran blade. You could be next on the block. Act now!"
	icon_state = "tesh_warn"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"We will shatter their Tiziran steel with our resolve..." = 10,
			"I won't be next. Noone will. We can stop the Tizirans here and now." = 10,
		),
		WAR_FACTION_TIZIRA = list(

		),
		WAR_FACTION_ISOLATIONIST = list(
			"Seriously? An execution on a poster? That's just tasteless." = 10,
			"They're so desparate to get the 4CA involved, they post fake executions on our walls?" = 10
		)
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_sympathy,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_wrong,
		WAR_FACTION_ISOLATIONIST = /datum/mood_event/war_poster_wrong
	)

/obj/structure/sign/poster/doppler_war/tiziran
	name = "tiziran war poster"
	poster_item_name = "tiziran war poster"
	poster_item_desc = "A pro-tizira propoganda poster, generally encouraging enlistment and patriotism."
	poster_item_icon_state = "rolled_tizira"
	printable = TRUE
	abstract_type = /obj/structure/sign/poster/doppler_war/tiziran
	aligned_faction = WAR_FACTION_TIZIRA

/obj/structure/sign/poster/doppler_war/tiziran/enlist
	name = "Za'Haious Rar! (Enlist!)"
	desc = "While many Tizirans face obligate military service, few reach professional status. This poster encourages the reader to fully commit themselves to the Talunan ranks, and earn their prestige in white."
	icon_state = "tizira_enlist"
	faction_reactions = list(
		WAR_FACTION_TESHARI = list(
			"We will shatter their Tiziran steel with our resolve..." = 10,
			"I won't be next. Noone will. We can stop the Tizirans here and now." = 10,
		),
		WAR_FACTION_TIZIRA = list(

		),
		WAR_FACTION_ISOLATIONIST = list(
			"Ugh! More propoganda!" = 10,
			"Keep your war posters out of my workspace." = 10
		)
	)
	faction_moods = list(
		WAR_FACTION_TESHARI = /datum/mood_event/war_poster_wrong,
		WAR_FACTION_TIZIRA = /datum/mood_event/war_poster_sympathy,
		WAR_FACTION_ISOLATIONIST = /datum/mood_event/war_poster_wrong
	)

/obj/structure/sign/poster/doppler_war/isolationist
	name = "isolationist war poster"
	poster_item_name = "isolationist war poster"
	poster_item_desc = "An isolationist propoganda poster, condeming the 4CA for its attempted involvement in the tizira/teshari war."
	poster_item_icon_state = "rolled_iso"
	abstract_type = /obj/structure/sign/poster/doppler_war/isolationist
	aligned_faction = WAR_FACTION_ISOLATIONIST

#undef WAR_POSTER_MOOD
#undef WAR_POSTER_RANGE
