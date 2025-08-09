/datum/language/draconic
	name = "Khaishhs"
	desc = "Often mispronounced as \"Heesh\" by offworlders and non-lizardfolk, The language can date its origins to Tiziran Pre-History where its abundant use of hisses, rattles, glottal sounds and other harsh consonants made it easily understood at greater distances and the extensive cave systems below the surface of Tizira. Though there are as many dialects as there are Clans, the more common \"Imperial Khaishhs\" was created by Clan Talunan as an effort to unite the people under their rule, and is what used in any and all official dealings with their government. The language itself has gained a bit of infamy in how uncomfortable it is to speak after any extended period for those whom do not use it on a daily basis, or whose biology is non-conducive to the vocals required to properly speak it. "
	key = "o"
	flags = TONGUELESS_SPEECH
	space_chance = 12
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 3
	syllables = list(
		"za", "az", "ze", "ez", "zi", "iz", "zo", "oz", "zu", "uz", "zs", "sz",
		"ha", "ah", "he", "eh", "hi", "ih", "ho", "oh", "hu", "uh", "hs", "sh",
		"la", "al", "le", "el", "li", "il", "lo", "ol", "lu", "ul", "ls", "sl",
		"ka", "ak", "ke", "ek", "ki", "ik", "ko", "ok", "ku", "uk", "ks", "sk",
		"sa", "as", "se", "es", "si", "is", "so", "os", "su", "us", "ss", "ss",
		"ra", "ar", "re", "er", "ri", "ir", "ro", "or", "ru", "ur", "rs", "sr",
		"a",  "a",  "e",  "e",  "i",  "i",  "o",  "o",  "u",  "u",  "s",  "s"
	)
	special_characters = list("-")
	icon_state = "lizard"
	default_priority = 90
	default_name_syllable_min = 3
	default_name_syllable_max = 5
	random_name_spacer = "-"

/datum/language/draconic/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(force_use_syllables)
		return ..()
	if(gender != MALE && gender != FEMALE)
		gender = pick(MALE, FEMALE)

	if(gender == MALE)
		return "[pick(GLOB.lizard_names_male)][random_name_spacer][pick(GLOB.lizard_names_male)]"
	return "[pick(GLOB.lizard_names_female)][random_name_spacer][pick(GLOB.lizard_names_female)]"
