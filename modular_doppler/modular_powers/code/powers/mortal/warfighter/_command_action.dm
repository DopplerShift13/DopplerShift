
/* Commands work in their own little way so they get a different typepath. */
/datum/action/cooldown/power/warfighter/command
	name = "COMMAND abstract parent type"
	desc = "This is what the Karens in management think they have. Great power. But really this doesn't do anything; this is just an abstract type. Demand to speak to the manager of the server and that they fix this."

	click_to_activate = TRUE
	target_self = FALSE
	// we validate hands free differently given you can give commands with your voice and all that.
	need_hands_free = FALSE
	// silicons I hate to break it to you but you aren't included.
	target_type = /mob/living/carbon

	/// is the user a command staff
	var/command_bonus = FALSE
	/// is the target part of the user's department?
	var/department_bonus = FALSE

	/// the total effectiveness modifier for commander powers
	var/commander_modifier = WARFIGHTER_COMMANDER_BASE_MULT

	/// the symbol displayed over the target's head when using the action
	var/action_symbol = "point"

/// Is the user a member of the command department.
/datum/action/cooldown/power/warfighter/command/proc/is_command_staff(mob/living/user)
	var/datum/job/assigned = user?.mind?.assigned_role
	if(!assigned)
		return FALSE
	return (assigned.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND) || (assigned.job_flags & JOB_HEAD_OF_STAFF)

/// Are the user and target of the same department?
/datum/action/cooldown/power/warfighter/command/proc/is_same_department(mob/living/user, mob/living/target)
	var/datum/job/user_job = user?.mind?.assigned_role
	var/datum/job/target_job = target?.mind?.assigned_role
	if(!user_job || !target_job)
		return FALSE
	return (user_job.departments_bitflags & target_job.departments_bitflags)

/datum/action/cooldown/power/warfighter/command/can_use(mob/living/user, mob/living/target)
	. = ..()
	// If the target can't hear or see you
	if(!target.can_hear() && !can_see(target, user))
		owner.balloon_alert(user, "target can't perceive you!")
		return FALSE
	// If we can't talk nor use our hands.
	if(!user.can_speak() && HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		owner.balloon_alert(user, "you're unable to relay your commands!")
		return FALSE

// We do the department checks in here. We force a parent call because commands kind-of are build around this system.
/datum/action/cooldown/power/warfighter/command/use_action(mob/living/user, mob/living/target)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	commander_modifier = WARFIGHTER_COMMANDER_BASE_MULT
	command_bonus = is_command_staff(user)
	department_bonus = is_same_department(user, target)
	if(department_bonus)
		commander_modifier += WARFIGHTER_COMMANDER_DEPARTMENT_BONUS
	if(command_bonus)
		commander_modifier += WARFIGHTER_COMMANDER_HEAD_BONUS

/datum/action/cooldown/power/warfighter/command/on_action_success(mob/living/user, mob/living/target)
	. = ..()
	var/mutable_appearance/user_symbol = mutable_appearance('icons/effects/callouts.dmi', "danger")
	user_symbol.pixel_y = 16
	user_symbol.color = "#cc3d3d"
	SET_PLANE_EXPLICIT(user_symbol, ABOVE_LIGHTING_PLANE, user)
	var/mutable_appearance/target_symbol = mutable_appearance('icons/effects/callouts.dmi', action_symbol)
	target_symbol.pixel_y = 16
	target_symbol.color = "#cc3d3d"
	SET_PLANE_EXPLICIT(target_symbol, ABOVE_LIGHTING_PLANE, target)
	// applies the status effect overlay
	user.flick_overlay_static(user_symbol, 2 SECONDS)
	target.flick_overlay_static(target_symbol, 2 SECONDS)

	/// plays the sound to only the target and the user given that it's kind-of obnoxious.
	var/turf/origin = get_turf(user)
	var/sound_file = 'sound/items/whistle/whistle.ogg'
	user.playsound_local(origin, sound_file, 40, TRUE)
	target.playsound_local(origin, sound_file, 40, TRUE)

	// starts the gcd
	start_command_gcd(user)

// starts a gcd for all warfighter powers to prevent SPAM.
/datum/action/cooldown/power/warfighter/command/proc/start_command_gcd(mob/living/user)
	for(var/datum/action/A as anything in user.actions)
		if(!istype(A, /datum/action/cooldown/power/warfighter/command))
			continue
		var/datum/action/cooldown/power/warfighter/command/C = A
		if(C.next_use_time <= world.time)
			C.StartCooldownSelf(2 SECONDS)

