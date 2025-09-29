#define SLIME_ACTIONS_ICON_FILE 'modular_nova/master_files/icons/mob/actions/actions_slime.dmi'
/// This is the level of waterstacks that start doing noteworthy bloodloss to a slimeperson.
#define WATER_STACKS_DAMAGING 5
/// This is the level of waterstacks that prevent a slimeperson from regenerating, doing minimal bloodloss in the process.
#define WATER_STACKS_NO_REGEN 1

/datum/species/jelly
	hair_alpha = 160 //a notch brighter so it blends better.
	facial_hair_alpha = 160
	mutantliver = /obj/item/organ/liver/slime
	mutantstomach = /obj/item/organ/stomach/slime
	mutantbrain = /obj/item/organ/brain/slime
	mutantears = /obj/item/organ/ears/jelly
	hair_color_mode = null
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_TOXINLOVER,
		TRAIT_EASYDISMEMBER,
		TRAIT_WET_FOR_LONGER,
	)
	/// Ability to allow them to shapeshift their body around.
	var/datum/action/innate/alter_form/alter_form
	/// Ability to allow them to clean themselves and their stuff.
	var/datum/action/cooldown/slime_washing/slime_washing
	/// Ability to allow them to turn their core's GPS on or off.
	var/datum/action/innate/core_signal/core_signal

	digitigrade_customization = DIGITIGRADE_OPTIONAL
	digi_leg_overrides = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade,
	)

