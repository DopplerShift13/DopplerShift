/// Maximum an Hemophage will drain, they will drain less if they hit their cap.
#define HEMOPHAGE_DRAIN_AMOUNT 50
/// The multiplier for blood received by Hemophages out of humans with ckeys.
#define BLOOD_DRAIN_MULTIPLIER_CKEY 1.15

/datum/component/organ_corruption/tongue
	corruptable_organ_type = /obj/item/organ/tongue
	corrupted_icon_state = "tongue"
	/// The item action given to the tongue once it was corrupted.
	var/tongue_action_type = /datum/action/cooldown/hemophage/drain_victim


/datum/component/organ_corruption/tongue/corrupt_organ(obj/item/organ/corruption_target)
	. = ..()

	if(!.)
		return

	var/obj/item/organ/tongue/corrupted_tongue = corruption_target
	corrupted_tongue.liked_foodtypes = BLOODY
	corrupted_tongue.disliked_foodtypes = NONE

	var/datum/action/tongue_action = corruption_target.add_item_action(tongue_action_type)

	if(corruption_target.owner)
		tongue_action.Grant(corruption_target.owner)


/datum/action/cooldown/hemophage/drain_victim
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."

/datum/action/cooldown/hemophage/drain_victim/Activate(atom/target)
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/hemophage = owner

	if(!has_valid_target(hemophage))
		return

	// By now, we know that they're pulling a carbon.
	drain_victim(hemophage, hemophage.pulling)


/**
 * Handles the first checks to see if the target is eligible to be drained.
 *
 * Arguments:
 * * hemophage - The person that's trying to drain something or someone else.
 *
 * Returns `TRUE` if the target is eligible to be drained, `FALSE` if not.
 */
/datum/action/cooldown/hemophage/drain_victim/proc/has_valid_target(mob/living/carbon/hemophage)
	if(!hemophage.pulling || !iscarbon(hemophage.pulling))
		hemophage.balloon_alert(hemophage, "not pulling any valid target!")
		return FALSE

	var/mob/living/carbon/victim = hemophage.pulling
	if(hemophage.blood_volume >= BLOOD_VOLUME_MAXIMUM)
		hemophage.balloon_alert(hemophage, "already full!")
		return FALSE

	if(victim.stat == DEAD)
		hemophage.balloon_alert(hemophage, "needs a living victim!")
		return FALSE

	if(!victim.blood_volume || (victim.dna && ((HAS_TRAIT(victim, TRAIT_NOBLOOD)))))
		hemophage.balloon_alert(hemophage, "[victim] doesn't have blood!")
		return FALSE

	if(ismonkey(victim) && (hemophage.blood_volume >= BLOOD_VOLUME_NORMAL))
		hemophage.balloon_alert(hemophage, "their inferior blood cannot sate you any further!")
		return FALSE

	return TRUE


/**
 * Flavor interactions for unique things in the bloodstream.
 *
 * Arguments:
 * * hemophage - The person that's trying to drain something or someone else.
 *
 * Returns `TRUE` if we should continue the proc and drain reagents, returns `FALSE` if we shouldn't
 */
/datum/action/cooldown/hemophage/drain_victim/proc/handle_unsual_drinks(mob/living/carbon/hemophage, mob/living/carbon/victim)
	// Drinking a holy man's blood sets you on fire.
	if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 1))
		victim.show_message(span_warning("[hemophage] bites you, and catches aflame!"))
		to_chat(hemophage, span_boldwarning("[victim] is blessed! Your body is set ablaze as your fangs dig in!"))
		hemophage.adjust_fire_stacks(3)
		hemophage.ignite_mob()
		return FALSE
	// Drinking blood from a person with garlic makes you vomit.
	if(victim.has_reagent(/datum/reagent/consumable/garlic))
		victim.show_message(span_warning("[hemophage] bites you and immediately recoils in disgust!"))
		to_chat(hemophage, span_warning("[victim] reeks of garlic! Just the taste alone makes you vomit!"))
		hemophage.vomit(vomit_flags = HEMOPHAGE_VOMIT_FLAGS, lost_nutrition = 0, distance = 1, purge_ratio = HEMOPHAGE_VOMIT_PURGE_RATIO)
		return FALSE

	return TRUE

/**
 * Handles special feeding behavior for monkey-type targets.
 *
 * Returns TRUE if feeding on a monkey-type target, FALSE otherwise.
 */
