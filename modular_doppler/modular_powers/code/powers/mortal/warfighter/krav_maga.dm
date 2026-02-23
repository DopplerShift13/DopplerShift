/*
	Lets you do KRAV MAGA.
*/
/datum/power/warfighter/krav_maga
	name = "Krav Maga"
	desc = "Trained in various disarming moves, you can wield the martial arts of Krav Maga without any external assistance.\
	(Powers that give you access to Martial Arts override your unarmed attacks and thusly do not stack with any modifier that affect your punches)"
	value = 8
	required_powers = list(/datum/power/warfighter/martial_artist)
	/// Mindbound martial art component so the style follows mind transfers
	var/datum/component/mindbound_martial_arts/krav_component

/datum/power/warfighter/krav_maga/add()
	if(!power_holder?.mind)
		return
	krav_component = power_holder.mind.AddComponent(/datum/component/mindbound_martial_arts, /datum/martial_art/krav_maga)

/datum/power/warfighter/krav_maga/remove()
	if(krav_component)
		qdel(krav_component)
		krav_component = null
