/*
	Different version of a melee weapon power. While its comparible to the Armblade, it differs in a few important ways:
	- It deals less damage and has less armor penetration, but bleeds more.
	- Has a built-in dual-wield mechanic that builds momentum through repeated hits.
	- Occupies both hands.
	- Doesn't table-break.
*/
/datum/power/aberrant/raking_claws
	name = "Raking Claws"
	desc = "Transform both hands into wicked claws, dropping anything held and preventing you from holding items. Each claw deals 15 damage, has low armor penetration, can strike twice and readily causes bleeding.\
	\nDamaging living targets grants Bloodlust, with bleeding targets potentially granting an additional stack. Bloodlust stacks up to 10 and decays by 1 every 5 seconds without gaining a stack. Your chance to strike with both claws is 15%, increased by 6% per Bloodlust and an additional 25% against large targets.\
	\n(Claw Style is purely cosmetic and has no impact on mechanics)"
	security_record_text = "Subject can manifest sharp, monstrous claws from their hands."
	security_threat = POWER_THREAT_MAJOR
	value = 4
	magic_flags = POWER_MAGIC_STANDARD
	required_powers = list(/datum/power/aberrant_root)
	required_allow_subtypes = TRUE
	action_path = /datum/action/cooldown/power/aberrant/raking_claws

/datum/action/cooldown/power/aberrant/raking_claws
	name = "Raking Claws"
	desc = "Reform your hands into deadly claws, dropping everything you are holding. Using the power again retracts them."
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "sting_armblade"
	active = FALSE

	cooldown_time = 50
	cost = ABERRANT_HUNGER_TRIVIAL * 8
	/// Whether the current activation extended the claws and should spend hunger.
	var/raking_claws_extended = FALSE

	/// Base percentage chance for the dual-wield rake attack to trigger.
	var/rake_base_chance = 15
	/// Maximum percentage chance for the dual-wield rake attack to trigger.
	var/rake_max_chance = 100
	/// Percentage added to the dual-wield rake chance per stack of Bloodlust.
	var/rake_bloodlust_mult = 6
	/// Percentage added to the dual-wield rake chance against large targets.
	var/rake_large_target_bonus = 25
	/// Chance per unit of target bleed rate to gain an additional Bloodlust stack.
	var/bloodlust_bleed_mult = 7.5
	/// Final calculated chance for the dual-wield rake attack.
	var/rake_final_chance
	/// Fur colour shared by both manifested claws.
	var/raking_claw_fur_color
	/// Claw colour shared by both manifested claws.
	var/raking_claw_claw_color
	/// Numerical suffix selecting which set of beast-arm icon states to use.
	var/raking_claw_arm_style

/// Registers the dispel handler when the power is granted.
/datum/action/cooldown/power/aberrant/raking_claws/Grant(mob/granted_to)
	. = ..()
	RegisterSignal(granted_to, COMSIG_ATOM_DISPEL, PROC_REF(on_dispel))
	initialize_claw_appearance_from_preferences()

/// Retracts manifested claws and unregisters the dispel handler when the power is removed.
/datum/action/cooldown/power/aberrant/raking_claws/Remove(mob/removed_from)
	retract_claws(removed_from)
	UnregisterSignal(removed_from, COMSIG_ATOM_DISPEL)
	return ..()

/// Add a guard so that disabling does not run the can_use check on hunger.
/datum/action/cooldown/power/aberrant/raking_claws/can_use(mob/living/user, atom/target)
	bypass_cost = active
	return ..()

