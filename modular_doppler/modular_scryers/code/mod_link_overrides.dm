
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
