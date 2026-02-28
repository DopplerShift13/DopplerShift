/obj/item/organ/tongue/get_possible_languages()
	var/list/langs = ..()
	langs += /datum/language/crusoeslocal
	langs += /datum/language/konjin
	langs += /datum/language/gutter
	langs += /datum/language/movespeak
	langs += /datum/language/carptongue
	langs += /datum/language/slime
	langs += /datum/language/primitive_genemod
	langs += /datum/language/nambuni
	return langs

/**
 * DOPPLER LANGUAGES
 * default_priority here is also used to pick what order these appear in the ingame language menu.
 * 100-90 - Common 4CA languages.
 * 89-70 - Common other languages.
 * 69-20 - Increasingly less common languages.
 * 19-0 - Exceptionally uncommon languages.
 */

/datum/language/konjin
	name = "Konjin"
	desc = "This language group formally regarded as Orbital Sino-Tibetan is a result of a genetic relationship between Chinese, Tibetan, \
	Burmese, and other Human languages of similar characteristics that was first proposed in the early 19th century and is extremely popular even in the space age. \
	Originating from Asia, this group of tongues is the second most spoken by Human and Human-derived populations since contact with the 4CA. \
	Many loanwords, idioms, and cultural relics of Japanese, Ryukyuan, Korean, and other societies have managed to persist within it, especially in the daily lives of speakers coming from Martian cities."
	key = "Y"
	flags = TONGUELESS_SPEECH
	space_chance = 70
	// Entirely Chinese save for the isolated 2 "nya" style syllables. I don't want to bloat the syllable list with other mixes, but they generally sound somewhat alike.
	syllables = list (
		"ai", "ang", "bai", "beng", "bian", "biao", "bie", "bing", "cai", "can", "cao", "cei", "ceng", "chai", "chan", "chang",
		"chen", "chi", "chong", "chou", "chu", "chuai", "chuang", "chui", "chun", "dai", "dao", "dang", "deng", "diao", "dong", "duan",
		"fain", "fang", "feng", "fou", "gai", "gang", "gao", "gong", "guai", "guang", "hai", "han", "hang", "hao", "heng", "huai", "ji", "jiang",
		"jiao", "jin", "jun", "kai", "kang", "kong", "kuang", "lang", "lao", "liang", "ling", "long", "luan", "mao", "meng", "mian", "miao",
		"ming", "miu", "nyai", "nang", "nao", "neng", "nyang", "nuan", "qi", "qiang", "qiao", "quan", "qing", "sen", "shang", "shao", "shuan", "song", "tai",
		"tang", "tian", "tiao", "tong", "tuan", "wai", "wang", "wei", "weng", "xi", "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu", "xuan", "xue", "yan", "yang",
		"yao", "yin", "ying", "yong", "yuan", "zang", "zao", "zeng", "zhai", "zhang",
		"zhen", "zhi", "zhuai", "zhui", "zou", "zun", "zuo"
	)
	icon_state = "hanzi"
	icon = 'modular_doppler/languages/icons/language.dmi'
	default_name_syllable_min = 1
	default_name_syllable_max = 2
	default_priority = 79
	mutual_understanding = list(
		/datum/language/crusoeslocal = 10,
		/datum/language/common = 10,
	)

/datum/language/gutter
	name = "Plutonian"
	desc = "Plutonian Franco-Castilian is a constructed Romance language that was developed early on in the Sol system's colonization history out of a desire for less externally readable communications by its first Plutonian colonists. \
	It heavily borrows from Spanish and French, with minor influence from other tongues the likes of Italian and Portuguese, despite coming off as elegant it carries a heavy amount of slang and idioms correlated to certain criminal groups. \
	Today, it stands heavily engrained in the planet's culture - and almost every citizen will speak at least some of it on top of Celestial."
	key = "G"
	flags = TONGUELESS_SPEECH
	syllables = list (
		"bai", "cai", "jai", "quai", "vai", "dei", "lei", "quei", "sei", "noi", "quoi", "voi", "beu", "queu", "seu", "gan", "zan", "quan", "len", "ten",
		"ba", "be", "bi", "bo", "bu", "ca", "ce", "ci", "co", "cu", "da", "de", "di", "do", "du", "fa", "fe", "fi", "fo", "fu", "ga", "gue", "gui", "go",
		"gu", "ña", "ñe", "ñi", "ño", "ñu", "que", "qui", "cha", "che", "chi", "cho", "chu", "lla", "lle", "lli", "llo", "llu",
		"tá", "vé", "sál", "fáb", "l'e", "seu", "deu", "meu", "vai", "ción", "tá"
	)
	icon_state = "gutter"
	icon = 'modular_doppler/languages/icons/language.dmi'
	default_priority = 78