/// Manifests a claw in each hand, or retracts both claws when already active.
/datum/action/cooldown/power/aberrant/raking_claws/use_action(mob/living/user, atom/target)
	raking_claws_extended = FALSE
	if(active)
		retract_claws(user)
		playsound(user, 'sound/effects/magic/exit_blood.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		user.visible_message(
			span_warning("With a sickening crunch, [user]'s claws reform into hands!"),
			span_notice("You assimilate the claws back into your body."),
		)
		return TRUE

	user.drop_all_held_items()
	if(length(user.get_empty_held_indexes()) < 2)
		user.balloon_alert(user, "hands obstructed!")
		return FALSE

	var/obj/item/raking_claw/active_claw = new(user)
	active_claw.manifesting_power = src
	active_claw.apply_claw_appearance(raking_claw_arm_style, raking_claw_fur_color, raking_claw_claw_color)
	if(!user.put_in_active_hand(active_claw))
		qdel(active_claw)
		return FALSE

	var/obj/item/raking_claw/inactive_claw = new(user)
	inactive_claw.manifesting_power = src
	inactive_claw.apply_claw_appearance(raking_claw_arm_style, raking_claw_fur_color, raking_claw_claw_color)
	if(!user.put_in_inactive_hand(inactive_claw))
		user.temporarilyRemoveItemFromInventory(active_claw, TRUE)
		qdel(inactive_claw)
		return FALSE

	playsound(user, 'sound/effects/magic/exit_blood.ogg', 50, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	user.visible_message(
		span_warning("A pair of grotesque claws tear their way out of [user]'s hands!"),
		span_notice("Your hands twist and mutate into deadly claws."),
	)
	user.update_held_items()
	active = TRUE
	bypass_cost = TRUE
	raking_claws_extended = TRUE
	return TRUE

/// Resolves the owner's saved fur colour, claw colour, and arm style once for both manifested claws.
/datum/action/cooldown/power/aberrant/raking_claws/proc/initialize_claw_appearance_from_preferences()
	var/fur_color_choice = owner?.client?.prefs?.read_preference(/datum/preference/color/raking_claws/fur)
	var/claw_color_choice = owner?.client?.prefs?.read_preference(/datum/preference/color/raking_claws/claws)
	var/arm_style_choice = owner?.client?.prefs?.read_preference(/datum/preference/choiced/raking_claws_arm_style)

	raking_claw_fur_color = fur_color_choice || POWER_COLOR_ABERRANT
	raking_claw_claw_color = claw_color_choice || COLOR_WHITE
	if(!findtext(raking_claw_fur_color, "#", 1, 2))
		raking_claw_fur_color = "#[raking_claw_fur_color]"
	if(!findtext(raking_claw_claw_color, "#", 1, 2))
		raking_claw_claw_color = "#[raking_claw_claw_color]"

	raking_claw_arm_style = GLOB.raking_claw_arm_styles[arm_style_choice]
	if(!isnum(raking_claw_arm_style))
		raking_claw_arm_style = GLOB.raking_claw_arm_styles["Bear"]

/// Charges hunger only when the claws were extended, allowing free retraction.
/datum/action/cooldown/power/aberrant/raking_claws/on_action_success(mob/living/user, atom/target)
	cost = raking_claws_extended ? ABERRANT_HUNGER_TRIVIAL * 8 : 0
	. = ..()
	raking_claws_extended = FALSE
	cost = initial(cost)

/// Deletes every manifested claw held by the owner and marks the power inactive.
/datum/action/cooldown/power/aberrant/raking_claws/proc/retract_claws(mob/claw_owner)
	for(var/obj/item/raking_claw/claw in claw_owner.held_items)
		claw_owner.temporarilyRemoveItemFromInventory(claw, TRUE)
	claw_owner.update_held_items()
	active = FALSE
	bypass_cost = FALSE

/// Dispels both claws and puts the power on a longer cooldown.
/datum/action/cooldown/power/aberrant/raking_claws/proc/on_dispel(mob/living/owner, atom/dispeller)
	SIGNAL_HANDLER
	if(!active)
		return NONE

	retract_claws(owner)
	owner.visible_message(
		span_warning("With a sickening crunch, [owner]'s claws are forced back into [owner.p_their()] hands!"),
		span_boldwarning("Your claws twist back to normal against your will!"),
	)
	StartCooldownSelf(150)
	return DISPEL_RESULT_DISPELLED

/*
	Item code below, including handling for most on-hit effects.
*/
/obj/item/raking_claw
	name = "raking claw"
	desc = "A long, wicked claw made for tearing open flesh and existing wounds."
	icon = 'modular_doppler/modular_powers/icons/items/beastarm_items.dmi'
	icon_state = "base_fur2"
	inhand_icon_state = "base_fur2"
	icon_angle = 180
	lefthand_file = 'modular_doppler/modular_powers/icons/mob/inhands/beastarm_lefthand.dmi'
	righthand_file = 'modular_doppler/modular_powers/icons/mob/inhands/beastarm_righthand.dmi'
	color = POWER_COLOR_ABERRANT
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 15
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	hitsound = 'sound/items/weapons/slash.ogg'
	attack_verb_continuous = list("rakes", "slashes", "tears", "lacerates", "rips", "cuts")
	attack_verb_simple = list("rake", "slash", "tear", "lacerate", "rip", "cut")
	sharpness = SHARP_EDGED
	armour_penetration = 10
	wound_bonus = 5
	exposed_wound_bonus = 25 // really good at bleeding exposed bodyparts
	/// Inherited reference to the power that manifested this claw and owns its dual-wield tuning.
	var/datum/action/cooldown/power/aberrant/raking_claws/manifesting_power
	/// Prevents propagation and mirrors the animation during a dual-wield follow-up attack.
	var/is_dual_wield_followup = FALSE
	/// Numerical suffix selecting this claw's icon states.
	var/arm_style = 2
	/// Colour applied only to the fur base.
	var/fur_color = POWER_COLOR_ABERRANT
	/// Colour applied only to the claw overlay.
	var/claw_color = COLOR_WHITE
	/// Damage this claw's current attack would deal before target mitigation.
	var/unmitigated_attack_damage = 0

/// Makes the manifested claw undroppable and registers its shared attack handlers.
/obj/item/raking_claw/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, REF(src))
	RegisterSignal(src, COMSIG_ITEM_AFTERATTACK, PROC_REF(try_dual_wield_attack))
	AddComponent(/datum/component/butchering, butcher_callback = CALLBACK(src, PROC_REF(on_butchering)))

