// Psyker Events happen when your stress reaches the threshold. Specifically, 1x the stress_threshold, 1.5x for severe and 2x for catastrohpic.
// There is a 20% of substituting a catastrophic event for a special event. These aren't necessarily always better, just a lot weirder.
// Any psyker_event you define is added to the lists unless it is abstract.

/datum/psyker_event
	// Remember to set abstracts to this.
	abstract_type = /datum/psyker_event
	/// check defines for weights.
	var/weight = PSYKER_EVENT_RARITY_COMMON
	/// For events that continue for a while, this skips the qdel step. MAKE SURE YOU QDEL IT YOURSELF LATER INSIDE THE CODE.
	var/lingering = FALSE

/// Are there any special prerequisites?
/datum/psyker_event/proc/can_execute(mob/living/carbon/human/psyker)
		return TRUE

/// Return TRUE if the event actually happens, FALSE if it doesnt and should be skipped
/datum/psyker_event/proc/execute(mob/living/carbon/human/psyker)
		return FALSE

/// Milds generally want to not take you out of the flow but be noticeable enough that someone paying attention will notice they're pushing the line.
/datum/psyker_event/mild
	abstract_type = /datum/psyker_event/mild

/// Severe are the very clear warning to stop. These should be obvious and detrimental, with a clear goal of making it so that you stop and meditate or face the consequences.
/datum/psyker_event/severe
	abstract_type = /datum/psyker_event/severe

/// The consequences of your actions. Usually things that demand an immediate medbay visit or leave lingering consequences for the Psyker.
/datum/psyker_event/catastrophic
	abstract_type = /datum/psyker_event/catastrophic
