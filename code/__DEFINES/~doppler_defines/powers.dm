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

// Trait for when you are immune to resonant powers that reveal any information about you.
#define TRAIT_ANTIRESONANCE_SCRYING "TRAIT_ANTIRESONANCE_SCRYING"

// How much anti resonant stuff should cost by default
#define ANTIRESONANCE_BASE_CHARGE_COST 1

// Listener for dispelling
#define COMSIG_ATOM_DISPEL "atom_dispel"

/// Fired after a successful unarmed hit (i.e. not missed/blocked), right before damage is applied.
/// Args: (mob/living/carbon/attacker, mob/living/carbon/target, obj/item/bodypart/affecting, damage, armor_block, limb_accuracy, limb_sharpness)
#define COMSIG_HUMAN_UNARMED_HIT "living_unarmed_hit"

// Bitflag return value(s) from handlers:
#define DISPEL_RESULT_DISPELLED (1<<0)

// Bitflags for how dispel should behave
#define DISPEL_CASCADE_CARRIED (1<<0)

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
#define THAUMATURGE_MAX_MANA (MAXIMUM_POWER_POINTS * THAUMATURGE_MANA_MULT )

// The factor with which we multiply our power points to get our mana.
#define THAUMATURGE_MANA_MULT 2

// How many spells of a type can you prepare max?
#define THAUMATURGE_MAX_CHARGES_BASE 6

// For refund abilities, how much refund chance does each level/degree add.
#define THAUMATURGE_REFUND_MULT_BASE 35
#define THAUMATURGE_REFUND_MULT_AFFINITY 5

// hard cap on refund powers.
#define THAUMATURGE_REFUND_MAX 75

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
#define THEOLOGIST_ROOT_HEALING 30

// Healing equates to this much piety.
#define THEOLOGIST_PIETY_HEALING_COEFFICIENT 0.2

// Maximum amount of Piety (chaplain gets double this amount)
#define THEOLOGIST_PIETY_MAX 50

// UI location of the Piety element
#define THEOLOGIST_UI_SCREEN_LOC "WEST,CENTER-2:15"

// In case the space is taken up by cultivator
#define THEOLOGIST_ALT_UI_SCREEN_LOC "WEST+1,CENTER-2:15"

// Trait made as to prevent duplicate smites.
#define TRAIT_HAS_SMITING_STRIKE "has_smiting_strike"

// Standard Theologian costs
#define THEOLOGIST_PIETY_TRIVIAL (CULTIVATOR_DANTIAN_MAX / 100)
#define THEOLOGIST_PIETY_MINOR (CULTIVATOR_DANTIAN_MAX / 10)
#define THEOLOGIST_PIETY_MODERATE (CULTIVATOR_DANTIAN_MAX / 5)
#define THEOLOGIST_PIETY_MAJOR (CULTIVATOR_DANTIAN_MAX / 2)
#define THEOLOGIST_PIETY_CRUSHING (CULTIVATOR_DANTIAN_MAX)

/**
 * RESONANT
 * All defines related to the resonant archetype.
 */

/// Trait held by all under the resonant archetype.
#define TRAIT_ARCHETYPE_RESONANT "archetype_resonant"

/**
 * RESONANT: CULTIVATOR
 * All defines related to the cultivator powers.
 */

// Maximum amount of Dantian we can have.
#define CULTIVATOR_DANTIAN_MAX 1000

// How much dantian we get from meditation every 2.5 seconds
#define CULTIVATOR_DANTIAN_MEDITATION_POWER 5

// UI location of the Cultivator element
#define CULTIVATOR_UI_SCREEN_LOC "WEST,CENTER-2:15"

// Bonus damage on strikes done while in alignment. Balancing notes: punches have a base 20% miss chance, and this does not stack with martial arts.
#define CULTIVATOR_ALIGNMENT_DAMAGE_BONUS 15

// The max amount of Dantian we give from aura farming per second
#define CULTIVATOR_MAX_CULTIVATION_BONUS 3
// The min amount of Dantian we give from aura farming per second
#define CULTIVATOR_MIN_CULTIVATION_BONUS 0

