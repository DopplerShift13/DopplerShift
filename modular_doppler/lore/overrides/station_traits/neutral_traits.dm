/datum/station_trait/birthday
	report_message = "We here at the Port Authority would all like to wish Employee Name a very happy birthday"

/datum/station_trait/birthday/announce_birthday()
	report_message = "We here at the Port Authority would all like to wish [birthday_person ? birthday_person_name : "Employee Name"] a very happy birthday."
	priority_announce("Happy birthday to [birthday_person ? birthday_person_name : "Employee Name"]! The Port Authority wishes you a very happy [birthday_person ? thtotext(birthday_person.age + 1) : "255th"] birthday.")

/datum/station_trait/announcement_intern
	// 0 = disables the station trait
	weight = 0

/datum/station_trait/gmm_spotlight
	// 0 = disables the station trait
	weight = 0
