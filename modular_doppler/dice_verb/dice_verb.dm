/// Rolls the sent dice and announces the resulting roll in LOOC.
/client/verb/roll_dice(dice_expression as text)
	set name = "Roll Dice"
	set desc = "Roll dice for nearby players to see. Example: 2d6 or 1d20+5."
	set category = "OOC"

	if(isnull(dice_expression))
		return

	/// Regex parser: before D is group 1 (count), after D is group 2 (size) and anything after a + or - is group 3 (modifier).
	var/static/regex/dice_pattern = regex(@"^(\d+)d(\d+)([+-]\d+)?$", "i")
	dice_expression = LOWER_TEXT(trim(dice_expression))
	if(length(dice_expression) > 16 || !dice_pattern.Find(dice_expression))
		to_chat(src, span_warning("Enter dice such as 2d6, 1d20+5, or 1d20-4. Leave empty for 1d20!"))
		return

	// The only numbers here that matter in performance is dice-count.
	// Size and modifier are only capped to prevent stupid chat-spam where you start breaking into 'to the power of E' territory. What tabletop system are you playing that you need modifiers that big?
	var/dice_count = text2num(dice_pattern.group[1])
	if(dice_count < 1 || dice_count > 100)
		to_chat(src, span_warning("You must roll between 1 and 100 dice."))
		return
	var/die_size = text2num(dice_pattern.group[2])
	if(die_size < 1 || die_size > 1000)
		to_chat(src, span_warning("Dice must have between 1 and 1,000 sides."))
		return
	var/flat_modifier = text2num(dice_pattern.group[3])
	if(abs(flat_modifier) > 10000)
		to_chat(src, span_warning("The dice modifier must be between -10,000 and 10,000."))
		return

	// RRRRRRRRROOOOOLL THE DICE.
	var/roll_total = roll(dice_expression)

	dice_looc_action("rolled [dice_expression] = [roll_total]!")

/// Sends the result as a LOOC message with the same checks and rules as LOOC. The exception is that we don't support wallpierce.
/client/proc/dice_looc_action(message)

	// Same LOOC restrictions with the exception of non-applicable rules such as the advertising one.
	if(GLOB.say_disabled)
		to_chat(src, span_danger("Speech is currently admin-disabled."))
		return
	if(!mob)
		return
	if(!message)
		return
	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger("LOOC is globally muted."))
			return
		// Note that this only flags quant unless you are spamming a lotta 1d2s
		if(handle_spam_prevention(message, MUTE_OOC))
			return
		if(prefs.muted & MUTE_LOOC)
			to_chat(src, span_danger("You cannot use LOOC (muted)."))
			return
		if(is_banned_from(ckey, BAN_LOOC))
			to_chat(src, span_warning("You are LOOC banned!"))
			return
		if(mob.stat == DEAD)
			to_chat(src, span_danger("You cannot use LOOC while dead."))
			return
		if(istype(mob, /mob/dead))
			to_chat(src, span_danger("You cannot use LOOC while ghosting."))
			return

	mob.log_talk(message, LOG_OOC, tag = "LOOC (Dice)")
	var/list/heard = get_hearers_in_view(LOOC_RANGE, mob.get_top_level_mob())

	//so the ai can roll dice too
	if(istype(mob, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/ai = mob
		heard = get_hearers_in_view(LOOC_RANGE, ai.eyeobj)
	//so the ai can see dice too
	for(var/mob/living/silicon/ai/ai as anything in GLOB.ai_list)
		if(ai.client && !(ai in heard) && (ai.eyeobj in heard))
			heard += ai

	// Deliver the message in the same way LOOC does it.
	var/list/admin_seen = list()
	for(var/mob/hearing in heard)
		if(!hearing.client)
			continue
		var/client/hearing_client = hearing.client
		var/is_holder = hearing_client.holder
		if(is_holder)
			admin_seen[hearing_client] = TRUE

		if(isobserver(hearing) && !is_holder)
			continue

		// The message is slightly different in the sense that : are not after the name, in the same way a me* would be done.
		// E.g John Dice rolled 1d6 = 6!, rather than the normal John Dice: rolled 1d6 = 6.
		// Slight mark of authenticity.
		if(mob.runechat_prefs_check(hearing) && hearing.client?.prefs.read_preference(/datum/preference/toggle/enable_looc_runechat))
			hearing.create_chat_message(mob, raw_message = "(LOOC: [message])", runechat_flags = EMOTE_MESSAGE)

		if(is_holder)
			continue

		to_chat(hearing_client, span_looc("<span class='prefix'>LOOC:</span> <EM>[mob.name]</EM> <span class='message'>[message]</span>"))

	for(var/client/admin_client as anything in GLOB.admins)
		if(admin_seen[admin_client])
			to_chat(admin_client, span_looc("[ADMIN_FLW(usr)] <span class='prefix'>LOOC:</span> <EM>[key]/[mob.name]</EM> <span class='message'>[message]</span>"))
		else if(admin_client.prefs.read_preference(/datum/preference/toggle/admin/see_looc))
			to_chat(admin_client, span_rlooc("[ADMIN_FLW(usr)] <span class='prefix'>(R)LOOC:</span> <EM>[key]/[mob.name]</EM> <span class='message'>[message]</span>"))
