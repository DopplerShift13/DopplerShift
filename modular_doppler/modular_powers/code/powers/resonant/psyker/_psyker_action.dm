/datum/action/cooldown/power/psyker
	name = "abstract psyker power action - ahelp this"
	background_icon_state = "bg_hive"
	overlay_icon_state = "bg_hive_border"
	button_icon = 'icons/mob/actions/backgrounds.dmi'

	// The organ that processes most of the Psyker Powers. Mostly all functions here communicate with this.
	var/obj/item/organ/resonant/psyker/psyker_organ

	// Disabled by the trait
	var/disabled_by_mental_immunity = TRUE

/datum/action/cooldown/power/psyker/New()
	. = ..()
	ValidateOrgan()

// Actually checks if our Psyker Organ is there. We really want to check this every use.
/datum/action/cooldown/power/psyker/proc/ValidateOrgan()
	if(owner) // Prevents runtiming on start
		psyker_organ =  owner.get_organ_slot(ORGAN_SLOT_PSYKER)
	if(!psyker_organ)
		return FALSE
	return TRUE

// This doesn't actually add the stress itself; it merely tells the organ to add the stress.
// Why not handle it here? Because why give them an organ if we're not going to use it?!
// Validation is handled on the organ side.
/datum/action/cooldown/power/psyker/proc/add_stress(amount)
	psyker_organ.add_stress(amount)

/datum/action/cooldown/power/psyker/proc/remove_stress(amount)
	psyker_organ.remove_stress(amount)

// We added checking for organs on try_use, as well as making sure that if we are wearing a tinfoil cap, we can't just wield our psychic powers.
/datum/action/cooldown/power/psyker/try_use(mob/living/user, mob/living/target)
	if(!ValidateOrgan())
		owner.balloon_alert(owner, "No paracausal gland!")
		return FALSE
	if(target)
		if(disabled_by_mental_immunity && target.can_block_magic(MAGIC_RESISTANCE_MIND))
			add_stress(PSYKER_STRESS_MINOR) // This actively stresses you out.
			owner.balloon_alert(owner, "Something interveres with your powers!")
			return FALSE
	. = .. ()