/datum/language/movespeak
	name = "Move-Speak"
	desc = "A primarily nonverbal language comprised of body movements, gesticulation, and sign language, with only intermittent warbles & other vocalizations. \
	It's almost completely incomprehensible without its somatic components."
	key = "M"
	flags = TONGUELESS_SPEECH
	space_chance = 30
	syllables = list(
		"wa", "wawa", "awa", "a"
	)
	icon = 'modular_doppler/languages/icons/language.dmi'
	icon_state = "movespeak"
	default_priority = 68

	default_name_syllable_min = 5
	default_name_syllable_max = 10

/datum/language/movespeak/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(force_use_syllables)
		return ..()

	return "The [pick(GLOB.ramatan_last)]"

/datum/language/nambuni
	name = "Nambūni"
	desc = "Nambūni is the language spoken by most Nambūlites and by extension Deep Spacers. \
	It has no known origin, though it superficially resembles some Austronesian and Khoisan languages in grammatical and phonetic structure despite predating human spaceflight. \
	There are countless dialects, pidgins, and creoles spread throughout the thousands of micronations that compose the greater Nambūni Assembly, making the language a difficult one to master. \
	As it is the official language of the Assembly, it is mandated that all prayer, diplomacy, and trade must be conducted in Nambūni, thus learning the language is one of the greatest hurdles outsider merchants face."
	key = "N"
	flags = TONGUELESS_SPEECH
	space_chance = 30
	syllables = list (
		"se", "tiap", "ora", "nga", "nge", "ngi", "ngo", "ngū", "ang", "eng", "ing", "ong", "ung", "ach",
		"ech", "ich", "och", "uch", "ych", "basei", "gehi", "nam", "nem", "nim", "nom", "nūm", "da", "de", "di",
		"do", "du", "harū", "heru", "horo", "lua", "lūi", "luo", "ikan", "iken", "ikun", "lah", "luh", "leh",
		"lih", "loh", "pan", "pen", "pon", "pun", "panam", "penam", "pinam", "ponam", "pūnam", "bang", "beng",
		"yang", "yeng", "yong", "yung", "apat", "apet", "apot", "pat", "pet", "pot", "gaan", "geen", "giin", "goon",
		"guun", "yai", "yei", "yūi", "hara", "hera", "hira", "hora", "hura", "hak", "hek", "hik", "hok", "huk",
		"sai", "sei", "sui", "basei", "gehinnam", "mbūn", "mben", "mbon", "mbin", "mbem", "pakan", "pekan", "pak",
		"pek", "puk"
	)
	special_characters = list("'", "-")
	icon_state = "nambu"
	icon = 'modular_doppler/languages/icons/language.dmi'
	additional_syllable_low = 1
	additional_syllable_high = 3
	default_name_syllable_min = 2
	default_name_syllable_max = 3
	default_priority = 88
	mutual_understanding = list( // TODO: make this account for most cultural languages.
		/datum/language/crusoeslocal = 10,
	)

/datum/language/crusoeslocal
	name = "Crusoe's Locals' Pidgins"
	desc = "A collection of unstable pidgin languages originating at the forefront of the frontier, here in Crusoe's Rest. \
	Informal and simplified, it's what you'd hear yelled loudly between colonists in the New Gibraltar markets. \
	A language stone soup, slowly congealing."
	secret = TRUE // Special language unavailable outside of its quirk.

	icon = 'modular_doppler/languages/icons/language.dmi'
	icon_state = "new_gibby"

	key = "C"
	default_priority = 90

	// We randomize these all based on mutual_understanding languages when initializing language prototypes
	syllables = list(
		"a", "b", "c",
	)
	space_chance = 60
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 0
	// Except for this one.
	special_characters = list("'", "-")

	// We get to have a whole bunch of these due to being THE Crusoe's Rest contact language.
	mutual_understanding = list(
		/datum/language/sylvan = 80,
		/datum/language/common = 60,
		/datum/language/uncommon = 60,
		/datum/language/draconic = 40,
		/datum/language/konjin = 20,
		/datum/language/moffic = 20,
		/datum/language/nambuni = 10,
	)


