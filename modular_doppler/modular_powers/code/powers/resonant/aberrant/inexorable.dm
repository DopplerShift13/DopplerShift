/*
	Grants /datum/mutation/inexorable. I don't personally enjoy handing out mutations as a power (it feels like it infringes on geneticist) but since its relatively popular as a quirk option from genemodded I figured giving it a home is still nice.
*/
/datum/power/aberrant/inexorable
	name = "Inexorable"
	desc = "You can keep fighting for several moments in critical condition: but your body will start rapidly damaging itself as vital parts of it begin failing. Grants the Inexorable mutation."
	security_record_text = "Subject can keep fighting even as they enter critical condition."
	security_threat = POWER_THREAT_MAJOR
	value = 5
	power_flags = POWER_HUMAN_ONLY
	required_powers = list(/datum/power/aberrant_root/monstrous)
	magic_flags = NONE // non-magical

	menu_icon = 'icons/mob/actions/actions_changeling.dmi'
	menu_icon_state = "fake_death"

/datum/power/aberrant/inexorable/add(client/client_source)
	. = ..()
	if(!ishuman(power_holder))
		return
	var/mob/living/carbon/human/human_holder = power_holder
	human_holder.dna.add_mutation(/datum/mutation/inexorable, src)

/datum/power/aberrant/inexorable/remove()
	. = ..()
	if(!ishuman(power_holder))
		return
	var/mob/living/carbon/human_holder = power_holder
	human_holder.dna.remove_mutation(/datum/mutation/inexorable, src)
