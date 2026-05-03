/*
	Lets you do KRAV MAGA.
	I am aware of the controversy with the name; but as long as it is called krav maga in the code I am going to refer to it as such in the code.
	You are free to edit it once we get an in-setting name.
*/
/datum/power/warfighter/krav_maga
	name = "Krav Maga"
	desc = "Trained in various disarming moves, you can wield the martial arts of Krav Maga without any external assistance."
	security_record_text = "Subject can wield Krav Maga in unarmed combat."
	security_threat = POWER_THREAT_MAJOR
	value = 10
	required_powers = list(/datum/power/warfighter/martial_artist)
	/// Uniquely, martial arts components are stored in the minds. Most powers are stored per mob, so this is a bit of an odd case.
	var/datum/component/mindbound_martial_arts/krav_component

/datum/power/warfighter/krav_maga/add()
	if(!power_holder?.mind)
		return
	krav_component = power_holder.mind.AddComponent(/datum/component/mindbound_martial_arts, /datum/martial_art/krav_maga)

/datum/power/warfighter/krav_maga/remove()
	if(krav_component)
		qdel(krav_component)
		krav_component = null