/// Applies the shared customization selected by the power owner.
/obj/item/raking_claw/proc/apply_claw_appearance(new_arm_style, new_fur_color, new_claw_color)
	arm_style = new_arm_style
	fur_color = new_fur_color
	claw_color = new_claw_color
	icon_state = "base_fur[arm_style]"
	inhand_icon_state = icon_state
	color = fur_color
	update_appearance(UPDATE_ICON)
	update_inhand_icon()

/// Adds the independently coloured claws over the fur base on the item sprite.
/obj/item/raking_claw/update_overlays()
	. = ..()
	var/mutable_appearance/claw_overlay = mutable_appearance(icon, "claws_fur[arm_style]", appearance_flags = RESET_COLOR | KEEP_APART)
	claw_overlay.color = claw_color
	. += claw_overlay

/// Adds the independently coloured claws beside the fur layer so both remain grouped by worn transforms.
/obj/item/raking_claw/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file)
	. = ..()
	if(!isinhands)
		return
	var/mutable_appearance/claw_overlay = mutable_appearance(icon_file, "claws_fur[arm_style]")
	claw_overlay.color = claw_color
	. += claw_overlay

/// Reserves the off-hand follow-up before generic dual-wield effects can claim it.
/obj/item/raking_claw/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!. && !attack_modifiers[OFFHAND_ATTACK_CLAIMED] && isliving(target) && istype(user.get_inactive_held_item(), /obj/item/raking_claw))
		attack_modifiers[OFFHAND_ATTACK_CLAIMED] = src

/// Applies a signaler to the target so successful claw damage can build Bloodlust.
/obj/item/raking_claw/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!islist(attack_modifiers))
		attack_modifiers = list()
	SEND_SIGNAL(user, COMSIG_RAKING_CLAW_MODIFY_ATTACK, src, target_mob, attack_modifiers)
	unmitigated_attack_damage = CALCULATE_FORCE(src, attack_modifiers)
	if(target_mob.mob_biotypes & MOB_ROBOTIC)
		unmitigated_attack_damage *= get_demolition_modifier(target_mob)
	RegisterSignal(target_mob, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(record_attack_damage))
	. = ..()
	UnregisterSignal(target_mob, COMSIG_MOB_AFTER_APPLY_DAMAGE)
	unmitigated_attack_damage = 0
	return .