/datum/action/cooldown/hemophage/drain_victim/proc/feeding_on_monkeys(mob/living/carbon/hemophage, mob/living/carbon/victim)
	if(ismonkey(victim)) // monkey
		hemophage.add_mood_event("gross_food", /datum/mood_event/disgust/hemophage_feed_monkey) // drinking from a monkey is inherently gross, like, REALLY gross
		hemophage.adjust_disgust(TUMOR_DISLIKED_FOOD_DISGUST, DISGUST_LEVEL_MAXEDOUT)
		return TRUE
	if(istype(victim, /mob/living/carbon/human/species/monkey)) // humonkey
		hemophage.add_mood_event("gross_food", /datum/mood_event/disgust/hemophage_feed_humonkey)
		hemophage.adjust_disgust(DISGUST_LEVEL_GROSS / 4, TUMOR_DISLIKED_FOOD_DISGUST) // it's still gross but nowhere near as bad, though.
		return TRUE
	return FALSE


/**
 * The proc that actually handles draining the victim. Assumes that all the
 * pre-requesite checks were made, and as such will not make any more checks
 * outside of a `do_after` of three seconds.
 *
 * Arguments:
 * * hemophage - The feeder.
 * * victim - The one that's being drained.
 */
/datum/action/cooldown/hemophage/drain_victim/proc/drain_victim(mob/living/carbon/hemophage, mob/living/carbon/victim)
	//How much capacity we have left to absorb blood
	var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - hemophage.blood_volume
	// Did we drink something gross e.g monkey.
	var/horrible_feeding = FALSE

	// We start by checking that the victim is a human and they have a client, so we can give them the beneficial status effect for drinking higher-quality blood.
	var/is_target_human_with_client = istype(victim, /mob/living/carbon/human) && victim.client

	StartCooldown()

	// Feedback that the hemophage is attempting to drink from you.
	to_chat(hemophage, span_notice("You lean in to drink from [victim]."))
	to_chat(victim, span_danger("[hemophage] leans in close to your neck!"))

	// Do after to channel the feeding.
	if(!do_after(hemophage, 3 SECONDS, target = victim))
		hemophage.balloon_alert(hemophage, "stopped feeding")
		return

	// If we feed on a monkey, it is a horrible feeding.
	if(feeding_on_monkeys(hemophage, victim))
		horrible_feeding = TRUE
		is_target_human_with_client = FALSE
	// If we feed on something that doesn't have normal blood.
	if(!handle_unsual_drinks(hemophage, victim))
		return

	// How much blood we would be draining.
	var/drained_blood = min(victim.blood_volume, HEMOPHAGE_DRAIN_AMOUNT, blood_volume_difference)
	// The multiplier on drinking, if they have a mind.
	var/drained_multiplier = (is_target_human_with_client ? BLOOD_DRAIN_MULTIPLIER_CKEY : 1)

	// Build a temporary blood holder from the victim, then ingest it through normal chemistry handling.
	// Because blood doesn't exist as a reagent in a mob we have to middle-man the reagents to a holder if we want to trigger on ingestion effects for abstract lbood types.
	var/datum/reagents/drained_blood_holder = new /datum/reagents(drained_blood)
	// Acquires the victim's blood.
	var/datum/blood_type/victim_blood_type = victim.get_bloodtype()
	if(!victim_blood_type)
		qdel(drained_blood_holder)
		to_chat(hemophage, span_warning("You fail to draw anything useful from [victim]."))
		return

	// Adds the victim's blood to the holder.
	var/drain_reagent_to_holder = drained_blood_holder.add_reagent(victim.get_blood_reagent(), drained_blood, victim.get_blood_data(), victim.bodytemperature, creation_callback = CALLBACK(victim, TYPE_PROC_REF(/mob/living, on_blood_created), victim_blood_type))
	if(!drain_reagent_to_holder)
		qdel(drained_blood_holder)
		to_chat(hemophage, span_warning("You fail to draw anything useful from [victim]."))
		return

	// Adds the holder's blood to the drinker through ingestion.
	var/drained_amount = drained_blood_holder.trans_to(hemophage, drained_blood, target_id = victim.get_blood_reagent(), methods = INGEST, show_message = FALSE)

	qdel(drained_blood_holder)

	// Did we fail to drain anything?
	if(!drained_amount)
		to_chat(hemophage, span_warning("You fail to draw anything useful from [victim]."))
		return

	// blood_volume is separate from reagents, so we manually mirror the successful drain here.
	victim.blood_volume = clamp(victim.blood_volume - drained_amount, 0, BLOOD_VOLUME_MAXIMUM)

	// Feedback & Logging
	log_combat(hemophage, victim, "drained [drained_amount]u of blood from", addition = " (NEW BLOOD VOLUME: [victim.blood_volume] cL)")
	victim.show_message(span_userdanger("[hemophage] drains some of your blood!"))

	// Feedback informing the drinker that you drank something disgusting.
	if(horrible_feeding)
		if(istype(victim, /mob/living/carbon/human/species/monkey))
			to_chat(hemophage, span_notice("You take tentative draws of blood from [victim], each mouthful awash with the taste of ozone and a strange artificial twinge."))
		else
			to_chat(hemophage, span_warning("You choke back tepid mouthfuls of foul blood from [victim]. The taste is absolutely vile."))
	else
		to_chat(hemophage, span_notice("You pull greedy gulps of precious lifeblood from [victim]'s veins![is_target_human_with_client ? " That tasted particularly good!" : ""]"))

	playsound(hemophage, 'sound/items/drink.ogg', 30, TRUE, -2)

	// Lets the hemophage know they're capped out on blood if they're trying to go for an exsanguinate and wondering why it isn't working
	if(drained_amount != HEMOPHAGE_DRAIN_AMOUNT && hemophage.blood_volume >= (BLOOD_VOLUME_MAXIMUM - (HEMOPHAGE_DRAIN_AMOUNT * drained_multiplier)))
		to_chat(hemophage, span_boldnotice("Your thirst is temporarily slaked, and you can digest no more new blood for the moment."))

	// Tells drinker and victim that you drained a bit more than is safe.
	if(victim.blood_volume <= BLOOD_VOLUME_OKAY)
		to_chat(hemophage, span_warning("That definitely left them looking pale..."))
		to_chat(victim, span_warning("A groaning lethargy creeps into your muscles as you begin to feel slightly clammy...")) //let the victim know too

	// Gives happy chemicals moodlet.
	if(is_target_human_with_client)
		hemophage.apply_status_effect(/datum/status_effect/blood_thirst_satiated)
		hemophage.add_mood_event("drank_human_blood", /datum/mood_event/hemophage_feed_human) // absolutely scrumptious
		hemophage.clear_mood_event("gross_food") // it's a real palate cleanser, you know
		hemophage.disgust *= 0.85 //also clears a little bit of disgust too

	// Kill victim by draining them.
	// for this to ever occur, the hemophage actually has to be decently hungry, otherwise they'll cap their own blood reserves and be unable to pull it off.
	if(!victim.blood_volume || victim.blood_volume <= BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_boldwarning("Sensing an opportunity, your tumour produces an UNCONTROLLABLE URGE to draw extra deeply from [victim], forcing you to violently drain the last drops of blood from their veins."))
		to_chat(victim, span_bolddanger("The faint warmth of life flees your cooling body as [hemophage]'s ravenous hunger violently drains the last of your precious blood in one fell swoop, sending you hurtling headlong into the cold embrace of death."))
		victim.visible_message(span_warning("[victim] turns a terrible shade of ashen grey."))
		victim.death()
		victim.blood_volume = 0 // the rest of the blood goes towards the tumour making happy juice for you.
		if (is_target_human_with_client)
			to_chat(hemophage, span_boldnotice("A rush of unbidden exhilaration surges through you as the predatory urges of your terrible coexistence are momentarily sated."))
			hemophage.add_mood_event("hemophage_killed", /datum/mood_event/hemophage_exsanguinate) // this is the tumour-equivalent of a nice little headpat. you murderer, you!
			hemophage.disgust = 0 // all is forgiven.
			if(prob(33))
				to_chat(hemophage, span_warning("...what have you done?"))
	else if ((victim.blood_volume + HEMOPHAGE_DRAIN_AMOUNT) <= BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_warning("A sense of hesitation gnaws: you know for certain that taking much more blood from [victim] WILL kill them. <b>...but another part of you sees only opportunity.</b>"))

#undef HEMOPHAGE_DRAIN_AMOUNT
#undef BLOOD_DRAIN_MULTIPLIER_CKEY