/datum/species/jelly/on_species_gain(mob/living/carbon/new_jellyperson, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(ishuman(new_jellyperson))
		slime_washing = new
		slime_washing.Grant(new_jellyperson)
		core_signal = new
		core_signal.Grant(new_jellyperson)

/datum/species/jelly/on_species_loss(mob/living/carbon/former_jellyperson, datum/species/new_species, pref_load)
	. = ..()
	QDEL_NULL(slime_washing)
	QDEL_NULL(core_signal)

/obj/item/organ/eyes/jelly
	name = "photosensitive eyespots"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/eyes/roundstartslime
	name = "photosensitive eyespots"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/ears/jelly
	name = "core audiosomes"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/tongue/jelly
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/lungs/slime
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/liver/slime
	name = "endoplasmic reticulum"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/stomach/slime
	name = "golgi apparatus"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_UNREMOVABLE

/obj/item/organ/brain/slime
	name = "slime core"
	desc = "The central core of a slimeperson, technically their 'extract', and where the cytoplasm, membrane, and organelles come from. Cutting edge research in xenobiology suggests this could also be a mitochondria."
	icon = 'modular_doppler/modular_species/species_types/slimes/icons/slimecore.dmi'
	icon_state = "slime_core"
	zone = BODY_ZONE_CHEST
	/// This is the VFX for what happens when they melt and die.
	var/obj/effect/death_melt_type = /obj/effect/temp_visual/wizard/out
	/// Color of the slimeperson's 'core' brain, defaults to white.
	var/core_color = COLOR_WHITE
	/// This tracks whether their core has been ejected or not after they die.
	var/core_ejected = FALSE
	/// This tracks whether their GPS microchip is enabled or not, only becomes TRUE on activation of the below ability /datum/action/innate/core_signal.
	var/gps_active = FALSE
	throw_range = 9 //Oh! That's a baseball!
	throw_speed = 0.5
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | LAVA_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/item/organ/brain/slime/Initialize(mapload, mob/living/carbon/organ_owner, list/examine_list)
	. = ..()
	colorize()

/obj/item/organ/brain/slime/examine()
	. = ..()
	if(gps_active)
		. += span_notice("A dim light lowly pulsates from the center of the core, indicating an outgoing signal from a tracking microchip.")
		. += span_red("You could probably snuff that out.")
	. += span_hypnophrase("You remember that pouring plasma on it, if it's non-embodied, would make it regrow one.")

/obj/item/organ/brain/slime/attack_self(mob/living/user) // Allows a player (presumably an antag) to deactivate the GPS signal on a slime core
	if(!(gps_active))
		return
	user.visible_message(span_warning("[user] begins jamming [user.p_their()] hand into a slime core! Slime goes everywhere!"),
	span_notice("You jam your hand into the core, feeling for the densest point! Your arm is covered in slime!"),
	span_notice("You hear an obscene squelching sound.")
	)
	playsound(user, 'sound/items/handling/surgery/organ1.ogg', 80, TRUE)

	if(!do_after(user, 30 SECONDS, src))
		user.visible_message(span_warning("[user]'s hand slips out of the core before [user.p_they()] can cause any harm!'"),
		span_warning("Your hand slips out of the goopy core before you can find its densest point."),
		span_notice("You hear a resounding plop.")
		)
		return

	user.visible_message(span_warning("[user] crunches something deep in the slime core! It gradually stops glowing..."),
	span_notice("You find the densest point, crushing it in your palm. The blinking light in the core slowly dissipates."),
	span_notice("You hear a wet crunching sound."))
	playsound(user, 'sound/effects/wounds/crackandbleed.ogg', 80, TRUE)
	gps_active = FALSE
	qdel(GetComponent(/datum/component/gps))

/obj/item/organ/brain/slime/on_mob_insert(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	colorize()
	core_ejected = FALSE
	RegisterSignal(organ_owner, COMSIG_LIVING_DEATH, PROC_REF(on_slime_death))

/obj/item/organ/brain/slime/on_mob_remove(mob/living/carbon/organ_owner)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_LIVING_DEATH)

/**
* Colors the slime's core (their brain) the same as their first mutant color.
*/
/obj/item/organ/brain/slime/proc/colorize()
	if(owner && isjellyperson(owner))
		core_color = owner.dna.features[FEATURE_MUTANT_COLOR]
		add_atom_colour(core_color, FIXED_COLOUR_PRIORITY)

/**
* Handling for tracking when the slime in question dies (except through gibbing), which then segues into the core ejection proc.
*/
/obj/item/organ/brain/slime/proc/on_slime_death(mob/living/victim, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(victim, COMSIG_LIVING_DEATH)

	if(gibbed)
		qdel(src)
		UnregisterSignal(victim, COMSIG_LIVING_DEATH)
		return

	addtimer(CALLBACK(src, PROC_REF(core_ejection), victim), 0) // explode them after the current proc chain ends, to avoid weirdness

/**
* CORE EJECTION PROC -
* Makes it so that when a slime dies, their core ejects and their body is qdel'd.
*/
/obj/item/organ/brain/slime/proc/core_ejection(mob/living/victim, new_stat, turf/loc_override)
	if(core_ejected)
		return
	core_ejected = TRUE
	victim.visible_message(span_warning("[victim]'s body completely dissolves, collapsing outwards!"), span_notice("Your body completely dissolves, collapsing outwards!"), span_notice("You hear liquid splattering."))
	var/atom/death_loc = victim.drop_location()
	victim.unequip_everything()
	if(victim.get_organ_slot(ORGAN_SLOT_BRAIN) == src)
		Remove(victim)
	if(death_loc)
		forceMove(death_loc)
	src.wash(CLEAN_WASH)
	new death_melt_type(death_loc, victim.dir)

	do_steam_effects(get_turf(victim))
	playsound(victim, 'sound/effects/blob/blobattack.ogg', 80, TRUE)

	if(gps_active) // adding the gps signal if they have activated the ability
		AddComponent(/datum/component/gps, "[victim]'s Core")

	qdel(victim)
	UnregisterSignal(victim, COMSIG_LIVING_DEATH)

/**
* Procs the ethereal jaunt liquid effect when the slime dissolves on death.
*/
/obj/item/organ/brain/slime/proc/do_steam_effects(turf/loc)
	var/datum/effect_system/steam_spread/steam = new()
	steam.set_up(10, FALSE, loc)
	steam.start()

/**
* CHECK FOR REPAIR SECTION
* Makes it so that when a slime's core has plasma poured on it, it builds a new body and moves the brain into it.
*/
/obj/item/organ/brain/slime/check_for_repair(obj/item/item, mob/user)
	if(!item.is_drainable() || item.reagents.get_reagent_amount(/datum/reagent/toxin/plasma) < 100)
		return FALSE
	user.visible_message(
		span_notice("[user] starts to slowly pour the contents of [item] onto [src]. It seems to bubble and roil, beginning to stretch its cytoskeleton outwards..."),
		span_notice("You start to slowly pour the contents of [item] onto [src]. It seems to bubble and roil, beginning to stretch its membrane outwards...")
	)
	brainmob?.notify_revival("You are being revived!", sound = null, source = src) // no sound since it's a whopping 60 second wait time after this
	if(!do_after(user, 60 SECONDS, src))
		to_chat(user, span_warning("You failed to pour the contents of [item] onto [src]!"))
		return TRUE

	user.visible_message(
		span_notice("[user] pours the contents of [item] onto [src], causing it to form a proper cytoplasm and outer membrane."),
		span_notice("You pour the contents of [item] onto [src], causing it to form a proper cytoplasm and outer membrane.")
	)
	item.reagents.clear_reagents() //removes the whole shit
	if(isnull(brainmob))
		balloon_alert(user, "brain is not a viable candidate for repair!")
		return TRUE

	brainmob.grab_ghost()
	if(isnull(brainmob.stored_dna))
		balloon_alert(user, "brain does not contain any dna!")
		return TRUE
	if(isnull(brainmob.client))
		balloon_alert(user, "brain does not contain a mind!")
		return TRUE
	regenerate()
	return TRUE

/obj/item/organ/brain/slime/proc/regenerate()
	//we have the plasma. we can rebuild them.
	set_organ_damage(-maxHealth) //fully heals the brain
	if(gps_active) // making sure the gps signal is removed if it's active on revival
		gps_active = FALSE
		qdel(GetComponent(/datum/component/gps))

	var/mob/living/carbon/human/new_body = new /mob/living/carbon/human(src.loc)

	brainmob.client?.prefs?.safe_transfer_prefs_to(new_body)
	new_body.underwear = "Nude"
	new_body.bra = "Nude"
	new_body.undershirt = "Nude" //Which undershirt the player wants
	new_body.socks = "Nude" //Which socks the player wants
	brainmob.stored_dna.copy_dna(new_body.dna, transfer_flags = COPY_DNA_SE|COPY_DNA_SPECIES)
	new_body.dna.features[FEATURE_MUTANT_COLOR] = new_body.dna.features[FEATURE_MUTANT_COLOR]
	new_body.dna.update_uf_block(/datum/dna_block/feature/mutant_color)
	new_body.real_name = new_body.dna.real_name
	new_body.name = new_body.dna.real_name
	new_body.updateappearance(mutcolor_update=1)
	new_body.domutcheck()
	new_body.forceMove(get_turf(src))
	new_body.blood_volume = BLOOD_VOLUME_SAFE+60
	SSquirks.AssignQuirks(new_body, brainmob.client)
	src.replace_into(new_body)
	for(var/obj/item/bodypart/bodypart as anything in new_body.bodyparts)
		if(!istype(bodypart, /obj/item/bodypart/chest))
			bodypart.drop_limb()
			continue
	new_body.visible_message(span_warning("[new_body]'s torso \"forms\" from [new_body.p_their()] core, yet to form the rest."))
	to_chat(owner, span_purple("Your torso fully forms out of your core, yet to form the rest."))
	return TRUE

// HEALING SECTION
// Handles passive healing and water damage.
/datum/species/jelly/spec_life(mob/living/carbon/human/slime, seconds_per_tick, times_fired)
	. = ..()
	if(slime.stat != CONSCIOUS)
		return

	var/healing = TRUE

	if(HAS_TRAIT(slime, TRAIT_IS_WET))
		slime.blood_volume -= 2 * seconds_per_tick
		healing = FALSE
		if(SPT_PROB(25, seconds_per_tick))
			slime.visible_message(span_danger("[slime]'s form begins to lose cohesion, seemingly diluting with the water!"), span_warning("The water starts to dilute your body, dry it off!"))

	if(slime.blood_volume >= BLOOD_VOLUME_NORMAL && healing)
		if(slime.stat != CONSCIOUS)
			return
		slime.heal_overall_damage(brute = 1.5 * seconds_per_tick, burn = 1.5 * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC)
		slime.adjustOxyLoss(-1 * seconds_per_tick)

/datum/species/jelly/roundstartslime
	name = "Xenobiological Slime Hybrid"
	id = SPECIES_SLIMESTART
	preview_outfit = /datum/outfit/slime_preview
	examine_limb_id = SPECIES_SLIMEPERSON
	coldmod = 3
	heatmod = 1
	specific_alpha = 155
	mutanteyes = /obj/item/organ/eyes/roundstartslime
	mutanttongue = /obj/item/organ/tongue/jelly

	bodypart_overrides = list( //Overriding jelly bodyparts
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/jelly/slime/roundstart,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/jelly/slime/roundstart,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/jelly/slime/roundstart,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/jelly/slime/roundstart,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/jelly/slime/roundstart,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/jelly/slime/roundstart,
	)

/datum/outfit/slime_preview
	name = "Slimeperson (Species Preview)"
	uniform = /obj/item/clothing/under/costume/bunnysuit
	head = /obj/item/clothing/head/costume/maid_headband

/datum/species/jelly/roundstartslime/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features[FEATURE_MUTANT_COLOR] = "#EF313F"
	human.dna.ear_type = BUNNY
	human.dna.features[FEATURE_EARS] = "Lop (Sexy)"
	human.dna.features["ears_colors"][1] = "#EF313F"
	human.dna.features["ears_colors"][2] = "#EF313F"
	human.dna.features["ears_colors"][3] = "#EF313F"
	human.hair_color = "#EF313F"
	human.hairstyle = "Slime Droplet"
	regenerate_organs(human, src, visual_only = TRUE)
	human.update_body(TRUE)

/datum/species/jelly/roundstartslime/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "scissors",
			SPECIES_PERK_NAME = "Headcase",
			SPECIES_PERK_DESC = "Given slimepeople have all their organs in their chest, and no neck to boot, they can be decapitated easily.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "circle",
			SPECIES_PERK_NAME = "Single-Celled Organism",
			SPECIES_PERK_DESC = "Slimes only have one discrete organ, their core. It comes pre-installed with a togglable microchip for ease in location; their other organelles are unremovable.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "notes-medical",
			SPECIES_PERK_NAME = "Regenerator",
			SPECIES_PERK_DESC = "Slimes, if they have a proper amount of jelly inside, are capable of regenerating damage and limbs. If they're exposed to plasma at a high jelly volume, they can regenerate wounds.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "droplet-slash",
			SPECIES_PERK_NAME = "Dissolution",
			SPECIES_PERK_DESC = "If slimes have their limbs chopped off, they disintegrate and cannot be recovered. If their body dies as a whole, it dissolves away from their core and requires 100u of liquid plasma to fix.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "hand-holding-droplet",
			SPECIES_PERK_NAME = "Washes Right Out",
			SPECIES_PERK_DESC = "Slimes are capable of cleaning themselves and their clothing, siphoning the dirt off it and into themselves; even off the floor, if they're barefoot. This gives them a mild amount of nutrition.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "person-swimming",
			SPECIES_PERK_NAME = "Major Hydrophobia",
			SPECIES_PERK_DESC = "Slimes dissolve when exposed to water under normal circumstances, water nuking their blood volume and stopping their ability to regenerate.",
		),
	)

	return to_add