// How much does activating the alignment cost
#define CULTIVATOR_ALIGNMENT_ACTIVATION_COST 200

// How much does sustaining the alignment cost
#define CULTIVATOR_ALIGNMENT_UPKEEP_COST 3

// Standard Dantian cost defines for Cultivators.
#define CULTIVATOR_DANTIAN_TRIVIAL (CULTIVATOR_DANTIAN_MAX / 100)
#define CULTIVATOR_DANTIAN_MINOR (CULTIVATOR_DANTIAN_MAX / 10)
#define CULTIVATOR_DANTIAN_MODERATE (CULTIVATOR_DANTIAN_MAX / 5)
#define CULTIVATOR_DANTIAN_MAJOR (CULTIVATOR_DANTIAN_MAX / 2)
#define CULTIVATOR_DANTIAN_CRUSHING (CULTIVATOR_DANTIAN_MAX)

// Defines SPECIFICALLY for auro farming amounts
#define CULTIVATOR_AURA_FARM_TRIVIAL (CULTIVATOR_MAX_CULTIVATION_BONUS / 100)
#define CULTIVATOR_AURA_FARM_MINOR (CULTIVATOR_MAX_CULTIVATION_BONUS / 10)
#define CULTIVATOR_AURA_FARM_MODERATE (CULTIVATOR_MAX_CULTIVATION_BONUS / 5)
#define CULTIVATOR_AURA_FARM_MAJOR (CULTIVATOR_MAX_CULTIVATION_BONUS / 2)
#define CULTIVATOR_AURA_FARM_CRUSHING (CULTIVATOR_MAX_CULTIVATION_BONUS)

// Cultivator alignment activion/deactivation signals
#define COMSIG_CULTIVATOR_ALIGNMENT_ENABLED "cultivator_alignment_enabled"
#define COMSIG_CULTIVATOR_ALIGNMENT_DISABLED "cultivator_alignment_disabled"

// The trait for Astral Touched's flight upgrades (using AddElementTrait)
#define TRAIT_ASTRAL_TOUCHED_FLIGHT "astral_touched_flight"

/**
 * RESONANT: PSYKER
 * All defines related to the enigmatist powers.
 */

// Standard stress threshold value for the Psyker's organ.
#define PSYKER_STRESS_STANDARD_THRESHOLD 100

// Standard stress recovery per second before modifiers.
#define PSYKER_STRESS_RECOVERY 1

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
#define PSYKER_EVENT_CATASTROPHIC_STANDARD_MESSAGE "As you strain your psychic powers past the breaking point, you are suddenly hit with a strange sense of clarity; as well as a feeling that something is very wrong."

// The trait for Psyker's Levitate power.
#define TRAIT_PSYKER_LEVITATE_FLIGHT "psyker_levitate_flight"

/**MORTAL DEFINES
* I'm literally just using this to define Breacher Knuckle right now
* These things, they take time.
* edit: im also using this to def the mad dog style because it will not allow me to make a new file for melee defines
*/

#define MARTIALART_BREACHERKNUCKLE "breacher knuckle"
#define MARTIALART_MAD_DOG "the mag dog style"

/**
 * MORTAL: WARFIGHTER
 * All defines related to the augmented powers.
 */

// The amount to multiple the effects of all commander powers by.
#define WARFIGHTER_COMMANDER_BASE_MULT 1

// The multiplier bonus for sharing a department with the target as a commander
#define WARFIGHTER_COMMANDER_DEPARTMENT_BONUS 0.3

// The multiplier bonus for being a head of staff as a commander
#define WARFIGHTER_COMMANDER_HEAD_BONUS 0.3

// The global GCD for Warfigher powers
#define WARFIGHTER_COMMANDER_SHARED_COOLDOWN 2 SECONDS

// Trait for the Explosives Specialist power
#define TRAIT_POWER_EXPLOSIVES_SPECIALIST "power_explosives_specialist"

/**
 * MORTAL: Augmented
 * All defines related to the augmented powers.
 */

// Used for the prefs to shorthand tell there's nothing in the right or left arm augment slot.
#define AUGMENTED_NO_AUGMENT "None"
