/datum/round_event_control
	/// How chaotic is the event? Low chaos events will run automatically, anything above has to be voted for
	var/chaos_level = EVENT_CHAOS_DISABLED

/datum/round_event_control/veto
	typepath = /datum/round_event/veto
	name = "Veto"
	weight = 0

/datum/round_event/veto
	fakeable = FALSE
	processing = FALSE

/**
 * EVENT CHAOS DECLARES
 */

// LOW CHAOS EVENTS
/datum/round_event_control/anomaly
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/scrubber_overflow
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/stray_cargo
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/stray_cargo/syndicate
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/wisdomcow
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/wormholes
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/sentience
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/shuttle_catastrophe
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/shuttle_insurance
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/shuttle_loan
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/grey_tide
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/processor_overload
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/grid_check
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/ion_storm
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/market_crash
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/mass_hallucination
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/mice_migration
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/electrical_storm
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/bureaucratic_error
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/camera_failure
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/carp_migration
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/communications_blackout
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/obsessed
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/disease_outbreak
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/morph
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/vent_clog
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/radiation_leak
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/gravity_generator_blackout
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/space_dust
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/aurora_caelus
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/stray_meteor
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/bitrunning_glitch
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/fake_virus
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/brain_trauma
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/heart_attack
	chaos_level = EVENT_CHAOS_LOW

/datum/round_event_control/tram_malfunction
	chaos_level = EVENT_CHAOS_LOW

// MODERATE CHAOS PRESETS

/datum/round_event_control/spacevine
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/radiation_storm
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/portal_storm_syndicate
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/nightmare
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/meteor_wave/meaty
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/meteor_wave/threatening
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/meteor_wave
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/immovable_rod
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/fugitives
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/sandstorm
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/brand_intelligence
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/abductor
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/revenant
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/supermatter_surge
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/sappers
	chaos_level = EVENT_CHAOS_MED

/datum/round_event_control/anomaly/anomaly_vortex
	chaos_level = EVENT_CHAOS_MED

///////////////////////
// HIGH CHAOS EVENTS //
///////////////////////

/datum/round_event_control/slaughter
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/alien_infestation
	chaos_level = EVENT_CHAOS_HIGH
	min_players = 20

/datum/round_event_control/space_ninja
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/blob
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/pirates
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/space_dragon
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/earthquake
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/spider_infestation
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/wizard
	chaos_level = EVENT_CHAOS_HIGH

/datum/round_event_control/meteor_wave/catastrophic
	chaos_level = EVENT_CHAOS_HIGH