/// Grants Bloodlust when this claw damages a living target, with a bleed-scaled chance for an additional stack.
/obj/item/raking_claw/proc/record_attack_damage(mob/living/source, damage_dealt, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, obj/item/attacking_item, wound_clothing)
	SIGNAL_HANDLER
	if(attacking_item != src)
		return
	if(isnull(manifesting_power))
		return
	var/mob/living/claw_user = get(src, /mob/living)
	if(isnull(claw_user))
		return
	if(damage_dealt > 0 && source.stat != DEAD) // when hitting a non-dead target, plus random chance to get another.
		var/stacks_to_add = 1 + prob(source.get_bleed_rate() * manifesting_power.bloodlust_bleed_mult)
		claw_user.apply_status_effect(/datum/status_effect/raking_claw_bloodlust, stacks_to_add)
	SEND_SIGNAL(claw_user, COMSIG_RAKING_CLAW_AFTER_DAMAGE, src, source, damage_dealt, unmitigated_attack_damage, def_zone)

/// Publishes completed butchering so claw upgrades can independently provide rewards.
/obj/item/raking_claw/proc/on_butchering(mob/living/butcher, mob/living/target)
	SEND_SIGNAL(butcher, COMSIG_RAKING_CLAW_BUTCHERED, src, target)

/// Displays a red claw slash centered on the attacked atom instead of swinging the item's sprite from the attacker.
/obj/item/raking_claw/animate_attack(atom/movable/attacker, atom/attacked_atom, animation_type)
	var/image/claw_attack = image(icon = 'icons/effects/effects.dmi', icon_state = "claw")
	claw_attack.color = COLOR_RED
	claw_attack.plane = attacked_atom.plane + 1
	claw_attack.appearance_flags = APPEARANCE_UI
	if(is_dual_wield_followup)
		claw_attack.transform = matrix().Scale(-1, 1)
	var/atom/movable/flick_visual/claw_visual = attacked_atom.flick_overlay_view(claw_attack, 0.5 SECONDS)
	var/matrix/final_transform = matrix(claw_attack.transform).Scale(1.15)
	animate(claw_visual, alpha = 0, transform = final_transform, time = 0.5 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)

