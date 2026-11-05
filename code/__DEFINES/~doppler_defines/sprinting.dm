/// The maximum amount of sprint energy a mob can store.
#define SPRINT_ENERGY_MAXIMUM 100
/// The minimum amount of sprint energy a mob can store.
#define SPRINT_ENERGY_MINIMUM 0
/// The stamina damage taken for each sprint-energy point that cannot be paid.
#define SPRINT_STAMINA_DRAIN_PER_ENERGY 0.5
/// The sprint energy changed for each point of stamina adjustment.
#define SPRINT_ENERGY_PER_STAMINA_DAMAGE 2
/// The fraction by which each athletics level above None reduces sprint energy drain.
#define SPRINT_ATHLETICS_ENERGY_DRAIN_REDUCTION_PER_LEVEL 0.05
/// The run slowdown at zero momentum, based on the configured walk and run delays.
#define SPRINT_RUN_PENALTY (CONFIG_GET(number/movedelay/walk_delay) - CONFIG_GET(number/movedelay/run_delay))
/// The run-speed bonus granted at full momentum.
#define SPRINT_MOMENTUM_BONUS 0.5

/// The maximum amount of movement momentum a mob can store.
#define SPRINT_MOMENTUM_MAXIMUM 100
/// The minimum amount of movement momentum a mob can store.
#define SPRINT_MOMENTUM_MINIMUM 0
/// The minimum stamina damage required to affect momentum.
#define SPRINT_MOMENTUM_STAMINA_DAMAGE_MIN 10
/// The momentum lost for each point of qualifying stamina damage.
#define SPRINT_MOMENTUM_DAMAGE_PER_STAMINA_DAMAGE 5

/// The pixel height of the visible momentum bar.
#define SPRINT_MOMENTUM_BAR_HEIGHT 30

/// Fired before a sprinting mob loses momentum from changing direction. Arguments: (mob/living/carbon/human/sprinter, turn_angle, list/turn_loss_modifiers)
#define COMSIG_SPRINTING_TURNED "sprinting_turned"
/// Fired before sprint momentum is adjusted. Arguments: (mob/living/carbon/human/sprinter, amount, list/change_modifiers)
#define COMSIG_SPRINTING_MOMENTUM_CHANGE "sprinting_momentum_change"
/// Fired before sprint energy is adjusted. Arguments: (mob/living/carbon/human/sprinter, amount, list/energy_drain_modifiers)
#define COMSIG_SPRINTING_ENERGY_CHANGE "sprinting_energy_change"
/// Fired before energy is drained for sprinting movement. Arguments: (mob/living/carbon/human/sprinter, energy_drain, list/energy_drain_modifiers)
#define COMSIG_SPRINTING_ENERGY_DRAIN "sprinting_energy_drain"
/// Fired before the full-momentum speed bonus is scaled by momentum. Arguments: (mob/living/carbon/human/sprinter, list/speed_bonus_modifiers)
#define COMSIG_SPRINTING_SPEED_BONUS "sprinting_speed_bonus"