/**
 * Toggle Death Signal simply adds and removes the trait required for slimepeople to transmit a GPS signal upon core ejection.
 */
/datum/action/innate/core_signal
	name = "Toggle Core Signal"
	desc = "Interface with the microchip placed in your core, modifying whether it emits a GPS signal or not. Due to how thick your liquid body is, the signal won't reach out until your core is outside of it."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'modular_doppler/modular_species/species_types/slimes/icons/slimecore.dmi'
	button_icon_state = "slime_core"
	background_icon_state = "bg_alien"
	/// Do you need to be a slime-person to use this ability?
	var/slime_restricted = TRUE

/datum/action/innate/core_signal/Activate()
	var/mob/living/carbon/human/slime = owner
	var/obj/item/organ/brain/slime/core = slime.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(slime_restricted && !isjellyperson(slime))
		return
	if(core.gps_active)
		to_chat(owner,span_notice("You tune out the electromagnetic signals from your core so they are ignored by GPS receivers upon its rejection."))
		core.gps_active = FALSE
	else
		to_chat(owner, span_notice("You fine-tune the electromagnetic signals from your core to be picked up by GPS receivers upon its rejection."))
		core.gps_active = TRUE

#undef SLIME_ACTIONS_ICON_FILE
#undef WATER_STACKS_DAMAGING
#undef WATER_STACKS_NO_REGEN
