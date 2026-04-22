
/datum/id_trim/job/head_of_security
	assignment = JOB_CHIEF_GUARD
	intern_alt_name = "Security Chief-in-Training"
	honorifics = list("Chief Guard", "Chief")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL | HONORIFIC_POSITION_NONE

/datum/id_trim/job/warden
	assignment = JOB_DISPATCHER
	honorifics = list("Dispatcher", "Guard")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL | HONORIFIC_POSITION_NONE

/datum/id_trim/job/security_officer
	assignment = JOB_SECURITY_GUARD
	honorifics = list("Volunteer Guard", "Guard") // Letting you opt to really drive home the volunteer bit.
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL | HONORIFIC_POSITION_NONE

/datum/id_trim/job/security_officer/supply
	assignment = JOB_SECURITY_GUARD_SUPPLY

/datum/id_trim/job/security_officer/engineering
	assignment = JOB_SECURITY_GUARD_ENGINEERING

/datum/id_trim/job/security_officer/medical
	assignment = JOB_SECURITY_GUARD_MEDICAL

/datum/id_trim/job/security_officer/science
	assignment = JOB_SECURITY_GUARD_SCIENCE


/datum/id_trim/job/lawyer
	assignment = JOB_SOPHONT_RESOURCES_AGENT
	honorifics = list(
		", SR.",
		", IA.",
		", Liaison",
		", Negotiator",
	)
	honorific_positions = HONORIFIC_POSITION_LAST_FULL | HONORIFIC_POSITION_NONE
