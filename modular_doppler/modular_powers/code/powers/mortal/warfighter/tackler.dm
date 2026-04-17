/*
	Grants the tackle subsystem and makes you better at tackling.
	Stats wise this is about the same strenght as the tackler gloves just with a +1 to the skill_mod
*/
/datum/power/warfighter/tackler
	name = "Tackler"
	desc = "You know how to throw a well-trained tackle. Allows you to perform tackles without assistive items and allows you to perform them better."
	security_record_text = "Subject is trained in using tackles for takedowns."
	security_threat = POWER_THREAT_MAJOR
	value = 4

	required_powers = list(/datum/power/warfighter/martial_artist)

	/// the datum that the tackle system is in
	var/datum/component/tackler

/datum/power/warfighter/tackler/add()
	// Taking these over from tackle gloves just for clarity. They're in here becuase I don't want to clog the upgrade vars with these + the component inherits these values so having them tweakable in vv doesnt make sense.
	/// See: [/datum/component/tackler/var/stamina_cost]
	var/tackle_stam_cost = 25
	/// See: [/datum/component/tackler/var/base_knockdown]
	var/base_knockdown = 1 SECONDS
	/// See: [/datum/component/tackler/var/range]
	var/tackle_range = 4
	/// See: [/datum/component/tackler/var/min_distance]
	var/min_distance = 0
	/// See: [/datum/component/tackler/var/speed]
	var/tackle_speed = 1
	/// See: [/datum/component/tackler/var/skill_mod]
	var/skill_mod = 2

	tackler = power_holder.AddComponent(/datum/component/tackler, stamina_cost=tackle_stam_cost, base_knockdown = base_knockdown, range = tackle_range, speed = tackle_speed, skill_mod = skill_mod, min_distance = min_distance)

/datum/power/warfighter/tackler/remove()
	power_holder.RemoveComponentSource(src, /datum/component/tackler)

