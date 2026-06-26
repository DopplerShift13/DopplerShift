Powers Design Document

Explaining the system architecture of the Powers System and how to contribute to it

Written by Creeper Joe / @creeperjoe on Discord

Last updated: 26/06/26

Version: V1.0

#

# <span id="anchor"></span>Quick Notes (for the lazy)

Disclaimer: If this is your first time working with the powers system, read the full document first. This section exists as a quick-reference sheet for returning contributors.

- Vars in this document are written in _italics_. Functions are referred to by ending in ().

- Just look at how other powers do things; there are so many examples to draw from.

- For power datums, the main functions you want to usually use are add(), post_add() and remove().
  - Always make sure to set _name_, _desc_, _value_, _security_record_text_ and _required_powers_ (if any).
  - Make sure with _security_record_threat_ to set POWER_THREAT_MAJOR if it gets in the way of security doing their job.

- For action datums, the main functions you want to use are use_action() for using the action and can_use() for validation.
  - Use _active_ when there’s an active state to the power, to help communicate to other powers.
  - Use _click_to_activate_ = TRUE to use click-based targeting.
  - If you use projectiles, fire*projectile() is set up to handle almost all projectile firing mechanics. Make sure to set \_anti_magic_on_target* to FALSE so that it will only check on impact, and that _click_to_activate_ is TRUE so that you actually give targets.
  - If you want to have cast/use times, use the _use_time_ var, and optionally _use_time_flags_ to set the conditions for interruption. You can further tweak the properties of the cast time with do_use_time().
  - There are a lot of other niche vars in /datum/action/cooldown/power; it is recommended to look at them to see if you can use them.

- Use status effects for any and all lingering effects on mobs.

