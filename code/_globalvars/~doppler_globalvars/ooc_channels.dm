/// SOOC
#define SOOC_COLOR "#6551FF"
GLOBAL_VAR_INIT(sooc_allowed, TRUE)	// used with admin verbs to disable sooc - not a config option
GLOBAL_LIST_INIT(sooc_job_lookup, list(
	JOB_CAPTAIN = TRUE,
	JOB_AI = TRUE,
	JOB_HEAD_OF_SECURITY = TRUE,
	JOB_WARDEN = TRUE,
	JOB_DETECTIVE = TRUE,
	JOB_SECURITY_OFFICER = TRUE,
	JOB_COMMAND_BODYGUARD = TRUE,
	))

/// AOOC
#define AOOC_COLOR "#ff5967"
GLOBAL_VAR_INIT(aooc_allowed, TRUE)

/// Backstage
GLOBAL_VAR_INIT(backstage_allowed, TRUE)
