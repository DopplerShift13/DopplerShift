/mob/living
	var/temporary_flavor_text

/mob/living/verb/set_temporary_flavor()
	set category = "IC"
	set name = "Set Temporary Flavor Text"
	set desc = "Allows you to set temporary flavor text."

	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You can't set your temporary flavor text now..."))
		return

	var/msg = tgui_input_text(usr, "Set the temporary flavor text in your 'examine' verb. This is for describing what people can tell by looking at your character.", "Temporary Flavor Text", temporary_flavor_text, max_length = 4096, multiline = TRUE)
	if(msg == null)
		return

	// Turn empty input into no flavor text
	var/result = msg || null
	temporary_flavor_text = result
	update_holder_appearance()

/// Hook for subtypes to potentially adjust their own appearance.
/mob/living/proc/update_holder_appearance()
	return

/mob/living/proc/get_examine_temporary_flavor(list/examine_list)
	if(!temporary_flavor_text)
		return

	var/tempflavorpart
	if(length_char(temporary_flavor_text) < TEMPORARY_FLAVOR_PREVIEW_LIMIT)
		tempflavorpart = temporary_flavor_text
	else
		tempflavorpart = "[copytext_char(temporary_flavor_text, 1, TEMPORARY_FLAVOR_PREVIEW_LIMIT)]... <a href='byond://?src=[REF(src)];temporary_flavor=1'>More...</a>"

	if(length(examine_list) > 0 && examine_list[length(examine_list)])
		examine_list += "" // Add a newline if needed.
	examine_list += span_revennotice("They look different from usual: [tempflavorpart]")

/mob/living/Topic(href, href_list)
	. = ..()
	if(href_list["temporary_flavor"])
		show_temp_ftext(usr)

/mob/living/proc/show_temp_ftext(mob/user)
	if(temporary_flavor_text)
		var/datum/browser/popup = new(user, "[name]'s temporary flavor text", "[name]'s Temporary Flavor Text", 500, 200)
		popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s temporary flavor text", replacetext(temporary_flavor_text, "\n", "<BR>")))
		popup.open()
		return

/**
 * Simple examine addition. Carbons need a specialcase override.
 */

/mob/living/examine(mob/user)
	. = ..()
	get_examine_temporary_flavor(.)


/**
 * Silicon overrides, needed due to specialcased code.
 */

/mob/living/silicon/Topic(href, href_list)
	. = ..()
	if(href_list["temporary_flavor"])
		show_temp_ftext(usr)

/**
 * Temporary flavortext visible on the pAI card and AI intellicard.
 */

/mob/living/silicon/pai/update_holder_appearance()
	if(card)
		card.update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/obj/item/pai_card/examine(mob/user)
	. = ..()
	if(pai)
		pai.get_examine_temporary_flavor(.)


/mob/living/silicon/ai/update_holder_appearance()
	if(istype(loc, /obj/item/aicard))
		loc.update_appearance(UPDATE_ICON|UPDATE_OVERLAYS)

/obj/item/aicard/examine(mob/user)
	. = ..()
	if(AI)
		AI.get_examine_temporary_flavor(.)
