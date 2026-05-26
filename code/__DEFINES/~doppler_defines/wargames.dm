#define WARGAME_ACTIONS_FILE 'modular_doppler/wargaming/icons/actions.dmi'

/// Current game phase is placing units
#define WARGAME_PHASE_PLACEMENT 0
/// Current game phase is action
#define WARGAME_PHASE_ACTION 1
/// Current game phase is effects
#define WARGAME_PHASE_EFFECTS 2
/// Current game phase is nothing, the game is over or hasn't even started yet
#define WARGAME_PHASE_NOTHING 10

/// Something like a dust cloud that gives an evasion bonus but no cover
#define WARGAME_EVASION_BONUS 0
/// A small thing with zero cover value
#define WARGAME_SIZE_SMALL 1
/// A medium sized thing that small things can hide around
#define WARGAME_SIZE_MEDIUM 2
/// A large thing that even decent sized ships can hide around
#define WARGAME_SIZE_LARGE 3

/// The maximum amount of cover bonus a unit can have
#define WARGAME_MAX_COVER_BONUS 2
/// The maximum amount of evasion bonus a unit can have
#define WARGAME_MAX_EVASION_BONUS 2

/// Add a team to the base station
#define BASESTATION_ADD_TEAM "Add Team"
/// Remove a team from the base station
#define BASESTATION_REMOVE_TEAM "Remove Team"
/// Edit a team on the base station
#define BASESTATION_EDIT_TEAM "Edit Team"
/// Allows the user to join or leave a team
#define BASESTATION_JOIN_LEAVE "Join/Leave Team"
/// Reset the basestation, removing all teams and configuration
#define BASESTATION_RESET "Reset Configuration"
/// Start the game with all current base station settings
#define BASESTATION_START "Start Game"
/// Immediately stop the currently running game on the base station
#define BASESTATION_END "End Game"
/// End the current phase and advance to the next, changing to the next team's turn if applicable
#define BASESTATION_NEXT "Next Phase"

/// Change the name of the currently selected team
#define BASESTATION_TEAM_NAME "Team Name"
/// Change the color of the currently selected team
#define BASESTATION_TEAM_COLOR "Team Color"
/// Change a team's units address them
#define BASESTATION_TEAM_COMMANDER "Team Commander Response"
/// Change a team's name prefix for automatically generated ship names
#define BASESTATION_TEAM_PREFIX "Team Ship Prefix"

/// Opens a unit's movement options
#define WARGAME_UNIT_MOVE "Move"
/// Opens a unit's attack options
#define WARGAME_UNIT_ATTACK "Attack"
/// Opens a unit's special options
#define WARGAME_UNIT_SPECIAL "Special"

/// If the base station will go one team at a time until the effects phase
#define WARGAME_TURN_MODE_STANDARD "Sequential"
/// If the base station will let every team move at once before the effects phase
#define WARGAME_TURN_MODE_SIMULTANEOUS "Simultaneous"