- **Read the appropriate path notes for **[**Path-Specific Notes on Adding Powers**](#anchor-10), some things may radically differ per path.

#

# <span id="anchor-1"></span>Technical Notes on Adding Powers

First of all, you’ll have to possess some rudimentary understanding of code. The systems are set-up in a way that they are easily understandable, but to make things ‘work’ you’ll need to both be able to understand what you want to make and how to accomplish it.

Understanding _how_ you want to accomplish it is usually the first difficult step in the process. To do this you usually need to interact with at least 1 of these 3 datums, and sometimes multiples.

- The power datum. This is what defines the cost, name, description and what archetype it belongs to. Make sure it inherits the appropriate parent type. All passive powers will usually make the most use of this datum.
- The action datum. If your power has any actively used component that does not integrate into existing systems, you’ll want one of this. This adds an action-button that people can manipulate, and comes with a lot of support-tools for various powers to wield.
- Status effect datums. Any lingering effect on a mob should use these: it is a diegetic way to handle lingering effects, with a lot of useful helper functions such as durations, visible timers and UI alerts.

Make sure you keep your code compartmental. Not every power needs an action datum, but if it has one, you should make sure everything to do with the action stays inside the action, rather than trying to criss-cross communicate between the power and the action. This applies to status effects too; minimize the need to communicate.

Below are several sections going in-depth on the important information per datum.

## <span id="anchor-2"></span>Power Datum

The Power Datum is what registers the power in the system. The name and description is what shows up in prefs and the value is how much it costs. These are largely universal and don’t differ a great deal, but make sure you have the correct parent so that you inherit all the relevant traits.

When it comes to adding functionality to powers, most of it will make use of the add(), post_add(), add_unique() and remove() functions to call their own procs, signallers, etc. It does not have many helpers; most of these are in the action datum, so you usually want to keep passive-only powers delegated to this.

```dm
/datum/power/aberrant/miasmic_conversion
	name = "Miasmic Conversion"
	desc = "Your body mends itself disturbingly well, but creates toxic backlash in your system. You passively convert 1 brute or burn damage per second to toxins damage, at a 90% ratio. You also passively heal a tiny amount of toxins damage per second."
	security_record_text = "Subject extremely rapidly regenerates, but experiences toxic backlash when they do."
	value = 4
	power_flags = POWER_HUMAN_ONLY | POWER_PROCESSES
	required_powers = list(/datum/power/aberrant_root/monstrous)
	/// how much we passively heal tox
	var/passive_tox_healing = 0.05
	/// how much we heal/convert per second
	var/healing = 1
	/// the ratio at which we convert.
	var/conversion_rate = 0.90
```

Example of a Power Datum, set up to passively heal damage (`Miasmic Conversion`).

The difference between the various add functions is important. add() and post*add() differ in when it resolves. Some powers may require the mob to be fully initialized first before we can safely set values, for which post_add() is useful, as it guarantees we have a fully functional mob. Otherwise, you should default to add(). add_unique() works similar to post_add() but only functions when \_power_transfer* (indicating that the power is being transferred over from another source) is not true, and is meant for things that should occur only once, such as spawning items.

The description of powers supports newlines using \n; it is recommended you use these for formatting to prevent word-slop.

### <span id="anchor-3"></span>Variables & Functions

Check /datum/power for important variables. The most common ones you’ll use are _name_ and _desc_ (self-explanatory), _value_ (the cost), _required_powers_ (prerequisites), _action_path_ (the reference to the action datum, if any), and _security_record_text_ (the text that appears in security records).

action_path particularly deserves a unique mention. If you have an activate-able ability that warrants its own button, you want to make an action datum and define the full type-path of the action inside here. Usually, you have the power- and action datums in the same file for ease of access. More on action datums is elaborated in the [Action Datum section](#anchor-4).

_power_flags_ is another useful tool, specifically allowing you to pass POWER_PROCESSES as an argument to make the power start processing, performing the process() function every tick.

There are several sub-types of variables to do with power prerequisites.

- _required_powers_ as mentioned determines which powers are required to select it. This a list, so you can have multiple power requirements.
- _required_allow_subtypes_, allowing any with that typepath to count rather than an exact match. This is most commonly used for having the prerequisite of having a path’s roots but not a specific root.
- required_allow_any, which changes it so that you only need to fullfill the prerequisites of one power to qualify. This stacks with required_allow_subtypes.

For security records the following variables and functions are much more relevant:

- _security_record_text,_ which is the message that gets appended to security records for powers. This **should** always start with “Subject (...)”, and should refer to the person as subject and with gender-neutral terms (for the clinical writing style).
- _security_record_threat_, which is either POWER_THREAT_MINOR or POWER_THREAT_MAJOR. This determines if it is in bold on the record and red on SecHUDs. If it can get in the way of Security in any way of performing their duties, it should be major. Any teleportation, combat abilities (offensive or defensive), hidden storage spaces and any other ability capable of thwarting them. Always lean towards major if in doubt, as it is used to help security assess risk in a pinch.
- include_in_security_records, which determines if it shows up in the records at all. This should **normally** always be true and should not be modified.
- get_security_record_text(). This is the function that determines what gets contributed to the security records. If you take the omnilingual power, you can see it overrides it to give a custom result: this is usually how you want to pass custom powers.

There is also species blacklists, for which the following variables are relevant.

- species_blacklist. This is a list that blocks any and all listed species from selecting it, including subtypes. Preferably you want to only use this if this causes bugs and gameplay issues that cannot be remedied, such as holosynths being unable to use the Shapechange power because of their nature of being tied to a holopen. Avoid using species restrictions for purely balance reasons, as this leads to major player dissatisfaction.
- species_blacklist_is_whitelist. This inverses the above blacklist to become a whitelist, meaning only the listed species are allowed to choose the power.

Note that with any and all validation (blacklists and required species), it is only checked on the preferences and character creation. Adding incompatible powers through admin-powers is still possible, at the admin’s own risk.

## <span id="anchor-4"></span>Action Datum

The Action Datum is an optional but very commonly used part of powers. This adds an action-icon on the power owner’s UI, allowing them to manipulate the power at their leisure and call it using hotkeys or the press of the button. The system is largely stylized after Changeling’s action system, so if you are familiar with that, you should feel at home.

```dm
/datum/action/cooldown/power/thaumaturge/gale_blast
	name = "Gale Blast"
	desc = "Shoots forth a blast of wind. The blast keeps traveling until it hits a solid structure, extinguishing any fires and dragging along any items with it. If it hits a creature, it knocks them back 3 spaces and extinguishes them."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "smoke"
	required_affinity = 3
	prep_cost = 3
	click_to_activate = TRUE
	anti_magic_on_target = FALSE

/datum/action/cooldown/power/thaumaturge/gale_blast/use_action(mob/living/user, atom/target)
	if(fire_projectile(user, target, /obj/projectile/resonant/gale_blast))
		playsound(user, 'sound/effects/podwoosh.ogg', 60, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		return TRUE
	return FALSE
```

Example of an Action Datum that shoots a projectile (`Gale Blast`).

###

### <span id="anchor-5"></span>The Pipeline

Actions traverse a pipeline from the moment they are pressed to resolution. There are various stages to activation that you may want to override, intercept or tweak to match the expectations of your power. Most of this pipeline is visible in /datum/action/cooldown/power but uses some parent functions as well. Variables and functions mentioned here can be found in the [Variables & Functions section](#anchor-6) that follows this section.

- Pressing the button starts with trigger(). This is native to actions and immediately passes it to activate(), which will then set the user and pass it into our own eco system by calling try_use(). Once try_use() resolves, the action goes on cooldown.
  - If _click_to_activate_ is TRUE, this starting pipeline behaves differently right up until try_use(). See the added list after this one for details.

- try_use() is the whole powers-specific pipeline. It starts by checking against can_use()

- can_use() checks against any prerequisite checks, such as silencing, incapacitation, etc. If your action has powers that need validating, such as needing a tail for tail swipe, it should be done in can_use(), before the power actually starts resolving.

- Once can*use() is successfully resolved, we pass onto anti magic checks. If the action is resonant and \_anti_magic_on_target* is true, this runs can_block_resonance() against the target. If the target can block it (either from resonance or magic immunity), it returns a false, and the pipeline will fail.

- Once the anti-magic checks are resolved, we pass onto do*use_time(). If we have an \_use_time* specified, it will attempt a do_after() and return a TRUE if uninterrupted. A FALSE stops the actions.

- After this, we successfully reach use_action(). We send a signal for COMSIG_POWER_ACTION_USED, which is useful for powers to intercept powers before they reach their use_action(). use_action() then resolves depending on the specifications of the power. If it returns TRUE, the action is considered a success. If FALSE, it its considered a failure.

- If use_action() returned TRUE, we send the signal for COMSIG_POWER_ACTION_SUCCESS, which again powers can use. After which we run the on_action_success() function if use_action() returned TRUE. This is largely where most costs and resource mechanics are handled.

- Regardless of the outcome of on_action_success(), if use_action() returned TRUE, our pipeline will return a TRUE and confirm that our power was successfully handled. This will communicate back to the base action that the cooldown should start.

This is the step-by-step pipeline that every action follows. As mentioned however, _click_to_activate_ powers behave differently.

- Rather than passing off immediately after triggering, it is passed on to InterceptClickOn(). We override the whole parent function with a powers specific one.
  - Once a mob clicks while InterceptClickOn() is called, it will route through that part of the pipeline with the clicked target as the target. InterceptClickOn() will continue overriding click behaviour until it returns TRUE.

- First it attempts to perform aim*assist() if \_aim_assist* is TRUE. It will as explained earlier attempt to lock onto the earliest viable/preferred target. aim_assist() returns a target, and will override the existing click target if it does.

- It will then perform a large variety of targeting based checks.
  - It checks if the _target_type_ matches the target’s type. This is an istype() call.
  - After which it checks if the mob is allowed to _target_self,_ returning FALSE if not.
  - This is followed by a range check if _target_range_ is specified and if so, if the given target is within range.

- Finally, after this, it reroutes back to try_use(), and the pipeline continues as normal. However, after resolution, it will manually set the cooldown in InterceptClickOn(), unset the crosshair and adds a cooldown to the user’s clicker prevent spam-clicks.

Though some smaller steps may be omitted, this is the broad-strokes of both pipelines. Don’t try to reinvent the wheel: step inside of it harmoniously. This was all made so that you don’t need to worry much about the systems outside of the scope of your power.

### <span id="anchor-6"></span>Variables & Functions

Just like the power datum, the action datum has some general information variables: _name_, _desc_, _button_icon_ and _button_icon_state_. Name and description should largely match, though with description it is advised to trim the information down to just “what happens if you press the button” and keep the power datum description the longer one. _button_icon_ and _button_icon_state_ are the icon and the icon-state respectively that appear on the button. Pick something funny; reuse sprites, get creative.

**Again, you want to make sure you subtype to the correct parent**. A lot of path-specific mechanics are handled in the actions section of powers, as well as various helpers.

For actions, most of the meat of functionality exists in can_use(), use_action() and on_action_success().

- can_use() handles almost all validation. If the target is cuffed, incapacitated, silenced, etc. Any and all validation should be added to this, before reaching use_action. Returns FALSE if anything is wrong and the power should be stopped, return TRUE if its a-okay to continue. Keeping all your validation in here keeps requirements in one tidy location and prevents signallers and powers from firing when they shouldn’t.
- use_action() is where most of the functionality of the power should resolve. Return TRUE if the power successfully resolves, return FALSE if not. Assume that all validation has already succeeded at this point that is not intricately part of the functionalities of use_action() itself.
- on_action_success() resolves after use_action is successful and is mainly used for mechanics such as resource management & returns. Mostly used by specific paths but some powers use it themselves. Return value does not matter. The separation from use_action() is there so we can handle action failures without messing up costs.

There are a lot more variables at play in the action datum. The important ones are as followed:

- active, which is typically used to indicate the TRUE/FALSE (on/off) state of a power. Though not every power will use this, it is important you use this when you do. This is largely so other powers can ascertain if others are active, such as Psyker’s Meditate.

- resonant, which is the setting-specific term for magical. Specifically it is often used to refer to the tier of magic unique to the powers system, which sits below standard ‘magic’, a la wizard, heretic, cult, etc. Setting this to TRUE makes it check against anti-magic on the target and checks if you are silenced before use.
  - Most Paths set this in their parent version of the action. For most paths you will not need to adjust it, but non-magical powers should have this as FALSE.

- req_stat, determines which state you need to be in to use it. Powers by default require you be conscious, but if you want it to be useable while dead, you’ll have to change this to DEAD.
  - disabled_by_incapacitate full fills a similar role but checks against stuns, since req_stat doesn’t compare against that.
  - human_only makes it so that only carbon mobs can use the power.
  - need_hands_free makes it so you can’t use it while bound.

Action powers offer an use_time system, allowing you to have ‘cast times’ and a built-in do-after before using a power.

- use_time dictates this. If it is 0, it uses the power instantly. Otherwise, it routes through do_use_time() to attempt to perform the action.
- use_time_flags determines if the action is not interrupted by certain behaviour, e.g IGNORE_HELD_ITEM causes it to not stop when interacting with a held object.
- use_time_overlay_type allows passing an overlay effect (such as /obj/effect/temp_visual/conjure_rain) to display while using.
- do*use_time() is the function that handles most of \_use_time*’s functionality, performing a do_after(). It is wise to override if you want specific things to occur during cast time, such as telegraphs (e.g conjure rain). A FALSE return means the power fails and stops, a TRUE will cause it to keep going.

Targeting goes off of a singular target which is handed along through the entire action pipeline. How people acquire the target depends on the following variables.

- click_to_activate, which dictates targeting behaviour. If TRUE, you are given an aiming reticule and made to target a mob before the action activates, and alters the pipeline to use a targeting mode. Activate again to disable. If FALSE, it will default to you being the target and resolves it instantly on button-press.
- target_range, which is the maximum range the target has. This is measured based on a get_dist() check between the user and the target’s turf. Since get_dist() only moves horizontally and vertically, this means you have less range when aiming diagonally (meaning the range is more of a sphere than a cube)
- target_type, which restricts the target to be a specific subtype. This is handy if you want to target mobs or a specific type of item. If specified, it will ignore any and all other objects unless clicking on that target (or a space with one if you have aim_assist = TRUE). Use this whenever possible rather than manual istype() checks.
- target_self, which determines if the user is allowed to target themselves with their power.
- aim_assist. Any gamer may revolt at the term, but if your target is not a valid target for target_type, it will search that turf for another valid target instead. This defaults to targeting the specified target_type first, then mobs, then anything else. Keep on TRUE unless it’s something very weird and finicky, as it makes powers significantly more forgiving and causes less clunkiness in use.
- anti_magic_on_target. This determines if your target has its antimagic resistances checked, which also requires resonant to be TRUE. You shouldn’t need to tweak this unless your power creates an object, such as projectiles, that is responsible for most interactions instead.
- magic_resistance_types. You can pass any of the anti-magic flags through here and give powers additional magic types to check against. Since we check against normal magic by default, this basically means just mental and holy resistance. Some powers, like Hemomancy, override this for all powers.

Though that wraps up most variables, there are a multitude of functions aimed at helping common actions, such as applying damage against armour and firing projectiles resolve naturally without needing to reinvent it each time.

- apply_damage_with_armor() is a handler that allows applying damage to mobs whilst respecting armour variables. Any form of damage should route through this, as it introduces counterplay and keeps in harmony with the existing game systems.

- fire*projectile() fires a projectile from the first argument’s position towards the second argument’s position, with the third argument being the projectile type. Though this usually assumes the same to be the action’s \_target* var, this can be anything, allowing you to create complex patterns such as shotgun-blasts. You should use this with projectiles; and any magical projectiles you create should be /obj/projectile/resonant as to aid in anti-magic functionality.
  - These come with the on_power_projectile_hit() signaller, allowing you to easily communicate back to the power.

## <span id="anchor-7"></span>Status Effect Datum

Whilst this isn’t a part of the powers system, its usefulness to the system comes up so often that it is deserving of it’s own section. Status effects allow us to have lingering effects with a large degree of functionality on mobs to offload some of our core functionalities on for powers. Status effects for powers use the /datum/status_effect/power parent-type, which you should aim to use when possible.

Generally speaking, if your power has any form of lingering effect that sticks to a mob, it should use a status effect. It is also an ideal target for dispel functions, should your power require them.

```dm
/datum/status_effect/power/command_grit
	id = "command_grit"
	show_duration = TRUE
	duration = 15 SECONDS // baseline
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/command_grit

/datum/status_effect/power/command_grit/on_creation(mob/living/new_owner, commander_modifier)
	if(isnum(commander_modifier))
		duration = 15 SECONDS * commander_modifier
	. = ..()

/datum/status_effect/power/command_grit/on_apply()
	ADD_TRAIT(owner, TRAIT_ANALGESIA, type)
	owner.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/damage_slowdown)
	owner.add_movespeed_mod_immunities(src, /datum/movespeed_modifier/basic_stamina_slowdown)
	return TRUE

/datum/status_effect/power/command_grit/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ANALGESIA, type)
	owner.remove_movespeed_mod_immunities(src, /datum/movespeed_modifier/damage_slowdown)
	owner.remove_movespeed_mod_immunities(src, /datum/movespeed_modifier/basic_stamina_slowdown)
	return

/atom/movable/screen/alert/status_effect/command_grit
	name = "Grit"
	desc = "You ignore pain for a duration, including the slowdowns from damage and stamina!"
	icon = 'icons/hud/guardian.dmi'
	icon_state = "standard"
```

Example of a status effect, including the alert at the bottom (`Command: Grit`).

There are 3 primary functions you’ll interact with with status effects.

- on_creation(), which fires when the status effect is first created on a mob. Arguments and other information should be passed along from the power and given assignments here.
- tick(), which fires depending on the specified _tick_interval_, repeating a certain effect. This is a form of processing/on_life, and is ideally used for powers that have an ongoing effect such as a lingering damage-over-time.
- on_remove() fires when the power expires or is otherwise deleted. This step is particularly useful for communicating back to the power, such as a power expiring.

Status effects have a few important variables.

- id, which is used to check against duplicates of itself and for referencing purposes.
- duration, which determines how long the status effects lasts until it terminates. If set to -1, it is permanent (use STATUS_EFFECT_PERMANENT instead of -1). This duration can be passed along and over-ridden, as status effects allow for arbitrary arguments. This is best done on_creation. For example, how Command: Assault uses it.

```dm
/datum/status_effect/power/command_assault/on_creation(mob/living/new_owner, commander_modifier, vulnerable_amount, effect_duration)
	if(isnum(commander_modifier))
		duration = effect_duration * commander_modifier
	if(isnum(vulnerable_amount))
		damage_increase_percent = vulnerable_amount
	. = ..()
```

- tick_interval, which determines when the tick() function should fire. Because of BYOND being funky and having a variable amount of ticks per second, putting in low values (below 1 SECOND) may lead to inconsistent ticks. Setting this to -1 will prevent ticks. If the duration is also set to -1 (permanent), this will prevent any processing, which is good for optimization.

- _status_type_ determines how stacking behaves. Which to use determines on the nature of your power, but you usually do not want stacking for balance-reasons.
  - STATUS_EFFECT_MULTIPLE allows the effect to stack with itself at infinitum.
  - STATUS_EFFECT_UNIQUE will only allow 1 instance of it to exist on the mob and will prevent ‘younger’ statuses of the same id from being applied.
  - STATUS_EFFECT_REPLACE will only allow 1 instance of itself to exist on the mob, but will replace the oldest status with the youngest when reapplied.
  - STATUS_EFFECT_REFRESH functions as STATUS_EFFECT_UNIQUE but instead resets the duration rather than generating a new instance.

- alert_type shows an alert on the user’s UI. This is a type of /atom/movable/screen/alert/status_effect, and will show a name, description (when hovered over) and icon. These have to be configured and made separately, preferably in the same file as the status effect.

- show_duration shows a timer on the status effect (if it has an alert_type) until when it expires. It is a useful piece of player feedback to give, and should be given to any power that naturally expires after a period.

##

## <span id="anchor-8"></span>Anti-Magic, Silencing & Dispelling

The Powers System adds a new tier of magic to the existing anti-magic system, the ability for mobs to be silenced and unable to use resonant powers, and a dispel functionality to remove existing powers. Most of these are findable in modular_doppler\modular_powers\code\powers_antimagic.dm, and are used for people to be able to combat the strength often provided by magical and supernatural powers.

- Resonant is a new tier of anti-magic introduced with the system. It is largely used to check against immunities to resonant powers using can_block_resonance() function. Existing anti-magic (such as the null rod) applies to it as normal, and certain powers like Psyker’s are susceptible to alternative anti-magics like mental. Some powers grant immunity to specifically resonant magic, which does not apply to other types of magic. Any power with an action datum and magical/supernatural flavouring should have the resonant trait.
  - Scrying immunity also exists, except is delegated to a mob trait. Resonant and magic immunity also apply to it. Anything that gives information through magical means should check against the target’s scrying resistances.

- Silencing is a mob trait (TRAIT_RESONANCE_SILENCED) that can be given under various circumstances, and is meant to represent people being unable to exercise their magical abilities. Powers marked as resonant (as well as some non-action datum powers) will fail to activate if the user is silenced. Most powers that are magical should aim to integrate this in some capacity; even passive powers that are magical/supernatural in nature should have an if statement that checks against this.

- Dispelling ends any lingering magic effects on the target. This uses a signal (COMSIG_ATOM_DISPEL) which most lingering powers listen to. Any lingering resonant powers should always have listeners for this. Powers, spells and items then send the dispel signal to the target, and any listeners will immediately attempt to dispel themselves, returning the result to the dispeller. The effects of a dispel have to be programmed in; be humorous when you can, and the through line is that dispels should yield instantaneous results. You are allowed to diverge if this would be too detrimental to balance, such as Cultivators, whose power-design is very much ‘all eggs in one basket’.
  - There is an optional flag for dispelling called DISPEL_CASCADE_CARRIED, which dispels are carried items on the target mob. Normally, dispels do not check components of a target for performance reason.

## <span id="anchor-9"></span>Helper Functions

There’s a few generic helper functions you can call for various purposes, to do with the powers system. Most of these exist in mob/living, allowing you to ascertain if a mob has a certain power or a certain path of power.

- add_archetype_power() allows adding powers to mobs, and is generally speaking the best way to call it on mobs.
  - power_type argument determines the power. This has to be the typepath of the power
  - client_source is optional, additional info that includes the mobs prefs. This is mainly used for powers with specific preference options like which arm an augment should go on
  - add_unique is a TRUE/FALSE statement that determines if a power runs their add_unique() call (e.g spawning items).

- remove_archetype_power() does as it says on the tin and removes the specified power from the mob. power_type is the power to remove from the target mob.

- has_archetype_power() returns a TRUE if the given power is on the mob, otherwise FALSE. Accepts power_type as its argument, in the form of the power’s typepath.

- has_power_in_path() returns TRUE if the mob has any power that belongs to the specified power path, for example if you want to know if someone has any thaumaturgic powers.
  - This accepts the POWER_PATH_X defines, so it’d look something like POWER_PATH_THAUMATURGE.

- get_power() returns a specific instance of a power on a mob if they have it. It takes a power’s typepath as its argument.

- get_power_string() returns a printable string of ALL the powers the mob has into one joined string.
  - security is a TRUE/FALSE argument. When TRUE it returns the security-specific records. If FALSE, it returns only the power names.
  - category determines what categories should be passed along. This is based off of _security_record_threat_, so whether a power is a minor or major threat, regardless if the security argument is TRUE or FALSE
  - include_empty_text determines what happens if there are no powers to return. TRUE means it returns “No powers declared” if Security is TRUE or “None” if Security is FALSE. FALSE on include_empty_text will instead send an empty string.

- transfer_power_datums() lets you transfer all powers from one mob to another. This transfers from the mob that you call the proc on, to the mob specified in the argument.

#

# <span id="anchor-10"></span>Path-Specific Notes on Adding Powers

<span id="anchor-11"></span>Paths radically differ in some cases when it comes to how they function, whether for flavour or technical reasons. This section tries to illustrate all these differences, both in design and technical sense.

This section won’t go too in-depth in all the variables for each path, but instead tries to “keep it quick” with all the practical information and largely focusing on the design philosophy.

## <span id="anchor-12"></span>Thaumaturge

Mages! Wizards!

- <span id="anchor-13"></span>Thaumaturge uses components (modular_doppler\modular_powers\code\powers\sorcerous\thaumaturge\\thaumaturge_component.dm) to handle most of its mechanics due to the general complexity of their powers.

- <span id="anchor-14"></span>Thaumaturge at its core does not use cooldowns; all of the powers are designed to use alternative resource systems, with the system being determined by the root. Spell preparation uses a mana system, Hemomancy uses a blood system.
  - <span id="anchor-15"></span>Spell Preparation ‘prepares’ a set amount of charges per power that the user may allocate per power, up to 6 max. These cost mana: the thaumaturge has mana equal to 2x the amount of power points invested in the system, and preparing a charge costs the _prep_cost_ of that power; usually the same as its _value_
  - Hemomancy spends 4x the power’s _prep_cost_ to cast the spell, with your blood as cost. They need to channel a blood hand that takes up a slot to use their powers, and do not benefit from affinity. If exceeding 120% of their blood, they pay the cost multiple times to increase the affinity by +1, up to a maximum of Affinity 5. This is done to prevent exploitative behaviour of filling yourself up to 180% of your blood threshold and having virtually no downsides to using abilities, whilst still giving a practical use to excess amounts of blood.

- Thaumaturges have an affinity system, where items give bonuses to spellcasting. This takes the highest value out of all of them; so carrying Affinity 4 robes and an Affinity 3 hat will give you Affinity 4. Items have to be used as intended; clothes have to be worn and other items have to be held. Full details on what determines what affinity, and the list of affected items can be found at modular_doppler\modular_powers\code\powers\sorcerous\thaumaturge\affinity\thaumaturge_affinity.dm
  - Hemomancers cannot benefit from item Affinity, but their hand gives them Affinity 3, 4 if a Hemophage.

- <span id="anchor-16"></span>_prep_cost_ should almost always be tied to the power’s _value_. Value plays a closer role in balance than with other powers, as it determines how ‘spammable’ the ability is for all roots.

- Costs are handled in on*action_success(). Some powers have a refund chance, based on the \_power_refund_chance* and _power_refund_affinity_bonus_ vars. These are handled in that same function.

## <span id="anchor-17"></span>Enigmatist

They’re vandalizing everything with their damn circles!

- Isn’t in yet, but it is slated to be based around Runes, a hybrid between Heretic and Cultist, involving a large degree of exploration.
- Expect it to be about half as big as the entire original powers system.
- See Future Development

## <span id="anchor-18"></span>Theologist

The faithful, not specifically tied to god.

- Theologist uses a central component (/datum/component/theologist_piety) for handling their resource, including the UI element.
- Theologist is based around piety generation; a resource they build up doing various deeds. Though most roots offer a form of healing to acquire it, some alternative powers such as flagellant allow building it through other means. The piety generation for healing uses THEOLOGIST_PIETY_HEALING_COEFFICIENT (which as of writing is 5 healing = 1 piety). Any other healing should go off of your gut-feeling.
- Piety is a resource that is either hoarded or spend depending on powers and playstyle. There is no through line, but try to have most powers cost in increments of 5, as the power caps out at 50.
- Some Theologist powers use the* unholy_mobs *global list. It is recommended to try and incorporate this and grant increased effects against those creatures, for flavour-sake when possible. Likewise, involve the Chaplain and their religion system when possible.
- Flavour-wise, Theologist shouldn’t suggest being directly related to religions or gods. It is designed flavour wise to be open-ended and be more about strong convictions, e.g being a zealot. This can mean you have a strong philosophical believe, rather than needing to revere a god.

##

## <span id="anchor-19"></span>Psyker

Psychic powers at often grave risk.

- Psyker uses a new organ (modular_doppler\modular_powers\code\powers\resonant\psyker\psyker_organs\\psyker_organ.dm) to handle its stress resource as well as backlash mechanics.

- Stress is a resource that builds up for using abilities. Psyker has near-zero cooldowns and favours powers with indefinite durations to passively build up more manageable doses of stress. Stress decays passively depending on your root organ. Exceeding the first threshold hampers recovery and causes negative effect; further thresholds lead to heavier consequences until an eventual catastrophic stress event triggers, causing permanent negative effects for the Psyker and resting stress.
  - Adding new events to psyker stress thresholds is relatively easy encouraged, as each are their own compartmentalized datum that gets called by the appropriate organ when a breakdown does happen.
    - Minor events should be small but subtle things, such as a bloody-nose.
    - Major events should be a “stop-in-your-tracks and do something now” levels of events, such as vomiting, blinding, etc.
    - Catastrophic events should either be incredibly dangerous for the psyker or leave permanent lingering harm, acting as a proper deterrent for being so reckless.

  - Being unable to see your exact stress is a deliberate design choice to keep the power as a ‘fragile’ and ‘dangerous’ type of magic.

- Any effect with passive stress generation should be able to be easily turned off on demand; letting Psykers hit the brakes is important for gameplay!

- The roots determine which subtype of organ the psyker gets. This determines both how much stress they generate, how much they can handle, and how they cope with it.

- Psyker powers usually give increased bonuses for having matching negative quirks. For example, scrying is less stress inducing on a blind person. A paraplegic person can levitate with minimal upkeep. When possible, you should incorporate bonuses for matching negative quirks into your psyker powers for flavour reasons.

##

## <span id="anchor-20"></span>Cultivators

We’ve made the Goku analogy a hundred-times, it just isn’t funny anymore.

- Cultivators use a component (modular_doppler\modular_powers\code\powers\resonant\cultivator\\cultivator_energy.dm) for managing their Energy resource.

- Cultivators center around a specific root power called an alignment, which they have to charge up using Aura or through Meditation. Once in this state, they gain great bonuses, even if unarmed and unarmored, allowing them to go on equal playing field with most folks.
  - Unarmored defence is calculated based on the difference between the highest piece of armour worn of the type on any body-part. This is the best solution possible, as extra armour can’t discriminate against body-part.
  - Unarmed attack is a flat amount of damage added to punches. Beware the antics of punch-stacking.

- Alignments drains passively while active; and using your cultivator powers drains it more, but often with heightened effects. Most powers for Cultivator should not consume energy out of this state, and preferably offer some form of flavourful way to interact with your ‘theme’ outside of this empowered state.

- Aura works by passively processing in the root power and having a hand-picked list of circumstances that contribute to energy-generation. These usually align thematically with the root; Flamesoul for example loves seeing bonfires and people on fire. Try to cover as much ground as possible, and that almost all of it should be ‘visual’

- The flavour goal is all about associating with a specific phenomena, exuding it constantly around you. Thusly, try to design flavour with this in mind. Make it as clear as possible to all around you that you’re all about X!

## <span id="anchor-21"></span>Aberrant

It does a lot of things!

- Aberrant is divided into three sections; beastial, monstrous, and anomalous.
  - Though beastial and aberrant have overlap and have some powers that are shared among both, beastial is specifically about having animal-like traits and monstrous is about unnatural and monster-like qualities. These both use satiation and hunger as a secondary resource to using their powers. Aberrant does not have a build in cost var, so you’ll have to subtract hunger yourself (by for example using user.adjust_nutrition(hunger_cost))
  - Anomalous is all about odd phenomena that can’t be explained otherwise.

- Powers in this section are a mixed batch of resonant or not, so you should specify if powers are resonant or not in the description and mark the _resonant_ variable where applicable. If it is supernatural or not explainable through our current sciences, it should be magical. Always err towards magical when in doubt.

## <span id="anchor-22"></span>Warfighter

WRAAAAGH!

- There are three categories. These are not mutually exclusive roots, but have different priorities.
  - Commander is about giving commands, which are debuffs and buffs that linger for a duration.
  - Martial Artist, which is about tackles, unarmed combat and being a menace even without weapons.
  - Equipment Specialist, which is about specializing in specific equipment to greatly increase their performance. Shield blocks, explosives timers, etc.

- Commander has its own subtype of action (/datum/action/cooldown/power/warfighter/command) to facilitate its mechanics. It gains bonuses from being a head as the user and being near your own department members. Every single commander action should have some form of scaling that plays into this.

- Martial Arts have the issue that they are tied to the mind as components, which makes them transferable per bodies (unlike other powers). Make sure to properly clean them up when destroyed!

- All powers here should directly relate to combat, but cannot be magical. Peak-performance and exceptional strength are permitted, but it shouldn’t border into the supernatural.

## <span id="anchor-23"></span>Expert

Mundane, but neat!

- Powers here shouldn’t be spectacular and in essence anything something someone can do in our current day and age, even if it is exceptional by standards. It is meant to show the best of the best of what people can do.
- There’s no overarching mechanics; just add whats fun. It is best to keep things simple. Try to tap into gameplay systems such as the skill system that don’t often see a lot of love; people love having a cozy niche.
- Powers here shouldn’t be magical as that would mean they belong elsewhere, nor should they be directly combat, as that would imply they belong to Warfighter. Clever-use in combat is still allowed, such as Punt.

##

## <span id="anchor-24"></span>Augmented

I never asked for this.

- Augmented behaves more akin to augments than powers, largely to have as much parity as possible with the existing augment system. Some possess a special premium augment component (/datum/component/premium_augment) which adds special mechanics.

- Premium augments use quality, a degrading resource that sinks overtime as well as from use. The efficiency of augments decreases as quality goes down, and even stops working all-together at 0. This can be fixed with a premium augment maintenance surgery or by manually removing the augment and performing the examine steps on it.

- Actions for premium augments use item powers and **do not inherit any of the base functionalities **of the power system’s action system. **Everything must be handled on the augment **rather than the power.
  - Every premium augment needs an action, as it indicates the percentage. An off/on switch is sufficient.

- Regular augments are mixed in with the archetype as well. Make sure to distinguish powers-unique augments as premium; the flavour is that these are rare, custom-made augments that can’t be mass-produced on the station.

#

# <span id="anchor-25"></span>Step-By-Step Walkthrough on Making a Power

Disclaimer: This walkthrough deliberately skips some best practices and edge cases in order to stay focused on the fundamentals. Once complete, compare it against existing powers and the finished example.

For the practical learners, having an example to work with does wonders. so we’ll be making a small power ourselves to take in the various things we learned, without too much complexity. For this, we will be making an aberrant power that lets us shoot a laser from our eyes. Yes, this is similar to the genetics power, but ours will be _cooler_. This will expect at least a very rough understanding of SS13’s code: if you do not, [DMByExample](https://spacestation13.github.io/DMByExample/hello_world.html) is a good resource. Various links in this guide will link to either it or earlier terms mentioned in the document.

Let us start off with by defining the [Power Datum](#anchor-2) first. This is always a necessary step, and also helps us by setting our idea down on paper. We’ll need to do the [object typepath](https://spacestation13.github.io/DMByExample/objs.html): as it is an aberant power, this should end up becoming something like **/datum/power/aberrant/laser_eyes**. Find a fitting name and description, security text and a value, as well as a _security_record_text_ to describe our power. It’ll be a major threat as well.

Finally, since we’ll be using an action to toggle our laser eyes on and off, we’ll need to specify an _action_path._ Since we want it to inherit the aberrant action path, we’ll name it **/datum/action/cooldown/power/aberrant/laser_eyes** to stay consistent. Finally, we’ll want to make it require the monstrous root, so we’ll add **list(/datum/power/aberrant_root/monstrous)** as a requirement. Remember, requirements are a list!

In the end it should come out looking something like this. Don’t worry about matching the details in the name, description and security record; flavour is subjective.

```dm
/datum/power/aberrant/laser_eyes
	name = "Laser Eyes"
	desc = "Shoot a deadly beam from your eyes, burning your foes! Increases your hunger with each shot."
	security_record_text = "Subject can shoot lasers from their eyes."
	security_threat = POWER_THREAT_MAJOR
	value = 6
	action_path = /datum/action/cooldown/power/aberrant/laser_eyes
	required_powers = list(/datum/power/aberrant_root/monstrous)
```

Now that we have our power datum, it is time to add our matching [Action Datum](#anchor-4). Define it in the same file, using the _action_path_ we had just added. The name and description can be carried over, but we’ll need a _button_icon_ and _button_icon_state_. Shop for a fun one, or take the one from the final example below, which uses a laser impact sprite. Since we’re shooting projectiles, we’ll want to use _click_to_activate_ to be able to point where to shoot the lasers; and as we are shooting a projectile, we need to set _anti_magic_on_target_ to FALSE so that our ability doesn’t whiff when clicking someone that happens to be magic-immune, even if they aren’t the target! Finally, a cooldown would serve us well for balance.

For the sake of future customization and allowing for admin antics, it is in your best interest to use [variables](https://spacestation13.github.io/DMByExample/variables.html) where possible. We’ll want our chosen projectile to be a variable: **_var/obj/projectile/projectile_path_**. Since this is a custom var, make sure to comment on it with ///

With this, we already have a good basis. Now it is time to start writing our [functions](https://spacestation13.github.io/DMByExample/procs.html). We’ll start with our [can_use()](#anchor-6), since we actually need to check if our eyes are functional! These conditionals are part of the fun and follows the philosophy of having obvious weaknesses. Make sure to add another var, this one we’ll call **var/obj/item/organ/eyes/eyes**. The typepath matters, because we’ll be using it for reference later.

For this, we’ll need to get the user’s eyes, the damage value on it, and store it in our new _eyes_ variable. You’ll regularly bump into these scenarios where you’ll need to figure out how to discover something is done, to which my recommendation is to to try and find something that is similar in functionality. Take on the challenge; and once you’ve had enough, go to the next paragraph where I’ll present my answer.

In this case, we want **get_organ_slot(ORGAN_SLOT_EYES)** proc. Now, our ‘user’ in our action datum is only defined as a mob/living/, but that is insufficient for get*organ_slot(), so we’ll need to fix that by [casting](https://spacestation13.github.io/DMByExample/vars/casting.html) it. We’ll need to get and set them as a carbon; which means setting a variable that defines them as a **var/mob/living/carbon**. This is usually done with an **if(!iscarbon())** check, which is what we’ll be doing. Get and set our \_carbon_user* and then get their organ_slot_eyes. Make sure to add a can_use() function, with user and target as their arguments.

Let us expand it with an [if-statement](https://spacestation13.github.io/DMByExample/flow/if_else.html) to actually check against the damage of the eyes. We’ll be doing **if(eyes.damage >= eyes.maxHealth)**, and returning FALSE if true. This is an [operator](https://spacestation13.github.io/DMByExample/operators.html) that returns true if the left-side variable is bigger or equal to the right-side variable. This way, non-functional eyes won’t let us shoot, but a bit of eye damage isn’t a problem yet.

But wait, what if we have no eyes? Oh no. We’ll need to expand our if-statement a bit to account for that, or we’ll get errors as it tries to look-up something that doesn’t exist! Lets make sure our get_organ_slot succeeded by doing **if(eyes && eyes.damage >= eyes.maxHealth)**. This way, it won’t go onto the second check if we don’t have eyes defined, as && is an operator for ‘and’. In DM, multi-statements are resolved left-to-right and will terminate if any return false.

Make sure to include return ..() in the block so that it can [inherit](https://spacestation13.github.io/DMByExample/objs/inheritance.html) the parent; this in essence calls the effects of the original parent, meaning we can override it with relative safety and ensure all the other validation occurs.

Sweet. So now we have our validation out of the way. Now lets actually shoot freakin laser beams! Fortunately, we already have a good helper in the form of **fire_projectile()**. We’ll just need to add a few [arguments](https://spacestation13.github.io/DMByExample/procs/arguments.html), and add a bit of feedback in the form of a sound.

fire*projectile() takes three arguments; the origin point, the target and the projectile. I’ll give you an existing laser projectile for now for ease of access: we’ll be using **/obj/projectile/beam/laser**. Define it in our earlier \_projectile_path*. Now, lets make our use_action(). Make sure to define a user and a target, just like with can_use(). We’ll be adding the fire_projectile() function with all three arguments in there; and making it an if-statement. Why? Because that way we can now if our use_action() was a success or not.

Finally, throw in a sound for a bit of feedback, because a laser isn’t as satisfying without a pew. I’ll give you this one for free: **playsound(user, 'sound/items/weapons/lasercannonfire.ogg', 50)**

With that, we are technically done. That’s right, we now shoot lasers!

Of course, there is a lot missing from the minimal version. We aren’t subtracting hunger yet, we aren’t checking if the user is too hungry, and eye damage does not affect the laser yet. Rather than leaving the walkthrough split across several partial snippets, here is one complete example with those additions included:

```dm
/*
Shoots lasers from our eyes!
*/
/datum/power/aberrant/laser_eyes
	name = "Laser Eyes"
	desc = "Shoot a deadly beam from your eyes, burning your foes! Increases your hunger with each shot."
	security_record_text = "Subject can shoot lasers from their eyes."
	security_threat = POWER_THREAT_MAJOR
	value = 6
	action_path = /datum/action/cooldown/power/aberrant/laser_eyes
	required_powers = list(/datum/power/aberrant_root/monstrous)

/datum/action/cooldown/power/aberrant/laser_eyes
	name = "Laser Eyes"
	desc = "Shoot a deadly beam from your eyes, burning your foes! Increases your hunger with each shot."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "impact_laser"
	cooldown_time = 3 SECONDS
	click_to_activate = TRUE
	anti_magic_on_target = FALSE
	/// The projectile we fire
	var/obj/projectile/projectile_path = /obj/projectile/beam/laser
	/// The sound of the projectile we fire
	var/projectile_sound = 'sound/items/weapons/lasercannonfire.ogg'
	/// The user's eyes
	var/obj/item/organ/eyes/eyes
	/// The hunger cost of the power
	var/hunger_cost = 10

/datum/action/cooldown/power/aberrant/laser_eyes/can_use(mob/living/user, atom/target)
	if(!iscarbon(user))
		return FALSE
	var/mob/living/carbon/carbon_user = user
	eyes = carbon_user.get_organ_slot(ORGAN_SLOT_EYES)
	if(eyes && eyes.damage >= eyes.maxHealth)
		owner.balloon_alert(user, "eyes non-functional!")
		return FALSE
	if(user.nutrition <= NUTRITION_LEVEL_STARVING) // can't use while starving
		owner.balloon_alert(user, "too hungry!")
		return FALSE
	return ..()

/datum/action/cooldown/power/aberrant/laser_eyes/use_action(mob/living/user, atom/target)
	if(!fire_projectile(user, target, projectile_path))
		return FALSE
	playsound(user, projectile_sound, 50)
	return TRUE

/datum/action/cooldown/power/aberrant/laser_eyes/ready_projectile(obj/projectile/projectile_instance, atom/target, mob/living/user)
	// We halve the damage that eye loss affects so that it isn't that crippling.
	if(eyes)
		projectile_instance.damage = max(0, projectile_instance.damage - (eyes.damage / 2))
	return ..()

/datum/action/cooldown/power/aberrant/laser_eyes/on_action_success(mob/living/user, atom/target)
	if(iscarbon(user))
		user.adjust_nutrition(-hunger_cost)
```

# <span id="anchor-26"></span>Future Powers Development

As of writing, the first iteration of the system is not the final. Whilst the base systems are there, there is still likely that changes are to be had both gameplay and flow.

- Particularly, Aberrant is in not a great position and acts as a kitchen-sink. The goal is to eventually split this off into Aberrant and Imbued, where Aberrant is meant to be a mix of odd and supernatural BIOLOGICAL traits, and Imbued being in a position where anomalous and magical properties DIRECTLY affect you. This should make it so we have no more need for a future kitchen-sink power.
- Enigmatist is also still in development due to its sheer size.
- Outside of these there are no large changes expected to systems. Balance, numbers and more are always subject to debate.