/**
 * LANGUAGE OVERRIDES
 */

/datum/language/common
	name = "Celestial"
	desc = "Celestial, one of the common languages of habitual spacefarers and colonists alike under the 4CA as it stands today. \
	Originally constructed by the 3CA as a set of consistent protocols shared between species intended to aid in charting space, \
	the language as it is known today is a creole resulting from 3CA Celestial intertwining and forming pidgins with the various languages of contacted species."
	space_chance = 60
	// Is mostly syllables from other languages.
	syllables = list(
		"ce", "le", "est", "ial",
		// Borrowed from Helresa
		"e",
		"al", "el", "af", "ef", "as", "es",
		"eol", "eul",
		"be", "re", "ke", "ca", "la", "sa",
		"het", "hel", "lak", "rek", "ret", "kes",
		"drak", "drek", "dret",
		"ath", "eth", "ekh", "skh",
		"cala", "kesa", "resa",
		// And Helrekesha
		"beskh", "shekk", "sha",
		// Borrowed from Hillosk
		"fii", "sii", "rii", "rel",
		"hil", "losk",
		// Borrowed from Nomadic
		"i", "vii", "vuo", "eil", "tun", "gå", "det", "att", "ok",
		// Borrowed from Konjin
		"qi", "lao", "gao", "cai", "zun", "xuan", "ai", "feng",
		// Borrowed from Plutonian
		"l'e", // You get One. The One. Use it well.
		// Mixed syllables
		"arf", "dråk", "xuån", "fek", "laosk",
	)
	special_characters = list("-")
	icon_state = "solcommon"
	icon = 'modular_doppler/languages/icons/language.dmi'
	// We get to have a whole bunch of these due to being a contact language.
	mutual_understanding = list(
		/datum/language/uncommon = 75,
		/datum/language/crusoeslocal = 60,
		/datum/language/sylvan = 30,
		/datum/language/moffic = 20,
		/datum/language/konjin = 10,
	)

/datum/language/uncommon
	name = "Helresa"
	desc = "A language family commonly spoken in the 4CA core sectors. \
	Known as 'Helrekesha' at the time of the 2CA and having been used as the foundation for 3CA Celestial, \
	modern Helresa still has a coherent historical throughline despite its age and consequent cultural intermingling."
	default_priority = 98
	syllables = list(
		// Modern Helresa
		"e",
		"al", "el", "af", "ef", "as", "es",
		"eol", "eul",
		"be", "re", "ke", "ca", "la", "sa",
		"het", "hel", "lak", "rek", "ret", "kes",
		"drak", "drek", "dret",
		"ath", "eth", "ekh", "skh",
		"cala", "kesa", "resa",
		// Archaic Helrekesha still present
		"ri", "ha", "ho", "do",
		"rie",
		"bhe", "dha", "dhe", "cso",
		"jha", "jaho", "jhe", "kha", "khe",
		"sha", "she", "feh", "fre",
		"mazz", "mezz", "mohk", "nett", "nott", "kott",
		"takh", "tash", "tesh", "tekh", "vesh", "vekh",
		"hesh", "zekh", "rakh",
		"beskh", "shekk",
		"khet", "ghes", "ghos",
		"ar",
		"aur", "arh",
		"osh", "okh", "esh",
		"iash", "iakh", "iokh", "lahk", "lekh",
		// These are borrowed from Hillosk
		"fii", "sii", "rii", "tol", "tok", "dia", "eres", "aere",
		"hil", "losk",
	)
	special_characters = list("-")
	mutual_understanding = list(
		/datum/language/common = 75,
		/datum/language/crusoeslocal = 60,
		/datum/language/sylvan = 50,
	)

