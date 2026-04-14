/datum/uplink_item/implants/venezia_gene_kit
	name = "\"Necronom IV\" Covert Gene Kit"
	desc = "Non-lethal biological weaponry, unparalleled terrain manipulation and a formidable acid glands make these discrete tailored organs uniquely suited for kidnapping and escapes."
	item = /obj/item/storage/box/syndie_kit/venezia_covert_holder
	cost = 15
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS)

/datum/uplink_item/implants/self_defense_optics // homander
	name = "\"L'Ecarlate\" Self-Defense Optic Genemod"
	desc = "Developed as an exotic yet efficient self defense genemod, it enables optic organs to project energy blasts at will. Its development was halted due to it's side effects- a permanent, intense glow from the pupils, and hefty migraines."
	item = /obj/item/dnainjector/lasereyesmut/venezia
	cost = 11
	purchasable_from = ALL // if we ever run nukies i wanna see one with laser eyes dude

/datum/uplink_item/implants/implanted_energy_blades
	name = "Implanted Energy Blades"
	desc = "On testing-lease from the CI Weapons Institute: concealable high-energy melee weapons designed to slot into an arm."
	item = /obj/item/autosurgeon/imp_energy_blades
	cost = 12
