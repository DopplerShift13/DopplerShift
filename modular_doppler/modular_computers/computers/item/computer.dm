// Original in /code/modules/modular_computers/computers/item/computer.dm

/// The initial name for the computer at time of initialization.
/// Distinct from `initial(name)` in that this preserves custom names for
/// loadout items.
/// Set in `UpdateDisplay` which is called from `Initialize`.
/obj/item/modular_computer/var/initial_name = null
/// Whether this computer has been imprinted with an ID.
/obj/item/modular_computer/var/has_been_imprinted = FALSE

/// Sets the name of the computer based on the saved ID and job.
/// If both are unset, resets the name of the computer to the initial value.
/obj/item/modular_computer/UpdateDisplay()
	// This sets `initial_name` to the initial name or the first custom name
	// the computer has before imprinting.
	if (isnull(initial_name) || initial_name == initial(name))
		initial_name = name

	// Reset the name of the computer when there's no saved ID and job.
	if(!saved_identification && !saved_job)
		name = initial_name
		has_been_imprinted = FALSE
		return

	// Prevents naming the computer to "Name's Name's computer (Job) (Job)".
	if(has_been_imprinted)
		return

	// Should this adapt dynamically to cases where only one of
	// `saved_identification` or `saved_job` are set? Is that even possible?
	name = "[saved_identification]'s [initial_name] ([saved_job])"
	has_been_imprinted = TRUE
