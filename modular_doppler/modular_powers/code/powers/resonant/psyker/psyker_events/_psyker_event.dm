// Psyker Events happen when your stress reaches the threshold. Specifically, 1x the stress_threshold, 1.5x for severe and 2x for catastrohpic.
// There is a 20% of substituting a catastrophic event for a special event. These aren't necessarily always better, just a lot weirder.
// Any psyker_event you define is added to the lists unless it is abstract.

/datum/psyker_event
	// Remember to set abstracts to this.
	var/abstract_type = /datum/psyker_event
	var/weight = 1
	// For events that continue for a while, this skips the qdel step, under the condition you qdel it later.
	var/lingering = FALSE

// Are there any special prerequisites?
/datum/psyker_event/proc/can_execute(mob/living/carbon/human/psyker)
		return TRUE

// Return TRUE if the event actually happens, FALSE if it should be skipped
/datum/psyker_event/proc/execute(mob/living/carbon/human/psyker)
		return FALSE

/datum/psyker_event/mild
	abstract_type = /datum/psyker_event/mild

/datum/psyker_event/severe
	abstract_type = /datum/psyker_event/severe

/datum/psyker_event/catastrophic
	abstract_type = /datum/psyker_event/catastrophic

/datum/psyker_event/special
	abstract_type = /datum/psyker_event/special
