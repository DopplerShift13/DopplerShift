
/**
 * Overrides to make custom scryers work.
 * Non-modular overrides hooking into this are:
 * - code\modules\mod\mod_link.dm (/datum/mod_link/proc/call_link(...))
 */

/datum/mod_link
	/// A callback that allows a MODlink to override the logic when getting called.
	/// Takes the calling MODlink datum and the calling user as arguments.
	/// Return TRUE if we need to override.
	var/datum/callback/override_called_logic_callback

/datum/mod_link/Destroy()
	override_called_logic_callback = null
	return ..()

// Get the current user. For use outside of the datum.
/datum/mod_link/proc/get_user()
	return get_user_callback.Invoke()


// Temporary fix to MODlink calls keeping users in fake calls.
/datum/mod_link_call
	/// Weakref to the MODlink user that is calling.
	var/datum/weakref/link_caller_user_ref
	/// Weakref to the MODlink user that is being called.
	var/datum/weakref/link_receiver_user_ref

/datum/mod_link_call/New(datum/mod_link/link_caller, datum/mod_link/link_receiver)
	. = ..()
	var/mob/living/caller_mob = link_caller.get_user_callback.Invoke()
	link_caller_user_ref = WEAKREF(caller_mob)
	var/mob/living/receiver_mob = link_receiver.get_user_callback.Invoke()
	link_receiver_user_ref = WEAKREF(receiver_mob)

/datum/mod_link_call/Destroy()
	var/mob/living/caller_mob = link_caller_user_ref?.resolve()
	if(!QDELETED(caller_mob))
		REMOVE_TRAIT(caller_mob, TRAIT_IN_CALL, REF(src))
	link_caller_user_ref = null
	var/mob/living/receiver_mob = link_receiver_user_ref?.resolve()
	if(!QDELETED(receiver_mob))
		REMOVE_TRAIT(receiver_mob, TRAIT_IN_CALL, REF(src))
	link_receiver_user_ref = null
	return ..()
