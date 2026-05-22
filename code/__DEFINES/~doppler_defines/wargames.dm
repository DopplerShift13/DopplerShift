/// Current game phase is placing units
#define WARGAME_PHASE_PLACEMENT 0
/// Current game phase is action
#define WARGAME_PHASE_ACTION 1
/// Current game phase is effects
#define WARGAME_PHASE_EFFECTS 2
/// Current game phase is nothing, the game is over or hasn't even started yet
#define WARGAME_PHASE_NOTHING 10

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