/// Rolls the Bloodlust-scaled dual-wield chance and attacks once with the other held claw on success.
/obj/item/raking_claw/proc/try_dual_wield_attack(obj/item/source, atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER
	var/offhand_attack_claim = attack_modifiers[OFFHAND_ATTACK_CLAIMED]
	// Prevents dual-wield attacks if this is a follow-up attack, if the power isn't active, if the target isn't living, or if the off-hand attack has already been claimed by another source.
	if(is_dual_wield_followup || isnull(manifesting_power) || !isliving(target) || (offhand_attack_claim && offhand_attack_claim != source))
		return
	var/mob/living/living_target = target

	// Drake, where'd the other claw go?
	var/obj/item/raking_claw/other_claw
	for(var/obj/item/raking_claw/held_claw in user.held_items)
		if(held_claw != source)
			other_claw = held_claw
			break
	if(isnull(other_claw))
		return

	// Math out bonuses for bloodlust and large targets.
	var/datum/status_effect/raking_claw_bloodlust/bloodlust = user.has_status_effect(/datum/status_effect/raking_claw_bloodlust)
	var/large_target_bonus = living_target.mob_size >= MOB_SIZE_LARGE ? manifesting_power.rake_large_target_bonus : 0
	manifesting_power.rake_final_chance = min(
		manifesting_power.rake_base_chance + bloodlust?.stacks * manifesting_power.rake_bloodlust_mult + large_target_bonus,
		manifesting_power.rake_max_chance,
	)

	// If we roll it, do another attack.
	if(prob(manifesting_power.rake_final_chance))
		attack_modifiers[OFFHAND_ATTACK_CLAIMED] = source
		other_claw.is_dual_wield_followup = TRUE
		user.do_item_attack_animation(living_target, used_item = other_claw)
		other_claw.attack(living_target, user, modifiers, attack_modifiers)
		other_claw.is_dual_wield_followup = FALSE
	return

/// Attacker-owned momentum that increases the chance of a raking claw follow-up.
/datum/status_effect/raking_claw_bloodlust
	id = "raking_claw_bloodlust"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/raking_claw_bloodlust
	show_duration = FALSE
	/// Current Bloodlust intensity.
	var/stacks = 0
	/// Maximum Bloodlust obtainable from repeated claw hits.
	var/max_stacks = 10
	/// Maximum strength of the red screen tint at full Bloodlust.
	var/max_tint_strength = 0.12
	/// Hulk-style speech modifier attached to the owner while Bloodlust remains active.
	var/datum/component/speechmod/bloodlust_speech_modifier

/datum/status_effect/raking_claw_bloodlust/on_creation(mob/living/new_owner, stacks_to_add = 1)
	. = ..()
	if(!.)
		return
	bloodlust_speech_modifier = owner.AddComponent(/datum/component/speechmod, replacements = list("." = "!"), end_string = "!!", uppercase = TRUE) // YOU SHOUT LIKE THIS BECAUSE YOU ARE IN A FRENZY
	owner.add_client_colour(/datum/client_colour/raking_claw_bloodlust, REF(src))
	adjust_stacks(stacks_to_add)

/// Adds new stacks and restarts the five-second decay delay.
/datum/status_effect/raking_claw_bloodlust/refresh(effect, stacks_to_add = 1)
	. = ..()
	adjust_stacks(stacks_to_add)
	tick_interval = world.time + initial(tick_interval)

/// Removes one stack after five uninterrupted seconds without gaining one.
/datum/status_effect/raking_claw_bloodlust/tick(seconds_between_ticks)
	adjust_stacks(-1)

/datum/status_effect/raking_claw_bloodlust/on_remove()
	QDEL_NULL(bloodlust_speech_modifier)
	owner.remove_client_colour(REF(src))
	return ..()

/datum/status_effect/raking_claw_bloodlust/proc/adjust_stacks(amount)
	stacks = clamp(stacks + amount, 0, max_stacks)
	if(stacks <= 0)
		qdel(src)
		return
	var/tint_strength = max_tint_strength * stacks / max_stacks
	var/datum/client_colour/bloodlust_tint = owner.get_client_colour(REF(src))
	// Red remains unchanged while green and blue are reduced per stack, progressively tinting the screen redder as you RIP AND TEAR.
	bloodlust_tint?.update_color(list(1, 0, 0, 0, 0, 1 - tint_strength, 0, 0, 0, 0, 1 - tint_strength, 0, 0, 0, 0, 1, 0, 0, 0, 0), -1)
	linked_alert?.maptext = MAPTEXT_TINY_UNICODE("<span style='text-align:center'>[stacks]</span>")

/datum/client_colour/raking_claw_bloodlust
	priority = CLIENT_COLOR_IMPORTANT_PRIORITY
	color = COLOR_MATRIX_IDENTITY

/atom/movable/screen/alert/status_effect/raking_claw_bloodlust
	name = "Bloodlust"
	desc = "Each stack increases the chance of striking with both raking claws. Bloodlust decays while you are not damaging living targets."
	icon = 'icons/mob/actions/actions_ecult.dmi'
	icon_state = "blood_siphon"

/// Shared preference behavior for the independently coloured parts of Raking Claws.
/datum/preference/color/raking_claws
	abstract_type = /datum/preference/color/raking_claws
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/color/raking_claws/is_accessible(datum/preferences/preferences)
	return ..(preferences)

/datum/preference/color/raking_claws/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/color/raking_claws/fur
	savefile_key = "raking_claws_fur_color"

/datum/preference/color/raking_claws/fur/create_default_value()
	return copytext(POWER_COLOR_ABERRANT, 2)

/datum/preference/color/raking_claws/claws
	savefile_key = "raking_claws_claw_color"

/datum/preference/color/raking_claws/claws/create_default_value()
	return copytext(COLOR_WHITE, 2)

/// Preference selecting which beast-arm sprite variant Raking Claws manifests.
/datum/preference/choiced/raking_claws_arm_style
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "raking_claws_arm_style"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/raking_claws_arm_style/create_default_value()
	return "Bear"

/datum/preference/choiced/raking_claws_arm_style/init_possible_values()
	var/list/values = list()
	for(var/arm_style_name in GLOB.raking_claw_arm_styles)
		values += arm_style_name
	return values

/datum/preference/choiced/raking_claws_arm_style/is_accessible(datum/preferences/preferences)
	return ..(preferences)

/datum/preference/choiced/raking_claws_arm_style/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/power_constant_data/raking_claws
	associated_typepath = /datum/power/aberrant/raking_claws
	customization_options = list(
		/datum/preference/color/raking_claws/fur,
		/datum/preference/color/raking_claws/claws,
		/datum/preference/choiced/raking_claws_arm_style,
	)
