
/// Limping Quirk Side
GLOBAL_LIST_INIT(side_choice_limping, list(
	"Left Side" = LIMPING_SIDE_LEFT,
	"Right Side" = LIMPING_SIDE_RIGHT,
	"Both" = LIMPING_SIDE_BOTH,
))

/// Limping Quirk Severity
GLOBAL_LIST_INIT(severity_choice_limping, list(
	"Moderate" = list(LIMPING_SLOWDOWN = 3, LIMPING_CHANCE = 50),
	"Severe" = list(LIMPING_SLOWDOWN = 6, LIMPING_CHANCE = 60),
	"Critical" = list(LIMPING_SLOWDOWN = 7, LIMPING_CHANCE = 70),
))
