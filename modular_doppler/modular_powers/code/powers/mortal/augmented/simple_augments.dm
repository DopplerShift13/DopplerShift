/* A lot of these augments are very simple; rather than making a new .dm file for each we just put them all here.*/

/*
ARMS
*/

/datum/power/augmented/razor_claws
	name = "Razor Claws"
	desc = "Grants razor-sharp claws in your arms, which can be extended and retracted at will. \
	Can also be used as wirecutters."

	value = 2
	augment = /obj/item/organ/cyberimp/arm/toolkit/razor_claws

/datum/power/augmented/botany_toolkit
	name = "Hydroponics Toolset Implant"
	desc = "A rather simple arm implant containing tools used in gardening and botanical research."

	value = 3
	augment = /obj/item/organ/cyberimp/arm/toolkit/botany

/datum/power/augmented/sanitation_toolkit
	name = "Sanitation Toolset Implant"
	desc = "A set of janitorial tools on the user's arm."

	value = 3
	augment = /obj/item/organ/cyberimp/arm/toolkit/janitor

/datum/power/augmented/surgery_toolkit
	name = "Surgical Toolset Implant"
	desc = "A set of surgical tools hidden behind a concealed panel on the user's arm."

	value = 5
	augment = /obj/item/organ/cyberimp/arm/toolkit/surgery

/datum/power/augmented/toolset_toolkit
	name = "Integrated Toolset Implant"
	desc = "A stripped-down version of the engineering cyborg toolset, designed to be installed on subject's arm. Contain advanced versions of every tool."

	value = 9
	augment = /obj/item/organ/cyberimp/arm/toolkit/toolset

/datum/power/augmented/drill_arm
	name = "Integrated Drill Implant"
	desc = "Extending from a stabilization bracer built into the upper forearm, this implant allows for a steel mining drill to extend over the user's hand."

	value = 4
	augment = /obj/item/organ/cyberimp/arm/toolkit/mining_drill

/* I'm not including this one baseline because its just too fkn stron for unarmed stacking.
/datum/power/augmented/strong_arm
	name = "Strong Arm Implant"
	desc = "When implanted, this cybernetic implant will enhance the muscles of the arm to deliver more power-per-action. Install one in each arm \
		to pry open doors with your bare hands!"

	value = 10 // door forcing + unarmed stacking with cultivator make this a potential balance hazard.
	augment = /obj/item/organ/cyberimp/arm/strongarm*/

/*
CHEST
The game sometimes calls this spine.
*/
/datum/power/augmented/spinal_implant
	name = "Herculean Gravitronic Spinal Implant"
	desc = "This gravitronic spinal interface is able to improve the athletics of a user, allowing them greater physical ability. \
		Contains a slot which can be upgraded with a gravity anomaly core, improving its performance."

	value = 3
	augment = /obj/item/organ/cyberimp/chest/spine

/datum/power/augmented/nutriment_pump
	name = "Nutriment Pump Implant"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of nutriment when you are starving."

	value = 3
	augment = /obj/item/organ/cyberimp/chest/nutriment
/*
EYE HUDS.
Keep in mind these are HUDS. Not actual eye replacements.
*/

/datum/power/augmented/med_hud
	name = "Medical HUD Implant"
	desc = "These cybernetic eye implants will display a medical HUD over everything you see."

	value = 4
	augment = /obj/item/organ/cyberimp/eyes/hud/medical
	disable_if_prisoner = FALSE

/datum/power/augmented/diagnostic_hud
	name = "Diagnostic HUD Implant"
	desc = "These cybernetic eye implants will display a diagnostic HUD over everything you see."

	value = 2
	augment = /obj/item/organ/cyberimp/eyes/hud/diagnostic
	disable_if_prisoner = FALSE

/*
EYES.
Not to be confused with HUD eyes above.
*/

/datum/power/augmented/flashproof_eyes
	name = "Shielded Robotic Eyes"
	desc = "These reactive micro-shields will protect you from welders and flashes without obscuring your vision."

	value = 4
	augment = /obj/item/organ/eyes/robotic/shield
	disable_if_prisoner = FALSE // don't go ripping out a man's eyes.

/*
INTERNAL (basically anything that isnt standard slots)
*/

/datum/power/augmented/skillchip_connector
	name = "CNS Skillchip Connector Implant"
	desc = "This cybernetic adds a port to the back of your head, where you can remove or add skillchips at will."

	value = 2
	augment = /obj/item/organ/cyberimp/brain/connector
	disable_if_prisoner = FALSE
