
/// Rate at which turning the key will charge its stomach cell each loop.
#define WINDUP_KEY_CHARGE_RATE (CHARGING_STOMACH_DISCHARGE_RATE * 264)
/// Delay between key turning attempts.
#define WINDUP_KEY_CHARGE_DELAY 4.2 SECONDS

/**
 * ORGAN
 */

/obj/item/organ/stomach/charging/windup_key
	name = "wind-up key charging apparatus"
	desc = "A device designed to replace the need for food with \
	an oversized wind-up key you have to ask others to turn for you."
	icon = 'modular_doppler/modular_species/species_types/android/icons/synth_organs.dmi'
	icon_state = "winding_key"
	emp_vulnerability = 0 // We're a windup key.
	can_use_borg_charger = FALSE // We're a windup key.

	/// The bodypart overlay we're going to apply to whoever we're implanted into.
	var/datum/bodypart_overlay/windup_key/key_overlay
	/// Icon file for our on mob overlay.
	var/key_overlay_icon = 'modular_doppler/modular_species/species_types/android/icons/synth_organ_overlays.dmi'
	/// Are we out of charge? Used to limit how often we update our overlays.
	var/out_of_charge = FALSE
	var/currently_winding = FALSE

/obj/item/organ/stomach/charging/windup_key/Initialize(mapload)
	. = ..()
	key_overlay = new(src)

/obj/item/organ/stomach/charging/windup_key/Destroy()
	QDEL_NULL(key_overlay)
	return ..()

/obj/item/organ/stomach/charging/windup_key/on_mob_insert(mob/living/carbon/stomach_owner)
	. = ..()
	RegisterSignal(stomach_owner, COMSIG_CARBON_PRE_MISC_HELP, PROC_REF(on_pre_misc_help))

/obj/item/organ/stomach/charging/windup_key/on_mob_remove(mob/living/carbon/stomach_owner)
	. = ..()
	UnregisterSignal(stomach_owner, COMSIG_CARBON_PRE_MISC_HELP)
	currently_winding = FALSE // Edge case just in case we get removed mid-wind.

/obj/item/organ/stomach/charging/windup_key/on_bodypart_insert(obj/item/bodypart/limb)
	. = ..()
	limb.add_bodypart_overlay(key_overlay)

/obj/item/organ/stomach/charging/windup_key/on_bodypart_remove(obj/item/bodypart/limb)
	. = ..()
	limb.remove_bodypart_overlay(key_overlay)

/obj/item/organ/stomach/charging/windup_key/run_emp_effects(severity)
	return // We're a windup key.

/obj/item/organ/stomach/charging/windup_key/handle_charge_effects()
	. = ..()
	if(isnull(owner))
		return
	if(out_of_charge && (internal_cell.charge > 0))
		out_of_charge = FALSE
		owner.update_body_parts()
		return
	if(!out_of_charge && (internal_cell.charge <= 0))
		out_of_charge = TRUE
		owner.update_body_parts()
		return

/obj/item/organ/stomach/charging/windup_key/proc/on_pre_misc_help(datum/source, mob/living/carbon/helper)
	SIGNAL_HANDLER
	if(helper == owner)
		return NONE
	if(!check_if_key_reachable_by(helper))
		return NONE
	if(currently_winding)
		owner.balloon_alert(helper, "already winding!")
		return COMPONENT_BLOCK_MISC_HELP
	INVOKE_ASYNC(src, PROC_REF(wind_up), owner, helper)
	return COMPONENT_BLOCK_MISC_HELP

