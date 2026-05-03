/// Global list for OOC channels
GLOBAL_LIST_EMPTY(ckey_to_anonymous)

/proc/generate_anonymous_key()
	return "[pick(GLOB.first_names)] [trim(pick(GLOB.last_names), 2)]."


/// SOOC
GLOBAL_VAR_INIT(SOOC_COLOR, "#6551FF")
GLOBAL_VAR_INIT(sooc_allowed, TRUE)	// used with admin verbs to disable sooc - not a config option
GLOBAL_LIST_INIT(sooc_job_lookup, list(
	JOB_CAPTAIN = TRUE,
	JOB_HEAD_OF_SECURITY = TRUE,
	JOB_WARDEN = TRUE,
	JOB_DETECTIVE = TRUE,
	JOB_SECURITY_OFFICER = TRUE,
	JOB_COMMAND_BODYGUARD = TRUE,
	))

/// AOOC
GLOBAL_VAR_INIT(AOOC_COLOR, "#ff5967")
GLOBAL_VAR_INIT(aooc_allowed, TRUE)

/// Backstage
GLOBAL_LIST_INIT(backstage_color, list(GLOB.AOOC_COLOR, GLOB.SOOC_COLOR))
GLOBAL_VAR_INIT(backstage_allowed, TRUE)
