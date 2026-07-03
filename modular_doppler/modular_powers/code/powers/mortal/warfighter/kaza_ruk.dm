/*
	Lets you do Kaza Ruk (formerly known as Krav Maga)
*/
/datum/power/warfighter/kaza_ruk
	name = "Kaza Ruk"
	desc = "Trained in various disarming moves, you can wield the martial arts of Krav Maga without any external assistance."
	security_record_text = "Subject can wield Kaza Ruk in unarmed combat."
	security_threat = POWER_THREAT_MAJOR
	value = 10
	required_powers = list(/datum/power/warfighter/martial_artist)
	/// Uniquely, martial arts components are stored in the minds. Most powers are stored per mob, so this is a bit of an odd case.
	var/datum/component/mindbound_martial_arts/krav_component

/datum/power/warfighter/kaza_ruk/add()
	if(!power_holder?.mind)
		return
	krav_component = power_holder.mind.AddComponent(/datum/component/mindbound_martial_arts, /datum/martial_art/krav_maga)

/datum/power/warfighter/kaza_ruk/remove()
	if(krav_component)
		qdel(krav_component)
		krav_component = null
