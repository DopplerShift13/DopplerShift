/**
 * POWERS
 * All defines related to the powers system
 */

/// Maximum amount of points a player can spend on their powers
#define MAXIMUM_POWER_POINTS 20

#define POWER_PRIORITY_ROOT "Root"
#define POWER_PRIORITY_BASIC "Basic"
#define POWER_PRIORITY_ADVANCED "Advanced"

#define POWER_ARCHETYPE_SORCEROUS "Sorcerous"
#define POWER_ARCHETYPE_RESONANT "Resonant"
#define POWER_ARCHETYPE_MORTAL "Mortal"

#define POWER_PATH_THAUMATURGE "Thaumaturge"
#define POWER_PATH_ENIGMATIST "Enigmatist"
#define POWER_PATH_THEOLOGIST "Theologist"
#define POWER_PATH_PSYKER "Psyker"
#define POWER_PATH_CULTIVATOR "Cultivator"
#define POWER_PATH_ABERRANT "Aberrant"
#define POWER_PATH_WARFIGHTER "Warfighter"
#define POWER_PATH_EXPERT "Expert"
#define POWER_PATH_AUGMENTED "Augmented"

/// Any traits granted by powers.
#define POWER_TRAIT "power_trait"

/// This power can only be applied to humans.
#define POWER_HUMAN_ONLY (1<<0)
/// This power processes on SSpowers (and should implement power process)
#define POWER_PROCESSES (1<<1)
/// This power is has a visual aspect in that it changes how the player looks. Used in generating dummies.
#define POWER_CHANGES_APPEARANCE (1<<2)

/**
 * SORCEROUS
 * All defines related to the sorcerous archetype.
 */

/// Trait held by all under the sorcerous archetype.
#define TRAIT_ARCHETYPE_SORCEROUS "archetype_sorcerous"

/**
 * SORCEROUS: ENIGMATIST
 * All defines related to the enigmatist powers.
 */

/// Standard value for how much damage enigmatist chalk can take.
#define ENIGMATIST_CHALK_STANDARD_INTEGRITY 100

// Standard damages an enigmatist spell can do.
#define ENIGMATIST_CHALK_TRIVIAL_DAMAGE (ENIGMATIST_CHALK_STANDARD_INTEGRITY / 100)
#define ENIGMATIST_CHALK_MINOR_DAMAGE (ENIGMATIST_CHALK_STANDARD_INTEGRITY / 10)
#define ENIGMATIST_CHALK_MODERATE_DAMAGE (ENIGMATIST_CHALK_STANDARD_INTEGRITY / 5)
#define ENIGMATIST_CHALK_MAJOR_DAMAGE (ENIGMATIST_CHALK_STANDARD_INTEGRITY / 2)
#define ENIGMATIST_CHALK_CRUSHING_DAMAGE (ENIGMATIST_CHALK_STANDARD_INTEGRITY)

/// From /obj/item/enigmatist_chalk/click_alt(...): (enigmatist_flags, list/spell_options)
#define COMSIG_ENIGMATIST_CHALK_SELECTION "enigmatist_chalk_selection"

// Bitflags for what type of chalk/power a given chalk/power is.
/// Basic resonant chalks/powers.
#define ENIGMATIST_RESONANT (1<<0)
/// Chalks/powers relating to unsealed lore.
#define ENIGMATIST_UNSEALED (1<<1)
/// Chalks/powers relating to illuminated lore.
#define ENIGMATIST_ILLUMINATED (1<<2)
/// Chalks/powers relating to divided lore.
#define ENIGMATIST_DIVIDED (1<<3)

/// Any Enigmatist lore whatsoever.
#define ENIGMATIST_ANY_ALL (ENIGMATIST_RESONANT|ENIGMATIST_UNSEALED|ENIGMATIST_ILLUMINATED|ENIGMATIST_DIVIDED)

/**MORTAL DEFINES
* I'm literally just using this to define Breacher Knuckle right now
* These things, they take time.
* edit: im also using this to def the mad dog style because it will not allow me to make a new file for melee defines
*/

#define MARTIALART_BREACHERKNUCKLE "breacher knuckle"
#define MARTIALART_MAD_DOG "the mag dog style"

/**
 * RESONANT
 * All defines related to the resonant archetype.
 */

/// Trait held by all under the resonant archetype.
#define TRAIT_ARCHETYPE_RESONANT "archetype_resonant"