/// Handles our windup charging loop.
/obj/item/organ/stomach/charging/windup_key/proc/wind_up(mob/living/carbon/stomach_owner, mob/living/carbon/helper)
	helper.balloon_alert_to_viewers("winding key...")
	update_winding(TRUE)
	while(do_after(helper, WINDUP_KEY_CHARGE_DELAY, target = stomach_owner, extra_checks = CALLBACK(src, PROC_REF(check_if_key_reachable_by), helper)))
		if(owner != stomach_owner)
			stomach_owner.balloon_alert(helper, "key removed!?")
			break

		adjust_charge(WINDUP_KEY_CHARGE_RATE)
		handle_bad_touch(stomach_owner)
		playsound(src, 'sound/machines/click.ogg', 30, FALSE, -3)

		if(internal_cell.used_charge() <= 0)
			stomach_owner.balloon_alert(helper, "fully charged!")
			break
	update_winding(FALSE)

/// Update our winding state, including visuals.
/obj/item/organ/stomach/charging/windup_key/proc/update_winding(new_winding)
	if(currently_winding == new_winding)
		return
	currently_winding = new_winding
	owner.update_body_parts()

/// Handles our bad touch debuffs, if any.
/obj/item/organ/stomach/charging/windup_key/proc/handle_bad_touch(mob/living/carbon/stomach_owner)
	if(stomach_owner.stat == DEAD)
		return
	if(!HAS_TRAIT(stomach_owner, TRAIT_BADTOUCH))
		return

	new /obj/effect/temp_visual/annoyed(get_turf(stomach_owner))
	if(stomach_owner.mob_mood.sanity <= SANITY_NEUTRAL)
		stomach_owner.add_mood_event("bad_touch", /datum/mood_event/very_bad_touch)
	else
		stomach_owner.add_mood_event("bad_touch", /datum/mood_event/bad_touch)

/// Returns whether the helper is currently able to reach our key.
/obj/item/organ/stomach/charging/windup_key/proc/check_if_key_reachable_by(mob/living/carbon/helper)
	// In the most extreme edge case, no. No we can't reach it. Go figure.
	if(QDELETED(owner) || QDELETED(helper))
		return FALSE

	// If we're on the same tile, assume the best case.
	if(owner.loc == helper.loc)
		return TRUE

	// If we're floored, also assume our key is reachable.
	// So we don't need to awkwardly shuffle around
	// unconscious/dead people to find the right direction.
	if(owner.resting)
		return TRUE

	// If the owner was looking at the helper, this is the direction they'd have to be facing.
	var/owner_to_helper = get_dir(owner, helper)
	// The owner's dir is necessarily a cardinal value.
	var/owner_dir = owner.dir

	// # # #
	// - O - Owner facing south
	// - - -
	// Helper at 135 or more degrees of where the owner is facing.
	if(owner_dir & REVERSE_DIR(owner_to_helper))
		return TRUE

	// In all other cases, it's not reachable.
	return FALSE

/obj/item/organ/stomach/charging/windup_key/proc/get_overlay_state()
	if(currently_winding)
		return "winding_key_winding"
	return "winding_key_[internal_cell.charge() > 0 ? "on" : "off"]"

/obj/item/organ/stomach/charging/windup_key/proc/get_overlay(image_layer, obj/item/bodypart/limb)
	return list(image(icon = key_overlay_icon, icon_state = get_overlay_state(), layer = image_layer))

/**
 * VISUALS
 */

/datum/bodypart_overlay/windup_key
	layers = EXTERNAL_ADJACENT | EXTERNAL_FRONT
	/// Wind-up key that owns this overlay
	var/obj/item/organ/stomach/charging/windup_key/our_key

/datum/bodypart_overlay/windup_key/New(obj/item/organ/stomach/charging/windup_key/our_key)
	. = ..()
	src.our_key = our_key

/datum/bodypart_overlay/windup_key/Destroy(force)
	our_key = null
	return ..()

/datum/bodypart_overlay/windup_key/generate_icon_cache()
	. = ..()
	. += our_key.get_overlay_state()

/datum/bodypart_overlay/windup_key/get_overlay(layer, obj/item/bodypart/limb)
	layer = bitflag_to_layer(layer)
	return our_key.get_overlay(layer, limb)
