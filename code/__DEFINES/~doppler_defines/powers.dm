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

// Trait for when you are unable to use resonant powers
#define TRAIT_RESONANCE_SILENCED "RESONANCE_SILENCED"

// Trait for when you are immune to resonant powers
#define TRAIT_ANTIRESONANCE "TRAIT_ANTIRESONANCE"

/**
 * SORCEROUS
 * All defines related to the sorcerous archetype.
 */

/// Trait held by all under the sorcerous archetype.
#define TRAIT_ARCHETYPE_SORCEROUS "archetype_sorcerous"

/**
 * SORCEROUS: THAUMATURGE
 * All defines related to the Thaumaturge powers.
 */

// How much mana you practically can cap out at.
#define THAUMATURGE_MAX_MANA 50

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

/**
 * SORCEROUS: THEOLOGIST
 * All defines related to the enigmatist powers.
 */

// How much root abilities should heal (max), if they heal.
#define THEOLOGIAN_ROOT_HEALING 30

// Healing equates to this much piety.
#define THEOLOGIAN_PIETY_HEALING_COEFFICIENT 0.2

// Maximum amount of Piety
#define THEOLOGIAN_PIETY_MAX 50

// Trait made as to prevent duplicate smites.
#define TRAIT_HAS_SMITING_STRIKE "has_smiting_strike"

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

/**
 * RESONANT: PSYKER
 * All defines related to the enigmatist powers.
 */

// Standard stress threshold value for the Psyker's organ.
#define PSYKER_STRESS_STANDARD_THRESHOLD 100

// Standard stress recovery per second before modifiers.
#define PSYKER_STRESS_RECOVERY 1.1

// How much meditate recovers.
#define PSYKER_STRESS_MEDITATION_POWER 10

// Standard stress for Psykers. This all goes off of the base organ being 100.
#define PSYKER_STRESS_TRIVIAL (PSYKER_STRESS_STANDARD_THRESHOLD / 100)
#define PSYKER_STRESS_MINOR (PSYKER_STRESS_STANDARD_THRESHOLD / 10)
#define PSYKER_STRESS_MODERATE (PSYKER_STRESS_STANDARD_THRESHOLD / 5)
#define PSYKER_STRESS_MAJOR (PSYKER_STRESS_STANDARD_THRESHOLD / 2)
#define PSYKER_STRESS_CRUSHING (PSYKER_STRESS_STANDARD_THRESHOLD)

// Psyker event tiers.
#define PSYKER_EVENT_TIER_MILD 1
#define PSYKER_EVENT_TIER_SEVERE 2
#define PSYKER_EVENT_TIER_CATASTROPHIC 3

// Psyker event rarities
#define PSYKER_EVENT_RARITY_COMMON 100
#define PSYKER_EVENT_RARITY_UNCOMMON 50
#define PSYKER_EVENT_RARITY_RARE 25
#define PSYKER_EVENT_RARITY_VERYRARE 10

// Standard messages for Psyker Events
#define PSYKER_EVENT_CATASTROPHIC_STANDARD_MESSAGE "<b>As you strain your psychic powers past the breaking point, you are suddenly hit with a strange sense of clarity; as well as a feeling that something is very wrong.</b>"
