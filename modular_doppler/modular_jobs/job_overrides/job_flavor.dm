/**
 * === JOB DESCRIPTION OVERRIDES ===
 * This file includes all modular overrides for job descriptions.
 * Each sub-category has a description as to why.
 */


/**
 * SECURITY
 * There is no Space Law, there is no SOP.
 * The primary point of security is to mediate conflicts,
 * each of the different sub-roles have different priorities.
 * - Officers engage.
 * - Wardens hold the fort.
 * - Detectives investigate.
 */

/datum/job/warden
	description = "Watch over the Brig and Prison Wing, release prisoners when \
		their time is up, issue equipment to security, be a security officer when \
		they all eventually die."
	description = "Watch over the Brig, maintain the drunk tank. \
		Issue equipment, stop officers from raiding the armory unnecessarily, \
		and keep them accountable. Assist in mediating as needed."

/datum/job/security_officer
	// As (almost) straight from the wiki.
	description = "Mediate conflicts, try to prevent them from happening in the first place. \
		Come up with 'engaging' punishments. Help those that are in need. \
		Hold a karaoke night in the office. Break a leg, it doesn't have to be yours. \
		Follow orders from people that know better than you."

/datum/job/detective // TODO: make refer to officer, like an officer but with different priorities.
	description = "Investigate crimes, gather evidence, perform interrogations, \
		look badass, smoke cigarettes."
	description = "Investigate problems, gather evidence, find those responsible. \
		Look badass."
	description = "The investigative component of the officers. \
		Help find out the who, how, and why of things."

/datum/job/lawyer
	description = "Assist in mediating conflicts, negotiate for better outcomes. \
		Help parolees rehabilitate. \
		Keep records, hold Security and Command accountable."


/**
 * SILICONS
 * Cyborgs are each full people who aren't necessarily slaved to an AI.
 */

/datum/job/cyborg
	description = "Assist the crew, follow your laws, \
		coordinate with your AI."