/datum/power/imbued/mage_sight
	name = "Mage Sight"
	desc = "You can see the magic in the air around people with a bit of intense focus. When activated, you see a cyan aura around any creature currently near you that has magical powers, or is capable of casting spell-type actions. This persists for 6 seconds.\
	\nIf you both share a path and the target has at least one magical power in that path, you will see orange-colored aura on them instead, verifying that you both share at least one path. If the target is immune to resonant scrying or magic, you won't detect anything.\
	\nHas a 30 second cooldown."
	security_record_text = "Subject can identify other magic-using individuals."
	value = 2
	magic_flags = POWER_MAGIC_STANDARD | POWER_MAGIC_SCRYING

	required_powers = list(/datum/power/imbued_root/enchanted)
	action_path = /datum/action/cooldown/power/imbued/mage_sight

/datum/action/cooldown/power/imbued/mage_sight
	name = "Mage Sight"
	desc = "When activated, you see a cyan aura around any creature currently near you that has magical powers, or is capable of casting spell-type actions. This persists for 6 seconds.\
	\nIf you both share a path and the target has at least one magical power in that path, you will see orange-colored aura on them instead, verifying that you both share at least one path. If the target is immune to resonant scrying or magic, you won't detect anything."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "blip"
	cooldown_time = 30 SECONDS

	/// Client-only images currently being shown by this activation.
	var/list/mob/living/tracked_targets = list()
	var/list/image/target_images = list()
	/// Cached left eye color for restoring the caster after the effect ends.
	var/cached_left_eye_color
	/// Cached right eye color for restoring the caster after the effect ends.
	var/cached_right_eye_color

/datum/action/cooldown/power/imbued/mage_sight/Remove(mob/removed_from)
	clear_mage_sight_overlays()
	removed_from?.remove_client_colour(REF(src))
	restore_caster_visuals(removed_from)
	return ..()

/datum/action/cooldown/power/imbued/mage_sight/use_action(mob/living/carbon/human/user, atom/target)
	if(!user?.client)
		return FALSE

	apply_caster_visuals(user)
	show_mage_sight_overlays(user, 6 SECONDS)
	user.playsound_local(get_turf(user), 'sound/effects/magic/swap.ogg', 50, TRUE)
	user.add_client_colour(/datum/client_colour/mage_sight_flash, REF(src))
	addtimer(CALLBACK(src, PROC_REF(remove_caster_flash), user), 0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(restore_caster_visuals), user), 6 SECONDS)
	return TRUE

/// Shows the per-viewer sight overlay on every valid mob in view.
/datum/action/cooldown/power/imbued/mage_sight/proc/show_mage_sight_overlays(mob/living/user, duration)
	if(!user?.client)
		return

	clear_mage_sight_overlays()

	for(var/mob/living/seen_mob in view(user))
		if(seen_mob == user)
			continue
		var/overlay_color = get_mage_sight_color(user, seen_mob)
		if(!overlay_color)
			continue

		var/image/mage_sight_image = image(icon = 'icons/effects/effects.dmi', loc = seen_mob, icon_state = "blip", layer = BELOW_MOB_LAYER)
		mage_sight_image.color = overlay_color

		user.client.images += mage_sight_image
		tracked_targets += seen_mob
		target_images[seen_mob] = mage_sight_image

	if(duration > 0)
		addtimer(CALLBACK(src, PROC_REF(clear_mage_sight_overlays)), duration)

/// Applies the temporary eye-color change to the caster.
/datum/action/cooldown/power/imbued/mage_sight/proc/apply_caster_visuals(mob/living/carbon/human/user)
	cached_left_eye_color = user.eye_color_left
	cached_right_eye_color = user.eye_color_right
	user.set_eye_color(POWER_COLOR_IMBUED, COLOR_CYAN)
	user.update_body()

/// Restores the caster's original eye colors after the effect ends.
/datum/action/cooldown/power/imbued/mage_sight/proc/restore_caster_visuals(mob/living/carbon/human/user)
	if(!user)
		return
	if(isnull(cached_left_eye_color) || isnull(cached_right_eye_color))
		return

	user.set_eye_color(cached_left_eye_color, cached_right_eye_color)
	user.update_body()
	cached_left_eye_color = null
	cached_right_eye_color = null

/// Removes the short client flash applied when mage sight activates.
/datum/action/cooldown/power/imbued/mage_sight/proc/remove_caster_flash(mob/living/carbon/human/user)
	user?.remove_client_colour(REF(src))

/// Removes all client-only overlays created by mage sight.
/datum/action/cooldown/power/imbued/mage_sight/proc/clear_mage_sight_overlays()
	if(owner?.client)
		for(var/mob/living/seen_mob as anything in tracked_targets)
			var/image/mage_sight_image = target_images[seen_mob]
			if(mage_sight_image)
				owner.client.images -= mage_sight_image

	tracked_targets.Cut()
	target_images.Cut()

/// Returns the overlay color for a valid target, or null if the target should not be highlighted.
/datum/action/cooldown/power/imbued/mage_sight/proc/get_mage_sight_color(mob/living/user, mob/living/target_mob)
	if(!user || !target_mob)
		return null
	if(HAS_TRAIT(target_mob, TRAIT_ANTIRESONANCE_SCRYING) || target_mob.can_block_resonance(0)) // scrying immunity and magic immunity block info
		return null

	// If the mob is detected to have a power tagged as interacting with magic systems.
	var/has_magical_power = FALSE
	// If the mob is detected having a tagged power in a path you share.
	var/shares_magical_path = FALSE

	// Iterates all powers and checks if they are magic-tagged and share a path.
	for(var/datum/power/target_power as anything in target_mob.powers)
		if(!power_has_magic_flags(target_power))
			continue

		has_magical_power = TRUE
		if(!shares_magical_path && owner_has_magical_power_in_path(user, target_power.path))
			shares_magical_path = TRUE

	if(has_magical_power)
		return shares_magical_path ? POWER_COLOR_IMBUED : COLOR_CYAN

	if(has_spell_type_action(target_mob))
		return COLOR_CYAN

	return null

/// Whether the owner has any magical power in the specified path.
/datum/action/cooldown/power/imbued/mage_sight/proc/owner_has_magical_power_in_path(mob/living/user, power_path)
	if(!user || !power_path)
		return FALSE

	for(var/datum/power/owner_power as anything in user.powers)
		if(!power_has_magic_flags(owner_power))
			continue
		if(owner_power.path == power_path)
			return TRUE

	return FALSE

/// Whether a power participates in any of the magic-interaction domains.
/datum/action/cooldown/power/imbued/mage_sight/proc/power_has_magic_flags(datum/power/power_type)
	if(!power_type)
		return FALSE
	return !!power_type.magic_flags

/// Whether the target can cast standard spell actions.
/datum/action/cooldown/power/imbued/mage_sight/proc/has_spell_type_action(mob/living/target_mob)
	if(!length(target_mob?.actions))
		return FALSE

	for(var/datum/action/cooldown/action_datum as anything in target_mob.actions)
		if(istype(action_datum, /datum/action/cooldown/spell))
			return TRUE

	return FALSE

/datum/client_colour/mage_sight_flash
	priority = CLIENT_COLOR_IMPORTANT_PRIORITY
	color = POWER_COLOR_IMBUED
	fade_in = 0.125 SECONDS
	fade_out = 0.125 SECONDS