/datum/language/sylvan
	name = "Hillosk Toksii"
	desc = "The language family also known as the 'Agricultural Commons', or 'Hillosk' for short, \
	its variations are most commonly spoken in agricultural-focused sectors of the 4CA. \
	Originating as a workers' pidgin on an early agricultural colony, it has since then solidified, \
	brought to use by their now-experts turning it to writing, then propagated between colonies by the movement thereof. \
	In the case of biology and ecology, most scientific names are written in an archaic form of this."
	default_priority = 99
	syllables = list(
		"fii", "sii", "rii", "rel", "maa", "ala", "san", "tol", "tok", "dia", "eres",
		"fal", "tis", "bis", "qel", "aras", "losk", "rasa", "eob", "hil", "tanl", "aere",
		"fer", "bal", "pii", "dala", "ban", "foe", "doa", "cii", "uis", "mel", "wex",
		"incas", "int", "elc", "ent", "aws", "qip", "nas", "vil", "jens", "dila", "fa",
		"la", "re", "do", "ji", "ae", "so", "qe", "ce", "na", "mo", "ha", "yu",
		// These are borrowed from Helresa
		"eul", "ekh", "skh",
		"kesa", "resa",
	)
	mutual_understanding = list(
		/datum/language/crusoeslocal = 80,
		/datum/language/uncommon = 50,
		/datum/language/common = 30,
	)

/datum/language/moffic
	name = "Nomadic"
	desc = "Spoken colloquially by the Veniri of Grand Nomad Fleet, the early iteration of Nomadic emerged when Fueljacks relied on their receptors for simple, \
	one-worded pheromones to communicate, and navigate the often fatal maintenance tunnels sprawled throughout the fleet. \
	The moths developed gesticulation through antennas and wings to convey deeper intent, with mandibles providing emotional context through clicks and trills. \
	After contact with the Fourth Celestial Alignment, non-lepidoteran speakers managed to achieve a similar effect from clicking their tongue to roof, \
	and steer the tone with the width of their mouth while using their limbs in place of antennas. \
	It is informally spoken, deploying many slangs and shorthands from Celestial. Has phonetic resemblance to Italian."
	default_priority = 87
	mutual_understanding = list(
		/datum/language/common = 20,
		/datum/language/crusoeslocal = 20,
	)

/datum/language/draconic
	name = "Khaishhs"
	desc = "Often mispronounced as \"Heesh\" by offworlders and non-lizardfolk, The language can date its origins to Tiziran Pre-History where its abundant use of hisses, \
	rattles, glottal sounds and other harsh consonants made it easily understood at greater distances and the extensive cave systems below the surface of Tizira. \
	Though there are as many dialects as there are Clans, the more common \"Imperial Khaishhs\" was created by Clan Talunan as an effort to unite the people under their rule, \
	and is what used in any and all official dealings with their government. \
	The language itself has gained a bit of infamy in how uncomfortable it is to speak after any extended period for those whom do not use it on a daily basis, \
	or whose biology is non-conducive to the vocals required to properly speak it. "
	default_priority = 89
	mutual_understanding = list(
		/datum/language/crusoeslocal = 40,
	)

/datum/language/voltaic
	name = "Voltaic"
	desc = "The 'staticky' manipulation of electrical discharge used for communication between Ethereals almost universally. \
	Too universal and natural to be named to them, the name 'Voltaic' was rather assigned by the NanoTrasen corporation post-contact."
	default_priority = 69

/datum/language/machine
	// Outside of synths/silicons who start with this selected, most people probably shouldn't. Low priority.
	default_priority = 19

/datum/language/carptongue
	name = "Carptongue"
	desc = "Not quite a full language, this is the various fishy vocalizations and gestures that space carp, sharks, and dragons use intuitively to communicate basic concepts. \
	Words for more complex concepts form with the presence of a dragon anchoring them, and subsequently wane with the weaker long-term memory of dragonless carp."
	// Niche tongue that probably shouldn't be spoken outside of carp genemodders.
	default_priority = 18

/datum/language/shadowtongue
	name = "Shadowtongue"
	desc = "TONGUE OF A REALITY PLANE OFFSET FIVE INCHES ABOVE YOURS; the language of Resonance and Magycks, spoken by sorcerers and reality-benders. \
	The language their olden books are oft written in."
	// You should probably not be speaking in this as your standard tongue.
	default_priority = 1
