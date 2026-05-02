/// SOOC
GLOBAL_VAR_INIT(SOOC_COLOR, "#ff5454")
GLOBAL_VAR_INIT(sooc_allowed, TRUE)	// used with admin verbs to disable sooc - not a config option
GLOBAL_LIST_EMPTY(ckey_to_sooc_name)
GLOBAL_LIST_INIT(sooc_job_lookup, list(
	JOB_CAPTAIN = TRUE,
	JOB_HEAD_OF_SECURITY = TRUE,
	JOB_WARDEN = TRUE,
	JOB_DETECTIVE = TRUE,
	JOB_SECURITY_OFFICER = TRUE,
	JOB_COMMAND_BODYGUARD = TRUE,
	))

/// AOOC
GLOBAL_VAR_INIT(AOOC_COLOR, "#de3c8c")
GLOBAL_VAR_INIT(aooc_allowed, TRUE)
GLOBAL_LIST_EMPTY(ckey_to_aooc_name)

/// Backstage
GLOBAL_LIST_INIT(backstage_color, list("#ff5967", "#6551FF"))
GLOBAL_VAR_INIT(backstage_allowed, TRUE)
GLOBAL_LIST_EMPTY(ckey_to_backstage_name)
